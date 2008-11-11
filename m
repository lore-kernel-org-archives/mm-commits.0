From: akpm@linux-foundation.org
Subject: + atkbd-cancel-delayed-work-before-freeing-its-structure.patch added to -mm tree
Date: Tue, 11 Nov 2008 15:05:56 -0800
Message-ID: <200811112305.mABN5uR4003417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57239 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748AbYKKXGx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 11 Nov 2008 18:06:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpirko@redhat.com, dtor@mail.ru, oleg@tv-sign.ru


The patch titled
     atkbd: cancel delayed work before freeing its structure
has been added to the -mm tree.  Its filename is
     atkbd-cancel-delayed-work-before-freeing-its-structure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

atkbd-cancel-delayed-work-before-freeing-its-structure.patch

