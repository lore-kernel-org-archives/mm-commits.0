From: akpm@linux-foundation.org
Subject: - lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:41:49 -0700
Message-ID: <200707092341.l69Nfon9020878@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54721 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757301AbXGIXmY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:42:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, johnstul@us.ibm.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     lguest: handle dodgy/non-existent TSC.  Host code.
has been removed from the -mm tree.  Its filename was
     lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code.patch

This patch was dropped because it was folded into lguest-the-host-code.patch

------------------------------------------------------
Subject: lguest: handle dodgy/non-existent TSC.  Host code.
From: Rusty Russell <rusty@rustcorp.com.au>

Lguest currently requires a TSC, which breaks older machines and Matt Mackall
who boots the host with "notsc".  In addition, there is no good solution to
changing TSC speeds (informing all the guests about the TSC impending change
before it happens would be a great deal of code and have issues with
disobedient guests).

This patch makes the host determine if the TSC is both constant and stable: if
not, it doesn't tell the guest to use it.  We export check_tsc_unstable() for
this.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/tsc.c      |    3 ++-
 drivers/lguest/core.c       |    8 --------
 drivers/lguest/hypercalls.c |    9 +++++++++
 include/asm-i386/tsc.h      |    1 +
 4 files changed, 12 insertions(+), 9 deletions(-)

diff -puN arch/i386/kernel/tsc.c~lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code
+++ a/arch/i386/kernel/tsc.c
@@ -58,10 +58,11 @@ __setup("notsc", tsc_setup);
  */
 static int tsc_unstable;
 
-static inline int check_tsc_unstable(void)
+int check_tsc_unstable(void)
 {
 	return tsc_unstable;
 }
+EXPORT_SYMBOL_GPL(check_tsc_unstable);
 
 unsigned long native_calculate_cpu_khz(void)
 {
diff -puN drivers/lguest/core.c~lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code drivers/lguest/core.c
--- a/drivers/lguest/core.c~lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code
+++ a/drivers/lguest/core.c
@@ -332,14 +332,6 @@ int run_guest(struct lguest *lg, unsigne
 			continue;
 		}
 
-		/* If the Guest hasn't been told the clock multiplier to use or
-		 * it's changed, we update it here. */
-		if (unlikely(lg->tsc_khz != tsc_khz) && lg->lguest_data) {
-			lg->tsc_khz = tsc_khz;
-			if (put_user(lg->tsc_khz, &lg->lguest_data->tsc_khz))
-				return -EFAULT;
-		}
-
 		local_irq_disable();
 
 		/* Even if *we* don't want FPU trap, guest might... */
diff -puN drivers/lguest/hypercalls.c~lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code drivers/lguest/hypercalls.c
--- a/drivers/lguest/hypercalls.c~lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code
+++ a/drivers/lguest/hypercalls.c
@@ -132,12 +132,20 @@ static void do_async_hcalls(struct lgues
 
 static void initialize(struct lguest *lg)
 {
+	u32 tsc_speed;
+
 	if (lg->regs->eax != LHCALL_LGUEST_INIT) {
 		kill_guest(lg, "hypercall %li before LGUEST_INIT",
 			   lg->regs->eax);
 		return;
 	}
 
+	/* We only tell the guest to use the TSC if it's reliable. */
+	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC) && !check_tsc_unstable())
+		tsc_speed = tsc_khz;
+	else
+		tsc_speed = 0;
+
 	lg->lguest_data = (struct lguest_data __user *)lg->regs->edx;
 	/* We check here so we can simply copy_to_user/from_user */
 	if (!lguest_address_ok(lg, lg->regs->edx, sizeof(*lg->lguest_data))) {
@@ -148,6 +156,7 @@ static void initialize(struct lguest *lg
 	    || get_user(lg->noirq_end, &lg->lguest_data->noirq_end)
 	    /* We reserve the top pgd entry. */
 	    || put_user(4U*1024*1024, &lg->lguest_data->reserve_mem)
+	    || put_user(tsc_speed, &lg->lguest_data->tsc_khz)
 	    || put_user(lg->guestid, &lg->lguest_data->guestid))
 		kill_guest(lg, "bad guest page %p", lg->lguest_data);
 
diff -puN include/asm-i386/tsc.h~lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code include/asm-i386/tsc.h
--- a/include/asm-i386/tsc.h~lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code
+++ a/include/asm-i386/tsc.h
@@ -63,6 +63,7 @@ extern void tsc_init(void);
 extern void mark_tsc_unstable(char *reason);
 extern int unsynchronized_tsc(void);
 extern void init_tsc_clocksource(void);
+int check_tsc_unstable(void);
 
 /*
  * Boot-time check whether the TSCs are synchronized across
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
paravirt-helper-to-disable-all-io-space-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
modules-remove-modlist_lock.patch
permit-mempool_freenull.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-host-code.patch
lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code.patch
lguest-the-host-code-handle-dodgy-non-existent-tsc-guest-code.patch
lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code-fix.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-fix-guests-1g.patch
readahead-introduce-pg_readahead.patch
readahead-add-look-ahead-support-to-__do_page_cache_readahead.patch
readahead-min_ra_pages-max_ra_pages-macros.patch
readahead-data-structure-and-routines.patch
readahead-on-demand-readahead-logic.patch
readahead-convert-filemap-invocations.patch
readahead-convert-splice-invocations.patch
readahead-convert-ext3-ext4-invocations.patch
readahead-remove-the-old-algorithm.patch
readahead-move-synchronous-readahead-call-out-of-splice-loop.patch
readahead-pass-real-splice-size.patch
mm-share-pg_readahead-and-pg_reclaim.patch
readahead-split-ondemand-readahead-interface-into-two-functions.patch
readahead-sanify-file_ra_state-names.patch
define-new-percpu-interface-for-shared-data-version-4.patch
use-the-new-percpu-interface-for-shared-data-version-4.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
