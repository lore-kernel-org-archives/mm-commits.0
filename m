From: akpm@linux-foundation.org
Subject: + lguest-the-guest-code-suppress-ide-probing.patch added to -mm tree
Date: Tue, 05 Jun 2007 19:49:48 -0700
Message-ID: <200706060249.l562nmYT008229@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47983 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750902AbXFFCt6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 22:49:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, jeremy@xensource.com


The patch titled
     lguest: suppress IDE probing
has been added to the -mm tree.  Its filename is
     lguest-the-guest-code-suppress-ide-probing.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: lguest: suppress IDE probing
From: Rusty Russell <rusty@rustcorp.com.au>

The IDE probe is the slowest part of boot: by suppressing it we cut
boot from from 4.1 seconds to 0.6 seconds.

It turns out that paravirt_disable_iospace() does just this.  Woot!

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/lguest/lguest.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/lguest/lguest.c~lguest-the-guest-code-suppress-ide-probing drivers/lguest/lguest.c
--- a/drivers/lguest/lguest.c~lguest-the-guest-code-suppress-ide-probing
+++ a/drivers/lguest/lguest.c
@@ -510,6 +510,8 @@ __init void lguest_init(void)
 
 	reserve_top_address(lguest_data.reserve_mem);
 
+	paravirt_disable_iospace();
+
 	cpu_detect(&new_cpu_data);
 	/* Math is always hard! */
 	new_cpu_data.hard_math = 1;
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

git-kbuild.patch
paravirt-helper-to-disable-all-io-space.patch
paravirt-helper-to-disable-all-io-space-fix.patch
xen-disable-all-non-virtual-devices.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
use-menuconfig-objects-ii-module-menu.patch
fix-stop_machine_run-problem-with-naughty-real-time-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
define-new-percpu-interface-for-shared-data.patch
use-the-new-percpu-interface-for-shared-data.patch
lguest-export-symbols-for-lguest-as-a-module.patch
lguest-the-guest-code.patch
lguest-the-guest-code-tidyups.patch
lguest-the-guest-code-tidyups-update.patch
lguest-the-guest-code-update-for-mm-disable-tsc-dont-set-pge-bit.patch
lguest-speed-up-paravirt_lazy_flush-handling.patch
lguest-more-lazy_hcalls.patch
lguest-the-guest-code-tsc-fix.patch
lguest-the-guest-code-suppress-ide-probing.patch
lguest-the-host-code.patch
lguest-the-host-code-tidyups.patch
lguest-the-host-code-tidyups-update.patch
lguest-the-host-code-borkages.patch
lguest-faster-tls-switching.patch
lguest-the-host-code-dont-signal-like-crazy-use-lhreq_break-command.patch
lguest-the-host-code-use-tsc.patch
lguest-the-host-code-use-hrtimers.patch
lguest-the-host-code-update-for-mm-simplify-boot_params.patch
lguest-the-asm-offsets.patch
lguest-the-makefile-and-kconfig.patch
lguest-the-makefile-and-kconfig-tidyups.patch
lguest-the-console-driver.patch
lguest-the-console-driver-tidyups.patch
lguest-the-net-driver.patch
lguest-the-net-driver-tidyups.patch
lguest-the-net-driver-tidyups-update.patch
lguest-the-net-driver-include-fix.patch
lguest-the-block-driver.patch
lguest-the-block-driver-tidyups.patch
lguest-the-block-driver-tidyups-update.patch
lguest-the-documentation-example-launcher.patch
lguest-the-documentation-example-launcher-example-launcher-fix.patch
lguest-dont-signal-like-crazy-use-lhreq_break-command-doc.patch
mm-clean-up-and-kernelify-shrinker-registration-reiser4.patch
