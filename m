From: akpm@linux-foundation.org
Subject: +
 ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch added to -mm tree
Date: Tue, 17 Jan 2017 12:45:40 -0800
Message-ID: <587e8274.CqFEtsEDZRF+E3Pe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39104 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751107AbdAQUpl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Jan 2017 15:45:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guozhonghua@h3c.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes

WARNING: please, no spaces at the start of a line
#26: FILE: fs/ocfs2/dlm/dlmrecovery.c:2271:
+       struct list_head *queue = NULL;$

WARNING: please, no spaces at the start of a line
#27: FILE: fs/ocfs2/dlm/dlmrecovery.c:2272:
+       int i;$

WARNING: please, no spaces at the start of a line
#60: FILE: fs/ocfs2/dlm/dlmrecovery.c:2285:
+       for (i = DLM_GRANTED_LIST; i <= DLM_BLOCKED_LIST; i++) {$

WARNING: suspect code indent for conditional statements (7, 15)
#60: FILE: fs/ocfs2/dlm/dlmrecovery.c:2285:
+       for (i = DLM_GRANTED_LIST; i <= DLM_BLOCKED_LIST; i++) {
+               queue = dlm_list_idx_to_ptr(res, i);

ERROR: code indent should use tabs where possible
#61: FILE: fs/ocfs2/dlm/dlmrecovery.c:2286:
+               queue = dlm_list_idx_to_ptr(res, i);$

WARNING: please, no spaces at the start of a line
#61: FILE: fs/ocfs2/dlm/dlmrecovery.c:2286:
+               queue = dlm_list_idx_to_ptr(res, i);$

ERROR: code indent should use tabs where possible
#62: FILE: fs/ocfs2/dlm/dlmrecovery.c:2287:
+               list_for_each_entry_safe(lock, next, queue, list) {$

WARNING: please, no spaces at the start of a line
#62: FILE: fs/ocfs2/dlm/dlmrecovery.c:2287:
+               list_for_each_entry_safe(lock, next, queue, list) {$

WARNING: suspect code indent for conditional statements (15, 23)
#62: FILE: fs/ocfs2/dlm/dlmrecovery.c:2287:
+               list_for_each_entry_safe(lock, next, queue, list) {
+                       if (lock->ml.node == dead_node) {

ERROR: code indent should use tabs where possible
#63: FILE: fs/ocfs2/dlm/dlmrecovery.c:2288:
+                       if (lock->ml.node == dead_node) {$

WARNING: please, no spaces at the start of a line
#63: FILE: fs/ocfs2/dlm/dlmrecovery.c:2288:
+                       if (lock->ml.node == dead_node) {$

WARNING: suspect code indent for conditional statements (23, 31)
#63: FILE: fs/ocfs2/dlm/dlmrecovery.c:2288:
+                       if (lock->ml.node == dead_node) {
+                               list_del_init(&lock->list);

ERROR: code indent should use tabs where possible
#64: FILE: fs/ocfs2/dlm/dlmrecovery.c:2289:
+                               list_del_init(&lock->list);$

WARNING: please, no spaces at the start of a line
#64: FILE: fs/ocfs2/dlm/dlmrecovery.c:2289:
+                               list_del_init(&lock->list);$

ERROR: code indent should use tabs where possible
#65: FILE: fs/ocfs2/dlm/dlmrecovery.c:2290:
+                               dlm_lock_put(lock);$

WARNING: please, no spaces at the start of a line
#65: FILE: fs/ocfs2/dlm/dlmrecovery.c:2290:
+                               dlm_lock_put(lock);$

ERROR: code indent should use tabs where possible
#66: FILE: fs/ocfs2/dlm/dlmrecovery.c:2291:
+                               /* Can't schedule DLM_UNLOCK_FREE_LOCK$

ERROR: code indent should use tabs where possible
#67: FILE: fs/ocfs2/dlm/dlmrecovery.c:2292:
+                                * do manually$

ERROR: code indent should use tabs where possible
#68: FILE: fs/ocfs2/dlm/dlmrecovery.c:2293:
+                                */$

ERROR: code indent should use tabs where possible
#69: FILE: fs/ocfs2/dlm/dlmrecovery.c:2294:
+                               dlm_lock_put(lock);$

WARNING: please, no spaces at the start of a line
#69: FILE: fs/ocfs2/dlm/dlmrecovery.c:2294:
+                               dlm_lock_put(lock);$

ERROR: code indent should use tabs where possible
#70: FILE: fs/ocfs2/dlm/dlmrecovery.c:2295:
+                               freed++;$

WARNING: please, no spaces at the start of a line
#70: FILE: fs/ocfs2/dlm/dlmrecovery.c:2295:
+                               freed++;$

ERROR: code indent should use tabs where possible
#71: FILE: fs/ocfs2/dlm/dlmrecovery.c:2296:
+                       }$

WARNING: please, no spaces at the start of a line
#71: FILE: fs/ocfs2/dlm/dlmrecovery.c:2296:
+                       }$

total: 11 errors, 14 warnings, 51 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/ocfs2-dlm-optimization-of-code-while-free-dead-node-locks.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Guozhonghua <guozhonghua@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -2268,8 +2268,8 @@ static void dlm_free_dead_locks(struct d
 {
 	struct dlm_lock *lock, *next;
 	unsigned int freed = 0;
-       struct list_head *queue = NULL;
-       int i;
+	struct list_head *queue = NULL;
+	int i;
 
 	/* this node is the lockres master:
 	 * 1) remove any stale locks for the dead node
@@ -2282,18 +2282,19 @@ static void dlm_free_dead_locks(struct d
 	 * to force the DLM_UNLOCK_FREE_LOCK action so as to free the locks */
 
 	/* TODO: check pending_asts, pending_basts here */
-       for (i = DLM_GRANTED_LIST; i <= DLM_BLOCKED_LIST; i++) {
-               queue = dlm_list_idx_to_ptr(res, i);
-               list_for_each_entry_safe(lock, next, queue, list) {
-                       if (lock->ml.node == dead_node) {
-                               list_del_init(&lock->list);
-                               dlm_lock_put(lock);
-                               /* Can't schedule DLM_UNLOCK_FREE_LOCK
-                                * do manually
-                                */
-                               dlm_lock_put(lock);
-                               freed++;
-                       }
+	for (i = DLM_GRANTED_LIST; i <= DLM_BLOCKED_LIST; i++) {
+		queue = dlm_list_idx_to_ptr(res, i);
+		list_for_each_entry_safe(lock, next, queue, list) {
+			if (lock->ml.node == dead_node) {
+				list_del_init(&lock->list);
+				dlm_lock_put(lock);
+				/*
+				 * Can't schedule DLM_UNLOCK_FREE_LOCK: do
+				 * manually
+				 */
+				dlm_lock_put(lock);
+				freed++;
+			}
 		}
 	}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
mm-respect-foll_force-foll_cow-for-thp-checkpatch-fixes.patch
proc-add-a-schedule-point-in-proc_pid_readdir-fix.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
dax-enable-iostat-for-read-write-fix.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
kernel-watchdog-prevent-false-hardlockup-on-overloaded-system-fix.patch
mm.patch
mm-throttle-show_mem-from-warn_alloc-fix.patch
userfaultfd-hugetlbfs-fix-__mcopy_atomic_hugetlb-retry-error-processing-fix-fix.patch
linux-kernelh-fix-div_round_closest-to-support-negative-divisors-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
reimplement-idr-and-ida-using-the-radix-tree-support-storing-null-in-the-idr-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

