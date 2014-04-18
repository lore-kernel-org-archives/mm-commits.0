From: akpm@linux-foundation.org
Subject: + mm-gupc-tweaks.patch added to -mm tree
Date: Fri, 18 Apr 2014 15:23:04 -0700
Message-ID: <5351a5c8.AayxNp9qAZ6FMPEb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbaDRWXF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 18:23:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com, akpm@linux-foundation.org

Subject: + mm-gupc-tweaks.patch added to -mm tree
To: akpm@linux-foundation.org,kirill.shutemov@linux.intel.com
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 15:23:04 -0700


The patch titled
     Subject: mm/gup.c: tweaks
has been added to the -mm tree.  Its filename is
     mm-gupc-tweaks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gupc-tweaks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gupc-tweaks.patch

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
Subject: mm/gup.c: tweaks

- include some more header files, but many are still missed
- fix some 80-col overflows by removing unneeded `inline'

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/gup.c~mm-gupc-tweaks mm/gup.c
--- a/mm/gup.c~mm-gupc-tweaks
+++ a/mm/gup.c
@@ -1,3 +1,8 @@
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/spinlock.h>
+
 #include <linux/hugetlb.h>
 #include <linux/mm.h>
 #include <linux/rmap.h>
@@ -6,8 +11,8 @@
 
 #include "internal.h"
 
-static inline struct page *no_page_table(struct vm_area_struct *vma,
-		unsigned int flags)
+static struct page *no_page_table(struct vm_area_struct *vma,
+				  unsigned int flags)
 {
 	/*
 	 * When core dumping an enormous anonymous area that nobody
@@ -208,7 +213,7 @@ struct page *follow_page_mask(struct vm_
 	return follow_page_pte(vma, address, pmd, flags);
 }
 
-static inline int stack_guard_page(struct vm_area_struct *vma, unsigned long addr)
+static int stack_guard_page(struct vm_area_struct *vma, unsigned long addr)
 {
 	return stack_guard_page_start(vma, addr) ||
 	       stack_guard_page_end(vma, addr+PAGE_SIZE);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
kernel-watchdogc-touch_softlockup_watchdog-use-raw_cpu_write.patch
wait-explain-the-shadowing-and-type-inconsistencies.patch
mips-export-flush_icache_range.patch
drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b-fix.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-gupc-tweaks.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

