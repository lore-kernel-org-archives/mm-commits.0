From: akpm@linux-foundation.org
Subject: + w1-ds2490c-magic-number-work.patch added to -mm tree
Date: Wed, 30 Jul 2008 20:16:47 -0700
Message-ID: <200807310316.m6V3Glja001217@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756844AbYGaDS3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:18:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     W1: ds2490.c magic number work
has been added to the -mm tree.  Its filename is
     w1-ds2490c-magic-number-work.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: W1: ds2490.c magic number work
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

w1-fix-deadlocks-and-remove-w1_control_thread.patch
w1-abort-search-early-on-on-exit.patch
w1-dont-delay-search-start.patch
w1-w1_process-block-or-sleep.patch
w1-feature-enable-hardware-strong-pullup.patch
w1-feature-w1_thermc-use-strong-pullup-and-documentation.patch
w1-be-able-to-manually-add-and-remove-slaves.patch
w1-recode-w1_slave_found-logic.patch
w1-new-module-parameter-search_count.patch
w1-document-add-remove-search_count-and-pullup.patch
w1-w1_slave_read_id-read-bug-use-device_attribute.patch
w1-w1_therm-fix-user-buffer-overflow-and-cat.patch
w1-w1_family-remove-unused-variable-need_exit.patch
w1-w1_therm-consistent-mutex-access-code-cleanup.patch
w1-w1_intc-use-first-available-master-number.patch
w1-w1c-s-printk-dev_dbg.patch
w1-w1_ioc-reset-comments-and-msleep.patch
w1-ds1wmc-msleep-for-reset.patch
w1-ds2490c-correct-print-message.patch
w1-ds2490c-add-support-for-strong-pullup.patch
w1-ds2490c-ds_write_bit-grouping-error-disable-readback.patch
w1-ds2490c-disable-bit-read-and-write.patch
w1-ds2490c-simplify-and-fix-ds_touch_bit.patch
w1-ds2490c-ds_dump_status-rework.patch
w1-ds2490c-ds_reset-remove-ds_wait_status.patch
w1-ds2490c-reset-ds2490-in-init.patch
w1-ds2490c-magic-number-work.patch
w1-ds2490c-ds_write_block-remove-extra-ds_wait_status.patch
w1-documentation-w1-masters-ds2490-update.patch
w1-ds2490c-optimize-ds_set_pullup.patch

