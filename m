From: akpm@linux-foundation.org
Subject: [merged]
 scsi-gdth-increase-the-procfs-event-buffer-size.patch removed from -mm tree
Date: Tue, 25 Jul 2017 10:40:36 -0700
Message-ID: <20170725174036.1NT8mxaCy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50540 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751755AbdGYRkh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jul 2017 13:40:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: gdth: increase the procfs event buffer size
has been removed from the -mm tree.  Its filename was
     scsi-gdth-increase-the-procfs-event-buffer-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: scsi: gdth: increase the procfs event buffer size

We print a 256 byte event string into a buffer that is only 161
bytes long, this is clearly wrong:

drivers/scsi/gdth_proc.c: In function 'gdth_show_info':
drivers/scsi/gdth.c:3660:41: error: '%s' directive writing up to 255 bytes into a region of size between 141 and 150 [-Werror=format-overflow=]
             sprintf(buffer,"Adapter %d: %s\n",
                                         ^~
/git/arm-soc/drivers/scsi/gdth.c:3660:13: note: 'sprintf' output between 13 and 277 bytes into a destination of size 161
             sprintf(buffer,"Adapter %d: %s\n",
             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                 dvr->eu.async.ionode,dvr->event_string);
                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

gcc calculates that the worst case buffer size would be 277 bytes,
so we can use that.

Link: http://lkml.kernel.org/r/20170714120720.906842-8-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth_proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/gdth_proc.c~scsi-gdth-increase-the-procfs-event-buffer-size drivers/scsi/gdth_proc.c
--- a/drivers/scsi/gdth_proc.c~scsi-gdth-increase-the-procfs-event-buffer-size
+++ a/drivers/scsi/gdth_proc.c
@@ -147,7 +147,7 @@ int gdth_show_info(struct seq_file *m, s
 
     gdth_cmd_str *gdtcmd;
     gdth_evt_str *estr;
-    char hrec[161];
+    char hrec[277];
 
     char *buf;
     gdth_dskstat_str *pds;
_

Patches currently in -mm which might be from arnd@arndb.de are

kasan-avoid-wmaybe-uninitialized-warning.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

