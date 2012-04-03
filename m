From: akpm@linux-foundation.org
Subject: [merged] x86-remove-deprecated-disable_hlt-and-enable_hlt.patch removed from -mm tree
Date: Tue, 03 Apr 2012 13:10:49 -0700
Message-ID: <20120403201049.94D35A0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:43041 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab2DCUKv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Apr 2012 16:10:51 -0400
Received: by ggnd2 with SMTP id d2so16618ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Apr 2012 13:10:50 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: len.brown@intel.com, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, jwboyer@redhat.com, mingo@kernel.org, shemminger@vyatta.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86: remove deprecated disable_hlt and enable_hlt
has been removed from the -mm tree.  Its filename was
     x86-remove-deprecated-disable_hlt-and-enable_hlt.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Len Brown <len.brown@intel.com>
Subject: x86: remove deprecated disable_hlt and enable_hlt

The X86_32-only disable_hlt/enable_hlt mechanism was used by the 32-bit
floppy driver.  Its effect was to replace the use of the HLT instruction
inside default_idle() with cpu_relax().

This workaround was commented:
"disable hlt during certain critical i/o operations"

"This halt magic was a workaround for ancient floppy DMA wreckage. It should
be safe to remove."

H. Peter Anvin additionally adds:

"To the best of my knowledge, no-hlt only existed because of flaky power
distributions on 386/486 systems which were sold to run DOS.  Since DOS
did no power management of any kind, including HLT, the power draw was
fairly uniform; when exposed to the much hhigher noise levels you got when
Linux used HLT caused some of these systems to fail.

They were by far in the minority even back then."

Alan Cox further says:

"Also for the Cyrix 5510 which tended to go castors up if a HLT occurred
during a DMA cycle and on a few other boxes HLT during DMA tended to go
astray.

Do we care ? I doubt it. The 5510 was pretty obscure, the 5520 fixed it,
the 5530 is probably the oldest still in any kind of use."

So, let's finally drop this.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Stephen Hemminger <shemminger@vyatta.com
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    8 ----
 arch/x86/include/asm/processor.h           |   10 -----
 arch/x86/kernel/process.c                  |   24 ------------
 drivers/block/floppy.c                     |   36 -------------------
 4 files changed, 78 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~x86-remove-deprecated-disable_hlt-and-enable_hlt Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~x86-remove-deprecated-disable_hlt-and-enable_hlt
+++ a/Documentation/feature-removal-schedule.txt
@@ -6,14 +6,6 @@ be removed from this file.
 
 ---------------------------
 
-What:	x86 floppy disable_hlt
-When:	2012
-Why:	ancient workaround of dubious utility clutters the
-	code used by everybody else.
-Who:	Len Brown <len.brown@intel.com>
-
----------------------------
-
 What:	CONFIG_APM_CPU_IDLE, and its ability to call APM BIOS in idle
 When:	2012
 Why:	This optional sub-feature of APM is of dubious reliability,
diff -puN /dev/null /dev/null
diff -puN arch/x86/kernel/process.c~x86-remove-deprecated-disable_hlt-and-enable_hlt arch/x86/kernel/process.c
--- a/arch/x86/kernel/process.c~x86-remove-deprecated-disable_hlt-and-enable_hlt
+++ a/arch/x86/kernel/process.c
@@ -362,34 +362,10 @@ void (*pm_idle)(void);
 EXPORT_SYMBOL(pm_idle);
 #endif
 
-#ifdef CONFIG_X86_32
-/*
- * This halt magic was a workaround for ancient floppy DMA
- * wreckage. It should be safe to remove.
- */
-static int hlt_counter;
-void disable_hlt(void)
-{
-	hlt_counter++;
-}
-EXPORT_SYMBOL(disable_hlt);
-
-void enable_hlt(void)
-{
-	hlt_counter--;
-}
-EXPORT_SYMBOL(enable_hlt);
-
-static inline int hlt_use_halt(void)
-{
-	return (!hlt_counter && boot_cpu_data.hlt_works_ok);
-}
-#else
 static inline int hlt_use_halt(void)
 {
 	return 1;
 }
-#endif
 
 #ifndef CONFIG_SMP
 static inline void play_dead(void)
diff -puN drivers/block/floppy.c~x86-remove-deprecated-disable_hlt-and-enable_hlt drivers/block/floppy.c
--- a/drivers/block/floppy.c~x86-remove-deprecated-disable_hlt-and-enable_hlt
+++ a/drivers/block/floppy.c
@@ -1030,37 +1030,6 @@ static int fd_wait_for_completion(unsign
 	return 0;
 }
 
-static DEFINE_SPINLOCK(floppy_hlt_lock);
-static int hlt_disabled;
-static void floppy_disable_hlt(void)
-{
-	unsigned long flags;
-
-	WARN_ONCE(1, "floppy_disable_hlt() scheduled for removal in 2012");
-	spin_lock_irqsave(&floppy_hlt_lock, flags);
-	if (!hlt_disabled) {
-		hlt_disabled = 1;
-#ifdef HAVE_DISABLE_HLT
-		disable_hlt();
-#endif
-	}
-	spin_unlock_irqrestore(&floppy_hlt_lock, flags);
-}
-
-static void floppy_enable_hlt(void)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&floppy_hlt_lock, flags);
-	if (hlt_disabled) {
-		hlt_disabled = 0;
-#ifdef HAVE_DISABLE_HLT
-		enable_hlt();
-#endif
-	}
-	spin_unlock_irqrestore(&floppy_hlt_lock, flags);
-}
-
 static void setup_DMA(void)
 {
 	unsigned long f;
@@ -1105,7 +1074,6 @@ static void setup_DMA(void)
 	fd_enable_dma();
 	release_dma_lock(f);
 #endif
-	floppy_disable_hlt();
 }
 
 static void show_floppy(void);
@@ -1707,7 +1675,6 @@ irqreturn_t floppy_interrupt(int irq, vo
 	fd_disable_dma();
 	release_dma_lock(f);
 
-	floppy_enable_hlt();
 	do_floppy = NULL;
 	if (fdc >= N_FDC || FDCS->address == -1) {
 		/* we don't even know which FDC is the culprit */
@@ -1856,8 +1823,6 @@ static void floppy_shutdown(unsigned lon
 		show_floppy();
 	cancel_activity();
 
-	floppy_enable_hlt();
-
 	flags = claim_dma_lock();
 	fd_disable_dma();
 	release_dma_lock(flags);
@@ -4508,7 +4473,6 @@ static void floppy_release_irq_and_dma(v
 #if N_FDC > 1
 	set_dor(1, ~8, 0);
 #endif
-	floppy_enable_hlt();
 
 	if (floppy_track_buffer && max_buffer_sectors) {
 		tmpsize = max_buffer_sectors * 1024;
diff -puN arch/x86/include/asm/processor.h~x86-remove-deprecated-disable_hlt-and-enable_hlt arch/x86/include/asm/processor.h
--- a/arch/x86/include/asm/processor.h~x86-remove-deprecated-disable_hlt-and-enable_hlt
+++ a/arch/x86/include/asm/processor.h
@@ -974,16 +974,6 @@ extern bool cpu_has_amd_erratum(const in
 #define cpu_has_amd_erratum(x)	(false)
 #endif /* CONFIG_CPU_SUP_AMD */
 
-#ifdef CONFIG_X86_32
-/*
- * disable hlt during certain critical i/o operations
- */
-#define HAVE_DISABLE_HLT
-#endif
-
-void disable_hlt(void);
-void enable_hlt(void);
