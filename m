From: akpm@linux-foundation.org
Subject: + fix-ide-ide-remove-ide-dma-check.patch added to -mm tree
Date: Thu, 16 Aug 2007 13:53:46 -0700
Message-ID: <200708162053.l7GKrkEV006209@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37311 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753312AbXHPUyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Aug 2007 16:54:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, bzolnier@gmail.com


The patch titled
     fix ide-ide-remove-ide-dma-check
has been added to the -mm tree.  Its filename is
     fix-ide-ide-remove-ide-dma-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix ide-ide-remove-ide-dma-check
From: Adrian Bunk <bunk@kernel.org>

static code mustn't be exported.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ide/ide-dma.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/ide/ide-dma.c~fix-ide-ide-remove-ide-dma-check drivers/ide/ide-dma.c
--- a/drivers/ide/ide-dma.c~fix-ide-ide-remove-ide-dma-check
+++ a/drivers/ide/ide-dma.c
@@ -778,8 +778,6 @@ static int ide_tune_dma(ide_drive_t *dri
 	return 1;
 }
 
-EXPORT_SYMBOL_GPL(ide_tune_dma);
-
 static int ide_dma_check(ide_drive_t *drive)
 {
 	int vdma = (drive->hwif->host_flags & IDE_HFLAG_VDMA)? 1 : 0;
_

Patches currently in -mm which might be from bunk@kernel.org are

alpm-enable-link-power-management-for-ata-drivers-make-drivers-ata-libata-scsicata_scsi_link_pm_policy-static.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
