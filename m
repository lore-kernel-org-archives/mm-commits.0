From: akpm@linux-foundation.org
Subject: + deflate-stack-usage-in-lib-inflatec-update.patch added to -mm tree
Date: Fri, 13 Apr 2007 12:10:31 -0700
Message-ID: <200704131910.l3DJAV9w007267@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46870 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbXDMTKe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 15:10:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org


The patch titled
     deflate-stack-usage-in-lib-inflatec update
has been added to the -mm tree.  Its filename is
     deflate-stack-usage-in-lib-inflatec-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: deflate-stack-usage-in-lib-inflatec update
From: Jeremy Fitzhardinge <jeremy@goop.org>



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/boot/misc.c             |    2 +-
 arch/arm/boot/compressed/misc.c    |    2 +-
 arch/arm26/boot/compressed/misc.c  |    2 +-
 arch/x86_64/boot/compressed/misc.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/alpha/boot/misc.c~deflate-stack-usage-in-lib-inflatec-update arch/alpha/boot/misc.c
--- a/arch/alpha/boot/misc.c~deflate-stack-usage-in-lib-inflatec-update
+++ a/arch/alpha/boot/misc.c
@@ -98,7 +98,7 @@ extern int end;
 static ulg free_mem_ptr;
 static ulg free_mem_ptr_end;
 
-#define HEAP_SIZE 0x2000
+#define HEAP_SIZE 0x3000
 
 #include "../../../lib/inflate.c"
 
diff -puN arch/arm/boot/compressed/misc.c~deflate-stack-usage-in-lib-inflatec-update arch/arm/boot/compressed/misc.c
--- a/arch/arm/boot/compressed/misc.c~deflate-stack-usage-in-lib-inflatec-update
+++ a/arch/arm/boot/compressed/misc.c
@@ -239,7 +239,7 @@ extern int end;
 static ulg free_mem_ptr;
 static ulg free_mem_ptr_end;
 
-#define HEAP_SIZE 0x2000
+#define HEAP_SIZE 0x3000
 
 #include "../../../../lib/inflate.c"
 
diff -puN arch/arm26/boot/compressed/misc.c~deflate-stack-usage-in-lib-inflatec-update arch/arm26/boot/compressed/misc.c
--- a/arch/arm26/boot/compressed/misc.c~deflate-stack-usage-in-lib-inflatec-update
+++ a/arch/arm26/boot/compressed/misc.c
@@ -182,7 +182,7 @@ extern int end;
 static ulg free_mem_ptr;
 static ulg free_mem_ptr_end;
 
-#define HEAP_SIZE 0x2000
+#define HEAP_SIZE 0x3000
 
 #include "../../../../lib/inflate.c"
 
diff -puN arch/x86_64/boot/compressed/misc.c~deflate-stack-usage-in-lib-inflatec-update arch/x86_64/boot/compressed/misc.c
--- a/arch/x86_64/boot/compressed/misc.c~deflate-stack-usage-in-lib-inflatec-update
+++ a/arch/x86_64/boot/compressed/misc.c
@@ -189,7 +189,7 @@ static void putstr(const char *);
 static long free_mem_ptr;
 static long free_mem_end_ptr;
 
-#define HEAP_SIZE             0x6000
+#define HEAP_SIZE             0x7000
 
 static char *vidmem = (char *)0xb8000;
 static int vidport;
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
deflate-stack-usage-in-lib-inflatec-update.patch
