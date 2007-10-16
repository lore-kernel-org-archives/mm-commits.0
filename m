From: akpm@linux-foundation.org
Subject: - add-assembler-equivalents-to-__initdate_refok.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:29:34 -0700
Message-ID: <200710162029.l9GKTY8a014327@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59778 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935833AbXJPU3t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 16:29:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, mm-commits@vger.kernel.org


The patch titled
     Add assembler equivalents to __init{,date}_refok
has been removed from the -mm tree.  Its filename was
     add-assembler-equivalents-to-__initdate_refok.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add assembler equivalents to __init{,date}_refok
From: Ralf Baechle <ralf@linux-mips.org>

I need __INIT_REFOK to fix a MODPOST warning for a few MIPS configs which
have to call init code from .text very early in the game due to bootloader
issues.  __INITDATA_REFOK is just for consistency.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/init.h~add-assembler-equivalents-to-__initdate_refok include/linux/init.h
--- a/include/linux/init.h~add-assembler-equivalents-to-__initdate_refok
+++ a/include/linux/init.h
@@ -67,8 +67,10 @@
 
 /* For assembly routines */
 #define __INIT		.section	".init.text","ax"
+#define __INIT_REFOK	.section	".text.init.refok","ax"
 #define __FINIT		.previous
 #define __INITDATA	.section	".init.data","aw"
+#define __INITDATA_REFOK .section	".data.init.refok","aw"
 
 #ifndef __ASSEMBLY__
 /*
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
spelling-fix-weired-weird.patch
remove-dma_cache_wbackinvwback_inv-functions.patch
lk201-remove-obsolete-driver.patch
fix-wrong-filename-reference-in-drivers-testingtxt.patch
completely-remove-deprecated-irq-flags-sa_.patch
compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
break-elf_platform-and-stack-pointer-randomization-dependency.patch
add-a-00-index-file-to-documentation-mips.patch
define-global-bit-macro.patch
bitops-introduce-lock-ops.patch
mips-fix-bitops.patch
mips-lock-bitops.patch
replace-__attribute_pure__-with-__pure.patch
