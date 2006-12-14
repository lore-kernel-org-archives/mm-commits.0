From: akpm@osdl.org
Subject: + m32r-build-fix-for-processors-without-isa_dsp_level2.patch added to -mm tree
Date: Thu, 14 Dec 2006 13:06:03 -0800
Message-ID: <200612142106.kBEL63xr025491@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:58440 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932912AbWLNVHN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 16:07:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: takata@linux-m32r.org, stable@kernel.org


The patch titled
     m32r: build fix for processors without ISA_DSP_LEVEL2
has been added to the -mm tree.  Its filename is
     m32r-build-fix-for-processors-without-isa_dsp_level2.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m32r: build fix for processors without ISA_DSP_LEVEL2
From: Hirokazu Takata <takata@linux-m32r.org>

Additional fixes for processors without ISA_DSP_LEVEL2.  sigcontext_t does not
have dummy_acc1h, dummy_acc1l members any longer.

Signed-off-by: Hirokazu Takata <takata@linux-m32r.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/m32r/kernel/process.c |    2 +-
 arch/m32r/kernel/signal.c  |   26 ++++----------------------
 2 files changed, 5 insertions(+), 23 deletions(-)

diff -puN arch/m32r/kernel/process.c~m32r-build-fix-for-processors-without-isa_dsp_level2 arch/m32r/kernel/process.c
--- a/arch/m32r/kernel/process.c~m32r-build-fix-for-processors-without-isa_dsp_level2
+++ a/arch/m32r/kernel/process.c
@@ -174,7 +174,7 @@ void show_regs(struct pt_regs * regs)
 	  regs->acc1h, regs->acc1l);
 #elif defined(CONFIG_ISA_M32R2) || defined(CONFIG_ISA_M32R)
 	printk("ACCH[%08lx]:ACCL[%08lx]\n", \
-	  regs->acch, regs->accl);
+	  regs->acc0h, regs->acc0l);
 #else
 #error unknown isa configuration
 #endif
diff -puN arch/m32r/kernel/signal.c~m32r-build-fix-for-processors-without-isa_dsp_level2 arch/m32r/kernel/signal.c
--- a/arch/m32r/kernel/signal.c~m32r-build-fix-for-processors-without-isa_dsp_level2
+++ a/arch/m32r/kernel/signal.c
@@ -109,19 +109,10 @@ restore_sigcontext(struct pt_regs *regs,
 	COPY(r10);
 	COPY(r11);
 	COPY(r12);
-#if defined(CONFIG_ISA_M32R2) && defined(CONFIG_ISA_DSP_LEVEL2)
 	COPY(acc0h);
 	COPY(acc0l);
-	COPY(acc1h);
-	COPY(acc1l);
-#elif defined(CONFIG_ISA_M32R2) || defined(CONFIG_ISA_M32R)
-	COPY(acch);
-	COPY(accl);
-	COPY(dummy_acc1h);
-	COPY(dummy_acc1l);
-#else
-#error unknown isa configuration
-#endif
+	COPY(acc1h);		/* ISA_DSP_LEVEL2 only */
+	COPY(acc1l);		/* ISA_DSP_LEVEL2 only */
 	COPY(psw);
 	COPY(bpc);
 	COPY(bbpsw);
@@ -196,19 +187,10 @@ setup_sigcontext(struct sigcontext __use
 	COPY(r10);
 	COPY(r11);
 	COPY(r12);
-#if defined(CONFIG_ISA_M32R2) && defined(CONFIG_ISA_DSP_LEVEL2)
 	COPY(acc0h);
 	COPY(acc0l);
-	COPY(acc1h);
-	COPY(acc1l);
-#elif defined(CONFIG_ISA_M32R2) || defined(CONFIG_ISA_M32R)
-	COPY(acch);
-	COPY(accl);
-	COPY(dummy_acc1h);
-	COPY(dummy_acc1l);
-#else
-#error unknown isa configuration
-#endif
+	COPY(acc1h);		/* ISA_DSP_LEVEL2 only */
+	COPY(acc1l);		/* ISA_DSP_LEVEL2 only */
 	COPY(psw);
 	COPY(bpc);
 	COPY(bbpsw);
_

Patches currently in -mm which might be from takata@linux-m32r.org are

m32r-build-fix-for-processors-without-isa_dsp_level2.patch
m32r-fix-do_page_fault-and-update_mmu_cache.patch
m32r-update-defconfig-files-for-v2619.patch
m32r-fix-kernel-entry-address-of-vmlinux.patch
m32r-cosmetic-updates-and-trivial-fixes.patch

