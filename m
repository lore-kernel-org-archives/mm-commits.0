From: akpm@linux-foundation.org
Subject: + cpu-silence-section-mismatch-warnings-for-hotcpu-notifies.patch added to -mm tree
Date: Thu, 31 Jan 2008 14:45:39 -0800
Message-ID: <200801312245.m0VMje3p015200@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36411 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763911AbYAaWps (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 17:45:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, ego@in.ibm.com


The patch titled
     cpu: silence section mismatch warnings for hotcpu notifies
has been added to the -mm tree.  Its filename is
     cpu-silence-section-mismatch-warnings-for-hotcpu-notifies.patch

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
Subject: cpu: silence section mismatch warnings for hotcpu notifies
From: Sam Ravnborg <sam@ravnborg.org>

The hotcpu_notifier is used to create notifiers to be called later.
It really looks like the functions that are registered are only
relevant in a HOTPLUG_CPU configuration and the correct fix was
to wrap them in an #ifdef / #endif or similar.
But for now just tell modpost to silence the warning by annotating
the static variable with __refdata.

This silences the following warnings in kernel/:
WARNING: o-x86_64/kernel/built-in.o(.data+0x960): Section mismatch in reference from the variable profile_cpu_callback_nb.17240 to the function .devinit.text:profile_cpu_callback()
WARNING: o-x86_64/kernel/built-in.o(.data+0x3fa0): Section mismatch in reference from the variable workqueue_cpu_callback_nb.14663 to the function .devinit.text:workqueue_cpu_callback()
WARNING: o-x86_64/kernel/built-in.o(.data+0xe280): Section mismatch in reference from the variable relay_hotcpu_callback_nb.19247 to the function .cpuinit.text:relay_hotcpu_callback()

Additional warnings are silenced with this change but
they are left put.

This patch is just a workaround for the bad practice
to use __cpuinit to annotate code solely used for
HOTPLUG_CPU.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/cpu.h~cpu-silence-section-mismatch-warnings-for-hotcpu-notifies include/linux/cpu.h
--- a/include/linux/cpu.h~cpu-silence-section-mismatch-warnings-for-hotcpu-notifies
+++ a/include/linux/cpu.h
@@ -109,7 +109,7 @@ static inline void cpuhotplug_mutex_unlo
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
-	static struct notifier_block fn##_nb =			\
+	static struct notifier_block fn##_nb __refdata =	\
 		{ .notifier_call = fn, .priority = pri };	\
 	register_cpu_notifier(&fn##_nb);			\
 }
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
