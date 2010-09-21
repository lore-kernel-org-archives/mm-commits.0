From: akpm@linux-foundation.org
Subject: + config_fw_loader-fix-kconfig-dependency-warning-on-hotplug.patch added to -mm tree
Date: Tue, 21 Sep 2010 15:53:56 -0700
Message-ID: <201009212253.o8LMru3C007592@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767Ab0IUWy2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Sep 2010 18:54:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com


The patch titled
     CONFIG_FW_LOADER: fix kconfig dependency warning on HOTPLUG
has been added to the -mm tree.  Its filename is
     config_fw_loader-fix-kconfig-dependency-warning-on-hotplug.patch

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
Subject: CONFIG_FW_LOADER: fix kconfig dependency warning on HOTPLUG
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig dependency warning for FW_LOADER.

Lots of drivers select FW_LOADER without bothering to depend on HOTPLUG
and/or without selecting HOTPLUG.  A kernel builds fine when FW_LOADER is
enabled, whether HOTPLUG is enabled or not, and a kernel config file (make
oldconfig) is not changed by this patch.  (Yes,
drivers/base/firmware_class.c uses interfaces from linux/kobject.h, which
does have some CONFIG_HOTPLUG dependencies, but this patch does not change
that.)

warning: (MICROCODE || MICROCODE_INTEL && MICROCODE || MICROCODE_AMD && MICROCODE || PCMCIA_LOAD_CIS && PCCARD && PCMCIA && EXPERIMENTAL || USB_IRDA && NET && IRDA && USB || BT_HCIBCM203X && NET && BT && USB || BT_HCIBFUSB && NET && BT && USB || BT_HCIBT3C && NET && BT && PCMCIA || BT_MRVL_SDIO && NET
...
!STAGING_EXCLUDE_BUILD && USB && (X86 || ARM) && WLAN || DRM_NOUVEAU && STAGING && !STAGING_EXCLUDE_BUILD && DRM && PCI || TI_ST && STAGING && !STAGING_EXCLUDE_BUILD && RFKILL || DELL_RBU && X86) selects FW_LOADER which has unmet direct dependencies (HOTPLUG)
(5200 byte line reduced a lot)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/Kconfig |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/base/Kconfig~config_fw_loader-fix-kconfig-dependency-warning-on-hotplug drivers/base/Kconfig
--- a/drivers/base/Kconfig~config_fw_loader-fix-kconfig-dependency-warning-on-hotplug
+++ a/drivers/base/Kconfig
@@ -71,7 +71,6 @@ config PREVENT_FIRMWARE_BUILD
 
 config FW_LOADER
 	tristate "Userspace firmware loading support" if EMBEDDED
-	depends on HOTPLUG
 	default y
 	---help---
 	  This option is provided for the case where no in-kernel-tree modules
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
scripts-get_maintainerpl-add-git-blame-rolestats-authored-lines-information.patch
config_fw_loader-fix-kconfig-dependency-warning-on-hotplug.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

