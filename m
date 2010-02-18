From: akpm@linux-foundation.org
Subject: [merged] msi-laptop-depends-on-rfkill.patch removed from -mm tree
Date: Thu, 18 Feb 2010 12:45:48 -0800
Message-ID: <201002182045.o1IKjm12002760@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753619Ab0BRUtk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Feb 2010 15:49:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, greg@kroah.com, jlee@novell.com, mzxreary@0pointer.de, mm-commits@vger.kernel.org


The patch titled
     msi-laptop: depends on RFKILL
has been removed from the -mm tree.  Its filename was
     msi-laptop-depends-on-rfkill.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
timberdale-fix-mfd-build.patch
i2c-fix-xiic-build-error.patch
mfgpt-move-clocksource-menu.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
doc-console-doc-should-read-bind-unbind-instead-of-bind-bind.patch
documentation-timers-split-txt-and-source-files.patch
documentation-laptop-split-txt-and-source-files.patch
documentation-fs-split-txt-and-source-files.patch
documentation-vm-split-txt-and-source-files.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

