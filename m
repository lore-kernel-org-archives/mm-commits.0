From: akpm@linux-foundation.org
Subject: - re-enable-vdso-by-default-with-paravirt.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:30:37 -0700
Message-ID: <200704132330.l3DNUbJC012753@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60703 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161223AbXDMXam (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, ak@suse.de, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     Re-enable VDSO by default with PARAVIRT
has been removed from the -mm tree.  Its filename was
     re-enable-vdso-by-default-with-paravirt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Re-enable VDSO by default with PARAVIRT
From: Jeremy Fitzhardinge <jeremy@goop.org>

Everyone wants VDSO to be enabled by default.  COMPAT_VDSO still needs a fix,
but with luck that will turn up soon.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/sysenter.c |    4 ----
 1 files changed, 4 deletions(-)

diff -puN arch/i386/kernel/sysenter.c~re-enable-vdso-by-default-with-paravirt arch/i386/kernel/sysenter.c
--- a/arch/i386/kernel/sysenter.c~re-enable-vdso-by-default-with-paravirt
+++ a/arch/i386/kernel/sysenter.c
@@ -27,11 +27,7 @@
  * Should the kernel map a VDSO page into processes and pass its
  * address down to glibc upon exec()?
  */
-#ifdef CONFIG_PARAVIRT
-unsigned int __read_mostly vdso_enabled = 0;
-#else
 unsigned int __read_mostly vdso_enabled = 1;
-#endif
 
 EXPORT_SYMBOL_GPL(vdso_enabled);
 
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
x86-clean-up-identify_cpu-update.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
deflate-stack-usage-in-lib-inflatec.patch
