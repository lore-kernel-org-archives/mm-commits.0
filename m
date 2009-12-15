From: akpm@linux-foundation.org
Subject: [merged] sdio-rework-cis-tuple-parsing.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:58:27 -0800
Message-ID: <200912152158.nBFLwRlm015819@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933963AbZLOWPO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:15:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: albert_herranz@yahoo.es, linux-mmc@vger.kernel.org, pierre@ossman.eu, mm-commits@vger.kernel.org


The patch titled
     sdio: rework cis tuple parsing
has been removed from the -mm tree.  Its filename was
     sdio-rework-cis-tuple-parsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio: rework cis tuple parsing
From: Albert Herranz <albert_herranz@yahoo.es>

Rework the current CIS tuple parsing code, reusing the existing
infrastructure and providing an easy way to add new CISTPL_FUNCE parsers
by TPLFE_TYPE.

Valid known CIS tuples are now silently queued for the SDIO function
driver when not parsed/processed (-EILSEQ) by the SDIO core.  Unknown CIS
tuples (-ENOENT) are queued too for the SDIO function driver without
aborting the initialization, but emit a warning in the kernel log.

CISTPL_FUNCE tuples can be "whitelisted" now by adding a matching entry to
the cis_tpl_funce_list table.

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
Acked-by: Pierre Ossman <pierre@ossman.eu>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio_cis.c |  167 ++++++++++++++++++----------------
 1 file changed, 93 insertions(+), 74 deletions(-)

diff -puN drivers/mmc/core/sdio_cis.c~sdio-rework-cis-tuple-parsing drivers/mmc/core/sdio_cis.c
--- a/drivers/mmc/core/sdio_cis.c~sdio-rework-cis-tuple-parsing
+++ a/drivers/mmc/core/sdio_cis.c
@@ -97,26 +97,56 @@ static const unsigned char speed_val[16]
 static const unsigned int speed_unit[8] =
 	{ 10000, 100000, 1000000, 10000000, 0, 0, 0, 0 };
 
-/* FUNCE tuples with these types get passed to SDIO drivers */
-static const unsigned char funce_type_whitelist[] = {
-	4 /* CISTPL_FUNCE_LAN_NODE_ID used in Broadcom cards */
+
+typedef int (tpl_parse_t)(struct mmc_card *, struct sdio_func *,
+			   const unsigned char *, unsigned);
+
+struct cis_tpl {
+	unsigned char code;
+	unsigned char min_size;
+	tpl_parse_t *parse;
 };
 
-static int cistpl_funce_whitelisted(unsigned char type)
+static int cis_tpl_parse(struct mmc_card *card, struct sdio_func *func,
+			 const char *tpl_descr,
+			 const struct cis_tpl *tpl, int tpl_count,
+			 unsigned char code,
+			 const unsigned char *buf, unsigned size)
 {
-	int i;
+	int i, ret;
 
-	for (i = 0; i < ARRAY_SIZE(funce_type_whitelist); i++) {
-		if (funce_type_whitelist[i] == type)
-			return 1;
+	/* look for a matching code in the table */
+	for (i = 0; i < tpl_count; i++, tpl++) {
+		if (tpl->code == code)
+			break;
 	}
-	return 0;
+	if (i < tpl_count) {
+		if (size >= tpl->min_size) {
+			if (tpl->parse)
+				ret = tpl->parse(card, func, buf, size);
+			else
+				ret = -EILSEQ;	/* known tuple, not parsed */
+		} else {
+			/* invalid tuple */
+			ret = -EINVAL;
+		}
+		if (ret && ret != -EILSEQ && ret != -ENOENT) {
+			printk(KERN_ERR "%s: bad %s tuple 0x%02x (%u bytes)\n",
+			       mmc_hostname(card->host), tpl_descr, code, size);
+		}
+	} else {
+		/* unknown tuple */
+		ret = -ENOENT;
+	}
+
+	return ret;
 }
 
-static int cistpl_funce_common(struct mmc_card *card,
+static int cistpl_funce_common(struct mmc_card *card, struct sdio_func *func,
 			       const unsigned char *buf, unsigned size)
 {
-	if (size < 0x04 || buf[0] != 0)
+	/* Only valid for the common CIS (function 0) */
+	if (func)
 		return -EINVAL;
 
 	/* TPLFE_FN0_BLK_SIZE */
@@ -129,20 +159,24 @@ static int cistpl_funce_common(struct mm
 	return 0;
 }
 
-static int cistpl_funce_func(struct sdio_func *func,
+static int cistpl_funce_func(struct mmc_card *card, struct sdio_func *func,
 			     const unsigned char *buf, unsigned size)
 {
 	unsigned vsn;
 	unsigned min_size;
 
-	/* let SDIO drivers take care of whitelisted FUNCE tuples */
-	if (cistpl_funce_whitelisted(buf[0]))
-		return -EILSEQ;
+	/* Only valid for the individual function's CIS (1-7) */
+	if (!func)
+		return -EINVAL;
 
+	/*
+	 * This tuple has a different length depending on the SDIO spec
+	 * version.
+	 */
 	vsn = func->card->cccr.sdio_vsn;
 	min_size = (vsn == SDIO_SDIO_REV_1_00) ? 28 : 42;
 
-	if (size < min_size || buf[0] != 1)
+	if (size < min_size)
 		return -EINVAL;
 
 	/* TPLFE_MAX_BLK_SIZE */
@@ -157,39 +191,32 @@ static int cistpl_funce_func(struct sdio
 	return 0;
 }
 
+/*
+ * Known TPLFE_TYPEs table for CISTPL_FUNCE tuples.
+ *
+ * Note that, unlike PCMCIA, CISTPL_FUNCE tuples are not parsed depending
+ * on the TPLFID_FUNCTION value of the previous CISTPL_FUNCID as on SDIO
+ * TPLFID_FUNCTION is always hardcoded to 0x0C.
+ */
+static const struct cis_tpl cis_tpl_funce_list[] = {
+	{	0x00,	4,	cistpl_funce_common		},
+	{	0x01,	0,	cistpl_funce_func		},
+	{	0x04,	1+1+6,	/* CISTPL_FUNCE_LAN_NODE_ID */	},
+};
+
 static int cistpl_funce(struct mmc_card *card, struct sdio_func *func,
 			const unsigned char *buf, unsigned size)
 {
-	int ret;
-
-	/*
-	 * There should be two versions of the CISTPL_FUNCE tuple,
-	 * one for the common CIS (function 0) and a version used by
-	 * the individual function's CIS (1-7). Yet, the later has a
-	 * different length depending on the SDIO spec version.
-	 */
-	if (func)
-		ret = cistpl_funce_func(func, buf, size);
-	else
-		ret = cistpl_funce_common(card, buf, size);
-
-	if (ret && ret != -EILSEQ) {
-		printk(KERN_ERR "%s: bad CISTPL_FUNCE size %u "
-		       "type %u\n", mmc_hostname(card->host), size, buf[0]);
-	}
+	if (size < 1)
+		return -EINVAL;
 
-	return ret;
+	return cis_tpl_parse(card, func, "CISTPL_FUNCE",
+			     cis_tpl_funce_list,
+			     ARRAY_SIZE(cis_tpl_funce_list),
+			     buf[0], buf, size);
 }
 
-typedef int (tpl_parse_t)(struct mmc_card *, struct sdio_func *,
-			   const unsigned char *, unsigned);
-
-struct cis_tpl {
-	unsigned char code;
-	unsigned char min_size;
-	tpl_parse_t *parse;
-};
-
+/* Known TPL_CODEs table for CIS tuples */
 static const struct cis_tpl cis_tpl_list[] = {
 	{	0x15,	3,	cistpl_vers_1		},
 	{	0x20,	4,	cistpl_manfid		},
@@ -268,46 +295,38 @@ static int sdio_read_cis(struct mmc_card
 			break;
 		}
 
-		for (i = 0; i < ARRAY_SIZE(cis_tpl_list); i++)
-			if (cis_tpl_list[i].code == tpl_code)
-				break;
-		if (i < ARRAY_SIZE(cis_tpl_list)) {
-			const struct cis_tpl *tpl = cis_tpl_list + i;
-			if (tpl_link < tpl->min_size) {
-				printk(KERN_ERR
-				       "%s: bad CIS tuple 0x%02x"
-				       " (length = %u, expected >= %u)\n",
-				       mmc_hostname(card->host),
-				       tpl_code, tpl_link, tpl->min_size);
-				ret = -EINVAL;
-			} else if (tpl->parse) {
-				ret = tpl->parse(card, func,
-						 this->data, tpl_link);
-			}
+		/* Try to parse the CIS tuple */
+		ret = cis_tpl_parse(card, func, "CIS",
+				    cis_tpl_list, ARRAY_SIZE(cis_tpl_list),
+				    tpl_code, this->data, tpl_link);
+		if (ret == -EILSEQ || ret == -ENOENT) {
 			/*
-			 * We don't need the tuple anymore if it was
-			 * successfully parsed by the SDIO core or if it is
-			 * not going to be parsed by SDIO drivers.
+			 * The tuple is unknown or known but not parsed.
+			 * Queue the tuple for the function driver.
 			 */
-			if (!ret || ret != -EILSEQ)
-				kfree(this);
-		} else {
-			/* unknown tuple */
-			ret = -EILSEQ;
-		}
-
-		if (ret == -EILSEQ) {
-			/* this tuple is unknown to the core or whitelisted */
 			this->next = NULL;
 			this->code = tpl_code;
 			this->size = tpl_link;
 			*prev = this;
 			prev = &this->next;
-			printk(KERN_DEBUG
-			       "%s: queuing CIS tuple 0x%02x length %u\n",
-			       mmc_hostname(card->host), tpl_code, tpl_link);
+
+			if (ret == -ENOENT) {
+				/* warn about unknown tuples */
+				printk(KERN_WARNING "%s: queuing unknown"
+				       " CIS tuple 0x%02x (%u bytes)\n",
+				       mmc_hostname(card->host),
+				       tpl_code, tpl_link);
+			}
+
 			/* keep on analyzing tuples */
 			ret = 0;
+		} else {
+			/*
+			 * We don't need the tuple anymore if it was
+			 * successfully parsed by the SDIO core or if it is
+			 * not going to be queued for a driver.
+			 */
+			kfree(this);
 		}
 
 		ptr += tpl_link;
_

Patches currently in -mm which might be from albert_herranz@yahoo.es are

origin.patch
linux-next.patch
sdio-recognize-io-card-without-powercycle.patch

