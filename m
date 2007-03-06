From: akpm@linux-foundation.org
Subject: + mqueue-nested-locking-annotation.patch added to -mm tree
Date: Mon, 05 Mar 2007 20:08:30 -0800
Message-ID: <200703060408.l2648UDw011377@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49629 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751947AbXCFEIo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 23:08:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: a.p.zijlstra@chello.nl


The patch titled
     mqueue: nested locking annotation
has been added to the -mm tree.  Its filename is
     mqueue-nested-locking-annotation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mqueue: nested locking annotation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Fix http://bugzilla.kernel.org/show_bug.cgi?id=8130

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN ipc/mqueue.c~mqueue-nested-locking-annotation ipc/mqueue.c
--- a/ipc/mqueue.c~mqueue-nested-locking-annotation
+++ a/ipc/mqueue.c
@@ -731,7 +731,8 @@ asmlinkage long sys_mq_unlink(const char
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
-	mutex_lock(&mqueue_mnt->mnt_root->d_inode->i_mutex);
+	mutex_lock_nested(&mqueue_mnt->mnt_root->d_inode->i_mutex,
+			I_MUTEX_PARENT);
 	dentry = lookup_one_len(name, mqueue_mnt->mnt_root, strlen(name));
 	if (IS_ERR(dentry)) {
 		err = PTR_ERR(dentry);
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

mqueue-nested-locking-annotation.patch
ecryptfs-nested-locking-annotation.patch
nfs-fix-congestion-control-v4.patch
nfs-fix-congestion-control-use-atomic_longs.patch
