From: akpm@linux-foundation.org
Subject: + w1-new-module-parameter-search_count.patch added to -mm tree
Date: Wed, 30 Jul 2008 20:16:13 -0700
Message-ID: <200807310316.m6V3GDdT001155@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756685AbYGaDSG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:18:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david@fries.net, johnpol@2ka.mipt.ru


The patch titled
     W1: new module parameter search_count
has been added to the -mm tree.  Its filename is
     w1-new-module-parameter-search_count.patch

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
Subject: W1: new module parameter search_count
From: David Fries <david@fries.net>

Added a new module parameter search_count which allows overriding the
default search count.  -1 continual, 0 disabled, N that many times.

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/w1_int.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/w1/w1_int.c~w1-new-module-parameter-search_count drivers/w1/w1_int.c
--- a/drivers/w1/w1_int.c~w1-new-module-parameter-search_count
+++ a/drivers/w1/w1_int.c
@@ -30,6 +30,8 @@
 #include "w1_int.h"
 
 static u32 w1_ids = 1;
+static int w1_search_count = -1; /* Default is continual scan */
+module_param_named(search_count, w1_search_count, int, 0);
 
 static int w1_enable_pullup = 1;
 module_param_named(enable_pullup, w1_enable_pullup, int, 0);
@@ -62,8 +64,8 @@ static struct w1_master * w1_alloc_dev(u
 	dev->initialized	= 0;
 	dev->id			= id;
 	dev->slave_ttl		= slave_ttl;
+	dev->search_count	= w1_search_count;
 	dev->enable_pullup	= w1_enable_pullup;
-        dev->search_count	= -1; /* continual scan */
 
 	/* 1 for w1_process to decrement
 	 * 1 for __w1_remove_master_device to decrement
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

