From: akpm@linux-foundation.org
Subject: [merged]
 revert-ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each.patch
 removed from -mm tree
Date: Mon, 14 Sep 2015 10:28:53 -0700
Message-ID: <55f703d5.KFj9DOhmp+HsUYh7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48414 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbbINR2y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 13:28:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@gmail.com, jlbec@evilplan.org, joseph.qi@huawei.com, julia.lawall@lip6.fr, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: revert "ocfs2/dlm: use list_for_each_entry instead of list_for_each"
has been removed from the -mm tree.  Its filename was
     revert-ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: revert "ocfs2/dlm: use list_for_each_entry instead of list_for_each"

Revert f83c7b5e9fd633fe9 ("ocfs2/dlm: use list_for_each_entry instead of
list_for_each").

list_for_each_entry() will dereference its `pos' argument, which can be
NULL in dlm_process_recovery_data().

Reported-by: Julia Lawall <julia.lawall@lip6.fr>
Reported-by: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/dlm/dlmrecovery.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/dlm/dlmrecovery.c~revert-ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each fs/ocfs2/dlm/dlmrecovery.c
--- a/fs/ocfs2/dlm/dlmrecovery.c~revert-ocfs2-dlm-use-list_for_each_entry-instead-of-list_for_each
+++ a/fs/ocfs2/dlm/dlmrecovery.c
@@ -1776,7 +1776,7 @@ static int dlm_process_recovery_data(str
 				     struct dlm_migratable_lockres *mres)
 {
 	struct dlm_migratable_lock *ml;
-	struct list_head *queue;
+	struct list_head *queue, *iter;
 	struct list_head *tmpq = NULL;
 	struct dlm_lock *newlock = NULL;
 	struct dlm_lockstatus *lksb = NULL;
@@ -1821,7 +1821,9 @@ static int dlm_process_recovery_data(str
 			spin_lock(&res->spinlock);
 			for (j = DLM_GRANTED_LIST; j <= DLM_BLOCKED_LIST; j++) {
 				tmpq = dlm_list_idx_to_ptr(res, j);
-				list_for_each_entry(lock, tmpq, list) {
+				list_for_each(iter, tmpq) {
+					lock = list_entry(iter,
+						  struct dlm_lock, list);
 					if (lock->ml.cookie == ml->cookie)
 						break;
 					lock = NULL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
mm-srcu-ify-shrinkers-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

