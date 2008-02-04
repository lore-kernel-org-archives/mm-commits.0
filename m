From: akpm@linux-foundation.org
Subject: - cpu-do-not-annotate-exported-register_cpu_notifier.patch removed from -mm tree
Date: Mon, 04 Feb 2008 14:41:38 -0800
Message-ID: <200802042241.m14Mfclf021564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39141 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754215AbYBDWmQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 17:42:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cpu: do not annotate exported register_cpu_notifier()
has been removed from the -mm tree.  Its filename was
     cpu-do-not-annotate-exported-register_cpu_notifier.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu: do not annotate exported register_cpu_notifier()
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: o-x86_64/kernel/built-in.o(__ksymtab+0xfb0): Section mismatch in reference from the variable __ksymtab_register_cpu_notifier to the function .cpuinit.text:register_cpu_notifier()

register_cpu_notifier() are used from modules that may be
loaded long after init has completed.
Drop the annotation so the function is kept after init.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cpu.c~cpu-do-not-annotate-exported-register_cpu_notifier kernel/cpu.c
--- a/kernel/cpu.c~cpu-do-not-annotate-exported-register_cpu_notifier
+++ a/kernel/cpu.c
@@ -136,7 +136,7 @@ static void cpu_hotplug_done(void)
 	mutex_unlock(&cpu_hotplug.lock);
 }
 /* Need to know about CPUs going up/down? */
-int __cpuinit register_cpu_notifier(struct notifier_block *nb)
+int register_cpu_notifier(struct notifier_block *nb)
 {
 	int ret;
 	cpu_maps_update_begin();
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
cpu-do-not-annotate-exported-register_cpu_notifier.patch
