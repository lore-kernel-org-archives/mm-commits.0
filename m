From: akpm@linux-foundation.org
Subject: + mtd-fix-ctrl-alt-del-cant-reboot-for-intel-flash-bug.patch added to -mm tree
Date: Sat, 28 Jul 2007 23:35:41 -0700
Message-ID: <200707290635.l6T6Zfw0011888@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40473 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756787AbXG2Gfz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:35:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: haokexin@gmail.com, dwmw2@infradead.org


The patch titled
     MTD: fix ctrl-alt-del can't reboot for intel flash bug
has been added to the -mm tree.  Its filename is
     mtd-fix-ctrl-alt-del-cant-reboot-for-intel-flash-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MTD: fix ctrl-alt-del can't reboot for intel flash bug
From: "Kevin Hao" <haokexin@gmail.com>

When we press ctrl-alt-del,kernel_restart_prepare will revoke
cfi_intelext_reboot which will set flash to read array mode,but later when
device_shutdown is invoked which may put current work queue to sleep and
other process may be sheduled to running and programming flash in not
FL_READY mode again.So we cann't boot up if this flash is used for
bootloader.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/cfi_cmdset_0001.c |    9 ++++++---
 include/linux/mtd/flashchip.h       |    1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN drivers/mtd/chips/cfi_cmdset_0001.c~mtd-fix-ctrl-alt-del-cant-reboot-for-intel-flash-bug drivers/mtd/chips/cfi_cmdset_0001.c
--- a/drivers/mtd/chips/cfi_cmdset_0001.c~mtd-fix-ctrl-alt-del-cant-reboot-for-intel-flash-bug
+++ a/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -653,7 +653,7 @@ static int get_chip(struct map_info *map
  resettime:
 	timeo = jiffies + HZ;
  retry:
-	if (chip->priv && (mode == FL_WRITING || mode == FL_ERASING || mode == FL_OTP_WRITE)) {
+	if (chip->priv && (mode == FL_WRITING || mode == FL_ERASING || mode == FL_OTP_WRITE || mode == FL_SHUTDOWN)) {
 		/*
 		 * OK. We have possibility for contension on the write/erase
 		 * operations which are global to the real chip and not per
@@ -798,6 +798,9 @@ static int get_chip(struct map_info *map
 		if (mode == FL_READY && chip->oldstate == FL_READY)
 			return 0;
 
+	case FL_SHUTDOWN:
+		/* The machine is rebooting now,so no one can get chip anymore */
+		return -EIO;
 	default:
 	sleep:
 		set_current_state(TASK_UNINTERRUPTIBLE);
@@ -2402,10 +2405,10 @@ static int cfi_intelext_reset(struct mtd
 		   and switch to array mode so any bootloader in
 		   flash is accessible for soft reboot. */
 		spin_lock(chip->mutex);
-		ret = get_chip(map, chip, chip->start, FL_SYNCING);
+		ret = get_chip(map, chip, chip->start, FL_SHUTDOWN);
 		if (!ret) {
 			map_write(map, CMD(0xff), chip->start);
-			chip->state = FL_READY;
+			chip->state = FL_SHUTDOWN;
 		}
 		spin_unlock(chip->mutex);
 	}
diff -puN include/linux/mtd/flashchip.h~mtd-fix-ctrl-alt-del-cant-reboot-for-intel-flash-bug include/linux/mtd/flashchip.h
--- a/include/linux/mtd/flashchip.h~mtd-fix-ctrl-alt-del-cant-reboot-for-intel-flash-bug
+++ a/include/linux/mtd/flashchip.h
@@ -40,6 +40,7 @@ typedef enum {
 	FL_POINT,
 	FL_XIP_WHILE_ERASING,
 	FL_XIP_WHILE_WRITING,
+	FL_SHUTDOWN,
 	FL_UNKNOWN
 } flstate_t;
 
_

Patches currently in -mm which might be from haokexin@gmail.com are

mtd-fix-ctrl-alt-del-cant-reboot-for-intel-flash-bug.patch
