From: akpm@linux-foundation.org
Subject: [merged] fs-notify-notificationc-make-subsys_initcall-function-static.patch removed from -mm tree
Date: Mon, 26 Mar 2012 12:28:21 -0700
Message-ID: <20120326192821.742A4A0560@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:46715 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2CZT2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Mar 2012 15:28:23 -0400
Received: by faaa19 with SMTP id a19so298392faa.1
        for <mm-commits@vger.kernel.org>; Mon, 26 Mar 2012 12:28:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hartleys@visionengravers.com, asharma@fb.com, eric.dumazet@gmail.com, hsweeten@visionengravers.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/notify/notification.c: make subsys_initcall function static
has been removed from the -mm tree.  Its filename was
     fs-notify-notificationc-make-subsys_initcall-function-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
