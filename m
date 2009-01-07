From: akpm@linux-foundation.org
Subject: - mm-make-vread-and-vwrite-declaration.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:13:11 -0800
Message-ID: <200901072213.n07MDBEY013304@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756731AbZAGWNO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:13:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     mm: make vread() and vwrite() declaration
has been removed from the -mm tree.  Its filename was
     mm-make-vread-and-vwrite-declaration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make vread() and vwrite() declaration
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Sparse output following warnings.

mm/vmalloc.c:1436:6: warning: symbol 'vread' was not declared. Should it be static?
mm/vmalloc.c:1474:6: warning: symbol 'vwrite' was not declared. Should it be static?

However, it is used by /dev/kmem. fixed here.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c      |    3 ---
 include/linux/vmalloc.h |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/char/mem.c~mm-make-vread-and-vwrite-declaration drivers/char/mem.c
--- a/drivers/char/mem.c~mm-make-vread-and-vwrite-declaration
+++ a/drivers/char/mem.c
@@ -425,9 +425,6 @@ static ssize_t read_oldmem(struct file *
 }
 #endif
 
-extern long vread(char *buf, char *addr, unsigned long count);
-extern long vwrite(char *buf, char *addr, unsigned long count);
-
 #ifdef CONFIG_DEVKMEM
 /*
  * This function reads the *virtual* memory as seen by the kernel.
diff -puN include/linux/vmalloc.h~mm-make-vread-and-vwrite-declaration include/linux/vmalloc.h
--- a/include/linux/vmalloc.h~mm-make-vread-and-vwrite-declaration
+++ a/include/linux/vmalloc.h
@@ -97,6 +97,10 @@ extern void unmap_kernel_range(unsigned 
 extern struct vm_struct *alloc_vm_area(size_t size);
 extern void free_vm_area(struct vm_struct *area);
 
+/* for /dev/kmem */
+extern long vread(char *buf, char *addr, unsigned long count);
+extern long vwrite(char *buf, char *addr, unsigned long count);
+
 /*
  *	Internals.  Dont't use..
  */
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
softirq-introduce-statistics-for-softirq.patch
proc-export-statistics-for-softirq-to-proc.patch
proc-update-document-for-proc-softirqs-and-proc-stat.patch
devices-cgroup-allow-mkfifo.patch
memcg-new-force_empty-to-free-pages-under-group-fix.patch
memcg-new-force_empty-to-free-pages-under-group-fix-fix.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-inactive_anon_is_low-vmscan-style-cleanup.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-fix-calclation-of-active_ratio.patch
memcg-fix-calclation-of-active_ratio-build-error-fix.patch
memcg-show-real-limit-under-hierarchy-mode.patch
memcg-explain-details-and-test-document.patch
ia64-implement-interrupt-enabling-rwlocks-fix.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

