From: akpm@linux-foundation.org
Subject: - reiserfs-fix-more-sparse-warnings-in-do_balanc.patch removed from -mm tree
Date: Mon, 28 Apr 2008 15:01:19 -0700
Message-ID: <200804282201.m3SM1JKF018849@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965822AbYD1WCN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 18:02:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, chris.mason@oracle.com, jeffm@suse.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: fix more sparse warnings in do_balan.c
has been removed from the -mm tree.  Its filename was
     reiserfs-fix-more-sparse-warnings-in-do_balanc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiserfs: fix more sparse warnings in do_balan.c
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/reiserfs/do_balan.c:1467:10: warning: symbol 'ret_val' shadows an earlier one
fs/reiserfs/do_balan.c:275:6: originally declared here
fs/reiserfs/do_balan.c:1471:23: warning: symbol 'ih' shadows an earlier one
fs/reiserfs/do_balan.c:249:67: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/do_balan.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/reiserfs/do_balan.c~reiserfs-fix-more-sparse-warnings-in-do_balanc fs/reiserfs/do_balan.c
--- a/fs/reiserfs/do_balan.c~reiserfs-fix-more-sparse-warnings-in-do_balanc
+++ a/fs/reiserfs/do_balan.c
@@ -1464,29 +1464,29 @@ static int balance_leaf(struct tree_bala
 				} else
 					/* item falls wholly into S_new[i] */
 				{
-					int ret_val;
+					int leaf_mi;
 					struct item_head *pasted;
 
 #ifdef CONFIG_REISERFS_CHECK
-					struct item_head *ih =
+					struct item_head *ih_check =
 					    B_N_PITEM_HEAD(tbS0, item_pos);
 
-					if (!is_direntry_le_ih(ih)
-					    && (pos_in_item != ih_item_len(ih)
+					if (!is_direntry_le_ih(ih_check)
+					    && (pos_in_item != ih_item_len(ih_check)
 						|| tb->insert_size[0] <= 0))
 						reiserfs_panic(tb->tb_sb,
 							       "PAP-12235: balance_leaf: pos_in_item must be equal to ih_item_len");
 #endif				/* CONFIG_REISERFS_CHECK */
 
-					ret_val =
+					leaf_mi =
 					    leaf_move_items(LEAF_FROM_S_TO_SNEW,
 							    tb, snum[i],
 							    sbytes[i],
 							    S_new[i]);
 
-					RFALSE(ret_val,
+					RFALSE(leaf_mi,
 					       "PAP-12240: unexpected value returned by leaf_move_items (%d)",
-					       ret_val);
+					       leaf_mi);
 
 					/* paste into item */
 					bi.tb = tb;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
git-kvm.patch
git-mips.patch
git-nfsd.patch
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
power-replace-remaining-__function__-occurrences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
firmware-replace-remaining-__function__-occurrences.patch
drivers-misc-replace-remaining-__function__-occurrences.patch
xen-make-blkif_getgeo-static.patch
ecryptfs-replace-remaining-__function__-occurrences.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
ext4-replace-remaining-__function__-occurrences.patch
jdb2-replace-remaining-__function__-occurrences.patch
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
kernel-add-common-infrastructure-for-unaligned-access.patch
kernel-move-arches-to-use-common-unaligned-access.patch
drivers-block-use-get_unaligned_-helpers.patch
hid-core-use-get_unaligned_-helpers.patch
char-use-get_unaligned_-helpers.patch
input-use-get_unaligned_-helpers.patch
mmc-use-get-put_unaligned_-helpers.patch
net-use-get-put_unaligned_-helpers.patch
wireless-use-get-put_unaligned_-helpers.patch
pcmcia-use-get-put_unaligned_-helpers.patch
usb-use-get-put_unaligned_-helpers.patch
video-use-get-put_unaligned_-helpers.patch
fat-use-get-put_unaligned_-helpers.patch
hfsplus-use-get-put_unaligned_-helpers.patch
isofs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers.patch
ncpfs-use-get-put_unaligned_-helpers-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch
afs-replace-remaining-__function__-occurrences.patch
fs-replace-remaining-__function__-occurrences.patch
drivers-char-replace-remaining-__function__-occurrences.patch
serial-replace-remaining-__function__-occurrences.patch

