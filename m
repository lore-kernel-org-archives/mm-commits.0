From: akpm@linux-foundation.org
Subject: [merged] exec-make-exec-path-waiting-for-mmap_sem-killable.patch
 removed from -mm tree
Date: Fri, 27 May 2016 11:45:02 -0700
Message-ID: <574895ae.GK1mVtapyve0MSll%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42672 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbcE0SpD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:45:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, vbabka@suse.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: exec: make exec path waiting for mmap_sem killable
has been removed from the -mm tree.  Its filename was
     exec-make-exec-path-waiting-for-mmap_sem-killable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: exec: make exec path waiting for mmap_sem killable

setup_arg_pages requires mmap_sem for write.  If the waiting task gets
killed by the oom killer it would block oom_reaper from asynchronous
address space reclaim and reduce the chances of timely OOM resolving. 
Wait for the lock in the killable mode and return with EINTR if the task
got killed while waiting.  All the callers are already handling error path
and the fatal signal doesn't need any additional treatment.

The same applies to __bprm_mm_init.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~exec-make-exec-path-waiting-for-mmap_sem-killable fs/exec.c
--- a/fs/exec.c~exec-make-exec-path-waiting-for-mmap_sem-killable
+++ a/fs/exec.c
@@ -263,7 +263,10 @@ static int __bprm_mm_init(struct linux_b
 	if (!vma)
 		return -ENOMEM;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem)) {
+		err = -EINTR;
+		goto err_free;
+	}
 	vma->vm_mm = mm;
 
 	/*
@@ -290,6 +293,7 @@ static int __bprm_mm_init(struct linux_b
 	return 0;
 err:
 	up_write(&mm->mmap_sem);
+err_free:
 	bprm->vma = NULL;
 	kmem_cache_free(vm_area_cachep, vma);
 	return err;
@@ -696,7 +700,9 @@ int setup_arg_pages(struct linux_binprm
 		bprm->loader -= stack_shift;
 	bprm->exec -= stack_shift;
 
-	down_write(&mm->mmap_sem);
+	if (down_write_killable(&mm->mmap_sem))
+		return -EINTR;
+
 	vm_flags = VM_STACK_FLAGS;
 
 	/*
_

Patches currently in -mm which might be from mhocko@suse.com are

oom_reaper-close-race-with-exiting-task.patch

