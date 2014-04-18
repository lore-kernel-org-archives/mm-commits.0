From: akpm@linux-foundation.org
Subject: [folded-merged] mips-export-flush_icache_range-fix.patch removed
 from -mm tree
Date: Fri, 18 Apr 2014 15:04:38 -0700
Message-ID: <5351a176.DQ8HlOFyetql53hj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbaDRWEj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 18 Apr 2014 18:04:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sergei.shtylyov@cogentembedded.com, sanjayl@kymasys.com, ralf@linux-mips.org, paul.gortmaker@windriver.com, keescook@chromium.org, blogic@openwrt.org, akpm@linux-foundation.org

Subject: [folded-merged] mips-export-flush_icache_range-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,blogic@openwrt.org,keescook@chromium.org,paul.gortmaker@windriver.com,ralf@linux-mips.org,sanjayl@kymasys.com,sergei.shtylyov@cogentembedded.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 18 Apr 2014 15:04:38 -0700


The patch titled
     Subject: mips-export-flush_icache_range-fix
has been removed from the -mm tree.  Its filename was
     mips-export-flush_icache_range-fix.patch

This patch was dropped because it was folded into mips-export-flush_icache_range.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mips-export-flush_icache_range-fix

relocate export sites

Cc: John Crispin <blogic@openwrt.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Sanjay Lal <sanjayl@kymasys.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/mm/cache.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN arch/mips/mm/cache.c~mips-export-flush_icache_range-fix arch/mips/mm/cache.c
--- a/arch/mips/mm/cache.c~mips-export-flush_icache_range-fix
+++ a/arch/mips/mm/cache.c
@@ -29,16 +29,15 @@ void (*flush_cache_range)(struct vm_area
 void (*flush_cache_page)(struct vm_area_struct *vma, unsigned long page,
 	unsigned long pfn);
 void (*flush_icache_range)(unsigned long start, unsigned long end);
+EXPORT_SYMBOL_GPL(flush_icache_range);
 void (*local_flush_icache_range)(unsigned long start, unsigned long end);
 
 void (*__flush_cache_vmap)(void);
 void (*__flush_cache_vunmap)(void);
 
 void (*__flush_kernel_vmap_range)(unsigned long vaddr, int size);
-void (*__invalidate_kernel_vmap_range)(unsigned long vaddr, int size);
-
 EXPORT_SYMBOL_GPL(__flush_kernel_vmap_range);
-EXPORT_SYMBOL_GPL(flush_icache_range);
+void (*__invalidate_kernel_vmap_range)(unsigned long vaddr, int size);
 
 /* MIPS specific cache operations */
 void (*flush_cache_sigtramp)(unsigned long addr);
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

