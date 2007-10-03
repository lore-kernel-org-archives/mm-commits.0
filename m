From: akpm@linux-foundation.org
Subject: + platinumfb-fix-resource-management.patch added to -mm tree
Date: Wed, 03 Oct 2007 13:53:01 -0700
Message-ID: <200710032053.l93Kr1Qi008064@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57510 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756622AbXJCUxF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2007 16:53:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: benh@kernel.crashing.org, adaplas@gmail.com


The patch titled
     platinumfb: fix resource management
has been added to the -mm tree.  Its filename is
     platinumfb-fix-resource-management.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: platinumfb: fix resource management
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Current kernels have a non-working platinumfb due to some resource management
issues.  This fixes it.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN drivers/video/platinumfb.c~platinumfb-fix-resource-management drivers/video/platinumfb.c
--- a/drivers/video/platinumfb.c~platinumfb-fix-resource-management
+++ a/drivers/video/platinumfb.c
@@ -17,6 +17,8 @@
  *  more details.
  */
 
+#undef DEBUG
+
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
@@ -535,33 +537,35 @@ static int __devinit platinumfb_probe(st
 	volatile __u8		*fbuffer;
 	int			bank0, bank1, bank2, bank3, rc;
 
-	printk(KERN_INFO "platinumfb: Found Apple Platinum video hardware\n");
+	dev_info(&odev->dev, "Found Apple Platinum video hardware\n");
 
 	info = framebuffer_alloc(sizeof(*pinfo), &odev->dev);
-	if (info == NULL)
+	if (info == NULL) {
+		dev_err(&odev->dev, "Failed to allocate fbdev !\n");
 		return -ENOMEM;
+	}
 	pinfo = info->par;
 
 	if (of_address_to_resource(dp, 0, &pinfo->rsrc_reg) ||
 	    of_address_to_resource(dp, 1, &pinfo->rsrc_fb)) {
-		printk(KERN_ERR "platinumfb: Can't get resources\n");
-		framebuffer_release(info);
-		return -ENXIO;
-	}
-	if (!request_mem_region(pinfo->rsrc_reg.start,
-				pinfo->rsrc_reg.start -
-				pinfo->rsrc_reg.end + 1,
-				"platinumfb registers")) {
+		dev_err(&odev->dev, "Can't get resources\n");
 		framebuffer_release(info);
 		return -ENXIO;
 	}
+	dev_dbg(&odev->dev, " registers  : 0x%llx...0x%llx\n",
+		(unsigned long long)pinfo->rsrc_reg.start,
+		(unsigned long long)pinfo->rsrc_reg.end);
+	dev_dbg(&odev->dev, " framebuffer: 0x%llx...0x%llx\n",
+		(unsigned long long)pinfo->rsrc_fb.start,
+		(unsigned long long)pinfo->rsrc_fb.end);
+
+	/* Do not try to request register space, they overlap with the
+	 * northbridge and that can fail. Only request framebuffer
+	 */
 	if (!request_mem_region(pinfo->rsrc_fb.start,
-				pinfo->rsrc_fb.start
-				- pinfo->rsrc_fb.end + 1,
+				pinfo->rsrc_fb.end - pinfo->rsrc_fb.start + 1,
 				"platinumfb framebuffer")) {
-		release_mem_region(pinfo->rsrc_reg.start,
-				   pinfo->rsrc_reg.end -
-				   pinfo->rsrc_reg.start + 1);
+		printk(KERN_ERR "platinumfb: Can't request framebuffer !\n");
 		framebuffer_release(info);
 		return -ENXIO;
 	}
@@ -600,7 +604,8 @@ static int __devinit platinumfb_probe(st
 	bank2 = fbuffer[0x200000] == 0x56;
 	bank3 = fbuffer[0x300000] == 0x78;
 	pinfo->total_vram = (bank0 + bank1 + bank2 + bank3) * 0x100000;
-	printk(KERN_INFO "platinumfb: Total VRAM = %dMB (%d%d%d%d)\n", (int) (pinfo->total_vram / 1024 / 1024),
+	printk(KERN_INFO "platinumfb: Total VRAM = %dMB (%d%d%d%d)\n",
+	       (unsigned int) (pinfo->total_vram / 1024 / 1024),
 	       bank3, bank2, bank1, bank0);
 
 	/*
@@ -644,16 +649,15 @@ static int __devexit platinumfb_remove(s
         unregister_framebuffer (info);
 	
 	/* Unmap frame buffer and registers */
+	iounmap(pinfo->frame_buffer);
+	iounmap(pinfo->platinum_regs);
+	iounmap(pinfo->cmap_regs);
+
 	release_mem_region(pinfo->rsrc_fb.start,
 			   pinfo->rsrc_fb.end -
 			   pinfo->rsrc_fb.start + 1);
-	release_mem_region(pinfo->rsrc_reg.start,
-			   pinfo->rsrc_reg.end -
-			   pinfo->rsrc_reg.start + 1);
-	iounmap(pinfo->frame_buffer);
-	iounmap(pinfo->platinum_regs);
+
 	release_mem_region(pinfo->cmap_regs_phys, 0x1000);
-	iounmap(pinfo->cmap_regs);
 
 	framebuffer_release(info);
 
_

Patches currently in -mm which might be from benh@kernel.crashing.org are

cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
git-powerpc.patch
powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
powerpc-vdso-install-unstripped-copies-on-disk.patch
sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
powerpc-proper-defconfig-for-crosscompiles.patch
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
platinumfb-fix-resource-management.patch
add-scaled-time-to-taskstats-based-process-accounting.patch
add-missing-newlines-to-some-uses-of-dev_level-messages-fix.patch
powerpc-add-scaled-time-accounting.patch
powerpc-add-scaled-time-accounting-speedup.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
powerpc-lock-bitops.patch
powerpc-lock-bitops-fix.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-ppc64.patch
add-documentation-for-extended-crashkernel-syntax.patch
