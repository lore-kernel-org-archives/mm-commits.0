From: akpm@linux-foundation.org
Subject: + compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch added to -mm tree
Date: Thu, 27 Sep 2007 15:06:36 -0700
Message-ID: <200709272206.l8RM6aaR030260@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47420 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927AbXI0WHT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Sep 2007 18:07:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, tglx@linutronix.de


The patch titled
     Compile handle_percpu_irq even for uniprocessor kernels
has been added to the -mm tree.  Its filename is
     compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Compile handle_percpu_irq even for uniprocessor kernels
From: Ralf Baechle <ralf@linux-mips.org>

Compiling handle_percpu_irq only on uniprocessor generates an artificial
special case so a typical use like:

  set_irq_chip_and_handler(irq, &some_irq_type, handle_percpu_irq);

needs to be conditionally compiled only on SMP systems as well and an
alternative UP construct is usually needed - for no good reason.

This fixes uniprocessor configurations for some MIPS SMP systems.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/irq/chip.c~compile-handle_percpu_irq-even-for-uniprocessor-kernels kernel/irq/chip.c
--- a/kernel/irq/chip.c~compile-handle_percpu_irq-even-for-uniprocessor-kernels
+++ a/kernel/irq/chip.c
@@ -503,7 +503,6 @@ out_unlock:
 	spin_unlock(&desc->lock);
 }
 
-#ifdef CONFIG_SMP
 /**
  *	handle_percpu_IRQ - Per CPU local irq handler
  *	@irq:	the interrupt number
@@ -529,8 +528,6 @@ handle_percpu_irq(unsigned int irq, stru
 		desc->chip->eoi(irq);
 }
 
-#endif /* CONFIG_SMP */
-
 void
 __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		  const char *name)
_

Patches currently in -mm which might be from ralf@linux-mips.org are

git-mips.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-replace-config_usb_ohci-with-config_usb_ohci_hcd-in-a-few-overlooked-files.patch
git-mtd.patch
git-net.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
fix-ide-legacy-mode-resources.patch
fix-ide-legacy-mode-resources-fix.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
spelling-fix-weired-weird.patch
remove-dma_cache_wbackinvwback_inv-functions.patch
lk201-remove-obsolete-driver.patch
fix-wrong-filename-reference-in-drivers-testingtxt.patch
mips-remove-deprecated-irq-flags-sa_.patch
completely-remove-deprecated-irq-flags-sa_.patch
compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
rtc-make-rtc-ds1742-driver-hotplug-aware-take-2.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers.patch
fbcon-convert-struct-font_desc-to-use-iso-c-initializers-update.patch
vt-fix-warnings-in-selectionh.patch
export-font_vga_8x16.patch
drivers-video-pmag-ba-fbc-improve-diagnostics.patch
drivers-video-pmag-ba-fbc-improve-diagnostics-fix.patch
add-a-00-index-file-to-documentation-mips.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
