From: akpm@linux-foundation.org
Subject: [merged] scsi-mpt3sas-fix-format-overflow-warning.patch
 removed from -mm tree
Date: Tue, 25 Jul 2017 10:40:28 -0700
Message-ID: <20170725174028.KBKT5komX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50526 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751534AbdGYRk3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2017 13:40:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: mpt3sas: fix format overflow warning
has been removed from the -mm tree.  Its filename was
     scsi-mpt3sas-fix-format-overflow-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: scsi: mpt3sas: fix format overflow warning

We print the driver name into one string and then add and ID
and copy it into a second string of the same length, at which
point gcc complains about a possible overflow:

drivers/scsi/mpt3sas/mpt3sas_scsih.c: In function '_scsih_probe':
drivers/scsi/mpt3sas/mpt3sas_scsih.c:8884:21: error: '_cm' directive writing 3 bytes into a region of size between 1 and 32 [-Werror=format-overflow=]
printf(ioc->name, "%s_cm%d", ioc->driver_name, ioc->id);
                  ^~~~~~~~~
drivers/scsi/mpt3sas/mpt3sas_scsih.c:8884:21: note: directive argument in the range [0, 255]
drivers/scsi/mpt3sas/mpt3sas_scsih.c:8884:2: note: 'sprintf' output between 5 and 38 bytes into a destination of size 32
  sprintf(ioc->name, "%s_cm%d", ioc->driver_name, ioc->id);
  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Making the first string shorter is sufficient to avoid the
warning here, as we know it can only contain either "mpt2sas"
or "mpt3sas".

Link: http://lkml.kernel.org/r/20170714120720.906842-4-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mpt3sas/mpt3sas_base.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/mpt3sas/mpt3sas_base.h~scsi-mpt3sas-fix-format-overflow-warning drivers/scsi/mpt3sas/mpt3sas_base.h
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h~scsi-mpt3sas-fix-format-overflow-warning
+++ a/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -970,7 +970,7 @@ struct MPT3SAS_ADAPTER {
 	u8		id;
 	int		cpu_count;
 	char		name[MPT_NAME_LENGTH];
-	char		driver_name[MPT_NAME_LENGTH];
+	char		driver_name[MPT_NAME_LENGTH - 8];
 	char		tmp_string[MPT_STRING_LENGTH];
 	struct pci_dev	*pdev;
 	Mpi2SystemInterfaceRegs_t __iomem *chip;
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-avoid-wmaybe-uninitialized-warning.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

