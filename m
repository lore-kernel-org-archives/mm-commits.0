From: akpm@linux-foundation.org
Subject: - input-add-retry-logic-to-resume-with-respect-to-ctr.patch removed from -mm tree
Date: Mon, 23 Jun 2008 14:02:40 -0700
Message-ID: <200806232102.m5NL2e4t016097@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40233 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757305AbYFWVCp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jun 2008 17:02:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, hschaa@novell.com, mm-commits@vger.kernel.org


The patch titled
     input: add retry logic to resume with respect to CTR
has been removed from the -mm tree.  Its filename was
     input-add-retry-logic-to-resume-with-respect-to-ctr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: add retry logic to resume with respect to CTR
From: Jiri Kosina <jkosina@suse.cz>

There are systems that fail in i8042_resume() with

	i8042: Can't write CTR to resume

as i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR) fails even though the
controller claimed itself to be ready before.

One retry after failing write fixes the problems on the failing systems.

Reported-by: Helmut Schaa <hschaa@novell.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/input/serio/i8042.c~input-add-retry-logic-to-resume-with-respect-to-ctr drivers/input/serio/i8042.c
--- a/drivers/input/serio/i8042.c~input-add-retry-logic-to-resume-with-respect-to-ctr
+++ a/drivers/input/serio/i8042.c
@@ -952,8 +952,12 @@ static int i8042_resume(struct platform_
 	i8042_ctr |= I8042_CTR_AUXDIS | I8042_CTR_KBDDIS;
 	i8042_ctr &= ~(I8042_CTR_AUXINT | I8042_CTR_KBDINT);
 	if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
-		printk(KERN_ERR "i8042: Can't write CTR to resume\n");
-		return -EIO;
+		printk(KERN_WARNING "i8042: Can't write CTR to resume, retrying ...\n");
+		msleep(50);
+		if (i8042_command(&i8042_ctr, I8042_CMD_CTL_WCTR)) {
+			printk(KERN_ERR "i8042: CTR write retry failed\n");
+			return -EIO;
+		}
 	}
 
 
_

Patches currently in -mm which might be from jkosina@suse.cz are

linux-next.patch
elantech-touchpad-driver.patch
input-touchscreen-driver-add-support-ad7877-touchscreen-driver.patch
input-fix-hp-2133-not-sending-release-event-for-video-switch.patch
ds1302-push-down-the-bkl-into-the-driver-ioctl-code.patch

