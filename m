From: akpm@linux-foundation.org
Subject: + cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch added to -mm tree
Date: Mon, 09 Mar 2009 16:39:05 -0700
Message-ID: <200903092339.n29Nd5H5020805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752046AbZCIXkP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Mar 2009 19:40:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, david-b@pacbell.net, dilinger@debian.org, jordan@cosmicpenguin.net, katzj@redhat.com, tiwai@suse.de


The patch titled
     gpio: fix cs553x printk format
has been added to the -mm tree.  Its filename is
     cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpio: fix cs553x printk format
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warning:

drivers/gpio/cs553x-gpio.c:193: warning: format '%x' expects type 'unsigned int', but argument 5 has type 'resource_size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andres Salomon <dilinger@debian.org>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Jeremy Katz <katzj@redhat.com>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/cs553x-gpio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/gpio/cs553x-gpio.c~cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix drivers/gpio/cs553x-gpio.c
--- a/drivers/gpio/cs553x-gpio.c~cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix
+++ a/drivers/gpio/cs553x-gpio.c
@@ -190,8 +190,8 @@ static int __init cs553x_gpio_probe(stru
 	cs553x_gpio_chip.pdev = pdev;
 	spin_lock_init(&cs553x_gpio_chip.lock);
 
-	dev_info(&pdev->dev, "allocated PCI BAR #%d: base 0x%x\n", GPIO_BAR,
-			cs553x_gpio_chip.base);
+	dev_info(&pdev->dev, "allocated PCI BAR #%d: base 0x%llx\n", GPIO_BAR,
+			(unsigned long long)cs553x_gpio_chip.base);
 
 	/* finally, register with the generic GPIO API */
 	err = gpiochip_add(&cs553x_gpio_chip.chip);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
menu-fix-embedded-menu-snafu.patch
linux-next.patch
git-acpi-vs-git-cpufreq.patch
x86-oqo-depends-on-input_polldev.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
dvb-frontends-fix-duplicate-debug-symbol.patch
input-ad7879-touchscreen-driver.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
qla2x-fix-printk-format-warnings.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
alpha-convert-u64-to-unsigned-long-long.patch
alpha-convert-u64-to-unsigned-long-long-fix.patch
alpha-convert-u64-to-unsigned-long-long-fix-2.patch
alpha-convert-u64-to-unsigned-long-long-fix-3.patch
alpha-convert-u64-to-unsigned-long-long-fix-3-checkpatch-fixes.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems-99.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
fbdev-update-s1d13xxxfb-to-differ-between-revisions-and-production-ids-fix.patch
asiliantfb-fix-cmap-memory-leaks-fix.patch
documentation-ignore-byproducts-from-latex.patch
cpusets-replace-zone-allowed-functions-with-node-allowed.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
reiser4-export-remove_from_page_cache-fix.patch

