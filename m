From: akpm@linux-foundation.org
Subject: - cdc-acmc-fix-recursive-lock-in-acm_start_wb-error-path.patch removed from -mm tree
Date: Thu, 13 Nov 2008 13:28:09 -0800
Message-ID: <200811132128.mADLS9fY028321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42279 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753364AbYKMV2i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Nov 2008 16:28:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: brandon@ifup.org, bphilips@suse.de, dave@awk.cz, oliver@neukum.org, stable@kernel.org, stern@rowland.harvard.edu, mm-commits@vger.kernel.org


The patch titled
     cdc-acm.c: fix recursive lock in acm_start_wb error path
has been removed from the -mm tree.  Its filename was
     cdc-acmc-fix-recursive-lock-in-acm_start_wb-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cdc-acm.c: fix recursive lock in acm_start_wb error path
From: Brandon Philips <brandon@ifup.org>

Fix an obvious bug in cdc-acm by avoiding a recursive lock on
acm_start_wb()'s error path.  Should apply towards 2.6.27 stable and
2.6.28.

=============================================
[ INFO: possible recursive locking detected ]
2.6.27-2-pae #109
---------------------------------------------
python/31449 is trying to acquire lock:
 (&acm->write_lock){++..}, at: [<f89a0348>] acm_start_wb+0x5c/0x7b [cdc_acm]

but task is already holding lock:
 (&acm->write_lock){++..}, at: [<f89a04fb>] acm_tty_write+0xe1/0x167 [cdc_acm]

other info that might help us debug this:
2 locks held by python/31449:
 #0:  (&tty->atomic_write_lock){--..}, at: [<c0260fae>] tty_write_lock+0x14/0x3b
 #1:  (&acm->write_lock){++..}, at: [<f89a04fb>] acm_tty_write+0xe1/0x167 [cdc_acm]

stack backtrace:
Pid: 31449, comm: python Not tainted 2.6.27-2-pae #109
 [<c030f42f>] ? printk+0xf/0x18
 [<c0149f33>] __lock_acquire+0xc7b/0x1316
 [<c014a63e>] lock_acquire+0x70/0x97
 [<f89a0348>] ? acm_start_wb+0x5c/0x7b [cdc_acm]
 [<c0312109>] _spin_lock_irqsave+0x37/0x47
 [<f89a0348>] ? acm_start_wb+0x5c/0x7b [cdc_acm]
 [<f89a0348>] acm_start_wb+0x5c/0x7b [cdc_acm]
 [<f89a055d>] acm_tty_write+0x143/0x167 [cdc_acm]
 [<c0262a98>] write_chan+0x1cd/0x297
 [<c012527e>] ? default_wake_function+0x0/0xd
 [<c026111e>] tty_write+0x149/0x1b9
 [<c02628cb>] ? write_chan+0x0/0x297
 [<c01912c5>] ? rw_verify_area+0x76/0x98
 [<c0260fd5>] ? tty_write+0x0/0x1b9
 [<c01919ba>] vfs_write+0x8c/0x136
 [<c0191afd>] sys_write+0x3b/0x60
 [<c0103beb>] sysenter_do_call+0x12/0x3f
 =======================

Signed-off-by: Brandon Philips <bphilips@suse.de>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: <dave@awk.cz>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/class/cdc-acm.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN drivers/usb/class/cdc-acm.c~cdc-acmc-fix-recursive-lock-in-acm_start_wb-error-path drivers/usb/class/cdc-acm.c
--- a/drivers/usb/class/cdc-acm.c~cdc-acmc-fix-recursive-lock-in-acm_start_wb-error-path
+++ a/drivers/usb/class/cdc-acm.c
@@ -158,16 +158,12 @@ static int acm_wb_is_avail(struct acm *a
 }
 
 /*
- * Finish write.
+ * Finish write. Caller must hold acm->write_lock
  */
 static void acm_write_done(struct acm *acm, struct acm_wb *wb)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&acm->write_lock, flags);
 	wb->use = 0;
 	acm->transmitting--;
-	spin_unlock_irqrestore(&acm->write_lock, flags);
 }
 
 /*
@@ -482,6 +478,7 @@ static void acm_write_bulk(struct urb *u
 {
 	struct acm_wb *wb = urb->context;
 	struct acm *acm = wb->instance;
+	unsigned long flags;
 
 	if (verbose || urb->status
 			|| (urb->actual_length != urb->transfer_buffer_length))
@@ -490,7 +487,9 @@ static void acm_write_bulk(struct urb *u
 			urb->transfer_buffer_length,
 			urb->status);
 
+	spin_lock_irqsave(&acm->write_lock, flags);
 	acm_write_done(acm, wb);
+	spin_unlock_irqrestore(&acm->write_lock, flags);
 	if (ACM_READY(acm))
 		schedule_work(&acm->work);
 	else
_

Patches currently in -mm which might be from brandon@ifup.org are

linux-next.patch

