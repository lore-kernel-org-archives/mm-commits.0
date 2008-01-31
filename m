From: akpm@linux-foundation.org
Subject: + cpu-fix-section-mismatch-warnings-for-enable_nonboot_cpus.patch added to -mm tree
Date: Thu, 31 Jan 2008 14:45:33 -0800
Message-ID: <200801312245.m0VMjXGw015191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51055 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762366AbYAaWpr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 17:45:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, ego@in.ibm.com


The patch titled
     cpu: fix section mismatch warnings for enable_nonboot_cpus
has been added to the -mm tree.  Its filename is
     cpu-fix-section-mismatch-warnings-for-enable_nonboot_cpus.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu: fix section mismatch warnings for enable_nonboot_cpus
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: o-x86_64/kernel/built-in.o(.text+0x36d8b): Section mismatch in reference from the function enable_nonboot_cpus() to the function .cpuinit.text:_cpu_up()

enable_nonboot_cpus() are used solely from CONFIG_CONFIG_PM_SLEEP_SMP=y
and PM_SLEEP_SMP imply HOTPLUG_CPU therefore the reference
to _cpu_up() is valid.
Annotate enable_nonboot_cpus() with __ref to silence modpost.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cpu.c~cpu-fix-section-mismatch-warnings-for-enable_nonboot_cpus kernel/cpu.c
--- a/kernel/cpu.c~cpu-fix-section-mismatch-warnings-for-enable_nonboot_cpus
+++ a/kernel/cpu.c
@@ -389,7 +389,7 @@ int disable_nonboot_cpus(void)
 	return error;
 }
 
-void enable_nonboot_cpus(void)
+void __ref enable_nonboot_cpus(void)
 {
 	int cpu, error;
 
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
sdio-fix-module-device-table-definition-for-m68k.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-net.patch
hamradio-fix-dmascc-section-mismatch.patch
git-x86.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
gpiolib-avr32-at32ap-platform-support.patch
m68k-use-cc-cross-prefix.patch
cris-avoid-using-arch-links-in-kconfig.patch
uml-remove-topdir.patch
remove-support-for-un-needed-_extratext-section.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
kallsyms-should-prefer-non-weak-symbols.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
tpm-infineon-section-mismatch.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
linux-kernel-markers-create-modpost-file.patch
linux-typesh-always-export-64bit-aligned-defines.patch
avoid-overflows-in-kernel-timec.patch
remove-__init_refok-and-__initdata_refok.patch
pci-fix-section-mismatch-warnings-referring-to-pci_do_scan_bus.patch
pci-fix-4x-section-mismatch-warnings.patch
cpu-fix-section-mismatch-warnings-for-enable_nonboot_cpus.patch
cpu-fix-section-mismatch-related-to-cpu_chain.patch
cpu-do-not-annotate-exported-register_cpu_notifier.patch
cpu-silence-section-mismatch-warnings-for-hotcpu-notifies.patch
mm-fix-section-mismatch-warning-in-sparsec.patch
