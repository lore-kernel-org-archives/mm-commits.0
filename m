From: akpm@linux-foundation.org
Subject: - wireless-use-get-put_unaligned_-helpers.patch removed from -mm tree
Date: Fri, 16 May 2008 15:54:24 -0700
Message-ID: <200805162254.m4GMsOFb003239@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41994 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758094AbYEPWyn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:54:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, linville@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     wireless: use get/put_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     wireless-use-get-put_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wireless: use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/mac80211/mesh_hwmp.c |    2 +-
 net/wireless/radiotap.c  |   16 +++++++---------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff -puN net/mac80211/mesh_hwmp.c~wireless-use-get-put_unaligned_-helpers net/mac80211/mesh_hwmp.c
--- a/net/mac80211/mesh_hwmp.c~wireless-use-get-put_unaligned_-helpers
+++ a/net/mac80211/mesh_hwmp.c
@@ -26,7 +26,7 @@ static inline u32 u32_field_get(u8 *preq
 {
 	if (ae)
 		offset += 6;
-	return le32_to_cpu(get_unaligned((__le32 *) (preq_elem + offset)));
+	return get_unaligned_le32(preq_elem + offset);
 }
 
 /* HWMP IE processing macros */
diff -puN net/wireless/radiotap.c~wireless-use-get-put_unaligned_-helpers net/wireless/radiotap.c
--- a/net/wireless/radiotap.c~wireless-use-get-put_unaligned_-helpers
+++ a/net/wireless/radiotap.c
@@ -59,23 +59,21 @@ int ieee80211_radiotap_iterator_init(
 		return -EINVAL;
 
 	/* sanity check for allowed length and radiotap length field */
-	if (max_length < le16_to_cpu(get_unaligned(&radiotap_header->it_len)))
+	if (max_length < get_unaligned_le16(&radiotap_header->it_len))
 		return -EINVAL;
 
 	iterator->rtheader = radiotap_header;
-	iterator->max_length = le16_to_cpu(get_unaligned(
-						&radiotap_header->it_len));
+	iterator->max_length = get_unaligned_le16(&radiotap_header->it_len);
 	iterator->arg_index = 0;
-	iterator->bitmap_shifter = le32_to_cpu(get_unaligned(
-						&radiotap_header->it_present));
+	iterator->bitmap_shifter = get_unaligned_le32(&radiotap_header->it_present);
 	iterator->arg = (u8 *)radiotap_header + sizeof(*radiotap_header);
 	iterator->this_arg = NULL;
 
 	/* find payload start allowing for extended bitmap(s) */
 
 	if (unlikely(iterator->bitmap_shifter & (1<<IEEE80211_RADIOTAP_EXT))) {
-		while (le32_to_cpu(get_unaligned((__le32 *)iterator->arg)) &
-				   (1<<IEEE80211_RADIOTAP_EXT)) {
+		while (get_unaligned_le32(iterator->arg) &
+		       (1 << IEEE80211_RADIOTAP_EXT)) {
 			iterator->arg += sizeof(u32);
 
 			/*
@@ -241,8 +239,8 @@ int ieee80211_radiotap_iterator_next(
 			if (iterator->bitmap_shifter & 1) {
 				/* b31 was set, there is more */
 				/* move to next u32 bitmap */
-				iterator->bitmap_shifter = le32_to_cpu(
-					get_unaligned(iterator->next_bitmap));
+				iterator->bitmap_shifter =
+				    get_unaligned_le32(iterator->next_bitmap);
 				iterator->next_bitmap++;
 			} else
 				/* no more bitmaps: end */
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
kgdb-use-put_unaligned_be32-helper.patch
cifs-remove-global_extern-macro.patch
media-use-get_unaligned_-helpers.patch
hid-use-get-put_unaligned_-helpers.patch
git-input.patch
ata-remove-fit-macro.patch
mtd-mtdcharc-silence-sparse-warning.patch
mtd-mtdcharc-remove-shadowed-variable-warnings.patch
nfs-replace-remaining-__function__-occurrences.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
scsi-use-get_unaligned_-helpers.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
block-use-get_unaligned_-helpers.patch
usb-host-use-get-put_unaligned_-helpers-to-fix-more-potential-unaligned-issues.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
fs-ldm-use-get_unaligned_-helpers.patch
include-use-get-put_unaligned_-helpers.patch
lzo-use-get-put_unaligned_-helpers.patch
video-fix-integer-as-null-pointer-warnings.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
isdn-use-the-common-ascii-hex-helpers.patch
net-use-the-common-ascii-hex-helpers.patch
kgdb-use-the-common-ascii-hex-helpers.patch
cris-use-the-common-ascii-hex-helpers.patch
frv-use-the-common-ascii-hex-helpers.patch
mips-use-the-common-ascii-hex-helpers.patch
sh-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
mn10300-use-the-common-ascii-hex-helpers.patch

