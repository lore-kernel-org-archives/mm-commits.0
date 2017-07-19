From: akpm@linux-foundation.org
Subject: + scsi-fnic-fix-format-string-overflow-warning.patch added to -mm tree
Date: Wed, 19 Jul 2017 14:50:22 -0700
Message-ID: <596fd41e.9fJdzxxgs9WCTiKd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34118 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755076AbdGSVuX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 17:50:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: fnic: fix format string overflow warning
has been added to the -mm tree.  Its filename is
     scsi-fnic-fix-format-string-overflow-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scsi-fnic-fix-format-string-overflow-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scsi-fnic-fix-format-string-overflow-warning.patch

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

