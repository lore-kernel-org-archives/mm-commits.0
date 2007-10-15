From: akpm@linux-foundation.org
Subject: + add-assembler-equivalents-to-__initdate_refok.patch added to -mm tree
Date: Mon, 15 Oct 2007 13:03:48 -0700
Message-ID: <200710152003.l9FK3mIg022480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41592 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755357AbXJOUED (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 16:04:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org


The patch titled
     Add assembler equivalents to __init{,date}_refok
has been added to the -mm tree.  Its filename is
     add-assembler-equivalents-to-__initdate_refok.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
add-assembler-equivalents-to-__initdate_refok.patch
git-mips.patch
move-a-few-definitions-to-au1000_xxs1500c.patch
move-a-few-definitions-to-au1000_xxs1500c-fix.patch
serial_txx9-cleanup-includes.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
clean-up-duplicate-includes-in-drivers-char.patch
spelling-fix-weired-weird.patch
remove-dma_cache_wbackinvwback_inv-functions.patch
lk201-remove-obsolete-driver.patch
fix-wrong-filename-reference-in-drivers-testingtxt.patch
completely-remove-deprecated-irq-flags-sa_.patch
compile-handle_percpu_irq-even-for-uniprocessor-kernels.patch
break-elf_platform-and-stack-pointer-randomization-dependency.patch
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
replace-__attribute_pure__-with-__pure.patch
