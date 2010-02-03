From: akpm@linux-foundation.org
Subject: + msi-laptop-depends-on-rfkill.patch added to -mm tree
Date: Wed, 03 Feb 2010 14:24:28 -0800
Message-ID: <201002032224.o13MOSGP022771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752523Ab0BCWYl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 17:24:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com, jlee@novell.com, mzxreary@0pointer.de


The patch titled
     msi-laptop: depends on RFKILL
has been added to the -mm tree.  Its filename is
     msi-laptop-depends-on-rfkill.patch

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
Subject: msi-laptop: depends on RFKILL
From: Randy Dunlap <randy.dunlap@oracle.com>

msi-laptop uses rfkill*() interfaces so it should depend on RFKILL.

msi-laptop.c:(.text+0x1fcd1b): undefined reference to `rfkill_alloc'
msi-laptop.c:(.text+0x1fcd76): undefined reference to `rfkill_register'
msi-laptop.c:(.text+0x1fcdc8): undefined reference to `rfkill_destroy'
msi-laptop.c:(.text+0x1fcdd9): undefined reference to `rfkill_unregister'

This repairs "msi-laptop: Detect 3G device exists by standard ec command",
which is in some gregkh tree.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Lennart Poettering <mzxreary@0pointer.de>
Cc: Lee, Chun-Yi <jlee@novell.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/platform/x86/Kconfig~msi-laptop-depends-on-rfkill drivers/platform/x86/Kconfig
--- a/drivers/platform/x86/Kconfig~msi-laptop-depends-on-rfkill
+++ a/drivers/platform/x86/Kconfig
@@ -147,6 +147,7 @@ config MSI_LAPTOP
 	tristate "MSI Laptop Extras"
 	depends on ACPI
 	depends on BACKLIGHT_CLASS_DEVICE
+	depends on RFKILL
 	---help---
 	  This is a driver for laptops built by MSI (MICRO-STAR
 	  INTERNATIONAL):
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
msi-laptop-depends-on-rfkill.patch
ati_pcigart-fix-printk-format-warning.patch
radio-add-the-saa7706h-car-radio-dsp-to-v4l2-chip-identh.patch
mfgpt-move-clocksource-menu.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

