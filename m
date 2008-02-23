From: akpm@linux-foundation.org
Subject: + reiserfs-fix-sparse-warnings-in-do_balanc.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:35:16 -0800
Message-ID: <200802230736.m1N7a5ft018402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42121 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098AbYBWIAH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:00:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, chris.mason@oracle.com, jeffm@suse.com


The patch titled
     reiserfs: fix sparse warnings in do_balan.c
has been added to the -mm tree.  Its filename is
     reiserfs-fix-sparse-warnings-in-do_balanc.patch

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
Subject: reiserfs: fix sparse warnings in do_balan.c
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/reiserfs/do_balan.c:286:34: warning: Using plain integer as NULL pointer
fs/reiserfs/do_balan.c:1731:21: warning: Using plain integer as NULL pointer
fs/reiserfs/do_balan.c:1830:2: warning: Using plain integer as NULL pointer
fs/reiserfs/do_balan.c:1830:2: warning: Using plain integer as NULL pointer
fs/reiserfs/do_balan.c:1844:2: warning: Using plain integer as NULL pointer
fs/reiserfs/do_balan.c:1844:2: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/do_balan.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/reiserfs/do_balan.c~reiserfs-fix-sparse-warnings-in-do_balanc fs/reiserfs/do_balan.c
--- a/fs/reiserfs/do_balan.c~reiserfs-fix-sparse-warnings-in-do_balanc
+++ a/fs/reiserfs/do_balan.c
@@ -283,7 +283,7 @@ static int balance_leaf(struct tree_bala
 		return balance_leaf_when_delete(tb, flag);
 
 	zeros_num = 0;
-	if (flag == M_INSERT && body == 0)
+	if (flag == M_INSERT && body == NULL)
 		zeros_num = ih_item_len(ih);
 
 	pos_in_item = tb->tb_path->pos_in_item;
@@ -1728,7 +1728,7 @@ struct buffer_head *get_FEB(struct tree_
 	struct buffer_info bi;
 
 	for (i = 0; i < MAX_FEB_SIZE; i++)
-		if (tb->FEB[i] != 0)
+		if (tb->FEB[i])
 			break;
 
 	if (i == MAX_FEB_SIZE)
@@ -1827,7 +1827,7 @@ int get_left_neighbor_position(struct tr
 {
 	int Sh_position = PATH_H_POSITION(tb->tb_path, h + 1);
 
-	RFALSE(PATH_H_PPARENT(tb->tb_path, h) == 0 || tb->FL[h] == 0,
+	RFALSE(PATH_H_PPARENT(tb->tb_path, h) == NULL || tb->FL[h] == NULL,
 	       "vs-12325: FL[%d](%p) or F[%d](%p) does not exist",
 	       h, tb->FL[h], h, PATH_H_PPARENT(tb->tb_path, h));
 
@@ -1841,7 +1841,7 @@ int get_right_neighbor_position(struct t
 {
 	int Sh_position = PATH_H_POSITION(tb->tb_path, h + 1);
 
-	RFALSE(PATH_H_PPARENT(tb->tb_path, h) == 0 || tb->FR[h] == 0,
+	RFALSE(PATH_H_PPARENT(tb->tb_path, h) == NULL || tb->FR[h] == NULL,
 	       "vs-12330: F[%d](%p) or FR[%d](%p) does not exist",
 	       h, PATH_H_PPARENT(tb->tb_path, h), h, tb->FR[h]);
 
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
