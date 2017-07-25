From: akpm@linux-foundation.org
Subject: [merged]
 scsi-fnic-fix-format-string-overflow-warning.patch removed from -mm tree
Date: Tue, 25 Jul 2017 10:40:34 -0700
Message-ID: <20170725174034.yhbxKEQG4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50536 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751753AbdGYRkf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2017 13:40:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: fnic: fix format string overflow warning
has been removed from the -mm tree.  Its filename was
     scsi-fnic-fix-format-string-overflow-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: scsi: fnic: fix format string overflow warning

The MSI interrupt name can require 11 bytes in addition to the device name,
for a total of 23 bytes:

drivers/scsi/fnic/fnic_isr.c: In function 'fnic_request_intr':
drivers/scsi/fnic/fnic_isr.c:192:4: error: '-fcs-rq' directive writing 7 bytes into a region of size between 5 and 16 [-Werror=format-overflow=]
    "%.11s-fcs-rq", fnic->name);
drivers/scsi/fnic/fnic_isr.c:206:3: note: 'sprintf' output between 12 and 23 bytes into a destination of size 16
   sprintf(fnic->msix[FNIC_MSIX_ERR_NOTIFY].devname,
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    "%.11s-err-notify", fnic->name);

This extends the buffer to fit any possible value.

Link: http://lkml.kernel.org/r/20170714120720.906842-7-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/fnic/fnic.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/fnic/fnic.h~scsi-fnic-fix-format-string-overflow-warning drivers/scsi/fnic/fnic.h
--- a/drivers/scsi/fnic/fnic.h~scsi-fnic-fix-format-string-overflow-warning
+++ a/drivers/scsi/fnic/fnic.h
@@ -180,7 +180,7 @@ enum fnic_msix_intr_index {
 
 struct fnic_msix_entry {
 	int requested;
-	char devname[IFNAMSIZ];
+	char devname[IFNAMSIZ + 11];
 	irqreturn_t (*isr)(int, void *);
 	void *devid;
 };
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-avoid-wmaybe-uninitialized-warning.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

