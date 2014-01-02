From: akpm@linux-foundation.org
Subject: +
 mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
 added to -mm tree
Date: Thu, 02 Jan 2014 13:48:30 -0800
Message-ID: <52c5deae.JETN1Wc7EqKdCbNi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42836 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaABVsg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jan 2014 16:48:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, akpm@linux-foundation.org

Subject: + mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch added to -mm tree
To: akpm@linux-foundation.org,sasha.levin@oracle.com
From: akpm@linux-foundation.org
Date: Thu, 02 Jan 2014 13:48:30 -0800


The patch titled
     Subject: mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix
has been added to the -mm tree.  Its filename is
     mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch

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
@@ -2026,10 +2027,6 @@ extern void shake_page(struct page *p, i
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
+	do { if (unlikely(cond)) { dump_page(page, NULL); BUG(); } } while(0)
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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
mm-remap_file_pages-remove-unneeded-access_once.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix-2.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
mm-print-more-details-for-bad_page-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

