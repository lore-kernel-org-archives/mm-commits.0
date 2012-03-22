From: akpm@linux-foundation.org
Subject: + fs-notify-notificationc-make-subsys_initcall-function-static.patch added to -mm tree
Date: Thu, 22 Mar 2012 14:59:08 -0700
Message-ID: <20120322215908.CA10FA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:54931 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031206Ab2CVV7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 17:59:11 -0400
Received: by wgbdt11 with SMTP id dt11so82874wgb.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 14:59:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hartleys@visionengravers.com, asharma@fb.com, eric.dumazet@gmail.com, hsweeten@visionengravers.com, vapier@gentoo.org


The patch titled
     Subject: fs/notify/notification.c: make subsys_initcall function static
has been added to the -mm tree.  Its filename is
     fs-notify-notificationc-make-subsys_initcall-function-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: fs/notify/notification.c: make subsys_initcall function static

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Arun Sharma <asharma@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/notification.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/notify/notification.c~fs-notify-notificationc-make-subsys_initcall-function-static fs/notify/notification.c
--- a/fs/notify/notification.c~fs-notify-notificationc-make-subsys_initcall-function-static
+++ a/fs/notify/notification.c
@@ -447,7 +447,7 @@ struct fsnotify_event *fsnotify_create_e
 	return event;
 }
 
-__init int fsnotify_notification_init(void)
+static __init int fsnotify_notification_init(void)
 {
 	fsnotify_event_cachep = KMEM_CACHE(fsnotify_event, SLAB_PANIC);
 	fsnotify_event_holder_cachep = KMEM_CACHE(fsnotify_event_holder, SLAB_PANIC);
@@ -461,4 +461,3 @@ __init int fsnotify_notification_init(vo
 	return 0;
 }
 subsys_initcall(fsnotify_notification_init);
