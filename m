From: akpm@linux-foundation.org
Subject: + hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch added to -mm tree
Date: Fri, 31 Aug 2007 11:11:51 -0700
Message-ID: <200708311811.l7VIBpd7020158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55905 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965763AbXHaSMR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 14:12:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rjw@sisk.pl, ak@suse.de, pavel@ucw.cz


The patch titled
     Hibernation: Use temporary page tables for kernel text mapping on x86_64
has been added to the -mm tree.  Its filename is
     hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Hibernation: Use temporary page tables for kernel text mapping on x86_64
From: Rafael J. Wysocki <rjw@sisk.pl>

Use temporary page tables for the kernel text mapping during hibernation
restore on x86_64.

Without the patch, the original boot kernel's page tables that represent the
kernel text mapping are used while the core of the image kernel is being
restored.  However, in principle, if the boot kernel is not identical to the
image kernel, the location of these page tables in the image kernel need not
be the same, so we should create a safe copy of the kernel text mapping prior
to restoring the core of the image kernel.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/suspend.c |   39 +++++++++++++++++++++++++++------
 1 files changed, 33 insertions(+), 6 deletions(-)

diff -puN arch/x86_64/kernel/suspend.c~hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64 arch/x86_64/kernel/suspend.c
--- a/arch/x86_64/kernel/suspend.c~hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64
+++ a/arch/x86_64/kernel/suspend.c
@@ -192,25 +192,42 @@ static int res_phys_pud_init(pud_t *pud,
 	return 0;
 }
 
+static int res_kernel_text_pud_init(pud_t *pud, unsigned long start)
+{
+	pmd_t *pmd;
+	unsigned long paddr;
+
+	pmd = (pmd_t *)get_safe_page(GFP_ATOMIC);
+	if (!pmd)
+		return -ENOMEM;
+	set_pud(pud + pud_index(start), __pud(__pa(pmd) | _KERNPG_TABLE));
+	for (paddr = 0; paddr < KERNEL_TEXT_SIZE; pmd++, paddr += PMD_SIZE) {
+		unsigned long pe;
+
+		pe = __PAGE_KERNEL_LARGE_EXEC | _PAGE_GLOBAL | paddr;
+		pe &= __supported_pte_mask;
+		set_pmd(pmd, __pmd(pe));
+	}
+
+	return 0;
+}
+
 static int set_up_temporary_mappings(void)
 {
 	unsigned long start, end, next;
+	pud_t *pud;
 	int error;
 
 	temp_level4_pgt = (pgd_t *)get_safe_page(GFP_ATOMIC);
 	if (!temp_level4_pgt)
 		return -ENOMEM;
 
-	/* It is safe to reuse the original kernel mapping */
-	set_pgd(temp_level4_pgt + pgd_index(__START_KERNEL_map),
-		init_level4_pgt[pgd_index(__START_KERNEL_map)]);
-
 	/* Set up the direct mapping from scratch */
 	start = (unsigned long)pfn_to_kaddr(0);
 	end = (unsigned long)pfn_to_kaddr(end_pfn);
 
 	for (; start < end; start = next) {
-		pud_t *pud = (pud_t *)get_safe_page(GFP_ATOMIC);
+		pud = (pud_t *)get_safe_page(GFP_ATOMIC);
 		if (!pud)
 			return -ENOMEM;
 		next = start + PGDIR_SIZE;
@@ -221,7 +238,17 @@ static int set_up_temporary_mappings(voi
 		set_pgd(temp_level4_pgt + pgd_index(start),
 			mk_kernel_pgd(__pa(pud)));
 	}
-	return 0;
+
+	/* Set up the kernel text mapping from scratch */
+	pud = (pud_t *)get_safe_page(GFP_ATOMIC);
+	if (!pud)
+		return -ENOMEM;
+	error = res_kernel_text_pud_init(pud, __START_KERNEL_map);
+	if (!error)
+		set_pgd(temp_level4_pgt + pgd_index(__START_KERNEL_map),
+			__pgd(__pa(pud) | _PAGE_TABLE));
+
+	return error;
 }
 
 int swsusp_arch_resume(void)
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.patch
acpi-clean-up-acpi_enter_sleep_state_prep.patch
uli526x-add-suspend-and-resume-routines.patch
make-kernel-power-maincsuspend_enter-static.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-introduce-freezer-firendly-waiting-macros-fix.patch
freezer-do-not-send-signals-to-kernel-threads.patch
unexport-pm_power_off_prepare.patch
pm_trace-displays-the-wrong-time-from-the-rtc.patch
freezer-be-more-verbose.patch
freezer-use-wait-queue-instead-of-busy-looping.patch
freezer-measure-freezing-time.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
s2ram-kill-old-debugging-junk.patch
hibernation-arbitrary-boot-kernel-support-generic-code-rev-2.patch
hibernation-arbitrary-boot-kernel-support-on-x86_64-rev-2.patch
hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch
hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
pnp-make-pnpacpi_suspend-handle-errors.patch
shrink_slab-handle-bad-shrinkers.patch
