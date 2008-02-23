From: akpm@linux-foundation.org
Subject: + reiserfs-fix-more-sparse-warnings-in-do_balanc.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:35:24 -0800
Message-ID: <200802230736.m1N7aDqg018417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37368 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbYBWH5y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:57:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, chris.mason@oracle.com, jeffm@suse.com


The patch titled
     reiserfs: fix more sparse warnings in do_balan.c
has been added to the -mm tree.  Its filename is
     reiserfs-fix-more-sparse-warnings-in-do_balanc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
markers-fix-sparse-warnings-in-markersc.patch
acpi-sparse-fix-replace-macro-with-static-function.patch
bttv-struct-member-initialized-twice.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ata-fix-sparse-warning-in-libatah.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
lockd-fix-sparse-warning-in-svcsharec.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
