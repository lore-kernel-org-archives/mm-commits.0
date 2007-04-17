From: akpm@linux-foundation.org
Subject: - vmi-logic-error.patch removed from -mm tree
Date: Mon, 16 Apr 2007 22:19:59 -0700
Message-ID: <200704170519.l3H5JxqR021030@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36229 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753993AbXDQFUJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Apr 2007 01:20:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zach@vmware.com, ak@suse.de, aliguori@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     VMI logic error
has been removed from the -mm tree.  Its filename was
     vmi-logic-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
fix-buslogic-to-stop-using-check_region.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
i386-sysenter-arch-pages-fix.patch
i386-acpi-remove-earlyquirk-warning.patch
i386-mcheck-p4-grotesque-and-needless-warning-fix.patch
i386-pgd-clone-under-lock-fix.patch
vmi-supports-compat-vdso.patch
resurrect-the-vmi-lazy-mode-fixes.patch
resurrect-the-vmi-lazy-mode-fixes-fix.patch
vmi-kmap_atomic_pte-fix.patch
vmi-timer-update.patch
i386-pte-drop-ptep_get_and_clear-paravirt-op.patch
i386-pte-clear-optimization.patch
i386-pte-xchg-optimization.patch
i386-pte-simplify-ops.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings-fix.patch
mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung.patch
i386-use-pte_update_defer-in-ptep_test_and_clear_dirtyyoung-fix.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
