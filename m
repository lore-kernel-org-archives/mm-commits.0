From: akpm@linux-foundation.org
Subject: - hid-core-use-get_unaligned_-helpers.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:49:13 -0700
Message-ID: <200804300549.m3U5nD68029978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758811AbYD3Ftq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:49:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, jkosina@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     hid-core: use get_unaligned_* helpers
has been removed from the -mm tree.  Its filename was
     hid-core-use-get_unaligned_-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hid-core: use get_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hid/hid-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/hid/hid-core.c~hid-core-use-get_unaligned_-helpers drivers/hid/hid-core.c
--- a/drivers/hid/hid-core.c~hid-core-use-get_unaligned_-helpers
+++ a/drivers/hid/hid-core.c
@@ -606,7 +606,7 @@ static u8 *fetch_item(__u8 *start, __u8 
 		case 2:
 			if ((end - start) < 2)
 				return NULL;
-			item->data.u16 = le16_to_cpu(get_unaligned((__le16*)start));
+			item->data.u16 = get_unaligned_le16(start);
 			start = (__u8 *)((__le16 *)start + 1);
 			return start;
 
@@ -614,7 +614,7 @@ static u8 *fetch_item(__u8 *start, __u8 
 			item->size++;
 			if ((end - start) < 4)
 				return NULL;
-			item->data.u32 = le32_to_cpu(get_unaligned((__le32*)start));
+			item->data.u32 = get_unaligned_le32(start);
 			start = (__u8 *)((__le32 *)start + 1);
 			return start;
 	}
@@ -765,7 +765,7 @@ static __inline__ __u32 extract(__u8 *re
 
 	report += offset >> 3;  /* adjust byte index */
 	offset &= 7;            /* now only need bit offset into one byte */
-	x = le64_to_cpu(get_unaligned((__le64 *) report));
+	x = get_unaligned_le64(report);
 	x = (x >> offset) & ((1ULL << n) - 1);  /* extract bit field */
 	return (u32) x;
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

