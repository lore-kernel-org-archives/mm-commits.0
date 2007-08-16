From: akpm@linux-foundation.org
Subject: + drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch added to -mm tree
Date: Thu, 16 Aug 2007 13:52:40 -0700
Message-ID: <200708162052.l7GKqeA0006191@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43970 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751012AbXHPUxN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 16:53:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, dwmw2@infradead.org


The patch titled
     drivers/mtd/mtdbdi.c is no longer an own module
has been added to the -mm tree.  Its filename is
     drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/mtd/mtdbdi.c is no longer an own module
From: Adrian Bunk <bunk@kernel.org>

mtdbdi.c is now in the same module as mtdcore.c

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdbdi.c |    4 ----
 1 files changed, 4 deletions(-)

diff -puN drivers/mtd/mtdbdi.c~drivers-mtd-mtdbdic-is-no-longer-an-own-module drivers/mtd/mtdbdi.c
--- a/drivers/mtd/mtdbdi.c~drivers-mtd-mtdbdic-is-no-longer-an-own-module
+++ a/drivers/mtd/mtdbdi.c
@@ -22,7 +22,6 @@
 struct backing_dev_info mtd_bdi_unmappable = {
 	.capabilities	= BDI_CAP_MAP_COPY,
 };
-EXPORT_SYMBOL_GPL(mtd_bdi_unmappable);
 
 /*
  * backing device capabilities for R/O mappable devices (such as ROM)
@@ -33,7 +32,6 @@ struct backing_dev_info mtd_bdi_ro_mappa
 	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
 			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP),
 };
-EXPORT_SYMBOL_GPL(mtd_bdi_ro_mappable);
 
 /*
  * backing device capabilities for writable mappable devices (such as RAM)
@@ -45,6 +43,4 @@ struct backing_dev_info mtd_bdi_rw_mappa
 			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP |
 			   BDI_CAP_WRITE_MAP),
 };
-EXPORT_SYMBOL_GPL(mtd_bdi_rw_mappable);
 
-MODULE_LICENSE("GPL v2");
_

Patches currently in -mm which might be from bunk@kernel.org are

alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
