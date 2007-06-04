From: akpm@linux-foundation.org
Subject: - input-reduce-raciness-when-input-handlers-disconnect.patch removed from -mm tree
Date: Mon, 04 Jun 2007 13:56:34 -0700
Message-ID: <200706042056.l54KuWRE018901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44511 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757999AbXFDU4t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 16:56:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dtor@insightbb.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     Input: reduce raciness when input handlers disconnect
has been removed from the -mm tree.  Its filename was
     input-reduce-raciness-when-input-handlers-disconnect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Input: reduce raciness when input handlers disconnect
From: Dmitry Torokhov <dtor@insightbb.com>

There is a race between input handler's release() and disconnect() methods:
when input handler disconnects it wakes up all regular users and then process
to walk user list to wake up async.  users.  While disconnect() walks the list
release() removes elements of the same list causing oopses.

While this is not a substitute for proper locking we can reduce odds of
getting an oops if we wake up normal readers after walking the list.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/evdev.c    |    2 +-
 drivers/input/joydev.c   |    2 +-
 drivers/input/mousedev.c |    2 +-
 drivers/input/tsdev.c    |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/input/evdev.c~input-reduce-raciness-when-input-handlers-disconnect drivers/input/evdev.c
--- a/drivers/input/evdev.c~input-reduce-raciness-when-input-handlers-disconnect
+++ a/drivers/input/evdev.c
@@ -699,9 +699,9 @@ static void evdev_disconnect(struct inpu
 	if (evdev->open) {
 		input_flush_device(handle, NULL);
 		input_close_device(handle);
-		wake_up_interruptible(&evdev->wait);
 		list_for_each_entry(client, &evdev->client_list, node)
 			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
+		wake_up_interruptible(&evdev->wait);
 	} else
 		evdev_free(evdev);
 }
diff -puN drivers/input/joydev.c~input-reduce-raciness-when-input-handlers-disconnect drivers/input/joydev.c
--- a/drivers/input/joydev.c~input-reduce-raciness-when-input-handlers-disconnect
+++ a/drivers/input/joydev.c
@@ -619,9 +619,9 @@ static void joydev_disconnect(struct inp
 
 	if (joydev->open) {
 		input_close_device(handle);
-		wake_up_interruptible(&joydev->wait);
 		list_for_each_entry(client, &joydev->client_list, node)
 			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
+		wake_up_interruptible(&joydev->wait);
 	} else
 		joydev_free(joydev);
 }
diff -puN drivers/input/mousedev.c~input-reduce-raciness-when-input-handlers-disconnect drivers/input/mousedev.c
--- a/drivers/input/mousedev.c~input-reduce-raciness-when-input-handlers-disconnect
+++ a/drivers/input/mousedev.c
@@ -766,9 +766,9 @@ static void mousedev_disconnect(struct i
 
 	if (mousedev->open) {
 		input_close_device(handle);
-		wake_up_interruptible(&mousedev->wait);
 		list_for_each_entry(client, &mousedev->client_list, node)
 			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
+		wake_up_interruptible(&mousedev->wait);
 	} else
 		mousedev_free(mousedev);
 }
diff -puN drivers/input/tsdev.c~input-reduce-raciness-when-input-handlers-disconnect drivers/input/tsdev.c
--- a/drivers/input/tsdev.c~input-reduce-raciness-when-input-handlers-disconnect
+++ a/drivers/input/tsdev.c
@@ -476,9 +476,9 @@ static void tsdev_disconnect(struct inpu
 
 	if (tsdev->open) {
 		input_close_device(handle);
-		wake_up_interruptible(&tsdev->wait);
 		list_for_each_entry(client, &tsdev->client_list, node)
 			kill_fasync(&client->fasync, SIGIO, POLL_HUP);
+		wake_up_interruptible(&tsdev->wait);
 	} else
 		tsdev_free(tsdev);
 }
_

Patches currently in -mm which might be from dtor@insightbb.com are

git-dvb.patch
hdaps-switch-to-using-input-polldev.patch
applesmc-switch-to-using-input-polldev.patch
ams-switch-to-using-input-polldev.patch
git-input.patch
ibmasm-whitespace-cleanup.patch
ibmasm-dont-use-extern-in-function-declarations.patch
ibmasm-miscellaneous-fixes.patch
ibmasm-must-depend-on-config_input.patch
