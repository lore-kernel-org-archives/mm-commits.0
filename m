From: akpm@google.com
Subject: [nacked] x86-rtc-dont-register-a-platform-rtc-device-for-intel-mid-platforms-fix.patch removed from -mm tree
Date: Thu, 29 Sep 2011 16:11:13 -0700
Message-ID: <201109292311.p8TNBE8w007980@hpaq3.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:58433 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab1I2XLk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2011 19:11:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, alan@lxorguk.ukuu.org.uk, hpa@zytor.com, mathias.nyman@linux.intel.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: x86 mrst: fix build error when X86_MRST is not enabled
has been removed from the -mm tree.  Its filename was
     x86-rtc-dont-register-a-platform-rtc-device-for-intel-mid-platforms-fix.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Randy Dunlap <rdunlap@xenotime.net>
Subject: x86 mrst: fix build error when X86_MRST is not enabled

Fix build when CONFIG_X86_INTEL_MID is enabled but CONFIG_X86_MRST is not
enabled.  Fixes this build error:

rtc.c:(.init.text+0x2fbb): undefined reference to `__mrst_cpu_chip'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 arch/x86/include/asm/mrst.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/x86/include/asm/mrst.h~x86-rtc-dont-register-a-platform-rtc-device-for-intel-mid-platforms-fix arch/x86/include/asm/mrst.h
--- a/arch/x86/include/asm/mrst.h~x86-rtc-dont-register-a-platform-rtc-device-for-intel-mid-platforms-fix
+++ a/arch/x86/include/asm/mrst.h
@@ -32,18 +32,18 @@ enum mrst_cpu_type {
 
 extern enum mrst_cpu_type __mrst_cpu_chip;
 
-#ifdef CONFIG_X86_INTEL_MID
+#ifdef CONFIG_X86_MRST
 
 static inline enum mrst_cpu_type mrst_identify_cpu(void)
 {
 	return __mrst_cpu_chip;
 }
 
-#else /* !CONFIG_X86_INTEL_MID */
+#else /* !CONFIG_X86_MRST */
 
 #define mrst_identify_cpu()    (0)
 
-#endif /* !CONFIG_X86_INTEL_MID */
+#endif /* !CONFIG_X86_MRST */
 
 enum mrst_timer_options {
 	MRST_TIMER_DEFAULT,
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
drm-fix-kconfig-unmet-dependency-warning.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
cross-memory-attach-update.patch
consolidate-config_debug_strict_user_copy_checks-fix.patch
dynamic_debug-fix-undefined-reference-to-__netdev_printk.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
init-add-root=partuuid=uuid-partnroff=%d-support.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

