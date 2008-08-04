From: akpm@linux-foundation.org
Subject: - proc-switch-inode-number-allocation-to-ida.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:07:44 -0700
Message-ID: <200808042007.m74K7i1s027839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761131AbYHDUHq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:07:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     proc: switch inode number allocation to IDA
has been removed from the -mm tree.  Its filename was
     proc-switch-inode-number-allocation-to-ida.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: proc: switch inode number allocation to IDA
From: Alexey Dobriyan <adobriyan@gmail.com>

proc doesn't use "associate pointer with id" feature of IDR, so switch to
IDA.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/proc/generic.c~proc-switch-inode-number-allocation-to-ida fs/proc/generic.c
--- a/fs/proc/generic.c~proc-switch-inode-number-allocation-to-ida
+++ a/fs/proc/generic.c
@@ -300,7 +300,7 @@ out:
 	return rtn;
 }
 
-static DEFINE_IDR(proc_inum_idr);
+static DEFINE_IDA(proc_inum_ida);
 static DEFINE_SPINLOCK(proc_inum_lock); /* protects the above */
 
 #define PROC_DYNAMIC_FIRST 0xF0000000U
@@ -315,11 +315,11 @@ static unsigned int get_inode_number(voi
 	int error;
 
 retry:
-	if (idr_pre_get(&proc_inum_idr, GFP_KERNEL) == 0)
+	if (ida_pre_get(&proc_inum_ida, GFP_KERNEL) == 0)
 		return 0;
 
 	spin_lock(&proc_inum_lock);
-	error = idr_get_new(&proc_inum_idr, NULL, &i);
+	error = ida_get_new(&proc_inum_ida, &i);
 	spin_unlock(&proc_inum_lock);
 	if (error == -EAGAIN)
 		goto retry;
@@ -328,7 +328,7 @@ retry:
 
 	if (i > UINT_MAX - PROC_DYNAMIC_FIRST) {
 		spin_lock(&proc_inum_lock);
-		idr_remove(&proc_inum_idr, i);
+		ida_remove(&proc_inum_ida, i);
 		spin_unlock(&proc_inum_lock);
 	}
 	return PROC_DYNAMIC_FIRST + i;
@@ -337,7 +337,7 @@ retry:
 static void release_inode_number(unsigned int inum)
 {
 	spin_lock(&proc_inum_lock);
-	idr_remove(&proc_inum_idr, inum - PROC_DYNAMIC_FIRST);
+	ida_remove(&proc_inum_ida, inum - PROC_DYNAMIC_FIRST);
 	spin_unlock(&proc_inum_lock);
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

