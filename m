From: akpm@linux-foundation.org
Subject: - w1-abort-search-early-on-on-exit.patch removed from -mm tree
Date: Wed, 30 Jul 2008 20:01:31 -0700
Message-ID: <200807310301.m6V31VUg000445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755080AbYGaDGg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:06:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1: abort search early on on exit
has been removed from the -mm tree.  Its filename was
     w1-abort-search-early-on-on-exit.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: abort search early on on exit
From: David Fries <david@fries.net>

Early abort if the master driver or the hardware goes away in the middle
of a bus search operation.  The alternative is to spam the print buffer up
to 64*64 times with read errors in the case of USB.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/w1/w1.c~w1-abort-search-early-on-on-exit drivers/w1/w1.c
--- a/drivers/w1/w1.c~w1-abort-search-early-on-on-exit
+++ a/drivers/w1/w1.c
@@ -772,6 +772,11 @@ void w1_search(struct w1_master *dev, u8
 			/* extract the direction taken & update the device number */
 			tmp64 = (triplet_ret >> 2);
 			rn |= (tmp64 << i);
+
+			if (test_bit(W1_MASTER_NEED_EXIT, &dev->flags)) {
+				printk(KERN_INFO "Abort w1_search (exiting)\n");
+				return;
+			}
 		}
 
 		if ( (triplet_ret & 0x03) != 0x03 ) {
_

Patches currently in -mm which might be from david@fries.net are

w1-abort-search-early-on-on-exit.patch
w1-dont-delay-search-start.patch
w1-w1_process-block-or-sleep.patch
w1-feature-enable-hardware-strong-pullup.patch
w1-feature-enable-hardware-strong-pullup-checkpatch-fixes.patch
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
w1-ds2490c-add-support-for-strong-pullup-checkpatch-fixes.patch
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
w1-ds2490c-optimize-ds_set_pullup-checkpatch-fixes.patch

