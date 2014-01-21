From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch removed
 from -mm tree
Date: Tue, 21 Jan 2014 15:30:16 -0800
Message-ID: <52df0308.siid0ZDOwoR/p2Ej%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45571 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaAUXaR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 18:30:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jmarchan@redhat.com, dave.hansen@linux.intel.com, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org

Subject: [folded-merged] mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,alan@lxorguk.ukuu.org.uk,dave.hansen@linux.intel.com,jmarchan@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 15:30:16 -0800


The patch titled
     Subject: mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch

This patch was dropped because it was folded into mm-add-overcommit_kbytes-sysctl-variable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes

WARNING: Non-standard signature: Signed-of-by:
#13: 
Signed-of-by: Jerome Marchand <jmarchan@redhat.com>

WARNING: externs should be avoided in .c files
#115: FILE: kernel/sysctl.c:100:
+extern unsigned long sysctl_overcommit_kbytes;

ERROR: do not initialise globals to 0 or NULL
#142: FILE: mm/mmap.c:89:
+unsigned long sysctl_overcommit_kbytes __read_mostly = 0;

ERROR: do not initialise globals to 0 or NULL
#184: FILE: mm/nommu.c:63:
+unsigned long sysctl_overcommit_kbytes __read_mostly = 0;

total: 2 errors, 2 warnings, 145 lines checked

./patches/mm-add-overcommit_kbytes-sysctl-variable.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    4 ++++
 kernel/sysctl.c    |    3 ---
 mm/mmap.c          |    2 +-
 mm/nommu.c         |    2 +-
 4 files changed, 6 insertions(+), 5 deletions(-)

diff -puN include/linux/mm.h~mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes include/linux/mm.h
--- a/include/linux/mm.h~mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes
+++ a/include/linux/mm.h
@@ -57,6 +57,10 @@ extern int sysctl_legacy_va_layout;
 extern unsigned long sysctl_user_reserve_kbytes;
 extern unsigned long sysctl_admin_reserve_kbytes;
 
+extern int sysctl_overcommit_memory;
+extern int sysctl_overcommit_ratio;
+extern unsigned long sysctl_overcommit_kbytes;
+
 extern int overcommit_ratio_handler(struct ctl_table *, int, void __user *,
 				    size_t *, loff_t *);
 extern int overcommit_kbytes_handler(struct ctl_table *, int, void __user *,
diff -puN kernel/sysctl.c~mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes kernel/sysctl.c
--- a/kernel/sysctl.c~mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes
+++ a/kernel/sysctl.c
@@ -95,9 +95,6 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int sysctl_overcommit_memory;
-extern int sysctl_overcommit_ratio;
-extern unsigned long sysctl_overcommit_kbytes;
 extern int max_threads;
 extern int suid_dumpable;
 #ifdef CONFIG_COREDUMP
diff -puN mm/mmap.c~mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes mm/mmap.c
--- a/mm/mmap.c~mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes
+++ a/mm/mmap.c
@@ -86,7 +86,7 @@ EXPORT_SYMBOL(vm_get_page_prot);
 
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;  /* heuristic overcommit */
 int sysctl_overcommit_ratio __read_mostly = 50;	/* default is 50% */
-unsigned long sysctl_overcommit_kbytes __read_mostly = 0;
+unsigned long sysctl_overcommit_kbytes __read_mostly;
 int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
 unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
 unsigned long sysctl_admin_reserve_kbytes __read_mostly = 1UL << 13; /* 8MB */
diff -puN mm/nommu.c~mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes mm/nommu.c
--- a/mm/nommu.c~mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes
+++ a/mm/nommu.c
@@ -60,7 +60,7 @@ unsigned long highest_memmap_pfn;
 struct percpu_counter vm_committed_as;
 int sysctl_overcommit_memory = OVERCOMMIT_GUESS; /* heuristic overcommit */
 int sysctl_overcommit_ratio = 50; /* default is 50% */
-unsigned long sysctl_overcommit_kbytes __read_mostly = 0;
+unsigned long sysctl_overcommit_kbytes __read_mostly;
 int sysctl_max_map_count = DEFAULT_MAX_MAP_COUNT;
 int sysctl_nr_trim_pages = CONFIG_NOMMU_INITIAL_TRIM_EXCESS;
 unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
posix_acl-uninlining.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty.patch
mm-show_mem-remove-show_mem_filter_page_count.patch
mm-add-overcommit_kbytes-sysctl-variable.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch

