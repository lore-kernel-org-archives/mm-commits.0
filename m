From: akpm@linux-foundation.org
Subject: + reiserfs-fix-sparse-warnings-in-fix_nodec.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:35:14 -0800
Message-ID: <200802230736.m1N7a3j3018399@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760797AbYBWH4z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 02:56:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, chris.mason@oracle.com, jeffm@suse.com


The patch titled
     reiserfs: fix sparse warnings in fix_node.c
has been added to the -mm tree.  Its filename is
     reiserfs-fix-sparse-warnings-in-fix_nodec.patch

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
Subject: reiserfs: fix sparse warnings in fix_node.c
From: Harvey Harrison <harvey.harrison@gmail.com>

fs/reiserfs/fix_node.c:156:3: warning: Using plain integer as NULL pointer
fs/reiserfs/fix_node.c:860:46: warning: Using plain integer as NULL pointer
fs/reiserfs/fix_node.c:860:70: warning: Using plain integer as NULL pointer
fs/reiserfs/fix_node.c:881:46: warning: Using plain integer as NULL pointer
fs/reiserfs/fix_node.c:881:70: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/fix_node.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN fs/reiserfs/fix_node.c~reiserfs-fix-sparse-warnings-in-fix_nodec fs/reiserfs/fix_node.c
--- a/fs/reiserfs/fix_node.c~reiserfs-fix-sparse-warnings-in-fix_nodec
+++ a/fs/reiserfs/fix_node.c
@@ -153,7 +153,7 @@ static void create_virtual_node(struct t
 	if (vn->vn_mode == M_INSERT) {
 		struct virtual_item *vi = vn->vn_vi + vn->vn_affected_item_num;
 
-		RFALSE(vn->vn_ins_ih == 0,
+		RFALSE(vn->vn_ins_ih == NULL,
 		       "vs-8040: item header of inserted item is not specified");
 		vi->vi_item_len = tb->insert_size[0];
 		vi->vi_ih = vn->vn_ins_ih;
@@ -857,7 +857,8 @@ static int get_lfree(struct tree_balance
 	struct buffer_head *l, *f;
 	int order;
 
-	if ((f = PATH_H_PPARENT(tb->tb_path, h)) == 0 || (l = tb->FL[h]) == 0)
+	if ((f = PATH_H_PPARENT(tb->tb_path, h)) == NULL ||
+	    (l = tb->FL[h]) == NULL)
 		return 0;
 
 	if (f == l)
@@ -878,7 +879,8 @@ static int get_rfree(struct tree_balance
 	struct buffer_head *r, *f;
 	int order;
 
-	if ((f = PATH_H_PPARENT(tb->tb_path, h)) == 0 || (r = tb->FR[h]) == 0)
+	if ((f = PATH_H_PPARENT(tb->tb_path, h)) == NULL ||
+	    (r = tb->FR[h]) == NULL)
 		return 0;
 
 	if (f == r)
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
