From: akpm@linux-foundation.org
Subject: + w1-ds2490c-ds_reset-remove-ds_wait_status.patch added to -mm tree
Date: Wed, 30 Jul 2008 20:16:43 -0700
Message-ID: <200807310316.m6V3GhmU001205@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756412AbYGaDSF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:18:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     W1: ds2490.c ds_reset remove ds_wait_status
has been added to the -mm tree.  Its filename is
     w1-ds2490c-ds_reset-remove-ds_wait_status.patch

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
Subject: W1: ds2490.c ds_reset remove ds_wait_status
From: David Fries <david@fries.net>

ds_reset no longer calls ds_wait_status, the result wasn't used and it
would only delay the following data operations.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds2490.c |   15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff -puN drivers/w1/masters/ds2490.c~w1-ds2490c-ds_reset-remove-ds_wait_status drivers/w1/masters/ds2490.c
--- a/drivers/w1/masters/ds2490.c~w1-ds2490c-ds_reset-remove-ds_wait_status
+++ a/drivers/w1/masters/ds2490.c
@@ -457,7 +457,7 @@ static int ds_wait_status(struct ds_devi
 		return 0;
 }
 
-static int ds_reset(struct ds_device *dev, struct ds_status *st)
+static int ds_reset(struct ds_device *dev)
 {
 	int err;
 
@@ -466,14 +466,6 @@ static int ds_reset(struct ds_device *de
 	if (err)
 		return err;
 
-	ds_wait_status(dev, st);
-#if 0
-	if (st->command_buffer_status) {
-		printk(KERN_INFO "Short circuit.\n");
-		return -EIO;
-	}
-#endif
-
 	return 0;
 }
 
@@ -809,12 +801,9 @@ static u8 ds9490r_read_block(void *data,
 static u8 ds9490r_reset(void *data)
 {
 	struct ds_device *dev = data;
-	struct ds_status st;
 	int err;
 
-	memset(&st, 0, sizeof(st));
-
-	err = ds_reset(dev, &st);
+	err = ds_reset(dev);
 	if (err)
 		return 1;
 
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

