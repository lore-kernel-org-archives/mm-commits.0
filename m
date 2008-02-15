From: akpm@linux-foundation.org
Subject: + befs-fix-sparse-warning-in-linuxvfsc.patch added to -mm tree
Date: Fri, 15 Feb 2008 13:19:27 -0800
Message-ID: <200802152119.m1FLJRSN024473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34945 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758058AbYBOVUG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 16:20:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, rathamahata@php4.ru


The patch titled
     befs: fix sparse warning in linuxvfs.c
has been added to the -mm tree.  Its filename is
     befs-fix-sparse-warning-in-linuxvfsc.patch

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
Subject: befs: fix sparse warning in linuxvfs.c
From: Harvey Harrison <harvey.harrison@gmail.com>

Use link as the variable name to avoid shadowing the arg.

fs/befs/linuxvfs.c:492:8: warning: symbol 'p' shadows an earlier one
fs/befs/linuxvfs.c:488:77: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "Sergey S. Kostyliov" <rathamahata@php4.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/befs/linuxvfs.c~befs-fix-sparse-warning-in-linuxvfsc fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~befs-fix-sparse-warning-in-linuxvfsc
+++ a/fs/befs/linuxvfs.c
@@ -489,9 +489,9 @@ static void befs_put_link(struct dentry 
 {
 	befs_inode_info *befs_ino = BEFS_I(dentry->d_inode);
 	if (befs_ino->i_flags & BEFS_LONG_SYMLINK) {
-		char *p = nd_get_link(nd);
-		if (!IS_ERR(p))
-			kfree(p);
+		char *link = nd_get_link(nd);
+		if (!IS_ERR(link))
+			kfree(link);
 	}
 }
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ubi-fix-sparse-errors-in-ubih.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
