From: akpm@linux-foundation.org
Subject: [merged] cciss-auto-engage-scsi-mid-layer-at-driver-load-time.patch removed from -mm tree
Date: Thu, 17 Nov 2011 12:21:37 -0800
Message-ID: <201111172021.pAHKLbeH005000@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:38099 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab1KQUVj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Nov 2011 15:21:39 -0500
Received: by vbbff1 with SMTP id ff1so2899vbb.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Nov 2011 12:21:39 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: scameron@beardog.cce.hp.com, axboe@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     Subject: cciss: auto engage SCSI mid layer at driver load time
has been removed from the -mm tree.  Its filename was
     cciss-auto-engage-scsi-mid-layer-at-driver-load-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Subject: cciss: auto engage SCSI mid layer at driver load time

A long time ago, probably in 2002, one of the distros, or maybe more than
one, loaded block drivers prior to loading the SCSI mid layer.  This meant
that the cciss driver, being a block driver, could not engage the SCSI mid
layer at init time without panicking, and relied on being poked by a
userland program after the system was up (and the SCSI mid layer was
therefore present) to engage the SCSI mid layer.

This is no longer the case, and cciss can safely rely on the SCSI mid
layer being present at init time and engage the SCSI mid layer straight
away.  This means that users will see their tape drives and medium
changers at driver load time without need for a script in /etc/rc.d that
does this:

for x in /proc/driver/cciss/cciss*
do
	echo "engage scsi" > $x
done

However, if no tape drives or medium changers are detected, the SCSI mid
layer will not be engaged.  If a tape drive or medium change is later
hot-added to the system it will then be necessary to use the above script
or similar for the device(s) to be acceesible.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/blockdev/cciss.txt |   14 ++++++--------
 drivers/block/cciss.c            |    1 +
 drivers/block/cciss_scsi.c       |    1 +
 3 files changed, 8 insertions(+), 8 deletions(-)

diff -puN Documentation/blockdev/cciss.txt~cciss-auto-engage-scsi-mid-layer-at-driver-load-time Documentation/blockdev/cciss.txt
--- a/Documentation/blockdev/cciss.txt~cciss-auto-engage-scsi-mid-layer-at-driver-load-time
+++ a/Documentation/blockdev/cciss.txt
@@ -98,14 +98,12 @@ You must enable "SCSI tape drive support
 "SCSI support" in your kernel configuration to be able to use SCSI
 tape drives with your Smart Array 5xxx controller.
 
-Additionally, note that the driver will not engage the SCSI core at init 
-time.  The driver must be directed to dynamically engage the SCSI core via 
-the /proc filesystem entry which the "block" side of the driver creates as 
-/proc/driver/cciss/cciss* at runtime.  This is because at driver init time, 
-the SCSI core may not yet be initialized (because the driver is a block 
-driver) and attempting to register it with the SCSI core in such a case 
-would cause a hang.  This is best done via an initialization script 
-(typically in /etc/init.d, but could vary depending on distribution). 
+Additionally, note that the driver will engage the SCSI core at init
+time if any tape drives or medium changers are detected.  The driver may
+also be directed to dynamically engage the SCSI core via the /proc filesystem
+entry which the "block" side of the driver creates as
+/proc/driver/cciss/cciss* at runtime.  This is best done via a script.
+
 For example:
 
 	for x in /proc/driver/cciss/cciss[0-9]*
diff -puN drivers/block/cciss.c~cciss-auto-engage-scsi-mid-layer-at-driver-load-time drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-auto-engage-scsi-mid-layer-at-driver-load-time
+++ a/drivers/block/cciss.c
@@ -5158,6 +5158,7 @@ reinit_after_soft_reset:
 	h->cciss_max_sectors = 8192;
 
 	rebuild_lun_table(h, 1, 0);
+	cciss_engage_scsi(h);
 	h->busy_initializing = 0;
 	return 1;
 
diff -puN drivers/block/cciss_scsi.c~cciss-auto-engage-scsi-mid-layer-at-driver-load-time drivers/block/cciss_scsi.c
--- a/drivers/block/cciss_scsi.c~cciss-auto-engage-scsi-mid-layer-at-driver-load-time
+++ a/drivers/block/cciss_scsi.c
@@ -1720,5 +1720,6 @@ static int  cciss_eh_abort_handler(struc
 /* If no tape support, then these become defined out of existence */
 
 #define cciss_scsi_setup(cntl_num)
+#define cciss_engage_scsi(h)
 
 #endif /* CONFIG_CISS_SCSI_TAPE */
_

Patches currently in -mm which might be from scameron@beardog.cce.hp.com are

linux-next.patch

