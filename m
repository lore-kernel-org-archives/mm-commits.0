From: akpm@linux-foundation.org
Subject: - cpu-fix-section-mismatch-related-to-cpu_chain.patch removed from -mm tree
Date: Mon, 04 Feb 2008 14:41:16 -0800
Message-ID: <200802042241.m14MfG4M021558@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39858 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755469AbYBDWl6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 17:41:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cpu: fix section mismatch related to cpu_chain
has been removed from the -mm tree.  Its filename was
     cpu-fix-section-mismatch-related-to-cpu_chain.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu: fix section mismatch related to cpu_chain
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warnings:
WARNING: o-x86_64/kernel/built-in.o(.text+0x36de9): Section mismatch in reference from the function take_cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: o-x86_64/kernel/built-in.o(.text+0x36e86): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: o-x86_64/kernel/built-in.o(.text+0x36ea9): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: o-x86_64/kernel/built-in.o(.text+0x36f40): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: o-x86_64/kernel/built-in.o(.text+0x36f8f): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: o-x86_64/kernel/built-in.o(.text+0x370aa): Section mismatch in reference from the function unregister_cpu_notifier() to the variable .cpuinit.data:cpu_chain

cpu_chain is used by unregister_cpu_notifier() that is used
by the kvm module. So we can call the unregister_cpu_notifier() long
after init completed.
Drop the __cpuinitdata annotation to avoid freeing cpu_chain.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cpu.c~cpu-fix-section-mismatch-related-to-cpu_chain kernel/cpu.c
--- a/kernel/cpu.c~cpu-fix-section-mismatch-related-to-cpu_chain
+++ a/kernel/cpu.c
@@ -18,7 +18,7 @@
 /* Serializes the updates to cpu_online_map, cpu_present_map */
 static DEFINE_MUTEX(cpu_add_remove_lock);
 
-static __cpuinitdata RAW_NOTIFIER_HEAD(cpu_chain);
+static RAW_NOTIFIER_HEAD(cpu_chain);
 
 /* If set, cpu_up and cpu_down will return -EBUSY and do nothing.
  * Should always be manipulated under cpu_add_remove_lock
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
sdio-fix-module-device-table-definition-for-m68k.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
gpiolib-avr32-at32ap-platform-support.patch
mm-fix-section-mismatch-warning-in-sparsec.patch
m68k-use-cc-cross-prefix.patch
cris-avoid-using-arch-links-in-kconfig.patch
uml-remove-topdir.patch
git-kbuild.patch
hamradio-fix-dmascc-section-mismatch.patch
remove-support-for-un-needed-_extratext-section.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
kallsyms-should-prefer-non-weak-symbols.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
tpm-infineon-section-mismatch.patch
linux-kernel-markers-create-modpost-file.patch
avoid-overflows-in-kernel-timec.patch
cpu-fix-section-mismatch-warnings-for-enable_nonboot_cpus.patch
cpu-fix-section-mismatch-related-to-cpu_chain.patch
cpu-do-not-annotate-exported-register_cpu_notifier.patch
cpu-silence-section-mismatch-warnings-for-hotcpu-notifies.patch
