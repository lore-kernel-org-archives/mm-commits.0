From: akpm@linux-foundation.org
Subject: [merged]
 arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch removed from
 -mm tree
Date: Thu, 05 Jun 2014 12:42:24 -0700
Message-ID: <5390c820.ZskL/nLCgCI8369C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55549 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaFETmY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:42:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, gxt@mprc.pku.edu.cn, fabf@skynet.be, akpm@linux-foundation.org

Subject: [merged] arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch removed from -mm tree
To: akpm@linux-foundation.org,fabf@skynet.be,gxt@mprc.pku.edu.cn,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:42:24 -0700


The patch titled
     Subject: arch/unicore32/mm/ioremap.c: return NULL on invalid pfn
has been removed from the -mm tree.  Its filename was
     arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: arch/unicore32/mm/ioremap.c: return NULL on invalid pfn

__uc32_ioremap_pfn_caller() should return NULL when the pfn is found to be
invalid.

From a recommendation by Guan Xuetao.

Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/unicore32/mm/ioremap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/unicore32/mm/ioremap.c~arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn arch/unicore32/mm/ioremap.c
--- a/arch/unicore32/mm/ioremap.c~arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn
+++ a/arch/unicore32/mm/ioremap.c
@@ -143,11 +143,13 @@ void __iomem *__uc32_ioremap_pfn_caller(
 	/*
 	 * Don't allow RAM to be mapped
 	 */
-	if (pfn_valid(pfn))
+	if (pfn_valid(pfn)) {
 		WARN(1, "BUG: Your driver calls ioremap() on\n"
 			"system memory.  This leads to architecturally\n"
 			"unpredictable behaviour, and ioremap() will fail in\n"
 			"the next kernel release. Please fix your driver.\n");
+		return NULL;
+	}
 
 	type = get_mem_type(mtype);
 	if (!type)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
rtc-da9063-rtc-driver-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline-checkpatch-fixes.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
rwsem-support-optimistic-spinning.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

