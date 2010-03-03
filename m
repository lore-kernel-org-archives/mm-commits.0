From: akpm@linux-foundation.org
Subject: [merged] scsi-raid_attrs-depends-on-scsi.patch removed from -mm tree
Date: Wed, 03 Mar 2010 12:04:53 -0800
Message-ID: <201003032004.o23K4rW6028529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756475Ab0CCUFH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Mar 2010 15:05:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, mm-commits@vger.kernel.org


The patch titled
     scsi: RAID_ATTRS depends on SCSI
has been removed from the -mm tree.  Its filename was
     scsi-raid_attrs-depends-on-scsi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: RAID_ATTRS depends on SCSI
From: Randy Dunlap <randy.dunlap@oracle.com>

raid_class uses scsi interfaces, so it should depend on SCSI.
Otherwise build errors occur when RAID_ATTRS=y and SCSI=m:

ERROR: "raid_class_release" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!
ERROR: "raid_class_attach" [drivers/scsi/mpt2sas/mpt2sas.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/Kconfig |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/Kconfig~scsi-raid_attrs-depends-on-scsi drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig~scsi-raid_attrs-depends-on-scsi
+++ a/drivers/scsi/Kconfig
@@ -1,12 +1,5 @@
 menu "SCSI device support"
 
-config RAID_ATTRS
-	tristate "RAID Transport Class"
-	default n
-	depends on BLOCK
-	---help---
-	  Provides RAID
-
 config SCSI
 	tristate "SCSI device support"
 	depends on BLOCK
@@ -34,6 +27,13 @@ config SCSI_DMA
 	bool
 	default n
 
+config RAID_ATTRS
+	tristate "RAID Transport Class"
+	default n
+	depends on BLOCK && SCSI
+	---help---
+	  Provides RAID
+
 config SCSI_TGT
 	tristate "SCSI target support"
 	depends on SCSI && EXPERIMENTAL
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
vmwgfx-depends-on-fb.patch
dib3000mc-reduce-large-stack-usage.patch
dib7000p-reduce-large-stack-usage.patch
i2c-fix-xiic-build-error.patch
mfgpt-move-clocksource-menu.patch
elf-coredump-replace-elf_core_extra_-macros-by-functions-fix.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
documentation-timers-split-txt-and-source-files.patch
documentation-laptop-split-txt-and-source-files.patch
documentation-fs-split-txt-and-source-files.patch
documentation-vm-split-txt-and-source-files.patch
doc-submitchecklist-add-rule-1.patch
cgroups-subsystem-module-unloading-fix.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

