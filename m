From: akpm@linux-foundation.org
Subject: - w1-ds2490c-magic-number-work.patch removed from -mm tree
Date: Wed, 30 Jul 2008 20:02:28 -0700
Message-ID: <200807310302.m6V32Se6000576@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761663AbYGaDCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:02:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1: ds2490.c magic number work
has been removed from the -mm tree.  Its filename was
     w1-ds2490c-magic-number-work.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: ds2490.c magic number work
From: David Fries <david@fries.net>

This replaces some magic numbers with marcos and corrects one marco.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds2490.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff -puN drivers/w1/masters/ds2490.c~w1-ds2490c-magic-number-work drivers/w1/masters/ds2490.c
--- a/drivers/w1/masters/ds2490.c~w1-ds2490c-magic-number-work
+++ a/drivers/w1/masters/ds2490.c
@@ -88,7 +88,7 @@
 #define COMM_DT				0x2000
 #define COMM_SPU			0x1000
 #define COMM_F				0x0800
-#define COMM_NTP			0x0400
+#define COMM_NTF			0x0400
 #define COMM_ICP			0x0200
 #define COMM_RST			0x0100
 
@@ -440,7 +440,7 @@ static int ds_wait_status(struct ds_devi
 			printk("\n");
 		}
 #endif
-	} while(!(buf[0x08] & 0x20) && !(err < 0) && ++count < 100);
+	} while (!(buf[0x08] & ST_IDLE) && !(err < 0) && ++count < 100);
 
 	if (err >= 16 && st->status & ST_EPOF) {
 		printk(KERN_INFO "Resetting device after ST_EPOF.\n");
@@ -470,8 +470,16 @@ static int ds_reset(struct ds_device *de
 {
 	int err;
 
-	//err = ds_send_control(dev, COMM_1_WIRE_RESET | COMM_F | COMM_IM | COMM_SE, SPEED_FLEXIBLE);
-	err = ds_send_control(dev, 0x43, SPEED_NORMAL);
+	/* Other potentionally interesting flags for reset.
+	 *
+	 * COMM_NTF: Return result register feedback.  This could be used to
+	 * detect some conditions such as short, alarming presence, or
+	 * detect if a new device was detected.
+	 *
+	 * COMM_SE which allows SPEED_NORMAL, SPEED_FLEXIBLE, SPEED_OVERDRIVE:
+	 * Select the data transfer rate.
+	 */
+	err = ds_send_control(dev, COMM_1_WIRE_RESET | COMM_IM, SPEED_NORMAL);
 	if (err)
 		return err;
 
_

Patches currently in -mm which might be from david@fries.net are

w1-ds2490c-magic-number-work.patch
w1-ds2490c-ds_write_block-remove-extra-ds_wait_status.patch
w1-documentation-w1-masters-ds2490-update.patch
w1-ds2490c-optimize-ds_set_pullup.patch
w1-ds2490c-optimize-ds_set_pullup-checkpatch-fixes.patch

