From: akpm@osdl.org
Subject: - drivers-cdrom-trivial-vsnprintf-conversion.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:03:49 -0800
Message-ID: <200612072303.kB7N3nC9029994@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:51956 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163663AbWLGXDx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:03:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, axboe@suse.de, mm-commits@vger.kernel.org


The patch titled
     drivers/cdrom/*: trivial vsnprintf() conversion
has been removed from the -mm tree.  Its filename was
     drivers-cdrom-trivial-vsnprintf-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/cdrom/*: trivial vsnprintf() conversion
From: Alexey Dobriyan <adobriyan@gmail.com>

Fixing sbpcd.c baroque error printing in process.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Jens Axboe <axboe@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/cdrom/optcd.c |    2 +-
 drivers/cdrom/sbpcd.c |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/cdrom/optcd.c~drivers-cdrom-trivial-vsnprintf-conversion drivers/cdrom/optcd.c
--- a/drivers/cdrom/optcd.c~drivers-cdrom-trivial-vsnprintf-conversion
+++ a/drivers/cdrom/optcd.c
@@ -101,7 +101,7 @@ static void debug(int debug_this, const 
 		return;
 
 	va_start(args, fmt);
-	vsprintf(s, fmt, args);
+	vsnprintf(s, sizeof(s), fmt, args);
 	printk(KERN_DEBUG "optcd: %s\n", s);
 	va_end(args);
 }
diff -puN drivers/cdrom/sbpcd.c~drivers-cdrom-trivial-vsnprintf-conversion drivers/cdrom/sbpcd.c
--- a/drivers/cdrom/sbpcd.c~drivers-cdrom-trivial-vsnprintf-conversion
+++ a/drivers/cdrom/sbpcd.c
@@ -770,11 +770,10 @@ static void msg(int level, const char *f
 	
 	msgnum++;
 	if (msgnum>99) msgnum=0;
-	sprintf(buf, MSG_LEVEL "%s-%d [%02d]:  ", major_name, current_drive - D_S, msgnum);
 	va_start(args, fmt);
-	vsprintf(&buf[18], fmt, args);
+	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	printk(buf);
+	printk(MSG_LEVEL "%s-%d [%02d]:  %s", major_name, current_drive - D_S, msgnum, buf);
 #if KLOGD_PAUSE
 	sbp_sleep(KLOGD_PAUSE); /* else messages get lost */
 #endif /* KLOGD_PAUSE */ 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

origin.patch
git-cpufreq.patch
git-ieee1394.patch
git-mtd.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-isdn-trivial-vsnprintf-conversion.patch
drivers-video-use-kmemdup.patch

