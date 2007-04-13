From: akpm@linux-foundation.org
Subject: + vmi-logic-error.patch added to -mm tree
Date: Thu, 12 Apr 2007 19:37:46 -0700
Message-ID: <200704130237.l3D2bkML022890@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43831 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119AbXDMCh4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Apr 2007 22:37:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: zach@vmware.com, ak@suse.de, aliguori@us.ibm.com


The patch titled
     VMI logic error
has been added to the -mm tree.  Its filename is
     vmi-logic-error.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: VMI logic error
From: Zachary Amsden <zach@vmware.com>

Fix logic error in VMI relocation processing.  NOPs would always cause a
BUG_ON to fire because the != RELOCATION_NONE in the first if clause
precluding the == VMI_RELOCATION_NOP in the second clause.  Make these
direct equality tests and just warn for unsupported relocation types (which
should never happen), falling back to native in that case.

Thanks to Anthony Liguori for noting this!

Signed-off-by: Zachary Amsden <zach@vmware.com>
Cc: Anthony Liguori <aliguori@us.ibm.com>
Cc: Andi Kleen <ak@suse.de>a
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/vmi.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/vmi.c~vmi-logic-error arch/i386/kernel/vmi.c
--- a/arch/i386/kernel/vmi.c~vmi-logic-error
+++ a/arch/i386/kernel/vmi.c
@@ -712,11 +712,14 @@ static void *vmi_get_function(int vmical
 do {								\
 	reloc = call_vrom_long_func(vmi_rom, get_reloc,		\
 				    VMI_CALL_##vmicall);	\
-	if (rel->type != VMI_RELOCATION_NONE) {			\
-		BUG_ON(rel->type != VMI_RELOCATION_CALL_REL);	\
+	if (rel->type == VMI_RELOCATION_CALL_REL) 		\
 		paravirt_ops.opname = (void *)rel->eip;		\
-	} else if (rel->type == VMI_RELOCATION_NOP) 		\
+	else if (rel->type == VMI_RELOCATION_NOP) 		\
 		paravirt_ops.opname = (void *)vmi_nop;		\
+	else if (rel->type != VMI_RELOCATION_NONE)		\
+		printk(KERN_WARNING "VMI: Unknown relocation "	\
+				    "type %d for " #vmicall"\n",\
+					rel->type);		\
 } while (0)
 
 /*
_

Patches currently in -mm which might be from zach@vmware.com are

origin.patch
vmi-logic-error.patch
fix-buslogic-to-stop-using-check_region.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
paravirt_ops-update-maintainers.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
paravirt_ops-add-common-patching-machinery.patch
paravirt_ops-revert-map_pt_hook.patch
paravirt_ops-add-kmap_atomic_pte-for-mapping-highpte-pages.patch
i386-relocate-vdso-elf-headers-to-match-mapped-location-with-compat_vdso.patch
i386-make-compat_vdso-runtime-selectable.patch
i386-sysenter-arch-pages-fix.patch
i386-acpi-remove-earlyquirk-warning.patch
i386-mcheck-p4-grotesque-and-needless-warning-fix.patch
i386-pgd-clone-under-lock-fix.patch
vmi-supports-compat-vdso.patch
resurrect-the-vmi-lazy-mode-fixes.patch
resurrect-the-vmi-lazy-mode-fixes-fix.patch
vmi-kmap_atomic_pte-fix.patch
vmi-timer-update.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
