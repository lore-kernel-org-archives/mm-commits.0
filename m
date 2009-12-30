From: akpm@linux-foundation.org
Subject: + xen-add-kconfig-menu.patch added to -mm tree
Date: Wed, 30 Dec 2009 13:58:58 -0800
Message-ID: <200912302158.nBULwwFk004685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbZL3V7E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Dec 2009 16:59:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jeremy@xensource.com


The patch titled
     xen: add kconfig menu
has been added to the -mm tree.  Its filename is
     xen-add-kconfig-menu.patch

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
Subject: xen: add kconfig menu
From: Randy Dunlap <randy.dunlap@oracle.com>

Currently the xen support drivers are displayed in the main Device Drivers
menu of the config tools instead of in their own sub-menu, so move them to
their own sub-menu, like the rest of the driver world uses.

This keeps the main Device Drivers menu from becoming messy.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/xen/Kconfig |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/xen/Kconfig~xen-add-kconfig-menu drivers/xen/Kconfig
--- a/drivers/xen/Kconfig~xen-add-kconfig-menu
+++ a/drivers/xen/Kconfig
@@ -1,6 +1,8 @@
+menu "Xen driver support"
+	depends on XEN
+
 config XEN_BALLOON
 	bool "Xen memory balloon driver"
-	depends on XEN
 	default y
 	help
 	  The balloon driver allows the Xen domain to request more memory from
@@ -20,7 +22,6 @@ config XEN_SCRUB_PAGES
 
 config XEN_DEV_EVTCHN
 	tristate "Xen /dev/xen/evtchn device"
-	depends on XEN
 	default y
 	help
 	  The evtchn driver allows a userspace process to triger event
@@ -30,7 +31,6 @@ config XEN_DEV_EVTCHN
 
 config XENFS
 	tristate "Xen filesystem"
-	depends on XEN
 	default y
 	help
 	  The xen filesystem provides a way for domains to share
@@ -53,11 +53,13 @@ config XEN_COMPAT_XENFS
 
 config XEN_SYS_HYPERVISOR
        bool "Create xen entries under /sys/hypervisor"
-       depends on XEN && SYSFS
+       depends on SYSFS
        select SYS_HYPERVISOR
        default y
        help
          Create entries under /sys/hypervisor describing the Xen
 	 hypervisor environment.  When running native or in another
 	 virtual environment, /sys/hypervisor will still be present,
-	 but will have no xen contents.
\ No newline at end of file
+	 but will have no xen contents.
+
+endmenu
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

docs-large-update-to-ioctl-numbertxt.patch
linux-next.patch
documentation-update-ring-buffer-designtxt.patch
mfgpt-move-clocksource-menu.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

