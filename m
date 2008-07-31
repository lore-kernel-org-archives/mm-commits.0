From: akpm@linux-foundation.org
Subject: + w1-recode-w1_slave_found-logic.patch added to -mm tree
Date: Wed, 30 Jul 2008 20:16:11 -0700
Message-ID: <200807310316.m6V3GB8R001152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752639AbYGaDQq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:16:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     W1: recode w1_slave_found logic
has been added to the -mm tree.  Its filename is
     w1-recode-w1_slave_found-logic.patch

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
Subject: W1: recode w1_slave_found logic
From: David Fries <david@fries.net>

Simplified the logic in w1_slave_found by using the new
w1_attach_slave_device function to find a slave and mark it as active or
add the device if the crc checks.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |   26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff -puN drivers/w1/w1.c~w1-recode-w1_slave_found-logic drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-recode-w1_slave_found-logic
+++ a/drivers/w1/w1.c
@@ -844,9 +844,7 @@ void w1_reconnect_slaves(struct w1_famil
 
 static void w1_slave_found(struct w1_master *dev, u64 rn)
 {
-	int slave_count;
 	struct w1_slave *sl;
-	struct list_head *ent;
 	struct w1_reg_num *tmp;
 	u64 rn_le = cpu_to_le64(rn);
 
@@ -854,24 +852,12 @@ static void w1_slave_found(struct w1_mas
 
 	tmp = (struct w1_reg_num *) &rn;
 
-	slave_count = 0;
-	list_for_each(ent, &dev->slist) {
-
-		sl = list_entry(ent, struct w1_slave, w1_slave_entry);
-
-		if (sl->reg_num.family == tmp->family &&
-		    sl->reg_num.id == tmp->id &&
-		    sl->reg_num.crc == tmp->crc) {
-			set_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
-			break;
-		}
-
-		slave_count++;
-	}
-
-	if (slave_count == dev->slave_count &&
-		rn && ((rn >> 56) & 0xff) == w1_calc_crc8((u8 *)&rn_le, 7)) {
-		w1_attach_slave_device(dev, tmp);
+	sl = w1_slave_search_device(dev, tmp);
+	if (sl) {
+		set_bit(W1_SLAVE_ACTIVE, (long *)&sl->flags);
+	} else {
+		if (rn && tmp->crc == w1_calc_crc8((u8 *)&rn_le, 7))
+			w1_attach_slave_device(dev, tmp);
 	}
 
 	atomic_dec(&dev->refcnt);
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

