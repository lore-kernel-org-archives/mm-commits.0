From: akpm@linux-foundation.org
Subject: [merged] xen-add-kconfig-menu.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:10:13 -0800
Message-ID: <201003091910.o29JAD8e031584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58463 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755945Ab0CITWI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, jeremy@xensource.com, mm-commits@vger.kernel.org


The patch titled
     xen: add kconfig menu
has been removed from the -mm tree.  Its filename was
     xen-add-kconfig-menu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
xfs-needs-list_sort.patch
vmwgfx-depends-on-fb.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
documentation-timers-split-txt-and-source-files.patch
documentation-laptop-split-txt-and-source-files.patch
documentation-fs-split-txt-and-source-files.patch
documentation-vm-split-txt-and-source-files.patch
doc-submitchecklist-add-rule-1.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
dma-mappingh-add-the-dma_unmap-state-api-fix-2.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

