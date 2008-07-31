From: akpm@linux-foundation.org
Subject: + w1-ds1wmc-msleep-for-reset.patch added to -mm tree
Date: Wed, 30 Jul 2008 20:16:29 -0700
Message-ID: <200807310316.m6V3GTQd001182@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757079AbYGaDXi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:23:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     W1: ds1wm.c msleep for reset
has been added to the -mm tree.  Its filename is
     w1-ds1wmc-msleep-for-reset.patch

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
Subject: W1: ds1wm.c msleep for reset
From: David Fries <david@fries.net>

Like the previous w1_io.c reset coments and msleep patch, I don't have the
hardware to verify the change, but I think it is safe.  It also helps to
see a comment like this in the code.  "We'll wait a bit longer just to be
sure." If they are going to calculate delaying 324.9us, but actually delay
500us, why not just give up the CPU and sleep?  This is designed for a
battery powered ARM system, avoiding busywaiting has to be good for
battery life.

I sent a request for testers March 7, 2008 to the Linux kernel mailing
list and two developers who have patches for ds1wm.c, but I didn't get
any respons.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds1wm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/w1/masters/ds1wm.c~w1-ds1wmc-msleep-for-reset drivers/w1/masters/ds1wm.c
--- a/drivers/w1/masters/ds1wm.c~w1-ds1wmc-msleep-for-reset
+++ a/drivers/w1/masters/ds1wm.c
@@ -160,8 +160,10 @@ static int ds1wm_reset(struct ds1wm_data
 	 *     625 us - 60 us - 240 us - 100 ns = 324.9 us
 	 *
 	 * We'll wait a bit longer just to be sure.
+	 * Was udelay(500), but if it is going to busywait the cpu that long,
+	 * might as well come back later.
 	 */
-	udelay(500);
+	msleep(1);
 
 	ds1wm_write_register(ds1wm_data, DS1WM_INT_EN,
 		DS1WM_INTEN_ERBF | DS1WM_INTEN_ETMT | DS1WM_INTEN_EPD |
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

