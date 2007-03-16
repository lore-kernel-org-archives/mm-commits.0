From: akpm@linux-foundation.org
Subject: - crash-on-evdev-disconnect.patch removed from -mm tree
Date: Fri, 16 Mar 2007 11:36:37 -0800
Message-ID: <200703161936.l2GJabTm019938@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:32804 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbXCPTgq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 15:36:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: warp@aehallh.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Crash on evdev disconnect
has been removed from the -mm tree.  Its filename was
     crash-on-evdev-disconnect.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Crash on evdev disconnect
From: "Zephaniah E. Hull" <warp@aehallh.com>

While trying to figure out the best way to handle an odd mouse, I found
that we oopsed when doing a rmmod on usbhid while someone had a USB device
open through evdev.

We try to loop through evdev->list, calling kill_fasync on each member,
however by the time we try to get the next pointer, we have already freed
the member and poisoned the next/last.

akpm: doesn't really fix the bug (lack of locking).  But I'm queueing it up so
I can nag Dmitry with it ;)

Signed-off-by: "Zephaniah E. Hull" <warp@aehallh.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/evdev.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/input/evdev.c~crash-on-evdev-disconnect drivers/input/evdev.c
--- a/drivers/input/evdev.c~crash-on-evdev-disconnect
+++ a/drivers/input/evdev.c
@@ -659,7 +659,7 @@ static struct input_handle *evdev_connec
 static void evdev_disconnect(struct input_handle *handle)
 {
 	struct evdev *evdev = handle->private;
-	struct evdev_list *list;
+	struct evdev_list *list, *next;
 
 	sysfs_remove_link(&input_class.subsys.kset.kobj, evdev->name);
 	class_device_destroy(&input_class,
@@ -670,7 +670,7 @@ static void evdev_disconnect(struct inpu
 		input_flush_device(handle, NULL);
 		input_close_device(handle);
 		wake_up_interruptible(&evdev->wait);
-		list_for_each_entry(list, &evdev->list, node)
+		list_for_each_entry_safe(list, next, &evdev->list, node)
 			kill_fasync(&list->fasync, SIGIO, POLL_HUP);
 	} else
 		evdev_free(evdev);
_

Patches currently in -mm which might be from warp@aehallh.com are

crash-on-evdev-disconnect.patch
