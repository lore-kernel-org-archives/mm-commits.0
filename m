From: akpm@linux-foundation.org
Subject: [to-be-updated] sdio-pass-unknown-cis-tuples-to-sdio-drivers.patch removed from -mm tree
Date: Sun, 13 Sep 2009 15:43:21 -0700
Message-ID: <200909132243.n8DMhLIB004503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35375 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552AbZIMWnT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Sep 2009 18:43:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: albert_herranz@yahoo.es, linux-mmc@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     sdio: pass unknown cis tuples to sdio drivers
has been removed from the -mm tree.  Its filename was
     sdio-pass-unknown-cis-tuples-to-sdio-drivers.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sdio: pass unknown cis tuples to sdio drivers
From: Albert Herranz <albert_herranz@yahoo.es>

Some manufacturers provide vendor information in non-vendor specific CIS
tuples.  For example, Broadcom uses an Extended Function tuple to provide
the MAC address on some of their network cards, as in the case of the
Nintendo Wii WLAN daughter card.

This patch allows passing correct tuples unknown to the SDIO core to a
matching SDIO driver instead of rejecting them and failing.

Signed-off-by: Albert Herranz <albert_herranz@yahoo.es>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/core/sdio_cis.c |   46 ++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 21 deletions(-)

diff -puN drivers/mmc/core/sdio_cis.c~sdio-pass-unknown-cis-tuples-to-sdio-drivers drivers/mmc/core/sdio_cis.c
--- a/drivers/mmc/core/sdio_cis.c~sdio-pass-unknown-cis-tuples-to-sdio-drivers
+++ a/drivers/mmc/core/sdio_cis.c
@@ -123,8 +123,9 @@ static int cistpl_funce_func(struct sdio
 	vsn = func->card->cccr.sdio_vsn;
 	min_size = (vsn == SDIO_SDIO_REV_1_00) ? 28 : 42;
 
+	/* let the SDIO driver take care of unknown tuples */
 	if (size < min_size || buf[0] != 1)
-		return -EINVAL;
+		return -EILSEQ;
 
 	/* TPLFE_MAX_BLK_SIZE */
 	func->max_blksize = buf[12] | (buf[13] << 8);
@@ -154,13 +155,7 @@ static int cistpl_funce(struct mmc_card 
 	else
 		ret = cistpl_funce_common(card, buf, size);
 
-	if (ret) {
-		printk(KERN_ERR "%s: bad CISTPL_FUNCE size %u "
-		       "type %u\n", mmc_hostname(card->host), size, buf[0]);
-		return ret;
-	}
-
-	return 0;
+	return ret;
 }
 
 typedef int (tpl_parse_t)(struct mmc_card *, struct sdio_func *,
@@ -253,21 +248,12 @@ static int sdio_read_cis(struct mmc_card
 		for (i = 0; i < ARRAY_SIZE(cis_tpl_list); i++)
 			if (cis_tpl_list[i].code == tpl_code)
 				break;
-		if (i >= ARRAY_SIZE(cis_tpl_list)) {
-			/* this tuple is unknown to the core */
-			this->next = NULL;
-			this->code = tpl_code;
-			this->size = tpl_link;
-			*prev = this;
-			prev = &this->next;
-			printk(KERN_DEBUG
-			       "%s: queuing CIS tuple 0x%02x length %u\n",
-			       mmc_hostname(card->host), tpl_code, tpl_link);
-		} else {
+		if (i < ARRAY_SIZE(cis_tpl_list)) {
 			const struct cis_tpl *tpl = cis_tpl_list + i;
 			if (tpl_link < tpl->min_size) {
 				printk(KERN_ERR
-				       "%s: bad CIS tuple 0x%02x (length = %u, expected >= %u)\n",
+				       "%s: bad CIS tuple 0x%02x"
+				       " (length = %u, expected >= %u)\n",
 				       mmc_hostname(card->host),
 				       tpl_code, tpl_link, tpl->min_size);
 				ret = -EINVAL;
@@ -275,7 +261,25 @@ static int sdio_read_cis(struct mmc_card
 				ret = tpl->parse(card, func,
 						 this->data, tpl_link);
 			}
-			kfree(this);
+			/* already successfully parsed, not needed anymore */
+			if (!ret)
+				kfree(this);
+		} else {
+			/* unknown tuple */
+			ret = -EILSEQ;
+		}
+
+		if (ret == -EILSEQ) {
+			/* this tuple is unknown to the core */
+			this->next = NULL;
+			this->code = tpl_code;
+			this->size = tpl_link;
+			*prev = this;
+			prev = &this->next;
+			pr_debug("%s: queuing CIS tuple 0x%02x length %u\n",
+				 mmc_hostname(card->host), tpl_code, tpl_link);
+			/* keep on analyzing tuples */
+			ret = 0;
 		}
 
 		ptr += tpl_link;
_

Patches currently in -mm which might be from albert_herranz@yahoo.es are

linux-next.patch
sdio-pass-unknown-cis-tuples-to-sdio-drivers.patch

