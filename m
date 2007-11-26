From: akpm@linux-foundation.org
Subject: - input-polled-device-timer-rounding.patch removed from -mm tree
Date: Mon, 26 Nov 2007 13:48:33 -0800
Message-ID: <200711262148.lAQLmXnF024606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56150 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754898AbXKZVsw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 16:48:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shemminger@linux-foundation.org, arjan@infradead.org, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: polled device timer rounding
has been removed from the -mm tree.  Its filename was
     input-polled-device-timer-rounding.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: input: polled device timer rounding
From: Stephen Hemminger <shemminger@linux-foundation.org>

Fix the timer rounding on input polled device.  Rounding doesn't matter for
the first tick, but we want succeeding ticks to be aligned on second boundary
if poll interval is large enough.

The old code did a timer roundoff of the initial setting, not the rearming. 
Since the timer routine will take some time, it will eventually wander from
one jiffie to another, causing greater wakeups increasing power consumption.

It is not an issue at the moment because there are few users of the input
polled device, and those that do use polling less than one second.  But the
apanel driver uses a 1 sec poll interval, because they are really crappy
buttons (not really keys), and the value is sticky till read.

Also: cancel_rearming_delayed_workqueue is marked as obsolete
in workqueue.h so use cancel_delayed_work_sync.

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/input-polldev.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff -puN drivers/input/input-polldev.c~input-polled-device-timer-rounding drivers/input/input-polldev.c
--- a/drivers/input/input-polldev.c~input-polled-device-timer-rounding
+++ a/drivers/input/input-polldev.c
@@ -60,17 +60,17 @@ static void input_polled_device_work(str
 {
 	struct input_polled_dev *dev =
 		container_of(work, struct input_polled_dev, work.work);
+	unsigned long ticks = msecs_to_jiffies(dev->poll_interval);
 
 	dev->poll(dev);
 	queue_delayed_work(polldev_wq, &dev->work,
-			   msecs_to_jiffies(dev->poll_interval));
+			   ticks >= HZ ? round_jiffies(ticks) : ticks);
 }
 
 static int input_open_polled_device(struct input_dev *input)
 {
 	struct input_polled_dev *dev = input->private;
 	int error;
-	unsigned long ticks;
 
 	error = input_polldev_start_workqueue();
 	if (error)
@@ -79,10 +79,8 @@ static int input_open_polled_device(stru
 	if (dev->flush)
 		dev->flush(dev);
 
-	ticks = msecs_to_jiffies(dev->poll_interval);
-	if (ticks >= HZ)
-		ticks = round_jiffies(ticks);
-	queue_delayed_work(polldev_wq, &dev->work, ticks);
+	queue_delayed_work(polldev_wq, &dev->work,
+			   msecs_to_jiffies(dev->poll_interval));
 
 	return 0;
 }
@@ -91,7 +89,7 @@ static void input_close_polled_device(st
 {
 	struct input_polled_dev *dev = input->private;
 
-	cancel_rearming_delayed_workqueue(polldev_wq, &dev->work);
+	cancel_delayed_work_sync(&dev->work);
 	input_polldev_stop_workqueue();
 }
 
_

Patches currently in -mm which might be from shemminger@linux-foundation.org are

git-input.patch
fujitsu-application-panel-driver.patch
git-netdev-all.patch
git-wireless.patch
