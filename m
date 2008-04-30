From: akpm@linux-foundation.org
Subject: - pcmcia-use-get-put_unaligned_-helpers.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:27 -0700
Message-ID: <200804300549.m3U5nRYC030005@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50969 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758808AbYD3FuE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:50:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, daniel.ritz@gmx.ch, linux@dominikbrodowski.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     pcmcia: use get/put_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     pcmcia-use-get-put_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pcmcia: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Daniel Ritz <daniel.ritz@gmx.ch>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pcmcia/cistpl.c |   39 ++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff -puN drivers/pcmcia/cistpl.c~pcmcia-use-get-put_unaligned_-helpers drivers/pcmcia/cistpl.c
--- a/drivers/pcmcia/cistpl.c~pcmcia-use-get-put_unaligned_-helpers
+++ a/drivers/pcmcia/cistpl.c
@@ -402,15 +402,6 @@ EXPORT_SYMBOL(pcmcia_replace_cis);
     
 ======================================================================*/
 
-static inline u16 cis_get_u16(void *ptr)
-{
-	return le16_to_cpu(get_unaligned((__le16 *) ptr));
-}
-static inline u32 cis_get_u32(void *ptr)
-{
-	return le32_to_cpu(get_unaligned((__le32 *) ptr));
-}
-
 typedef struct tuple_flags {
     u_int		link_space:4;
     u_int		has_link:1;
@@ -471,7 +462,7 @@ static int follow_link(struct pcmcia_soc
 	/* Get indirect link from the MFC tuple */
 	read_cis_cache(s, LINK_SPACE(tuple->Flags),
 		       tuple->LinkOffset, 5, link);
-	ofs = cis_get_u32(link + 1);
+	ofs = get_unaligned_le32(link + 1);
 	SPACE(tuple->Flags) = (link[0] == CISTPL_MFC_ATTR);
 	/* Move to the next indirect link */
 	tuple->LinkOffset += 5;
@@ -679,8 +670,8 @@ static int parse_checksum(tuple_t *tuple
     if (tuple->TupleDataLen < 5)
 	return CS_BAD_TUPLE;
     p = (u_char *) tuple->TupleData;
-    csum->addr = tuple->CISOffset + cis_get_u16(p) - 2;
-    csum->len = cis_get_u16(p + 2);
+    csum->addr = tuple->CISOffset + get_unaligned_le16(p) - 2;
+    csum->len = get_unaligned_le16(p + 2);
     csum->sum = *(p + 4);
     return CS_SUCCESS;
 }
@@ -691,7 +682,7 @@ static int parse_longlink(tuple_t *tuple
 {
     if (tuple->TupleDataLen < 4)
 	return CS_BAD_TUPLE;
-    link->addr = cis_get_u32(tuple->TupleData);
+    link->addr = get_unaligned_le32(tuple->TupleData);
     return CS_SUCCESS;
 }
 
@@ -710,7 +701,7 @@ static int parse_longlink_mfc(tuple_t *t
 	return CS_BAD_TUPLE;
     for (i = 0; i < link->nfn; i++) {
 	link->fn[i].space = *p; p++;
-	link->fn[i].addr = cis_get_u32(p);
+	link->fn[i].addr = get_unaligned_le32(p);
 	p += 4;
     }
     return CS_SUCCESS;
@@ -800,8 +791,8 @@ static int parse_manfid(tuple_t *tuple, 
 {
     if (tuple->TupleDataLen < 4)
 	return CS_BAD_TUPLE;
-    m->manf = cis_get_u16(tuple->TupleData);
-    m->card = cis_get_u16(tuple->TupleData + 2);
+    m->manf = get_unaligned_le16(tuple->TupleData);
+    m->card = get_unaligned_le16(tuple->TupleData + 2);
     return CS_SUCCESS;
 }
 
@@ -1100,7 +1091,7 @@ static int parse_cftable_entry(tuple_t *
 	break;
     case 0x20:
 	entry->mem.nwin = 1;
-	entry->mem.win[0].len = cis_get_u16(p) << 8;
+	entry->mem.win[0].len = get_unaligned_le16(p) << 8;
 	entry->mem.win[0].card_addr = 0;
 	entry->mem.win[0].host_addr = 0;
 	p += 2;
@@ -1108,8 +1099,8 @@ static int parse_cftable_entry(tuple_t *
 	break;
     case 0x40:
 	entry->mem.nwin = 1;
-	entry->mem.win[0].len = cis_get_u16(p) << 8;
-	entry->mem.win[0].card_addr = cis_get_u16(p + 2) << 8;
+	entry->mem.win[0].len = get_unaligned_le16(p) << 8;
+	entry->mem.win[0].card_addr = get_unaligned_le16(p + 2) << 8;
 	entry->mem.win[0].host_addr = 0;
 	p += 4;
 	if (p > q) return CS_BAD_TUPLE;
@@ -1146,7 +1137,7 @@ static int parse_bar(tuple_t *tuple, cis
     p = (u_char *)tuple->TupleData;
     bar->attr = *p;
     p += 2;
-    bar->size = cis_get_u32(p);
+    bar->size = get_unaligned_le32(p);
     return CS_SUCCESS;
 }
 
@@ -1159,7 +1150,7 @@ static int parse_config_cb(tuple_t *tupl
 	return CS_BAD_TUPLE;
     config->last_idx = *(++p);
     p++;
-    config->base = cis_get_u32(p);
+    config->base = get_unaligned_le32(p);
     config->subtuples = tuple->TupleDataLen - 6;
     return CS_SUCCESS;
 }
@@ -1275,7 +1266,7 @@ static int parse_vers_2(tuple_t *tuple, 
 
     v2->vers = p[0];
     v2->comply = p[1];
-    v2->dindex = cis_get_u16(p +2 );
+    v2->dindex = get_unaligned_le16(p +2 );
     v2->vspec8 = p[6];
     v2->vspec9 = p[7];
     v2->nhdr = p[8];
@@ -1316,8 +1307,8 @@ static int parse_format(tuple_t *tuple, 
 
     fmt->type = p[0];
     fmt->edc = p[1];
-    fmt->offset = cis_get_u32(p + 2);
-    fmt->length = cis_get_u32(p + 6);
+    fmt->offset = get_unaligned_le32(p + 2);
+    fmt->length = get_unaligned_le32(p + 6);
 
     return CS_SUCCESS;
 }
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-fix-arch-frv-mm-unalignedo-build-error.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
add-macros-similar-to-min-max-min_t-max_t.patch
add-macros-similar-to-min-max-min_t-max_t-doc.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
drivers-replace-remaining-__function__-occurrences.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

