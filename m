From: akpm@linux-foundation.org
Subject: + lguest-the-guest-code-lguest-fix-tsc-divide-error-0000-boot-crash.patch added to -mm tree
Date: Tue, 03 Jul 2007 10:39:38 -0700
Message-ID: <200707031739.l63Hdd9P005355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46320 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755536AbXGCRjy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 13:39:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au


The patch titled
     lguest: fix TSC "divide error: 0000 [#1]" boot crash
has been added to the -mm tree.  Its filename is
     lguest-the-guest-code-lguest-fix-tsc-divide-error-0000-boot-crash.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: fix TSC "divide error: 0000 [#1]" boot crash
From: Rusty Russell <rusty@rustcorp.com.au>

Configuring a guest with < CONFIG_M586TSC reveals an lguest bug: the TSC
code expects to see the TSC capability bit, but we weren't setting up the
capabilities until much later in check_bugs -> identify_boot_cpu ->
identify_boot_cpu.

Do the same thing as Xen and the head.S native code: populate the first
capability word before start_kernel().

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c |    3 +++
 1 files changed, 3 insertions(+)

diff -puN drivers/lguest/lguest.c~lguest-the-guest-code-lguest-fix-tsc-divide-error-0000-boot-crash drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-guest-code-lguest-fix-tsc-divide-error-0000-boot-crash
+++ a/drivers/lguest/lguest.c
@@ -515,6 +515,9 @@ __init void lguest_init(void)
 	paravirt_disable_iospace();
 
 	cpu_detect(&new_cpu_data);
+	/* head.S usually sets up the first capability word, so do it here. */
+	new_cpu_data.x86_capability[0] = cpuid_edx(1);
+
 	/* Math is always hard! */
 	new_cpu_data.hard_math = 1;
 
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
paravirt-helper-to-disable-all-io-space-fix.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
mm-clean-up-and-kernelify-shrinker-registration-vs-git-nfs.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
fix-lguest-w-lockdep.patch
lguest-the-guest-code-lguest-fix-tsc-divide-error-0000-boot-crash.patch
lguest-the-host-code.patch
lguest-the-host-code-lguest-vs-clockevents-fix-resume-logic.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-console-driver.patch
lguest-the-net-driver.patch
lguest-the-block-driver.patch
lguest-the-documentation-example-launcher.patch
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
