From: akpm@linux-foundation.org
Subject: [wrecked]
 ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch removed from -mm tree
Date: Tue, 22 Aug 2017 15:23:19 -0700
Message-ID: <599caed7.IGnp+0OCIgoAvLNt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51786 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751796AbdHVWXV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2017 18:23:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, guozhonghua@h3c.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch

This patch was dropped because other changes were merged, which wrecked this patch

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
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
mm-thp-enable-thp-migration-in-generic-path-fix-fix.patch
zsmalloc-zs_page_migrate-skip-unnecessary-loops-but-not-return-ebusy-if-zspage-is-not-inuse-fix.patch
userfaultfd-selftest-exercise-uffdio_copy-zeropage-eexist-fix.patch
mm-swap-add-swap-readahead-hit-statistics-fix.patch
swap-choose-swap-device-according-to-numa-node-v2-fix.patch
add-testcases-for-memset16-32-64-fix.patch
lib-add-test-for-bitmap_parselist-fix.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes.patch
bitmap-introduce-bitmap_from_u64-checkpatch-fixes-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

