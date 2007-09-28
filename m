From: akpm@linux-foundation.org
Subject: + e100-fix-bogus-pci-quirk.patch added to -mm tree
Date: Fri, 28 Sep 2007 16:17:45 -0700
Message-ID: <200709282317.l8SNHjA7022254@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40128 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbXI1XST (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 19:18:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, auke-jan.h.kok@intel.com, greg@kroah.com, jeff@garzik.org, linas@austin.ibm.com


The patch titled
     e100: Fix bogus PCI quirk
has been added to the -mm tree.  Its filename is
     e100-fix-bogus-pci-quirk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: e100: Fix bogus PCI quirk
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Linas reported that some machines were crashing at boot in
quirk_e100_interrupt.  It appears that this quirk is doing an ioremap
directly on a PCI BAR value, which isn't legal and will cause all sorts of
bad things to happen on architectures where PCI BARs don't directly match
processor bus addresses.

This fixes it by using the proper PCI resources instead which is possible
since the quirk has been moved by a previous commit to happen late enough
for that.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Greg KH <greg@kroah.com>
Cc: Linas Vepstas <linas@austin.ibm.com>
Cc: Auke Kok <auke-jan.h.kok@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/pci/quirks.c~e100-fix-bogus-pci-quirk drivers/pci/quirks.c
--- a/drivers/pci/quirks.c~e100-fix-bogus-pci-quirk
+++ a/drivers/pci/quirks.c
@@ -1444,7 +1444,6 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_N
 static void __devinit quirk_e100_interrupt(struct pci_dev *dev)
 {
 	u16 command;
-	u32 bar;
 	u8 __iomem *csr;
 	u8 cmd_hi;
 
@@ -1476,12 +1475,12 @@ static void __devinit quirk_e100_interru
 	 * re-enable them when it's ready.
 	 */
 	pci_read_config_word(dev, PCI_COMMAND, &command);
-	pci_read_config_dword(dev, PCI_BASE_ADDRESS_0, &bar);
 
-	if (!(command & PCI_COMMAND_MEMORY) || !bar)
+	if (!(command & PCI_COMMAND_MEMORY) || !pci_resource_start(dev, 0))
 		return;
 
-	csr = ioremap(bar, 8);
+	/* Convert from PCI bus to resource space.  */
+	csr = ioremap(pci_resource_start(dev, 0), 8);
 	if (!csr) {
 		printk(KERN_WARNING "PCI: Can't map %s e100 registers\n",
 			pci_name(dev));
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

e100-fix-bogus-pci-quirk.patch
powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
git-powerpc.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
powerpc-vdso-install-unstripped-copies-on-disk-update.patch
sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
powerpc-proper-defconfig-for-crosscompiles.patch
powerpc-proper-defconfig-for-crosscompiles-fix.patch
powerpc-ptrace-check_full_regs.patch
adbhid-produce-all-capslock-key-events.patch
git-kbuild.patch
git-libata-all.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix.patch
convert-cpu_sibling_map-to-a-per_cpu-data-array-ppc64-fix-2.patch
sparsemem-clean-up-spelling-error-in-comments.patch
sparsemem-record-when-a-section-has-a-valid-mem_map.patch
generic-virtual-memmap-support-for-sparsemem.patch
ppc64-sparsemem_vmemmap-support.patch
ppc64-sparsemem_vmemmap-support-vmemmap-ppc64-convert-vmm_-macros-to-a-real-function.patch
ppc64-sparsemem_vmemmap-support-convert-to-new-config-options.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
remove-frv-usage-of-flush_tlb_pgtables.patch
softlockup-make-asm-irq_regsh-available-on-every-platform.patch
unexport-asm-shmparamh.patch
kconfig-make-instrumentation-support-non-experimental.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards.patch
pcmcia-compactflash-driver-for-pa-semi-electra-boards-fix.patch
report-the-per-irq-statistics-on-allarches.patch
add-linux-elfcore-compath.patch
x86_64-use-linux-elfcore-compath.patch
powerpc-use-linux-elfcore-compath.patch
fix-discrepancy-between-vdso-based-gettimeofday-and-sys_gettimeofday.patch
increase-at_vector_size-to-terminate-saved_auxv-properly.patch
delay-creation-of-khcvd-thread.patch
radeonfb-xpress-200m-rc410-support-patch.patch
add-scaled-time-to-taskstats-based-process-accounting.patch
add-missing-newlines-to-some-uses-of-dev_level-messages-fix.patch
powerpc-add-scaled-time-accounting.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-ppc64.patch
add-documentation-for-extended-crashkernel-syntax.patch
