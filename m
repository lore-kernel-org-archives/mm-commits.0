From: akpm@linux-foundation.org
Subject: - atkbd-cancel-delayed-work-before-freeing-its-structure.patch removed from -mm tree
Date: Wed, 12 Nov 2008 12:47:05 -0800
Message-ID: <200811122047.mACKl5ij006834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753655AbYKLUrp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 15:47:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpirko@redhat.com, dtor@mail.ru, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     atkbd: cancel delayed work before freeing its structure
has been removed from the -mm tree.  Its filename was
     atkbd-cancel-delayed-work-before-freeing-its-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atkbd: cancel delayed work before freeing its structure
From: Jiri Pirko <jpirko@redhat.com>

Pointed out by Oleg Nesterov.  Since delayed work is used here, use of
flush_scheduled_work() is not sufficient in atkbd_disconnect().  It does
not wait for scheduled delayed work to finish.  This patch prevents
delayed work to be processed after freeing atkbd structure (used struct
delayed_work is part of atkbd) by cancelling this delayed work.

Signed-off-by: Jiri Pirko <jpirko@redhat.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/keyboard/atkbd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/keyboard/atkbd.c~atkbd-cancel-delayed-work-before-freeing-its-structure drivers/input/keyboard/atkbd.c
--- a/drivers/input/keyboard/atkbd.c~atkbd-cancel-delayed-work-before-freeing-its-structure
+++ a/drivers/input/keyboard/atkbd.c
@@ -824,7 +824,7 @@ static void atkbd_disconnect(struct seri
 	atkbd_disable(atkbd);
 
 	/* make sure we don't have a command in flight */
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&atkbd->event_work);
 
 	sysfs_remove_group(&serio->dev.kobj, &atkbd_attribute_group);
 	input_unregister_device(atkbd->dev);
_

Patches currently in -mm which might be from jpirko@redhat.com are

linux-next.patch

