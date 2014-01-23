From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
 removed from -mm tree
Date: Thu, 23 Jan 2014 15:17:42 -0800
Message-ID: <52e1a316.dw6T8yOUmOf1DDjF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaAWXRm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Jan 2014 18:17:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 23 Jan 2014 15:17:42 -0800


The patch titled
     Subject: mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch

This patch was dropped because it was folded into mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix

Fix the patch for mm-print-more-details-for-bad_page.patch.

Also fix up an include mess - various files were using mmdebug.h
facilities but were not including that file.

Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h            |    1 +
 include/linux/hugetlb.h        |    1 +
 include/linux/hugetlb_cgroup.h |    1 +
 include/linux/mm.h             |    5 +----
 include/linux/mmdebug.h        |    9 +++++++--
 include/linux/percpu.h         |    1 +
 6 files changed, 12 insertions(+), 6 deletions(-)

diff -puN include/linux/gfp.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix include/linux/gfp.h
--- a/include/linux/gfp.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix
+++ a/include/linux/gfp.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_GFP_H
 #define __LINUX_GFP_H
 
+#include <linux/mmdebug.h>
 #include <linux/mmzone.h>
 #include <linux/stddef.h>
 #include <linux/linkage.h>
diff -puN include/linux/hugetlb.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix
+++ a/include/linux/hugetlb.h
@@ -2,6 +2,7 @@
 #define _LINUX_HUGETLB_H
 
 #include <linux/mm_types.h>
+#include <linux/mmdebug.h>
 #include <linux/fs.h>
 #include <linux/hugetlb_inline.h>
 #include <linux/cgroup.h>
diff -puN include/linux/hugetlb_cgroup.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix include/linux/hugetlb_cgroup.h
--- a/include/linux/hugetlb_cgroup.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix
+++ a/include/linux/hugetlb_cgroup.h
@@ -15,6 +15,7 @@
 #ifndef _LINUX_HUGETLB_CGROUP_H
 #define _LINUX_HUGETLB_CGROUP_H
 
+#include <linux/mmdebug.h>
 #include <linux/res_counter.h>
 
 struct hugetlb_cgroup;
diff -puN include/linux/mm.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix include/linux/mm.h
--- a/include/linux/mm.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix
+++ a/include/linux/mm.h
@@ -5,6 +5,7 @@
 
 #ifdef __KERNEL__
 
+#include <linux/mmdebug.h>
 #include <linux/gfp.h>
 #include <linux/bug.h>
 #include <linux/list.h>
@@ -2029,10 +2030,6 @@ extern void shake_page(struct page *p, i
 extern atomic_long_t num_poisoned_pages;
 extern int soft_offline_page(struct page *page, int flags);
 
-extern void dump_page(struct page *page, char *reason);
-extern void dump_page_badflags(struct page *page, char *reason,
-			       unsigned long badflags);
-
 #if defined(CONFIG_TRANSPARENT_HUGEPAGE) || defined(CONFIG_HUGETLBFS)
 extern void clear_huge_page(struct page *page,
 			    unsigned long addr,
diff -puN include/linux/mmdebug.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix
+++ a/include/linux/mmdebug.h
@@ -1,11 +1,16 @@
 #ifndef LINUX_MM_DEBUG_H
 #define LINUX_MM_DEBUG_H 1
 
+struct page;
+
+extern void dump_page(struct page *page, char *reason);
+extern void dump_page_badflags(struct page *page, char *reason,
+			       unsigned long badflags);
+
 #ifdef CONFIG_DEBUG_VM
-extern void dump_page(struct page *page);
 #define VM_BUG_ON(cond) BUG_ON(cond)
 #define VM_BUG_ON_PAGE(cond, page) \
-	do { if (unlikely(cond)) { dump_page(page); BUG(); } } while(0)
+	do { if (unlikely(cond)) { dump_page(page, NULL); BUG(); } } while (0)
 #else
 #define VM_BUG_ON(cond) BUILD_BUG_ON_INVALID(cond)
 #define VM_BUG_ON_PAGE(cond, page) VM_BUG_ON(cond)
diff -puN include/linux/percpu.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix include/linux/percpu.h
--- a/include/linux/percpu.h~mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix
+++ a/include/linux/percpu.h
@@ -1,6 +1,7 @@
 #ifndef __LINUX_PERCPU_H
 #define __LINUX_PERCPU_H
 
+#include <linux/mmdebug.h>
 #include <linux/preempt.h>
 #include <linux/smp.h>
 #include <linux/cpumask.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-print-more-details-for-bad_page.patch
mm-munlock-fix-potential-race-with-thp-page-split.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch
mm-improve-documentation-of-page_order-v2-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
lib-genallocc-add-check-gen_pool_dma_alloc-if-dma-pointer-is-not-null-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch

