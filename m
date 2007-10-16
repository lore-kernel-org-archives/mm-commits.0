From: akpm@linux-foundation.org
Subject: - pcmcia-cistpl-use-get_unaligned-in-cis-parsing.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:29:43 -0700
Message-ID: <200710162029.l9GKThOd014336@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39416 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935944AbXJPUaC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:30:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.ritz-ml@swissonline.ch, daniel.ritz@gmx.ch, hskinnemoen@atmel.com, mm-commits@vger.kernel.org


The patch titled
     pcmcia: cistpl: use get_unaligned() in CIS parsing
has been removed from the -mm tree.  Its filename was
     pcmcia-cistpl-use-get_unaligned-in-cis-parsing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: pcmcia: cistpl: use get_unaligned() in CIS parsing
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>

Based on a patch by Haavard Skinnemoen posted to linux-pcmcia, but using
static inlines for readability reasons.  this should fix PCMCIA an AVR32

Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/cistpl.c |   48 ++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff -puN drivers/pcmcia/cistpl.c~pcmcia-cistpl-use-get_unaligned-in-cis-parsing drivers/pcmcia/cistpl.c
--- a/drivers/pcmcia/cistpl.c~pcmcia-cistpl-use-get_unaligned-in-cis-parsing
+++ a/drivers/pcmcia/cistpl.c
@@ -25,6 +25,7 @@
 #include <linux/ioport.h>
 #include <asm/io.h>
 #include <asm/byteorder.h>
+#include <asm/unaligned.h>
 
 #include <pcmcia/cs_types.h>
 #include <pcmcia/ss.h>
@@ -401,6 +402,15 @@ EXPORT_SYMBOL(pcmcia_replace_cis);
     
 ======================================================================*/
 
+static inline u16 cis_get_u16(void *ptr)
+{
+	return le16_to_cpu(get_unaligned((__le16 *) ptr));
+}
+static inline u32 cis_get_u32(void *ptr)
+{
+	return le32_to_cpu(get_unaligned((__le32 *) ptr));
+}
+
 typedef struct tuple_flags {
     u_int		link_space:4;
     u_int		has_link:1;
@@ -461,7 +471,7 @@ static int follow_link(struct pcmcia_soc
 	/* Get indirect link from the MFC tuple */
 	read_cis_cache(s, LINK_SPACE(tuple->Flags),
 		       tuple->LinkOffset, 5, link);
-	ofs = le32_to_cpu(*(__le32 *)(link+1));
+	ofs = cis_get_u32(link + 1);
 	SPACE(tuple->Flags) = (link[0] == CISTPL_MFC_ATTR);
 	/* Move to the next indirect link */
 	tuple->LinkOffset += 5;
@@ -668,10 +678,10 @@ static int parse_checksum(tuple_t *tuple
     u_char *p;
     if (tuple->TupleDataLen < 5)
 	return CS_BAD_TUPLE;
-    p = (u_char *)tuple->TupleData;
-    csum->addr = tuple->CISOffset+(short)le16_to_cpu(*(__le16 *)p)-2;
-    csum->len = le16_to_cpu(*(__le16 *)(p + 2));
-    csum->sum = *(p+4);
+    p = (u_char *) tuple->TupleData;
+    csum->addr = tuple->CISOffset + cis_get_u16(p) - 2;
+    csum->len = cis_get_u16(p + 2);
+    csum->sum = *(p + 4);
     return CS_SUCCESS;
 }
 
@@ -681,7 +691,7 @@ static int parse_longlink(tuple_t *tuple
 {
     if (tuple->TupleDataLen < 4)
 	return CS_BAD_TUPLE;
-    link->addr = le32_to_cpu(*(__le32 *)tuple->TupleData);
+    link->addr = cis_get_u32(tuple->TupleData);
     return CS_SUCCESS;
 }
 
@@ -700,7 +710,8 @@ static int parse_longlink_mfc(tuple_t *t
 	return CS_BAD_TUPLE;
     for (i = 0; i < link->nfn; i++) {
 	link->fn[i].space = *p; p++;
-	link->fn[i].addr = le32_to_cpu(*(__le32 *)p); p += 4;
+	link->fn[i].addr = cis_get_u32(p);
+	p += 4;
     }
     return CS_SUCCESS;
 }
@@ -787,12 +798,10 @@ static int parse_jedec(tuple_t *tuple, c
 
 static int parse_manfid(tuple_t *tuple, cistpl_manfid_t *m)
 {
-    __le16 *p;
     if (tuple->TupleDataLen < 4)
 	return CS_BAD_TUPLE;
-    p = (__le16 *)tuple->TupleData;
-    m->manf = le16_to_cpu(p[0]);
-    m->card = le16_to_cpu(p[1]);
+    m->manf = cis_get_u16(tuple->TupleData);
+    m->card = cis_get_u16(tuple->TupleData + 2);
     return CS_SUCCESS;
 }
 
@@ -1091,7 +1100,7 @@ static int parse_cftable_entry(tuple_t *
 	break;
     case 0x20:
 	entry->mem.nwin = 1;
-	entry->mem.win[0].len = le16_to_cpu(*(__le16 *)p) << 8;
+	entry->mem.win[0].len = cis_get_u16(p) << 8;
 	entry->mem.win[0].card_addr = 0;
 	entry->mem.win[0].host_addr = 0;
 	p += 2;
@@ -1099,9 +1108,8 @@ static int parse_cftable_entry(tuple_t *
 	break;
     case 0x40:
 	entry->mem.nwin = 1;
-	entry->mem.win[0].len = le16_to_cpu(*(__le16 *)p) << 8;
-	entry->mem.win[0].card_addr =
-	    le16_to_cpu(*(__le16 *)(p+2)) << 8;
+	entry->mem.win[0].len = cis_get_u16(p) << 8;
+	entry->mem.win[0].card_addr = cis_get_u16(p + 2) << 8;
 	entry->mem.win[0].host_addr = 0;
 	p += 4;
 	if (p > q) return CS_BAD_TUPLE;
@@ -1138,7 +1146,7 @@ static int parse_bar(tuple_t *tuple, cis
     p = (u_char *)tuple->TupleData;
     bar->attr = *p;
     p += 2;
-    bar->size = le32_to_cpu(*(__le32 *)p);
+    bar->size = cis_get_u32(p);
     return CS_SUCCESS;
 }
 
@@ -1151,7 +1159,7 @@ static int parse_config_cb(tuple_t *tupl
 	return CS_BAD_TUPLE;
     config->last_idx = *(++p);
     p++;
-    config->base = le32_to_cpu(*(__le32 *)p);
+    config->base = cis_get_u32(p);
     config->subtuples = tuple->TupleDataLen - 6;
     return CS_SUCCESS;
 }
@@ -1267,7 +1275,7 @@ static int parse_vers_2(tuple_t *tuple, 
 
     v2->vers = p[0];
     v2->comply = p[1];
-    v2->dindex = le16_to_cpu(*(__le16 *)(p+2));
+    v2->dindex = cis_get_u16(p +2 );
     v2->vspec8 = p[6];
     v2->vspec9 = p[7];
     v2->nhdr = p[8];
@@ -1308,8 +1316,8 @@ static int parse_format(tuple_t *tuple, 
 
     fmt->type = p[0];
     fmt->edc = p[1];
-    fmt->offset = le32_to_cpu(*(__le32 *)(p+2));
-    fmt->length = le32_to_cpu(*(__le32 *)(p+6));
+    fmt->offset = cis_get_u32(p + 2);
+    fmt->length = cis_get_u32(p + 6);
 
     return CS_SUCCESS;
 }
_

Patches currently in -mm which might be from daniel.ritz-ml@swissonline.ch are

origin.patch
