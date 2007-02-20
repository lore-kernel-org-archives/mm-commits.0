From: akpm@linux-foundation.org
Subject: - sis-warning-fixes.patch removed from -mm tree
Date: Tue, 20 Feb 2007 12:09:15 -0800
Message-ID: <200702202009.l1KK9FkK018209@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46876 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965261AbXBTUJi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 20 Feb 2007 15:09:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     SiS warning fixes
has been removed from the -mm tree.  Its filename was
     sis-warning-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SiS warning fixes
From: Alan <alan@lxorguk.ukuu.org.uk>

Somehow the sis_info133 external definition ended up in libata.h and that
was included by both drivers.  However libata.h contains libata-* specific
internals and clashing defines like DRV_NAME so this makes a mess.  Move
the extern into the C file and remove the warnings

[akpm@linux-foundation.org: create sis.h to avoid extern-decl-in-C]
Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/libata.h   |    2 --
 drivers/ata/pata_sis.c |    3 +--
 drivers/ata/sata_sis.c |    3 +--
 drivers/ata/sis.h      |    5 +++++
 4 files changed, 7 insertions(+), 6 deletions(-)

diff -puN drivers/ata/libata.h~sis-warning-fixes drivers/ata/libata.h
--- a/drivers/ata/libata.h~sis-warning-fixes
+++ a/drivers/ata/libata.h
@@ -150,7 +150,5 @@ extern void ata_qc_schedule_eh(struct at
 /* libata-sff.c */
 extern u8 ata_irq_on(struct ata_port *ap);
 
-/* pata_sis.c */
-extern struct ata_port_info sis_info133;
 
 #endif /* __LIBATA_H__ */
diff -puN drivers/ata/pata_sis.c~sis-warning-fixes drivers/ata/pata_sis.c
--- a/drivers/ata/pata_sis.c~sis-warning-fixes
+++ a/drivers/ata/pata_sis.c
@@ -32,9 +32,8 @@
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
 #include <linux/ata.h>
-#include "libata.h"
+#include "sis.h"
 
-#undef DRV_NAME		/* already defined in libata.h, for libata-core */
 #define DRV_NAME	"pata_sis"
 #define DRV_VERSION	"0.4.5"
 
diff -puN drivers/ata/sata_sis.c~sis-warning-fixes drivers/ata/sata_sis.c
--- a/drivers/ata/sata_sis.c~sis-warning-fixes
+++ a/drivers/ata/sata_sis.c
@@ -40,9 +40,8 @@
 #include <linux/device.h>
 #include <scsi/scsi_host.h>
 #include <linux/libata.h>
-#include "libata.h"
+#include "sis.h"
 
-#undef DRV_NAME		/* already defined in libata.h, for libata-core */
 #define DRV_NAME	"sata_sis"
 #define DRV_VERSION	"0.7"
 
diff -puN /dev/null drivers/ata/sis.h
--- /dev/null
+++ a/drivers/ata/sis.h
@@ -0,0 +1,5 @@
+
+struct ata_port_info;
+
+/* pata_sis.c */
+extern struct ata_port_info sis_info133;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
git-libata-all.patch
libata-fix-hopefully-all-the-remaining-problems-with.patch
adjust-legacy-ide-resource-setting-v2.patch
resend-iphase-64bit-cleanup.patch
drivers-scsi-ncr5380c-replacing-yield-with-a.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
x86_64-do-not-enable-the-nmi-watchdog-by-default.patch
driver_bfin_serial_core.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
edac-k8-driver-coding-tidy.patch
