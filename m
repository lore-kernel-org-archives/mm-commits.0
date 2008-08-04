From: akpm@linux-foundation.org
Subject: - devpts-switch-to-ida.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:07:53 -0700
Message-ID: <200808042007.m74K7rh6027859@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760841AbYHDUID (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:08:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     devpts: switch to IDA
has been removed from the -mm tree.  Its filename was
     devpts-switch-to-ida.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: devpts: switch to IDA
From: Alexey Dobriyan <adobriyan@gmail.com>

Devpts code wants just numbers for tty indexes.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN fs/devpts/inode.c~devpts-switch-to-ida fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-switch-to-ida
+++ a/fs/devpts/inode.c
@@ -29,7 +29,7 @@
 #define DEVPTS_DEFAULT_MODE 0600
 
 extern int pty_limit;			/* Config limit on Unix98 ptys */
-static DEFINE_IDR(allocated_ptys);
+static DEFINE_IDA(allocated_ptys);
 static DEFINE_MUTEX(allocated_ptys_lock);
 
 static struct vfsmount *devpts_mnt;
@@ -180,24 +180,24 @@ static struct dentry *get_node(int num)
 int devpts_new_index(void)
 {
 	int index;
-	int idr_ret;
+	int ida_ret;
 
 retry:
-	if (!idr_pre_get(&allocated_ptys, GFP_KERNEL)) {
+	if (!ida_pre_get(&allocated_ptys, GFP_KERNEL)) {
 		return -ENOMEM;
 	}
 
 	mutex_lock(&allocated_ptys_lock);
-	idr_ret = idr_get_new(&allocated_ptys, NULL, &index);
-	if (idr_ret < 0) {
+	ida_ret = ida_get_new(&allocated_ptys, &index);
+	if (ida_ret < 0) {
 		mutex_unlock(&allocated_ptys_lock);
-		if (idr_ret == -EAGAIN)
+		if (ida_ret == -EAGAIN)
 			goto retry;
 		return -EIO;
 	}
 
 	if (index >= pty_limit) {
-		idr_remove(&allocated_ptys, index);
+		ida_remove(&allocated_ptys, index);
 		mutex_unlock(&allocated_ptys_lock);
 		return -EIO;
 	}
@@ -208,7 +208,7 @@ retry:
 void devpts_kill_index(int idx)
 {
 	mutex_lock(&allocated_ptys_lock);
-	idr_remove(&allocated_ptys, idx);
+	ida_remove(&allocated_ptys, idx);
 	mutex_unlock(&allocated_ptys_lock);
 }
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
linux-next.patch
mpt-remove-unused-struct-mpt_proc_entry_t.patch
cdc-acm-dont-unlock-acm-mutex-on-error-path.patch
vt8623fb-fix-kernel-oops.patch
slb-drop-kmem-cache-argument-from-constructor-fix-fix-logfs.patch
devpts-switch-to-ida-checkpatch-fixes.patch
proc-use-non-racy-method-for-proc-page_owner-creation-page_owner.patch
likely_prof-changed-to-use-proc_create.patch
proc-remove-proc_root-from-drivers-likelyprof.patch

