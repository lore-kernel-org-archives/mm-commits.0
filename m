From: akpm@linux-foundation.org
Subject: + i386-map-enough-initial-memory-to-create-lowmem-mappings.patch added to -mm tree
Date: Fri, 13 Apr 2007 14:44:05 -0700
Message-ID: <200704132144.l3DLi5Gr010199@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:53969 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030844AbXDMVoM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 17:44:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, ak@suse.de, chrisw@sous-sol.org, jeremy@xensource.com, zach@vmware.com


The patch titled
     i386: map enough initial memory to create lowmem mappings
has been added to the -mm tree.  Its filename is
     i386-map-enough-initial-memory-to-create-lowmem-mappings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: map enough initial memory to create lowmem mappings
From: Jeremy Fitzhardinge <jeremy@goop.org>

head.S creates the very initial pagetable for the kernel.  It maps maps
enough space for the kernel itself, and an allocation bitmap.  The amount
of mapped memory is rounded up to 4Mbytes, and so this typically ends up
mapping 8Mbytes of memory.

When booting, pagetable_init() needs to create mappings for all lowmem, and
the pagetables for these mappings are allocated from the free pages around
the kernel in low memory.  If the number of pagetable pages + kernel size
exceeds head.S's initial mapping, it will end up faulting on an unmapped
page.  This will only happen with specific combinations of kernel size and
memory size.

This patch makes sure that head.S also maps enough space to fit the kernel
pagetables as well as the kernel itself.  It ends up using an additional
two pages of unreclaimable memory.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/head.S |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/head.S~i386-map-enough-initial-memory-to-create-lowmem-mappings arch/i386/kernel/head.S
--- a/arch/i386/kernel/head.S~i386-map-enough-initial-memory-to-create-lowmem-mappings
+++ a/arch/i386/kernel/head.S
@@ -34,16 +34,19 @@
 
 /*
  * This is how much memory *in addition to the memory covered up to
- * and including _end* we need mapped initially.  We need one bit for
- * each possible page, but only in low memory, which means
- * 2^32/4096/8 = 128K worst case (4G/4G split.)
+ * and including _end* we need mapped initially.
+ * We need:
+ *  - one bit for each possible page, but only in low memory, which means
+ *     2^32/4096/8 = 128K worst case (4G/4G split.)
+ *  - enough space to map all low memory, which means
+ *     (2^32/4096) / 512 + 4 pages (worst case for PAE)
  *
  * Modulo rounding, each megabyte assigned here requires a kilobyte of
  * memory, which is currently unreclaimed.
  *
  * This should be a multiple of a page.
  */
-#define INIT_MAP_BEYOND_END	(128*1024)
+#define INIT_MAP_BEYOND_END	(128*1024 + (2048 + 4)*4096)
 
 
 /*
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
account-for-module-percpu-space-separately-from-kernel.patch
paravirt_ops-update-maintainers.patch
paravirt_ops-remove-config_debug_paravirt.patch
paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
paravirt_ops-hooks-to-set-up-initial-pagetable.patch
paravirt_ops-allocate-a-fixmap-slot.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-document-asm-i386-paravirth.patch
paravirt_ops-clean-up-paravirt-patchable-wrappers.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-add-flush_tlb_others-paravirt_op.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
re-enable-vdso-by-default-with-paravirt.patch
remove-noreplacement-option.patch
remove-smp_alt_instructions.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-smp-altinstructions.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
i386-clean-up-asm-i386-bugsh.patch
x86_64-clean-up-asm-x86_64-bugsh.patch
x86-clean-up-identify_cpu.patch
x86-clean-up-identify_cpu-update.patch
i386-relocate-vdso-elf-headers-to-match-mapped-location-with-compat_vdso.patch
i386-make-compat_vdso-runtime-selectable.patch
i386-update-smp_call_function-comments.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
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
