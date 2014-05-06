From: akpm@linux-foundation.org
Subject: +
 arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch added
 to -mm tree
Date: Tue, 06 May 2014 13:47:40 -0700
Message-ID: <53694a6c.HhaZSQ8j/xvIppUQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40841 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaEFUrl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 16:47:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gxt@mprc.pku.edu.cn, fabf@skynet.be, akpm@linux-foundation.org

Subject: + arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch added to -mm tree
To: akpm@linux-foundation.org,fabf@skynet.be,gxt@mprc.pku.edu.cn
From: akpm@linux-foundation.org
Date: Tue, 06 May 2014 13:47:40 -0700


The patch titled
     Subject: arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix
has been added to the -mm tree.  Its filename is
     arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch

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
Subject: arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix

undo crazy long line

Cc: Fabian Frederick <fabf@skynet.be>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/mm/ioremap.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN arch/unicore32/mm/ioremap.c~arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix arch/unicore32/mm/ioremap.c
--- a/arch/unicore32/mm/ioremap.c~arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix
+++ a/arch/unicore32/mm/ioremap.c
@@ -144,7 +144,10 @@ void __iomem *__uc32_ioremap_pfn_caller(
 	 * Don't allow RAM to be mapped
 	 */
 	if (pfn_valid(pfn))
-		WARN(1, "BUG: Your driver calls ioremap() on\nsystem memory.  This leads to architecturally\nunpredictable behaviour, and ioremap() will fail in\nthe next kernel release. Please fix your driver.\n");
+		WARN(1, "BUG: Your driver calls ioremap() on\n"
+			"system memory.  This leads to architecturally\n"
+			"unpredictable behaviour, and ioremap() will fail in\n"
+			"the next kernel release. Please fix your driver.\n");
 
 	type = get_mem_type(mtype);
 	if (!type)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported.patch
slub-use-sysfses-release-mechanism-for-kmem_cache.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
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
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
tools-testing-selftests-sysctl-validate-sysctl_writes_strict-fix.patch
fs-pstore-logging-clean-up-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch

