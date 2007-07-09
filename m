From: akpm@linux-foundation.org
Subject: - fix-lguest-w-lockdep.patch removed from -mm tree
Date: Mon, 09 Jul 2007 16:40:48 -0700
Message-ID: <200707092340.l69NemKE020828@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58925 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760365AbXGIXlN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 19:41:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, jeremy@xensource.com, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     Fix lguest w/ lockdep
has been removed from the -mm tree.  Its filename was
     fix-lguest-w-lockdep.patch

This patch was dropped because it was folded into lguest-the-guest-code.patch

------------------------------------------------------
Subject: Fix lguest w/ lockdep
From: Rusty Russell <rusty@rustcorp.com.au>

Fix "lguest: unhandled trap 14 at 0xc013630f (0x0)" with CONFIG_LOCKDEP=y

paravirt_disable_iospace -> request_resource -> write_lock -> __lock_acquire()

lockdep_init() is already idempotent: simply call it before
paravirt_disable_iospace().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/lguest/lguest.c~fix-lguest-w-lockdep drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~fix-lguest-w-lockdep
+++ a/drivers/lguest/lguest.c
@@ -510,6 +510,8 @@ __init void lguest_init(void)
 
 	reserve_top_address(lguest_data.reserve_mem);
 
+	lockdep_init();
+
 	paravirt_disable_iospace();
 
 	cpu_detect(&new_cpu_data);
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
fix-lguest-w-lockdep.patch
lguest-the-guest-code-lguest-fix-tsc-divide-error-0000-boot-crash.patch
lguest-the-host-code.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code.patch
lguest-the-host-code-handle-dodgy-non-existent-tsc-guest-code.patch
lguest-the-host-code-handle-dodgy-non-existent-tsc-host-code-fix.patch
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
