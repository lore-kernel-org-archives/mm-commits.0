From: akpm@linux-foundation.org
Subject: + scsi-mpt3sas-fix-format-overflow-warning.patch added to -mm
 tree
Date: Wed, 19 Jul 2017 14:50:16 -0700
Message-ID: <596fd418.KiIHsEt00/JcAm6z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34106 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755067AbdGSVuR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 17:50:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: mpt3sas: fix format overflow warning
has been added to the -mm tree.  Its filename is
     scsi-mpt3sas-fix-format-overflow-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scsi-mpt3sas-fix-format-overflow-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scsi-mpt3sas-fix-format-overflow-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kbuild-disable-wformat-truncation-warnings-by-default.patch
scsi-megaraid-fix-format-overflow-warning.patch
scsi-mpt3sas-fix-format-overflow-warning.patch
scsi-fusion-fix-string-overflow-warning.patch
scsi-gdth-avoid-buffer-overflow-warning.patch
scsi-fnic-fix-format-string-overflow-warning.patch
scsi-gdth-increase-the-procfs-event-buffer-size.patch
usbvision-i2c-fix-format-overflow-warning.patch
hwmon-applesmc-fix-format-string-overflow.patch
x86-intel-mid-fix-a-format-string-overflow-warning.patch
platform-x86-alienware-wmi-fix-format-string-overflow-warning.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

