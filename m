From: akpm@linux-foundation.org
Subject: - w1-w1_therm-consistent-mutex-access-code-cleanup.patch removed from -mm tree
Date: Wed, 30 Jul 2008 20:01:59 -0700
Message-ID: <200807310301.m6V31xk1000497@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44259 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762767AbYGaDCE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 23:02:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david@fries.net, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     w1: w1_therm consistent mutex access code cleanup
has been removed from the -mm tree.  Its filename was
     w1-w1_therm-consistent-mutex-access-code-cleanup.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: w1: w1_therm consistent mutex access code cleanup
From: David Fries <david@fries.net>

sl->master->mutex and dev->mutex refer to the same mutex variable, but be
consistent and use the same set of pointers for the lock and unlock calls.
It is less confusing (and one less pointer dereference this way).

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_therm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/w1/slaves/w1_therm.c~w1-w1_therm-consistent-mutex-access-code-cleanup drivers/w1/slaves/w1_therm.c
--- a/drivers/w1/slaves/w1_therm.c~w1-w1_therm-consistent-mutex-access-code-cleanup
+++ a/drivers/w1/slaves/w1_therm.c
@@ -171,7 +171,7 @@ static ssize_t w1_therm_read(struct devi
 	int i, max_trying = 10;
 	ssize_t c = PAGE_SIZE;
 
-	mutex_lock(&sl->master->mutex);
+	mutex_lock(&dev->mutex);
 
 	memset(rom, 0, sizeof(rom));
 
_

Patches currently in -mm which might be from david@fries.net are

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

