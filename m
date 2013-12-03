From: akpm@linux-foundation.org
Subject: + mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch added to -mm tree
Date: Tue, 03 Dec 2013 14:12:50 -0800
Message-ID: <529e5762.xQL5z+Qphbn8WOau%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab3LCWMw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Dec 2013 17:12:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jmarchan@redhat.com, dave.hansen@linux.intel.com, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org

Subject: + mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,alan@lxorguk.ukuu.org.uk,dave.hansen@linux.intel.com,jmarchan@redhat.com
From: akpm@linux-foundation.org
Date: Tue, 03 Dec 2013 14:12:50 -0800


The patch titled
     Subject: mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch

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
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
procfs-also-fix-proc_reg_get_unmapped_area-for-mmu-case-fix.patch
dma-debug-enhance-dma_debug_device_change-to-check-for-mapping-errors-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
mtd-cmdlinepart-use-cmdline-partition-parser-lib-fix-fix.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
kernel-paramsc-improve-standard-definitions-checkpatch-fixes.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

