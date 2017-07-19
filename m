From: akpm@linux-foundation.org
Subject: + scsi-gdth-increase-the-procfs-event-buffer-size.patch added to
 -mm tree
Date: Wed, 19 Jul 2017 14:50:24 -0700
Message-ID: <596fd420.z8kOIID4OkhCnoIX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34122 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755084AbdGSVuZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Jul 2017 17:50:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: scsi: gdth: increase the procfs event buffer size
has been added to the -mm tree.  Its filename is
     scsi-gdth-increase-the-procfs-event-buffer-size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scsi-gdth-increase-the-procfs-event-buffer-size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scsi-gdth-increase-the-procfs-event-buffer-size.patch

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

