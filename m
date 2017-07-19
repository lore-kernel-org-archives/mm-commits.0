From: akpm@linux-foundation.org
Subject: + scsi-gdth-avoid-buffer-overflow-warning.patch added to -mm tree
Date: Wed, 19 Jul 2017 14:50:20 -0700
Message-ID: <596fd41c.35DiZ45etyi79/YX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34114 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755074AbdGSVuV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 17:50:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: gdth: avoid buffer overflow warning
has been added to the -mm tree.  Its filename is
     scsi-gdth-avoid-buffer-overflow-warning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scsi-gdth-avoid-buffer-overflow-warning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scsi-gdth-avoid-buffer-overflow-warning.patch

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
Subject: scsi: gdth: avoid buffer overflow warning

gcc notices that we would overflow the buffer for the
inquiry of the product name if we have too many adapters:

drivers/scsi/gdth.c: In function 'gdth_next':
drivers/scsi/gdth.c:2357:29: warning: 'sprintf' may write a terminating nul past the end of the destination [-Wformat-overflow=]
         sprintf(inq.product,"Host Drive  #%02d",t);
                             ^~~~~~~~~~~~~~~~~~~
drivers/scsi/gdth.c:2357:9: note: 'sprintf' output between 16 and 17 bytes into a destination of size 16
         sprintf(inq.product,"Host Drive  #%02d",t);

This won't happen in practice, so just use snprintf to
truncate the string.

Link: http://lkml.kernel.org/r/20170714120720.906842-6-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/gdth.c~scsi-gdth-avoid-buffer-overflow-warning drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~scsi-gdth-avoid-buffer-overflow-warning
+++ a/drivers/scsi/gdth.c
@@ -2354,7 +2354,7 @@ static int gdth_internal_cache_cmd(gdth_
         inq.resp_aenc = 2;
         inq.add_length= 32;
         strcpy(inq.vendor,ha->oem_name);
-        sprintf(inq.product,"Host Drive  #%02d",t);
+        snprintf(inq.product, sizeof(inq.product), "Host Drive  #%02d",t);
         strcpy(inq.revision,"   ");
         gdth_copy_internal_data(ha, scp, (char*)&inq, sizeof(gdth_inq_data));
         break;
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

