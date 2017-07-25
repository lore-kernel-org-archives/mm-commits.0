From: akpm@linux-foundation.org
Subject: [merged] scsi-gdth-avoid-buffer-overflow-warning.patch
 removed from -mm tree
Date: Tue, 25 Jul 2017 10:40:32 -0700
Message-ID: <20170725174032.EOtBe_jwl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50532 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751658AbdGYRkd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2017 13:40:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: gdth: avoid buffer overflow warning
has been removed from the -mm tree.  Its filename was
     scsi-gdth-avoid-buffer-overflow-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

kasan-avoid-wmaybe-uninitialized-warning.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

