From: akpm@linux-foundation.org
Subject: + au1100fb-fix-modpost-warnings.patch added to -mm tree
Date: Wed, 17 Oct 2007 14:23:23 -0700
Message-ID: <200710172123.l9HLNNxg009027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756353AbXJQVXc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 17:23:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, adaplas@pol.net


The patch titled
     au1100fb: fix modpost warnings
has been added to the -mm tree.  Its filename is
     au1100fb-fix-modpost-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: au1100fb: fix modpost warnings
From: Ralf Baechle <ralf@linux-mips.org>

  MODPOST vmlinux.o
WARNING: vmlinux.o(.text+0x170be8): Section mismatch: reference to .init.data:au1100fb_fix (between 'au1100fb_drv_probe' and 'read_null')
WARNING: vmlinux.o(.text+0x170dc4): Section mismatch: reference to .init.data:au1100fb_var (between 'au1100fb_drv_probe' and 'read_null')
WARNING: vmlinux.o(.text+0x170dd0): Section mismatch: reference to .init.data:au1100fb_fix (between 'au1100fb_drv_probe' and 'read_null')
WARNING: vmlinux.o(.text+0x170de0): Section mismatch: reference to .init.data:au1100fb_var (between 'au1100fb_drv_probe' and 'read_null')
WARNING: vmlinux.o(.text+0x170e70): Section mismatch: reference to .init.data:au1100fb_var (between 'au1100fb_drv_probe' and 'read_null')

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/au1100fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/au1100fb.c~au1100fb-fix-modpost-warnings drivers/video/au1100fb.c
--- a/drivers/video/au1100fb.c~au1100fb-fix-modpost-warnings
+++ a/drivers/video/au1100fb.c
@@ -457,7 +457,7 @@ static struct fb_ops au1100fb_ops =
 
 /* AU1100 LCD controller device driver */
 
-int au1100fb_drv_probe(struct device *dev)
+static int __init au1100fb_drv_probe(struct device *dev)
 {
 	struct au1100fb_device *fbdev = NULL;
 	struct resource *regs_res;
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
clean-up-duplicate-includes-in-drivers-char.patch
spelling-fix-weired-weird.patch
remove-dma_cache_wbackinvwback_inv-functions.patch
lk201-remove-obsolete-driver.patch
fix-wrong-filename-reference-in-drivers-testingtxt.patch
completely-remove-deprecated-irq-flags-sa_.patch
compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
break-elf_platform-and-stack-pointer-randomization-dependency.patch
add-a-00-index-file-to-documentation-mips.patch
netport_conc-fix-build-errors-and-warnings.patch
au1100fb-fix-modpost-warnings.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
replace-__attribute_pure__-with-__pure.patch
