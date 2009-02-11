From: akpm@linux-foundation.org
Subject: + x86-dell-laptop-depends-on-power_supply.patch added to -mm tree
Date: Wed, 11 Feb 2009 14:16:33 -0800
Message-ID: <200902112216.n1BMGXJQ003132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887AbZBKWRQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Feb 2009 17:17:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, hpa@zytor.com, mingo@elte.hu, mjg59@srcf.ucam.org, tglx@linutronix.de


The patch titled
     x86: dell-laptop: depends on POWER_SUPPLY
has been added to the -mm tree.  Its filename is
     x86-dell-laptop-depends-on-power_supply.patch

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
Subject: x86: dell-laptop: depends on POWER_SUPPLY
From: Randy Dunlap <randy.dunlap@oracle.com>

Build breaks when DELL_LAPTOP=y and POWER_SUPPLY=m.  DELL_LAPTOP needs to
depend on POWER_SUPPLY.

dell-laptop.c:(.text+0x1ef3c4): undefined reference to `power_supply_is_system_supplied'
dell-laptop.c:(.text+0x1ef45e): undefined reference to `power_supply_is_system_supplied'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/platform/x86/Kconfig~x86-dell-laptop-depends-on-power_supply drivers/platform/x86/Kconfig
--- a/drivers/platform/x86/Kconfig~x86-dell-laptop-depends-on-power_supply
+++ a/drivers/platform/x86/Kconfig
@@ -62,6 +62,7 @@ config DELL_LAPTOP
 	depends on EXPERIMENTAL
 	depends on BACKLIGHT_CLASS_DEVICE
 	depends on RFKILL
+	depends on POWER_SUPPLY
 	default n
 	---help---
 	This driver adds support for rfkill and backlight control to Dell
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

kernel-doc-preferred-ending-marker-and-examples.patch
kernel-doc-fix-syscall-wrapper-processing.patch
linux-next.patch
uv-fix-header-struct-usage.patch
kgdb-fix-kernel-doc-error.patch
auditsc-fix-kernel-doc-notation.patch
input-ad7879-touchscreen-driver.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pci-fix-romc-kernel-doc-warning.patch
esp-fix-section-mismatch-warning.patch
cciss-pci-power-management-reset-for-kexec.patch
rtl8187se-depends-on-wireless_ext.patch
vfs-update-fsh-to-use-inline-functions-when-no-file-locking-set.patch
vfs-further-changes-from-macro-to-inline-function-in-fsh.patch
max3100-spi-uart-driver.patch
filesystem-freeze-allow-sysrq-emergency-thaw-to-thaw-frozen-filesystems.patch
atyfb-fix-header-file-trailing-whitespace.patch
cirrusfb-convert-printks-to-dev_foo-fix-fix2.patch
documentation-ignore-byproducts-from-latex.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
x86-dell-laptop-depends-on-power_supply.patch

