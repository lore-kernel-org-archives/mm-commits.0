From: akpm@linux-foundation.org
Subject: [merged] uinput-flush-all-pending-ff-effects-before-destroying-device.patch removed from -mm tree
Date: Tue, 26 May 2009 12:35:22 -0700
Message-ID: <200905261935.n4QJZMAW006232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756347AbZEZTp4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 May 2009 15:45:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aris@ruivo.org, aris@redhat.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     uinput: flush all pending ff effects before destroying device
has been removed from the -mm tree.  Its filename was
     uinput-flush-all-pending-ff-effects-before-destroying-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uinput: flush all pending ff effects before destroying device
From: Aristeu Sergio Rozanski Filho <aris@ruivo.org>

The destruction of a input device in uinput is triggered by an ioctl(). 
If a process tries to destroy an input device while other is uploading a
force feedback effect by evdev to the same device, they'll deadlock:

	uinput-driver D ffff88001f994540  3120  2403   2374
	 ffff88001dc459e8 0000000000000046 ffff88001dc45988 ffffffff8106a2d8
	 ffffffff81a4a980 ffffffff81a4a980 ffff88001f994540 ffff88001ea3c540
	 ffff88001f9948e0 00000000810297b8 0000000100000001 ffff88001f9948e0
	Call Trace:
	 [<ffffffff8106a2d8>] ? __lock_acquire+0xb3a/0xc01
	 [<ffffffff81068a7b>] ? mark_lock+0x22/0x3a2
	 [<ffffffff81068e62>] ? mark_held_locks+0x67/0x82
	 [<ffffffff813148c6>] ? __mutex_lock_common+0x1f0/0x35d
	 [<ffffffff813148d6>] __mutex_lock_common+0x200/0x35d
	 [<ffffffff81251699>] ? evdev_cleanup+0x2f/0x103
	 [<ffffffff8106763a>] ? lock_release_holdtime+0x2c/0x111
	 [<ffffffff81251699>] ? evdev_cleanup+0x2f/0x103
	 [<ffffffff81158b16>] ? kobject_put+0x47/0x4b
	 [<ffffffff81314adc>] mutex_lock_nested+0x35/0x3a
	 [<ffffffff81251699>] evdev_cleanup+0x2f/0x103
	 [<ffffffff81251798>] evdev_disconnect+0x2b/0x44
	 [<ffffffff8124cc02>] input_unregister_device+0x11a/0x1c9
	 [<ffffffff81258505>] uinput_destroy_device+0x2d/0x5d
	 [<ffffffff8125854d>] uinput_release+0x18/0x26
	 [<ffffffff810cc5b9>] __fput+0xf0/0x18b
	 [<ffffffff810cc669>] fput+0x15/0x17
	 [<ffffffff810c99f8>] filp_close+0x67/0x72
	 [<ffffffff81049255>] put_files_struct+0x74/0xc8
	 [<ffffffff810492f0>] exit_files+0x47/0x4f
	 [<ffffffff8104ab49>] do_exit+0x228/0x89b
	 [<ffffffff81316002>] ? _spin_unlock_irq+0x2b/0x37
	 [<ffffffff8104b235>] do_group_exit+0x79/0xa9
	 [<ffffffff81054a37>] get_signal_to_deliver+0x318/0x339
	 [<ffffffff810103fb>] do_notify_resume+0x8c/0x875
	 [<ffffffff8106763a>] ? lock_release_holdtime+0x2c/0x111
	 [<ffffffff81316002>] ? _spin_unlock_irq+0x2b/0x37
	 [<ffffffff81069007>] ? trace_hardirqs_on_caller+0xf6/0x11a
	 [<ffffffff81069038>] ? trace_hardirqs_on+0xd/0xf
	 [<ffffffff81316002>] ? _spin_unlock_irq+0x2b/0x37
	 [<ffffffff81043f97>] ? finish_task_switch+0x5f/0xc2
	 [<ffffffff81043f38>] ? finish_task_switch+0x0/0xc2
	 [<ffffffff810d71e2>] ? do_vfs_ioctl+0x398/0x3c6
	 [<ffffffff810119af>] ? retint_signal+0x11/0xc2
	 [<ffffffff81069007>] ? trace_hardirqs_on_caller+0xf6/0x11a
	 [<ffffffff81011a03>] retint_signal+0x65/0xc2
	uinput-app    D 0000000000000002  3120  2413   2374
	 ffff88001d941be8 0000000000000046 ffff88001d941b38 ffffffff81068a7b
	 ffffffff81a4a980 ffffffff81a4a980 ffff88001d96a2a0 ffff88001f994540
	 ffff88001d96a640 000000000000004e ffff88001d941bc8 ffff88001d96a640
	Call Trace:
	 [<ffffffff81068a7b>] ? mark_lock+0x22/0x3a2
	 [<ffffffff810297b8>] ? pvclock_clocksource_read+0x42/0x7e
	 [<ffffffff81068a7b>] ? mark_lock+0x22/0x3a2
	 [<ffffffff813142c6>] schedule_timeout+0x22/0xc6
	 [<ffffffff81316002>] ? _spin_unlock_irq+0x2b/0x37
	 [<ffffffff81069007>] ? trace_hardirqs_on_caller+0xf6/0x11a
	 [<ffffffff81069038>] ? trace_hardirqs_on+0xd/0xf
	 [<ffffffff81316002>] ? _spin_unlock_irq+0x2b/0x37
	 [<ffffffff813141a2>] wait_for_common+0xb7/0x100
	 [<ffffffff8103fcde>] ? default_wake_function+0x0/0xf
	 [<ffffffff81314275>] wait_for_completion+0x18/0x1a
	 [<ffffffff81258acf>] uinput_dev_upload_effect+0x80/0x93
	 [<ffffffff8124e6d1>] input_ff_upload+0x1eb/0x276
	 [<ffffffff8125130f>] evdev_ioctl_handler+0x6f1/0x709
	 [<ffffffff81017a68>] ? sched_clock+0x9/0xc
	 [<ffffffff8106763a>] ? lock_release_holdtime+0x2c/0x111
	 [<ffffffff81251344>] evdev_ioctl+0xb/0xd
	 [<ffffffff810d6dfc>] vfs_ioctl+0x2a/0x78
	 [<ffffffff810d71e2>] do_vfs_ioctl+0x398/0x3c6
	 [<ffffffff810cb067>] ? fsnotify_modify+0x62/0x6a
	 [<ffffffff810110ca>] ? sysret_check+0x46/0x81
	 [<ffffffff810d7252>] sys_ioctl+0x42/0x65
	 [<ffffffff8101107a>] system_call_fastpath+0x16/0x1b

This patch fixes the problem by flushing all pending FF uploads before
destroying the device and preventing new uploads during this operation

Signed-off-by: Aristeu Rozanski <aris@redhat.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/misc/uinput.c |   41 ++++++++++++++++++++++++++++++----
 include/linux/uinput.h      |    1 
 2 files changed, 38 insertions(+), 4 deletions(-)

diff -puN drivers/input/misc/uinput.c~uinput-flush-all-pending-ff-effects-before-destroying-device drivers/input/misc/uinput.c
--- a/drivers/input/misc/uinput.c~uinput-flush-all-pending-ff-effects-before-destroying-device
+++ a/drivers/input/misc/uinput.c
@@ -62,6 +62,9 @@ static int uinput_request_alloc_id(struc
 
 	spin_lock(&udev->requests_lock);
 
+	if (unlikely(udev->requests_flushed))
+		goto out;
+
 	for (id = 0; id < UINPUT_NUM_REQUESTS; id++)
 		if (!udev->requests[id]) {
 			request->id = id;
@@ -70,6 +73,7 @@ static int uinput_request_alloc_id(struc
 			break;
 		}
 
+out:
 	spin_unlock(&udev->requests_lock);
 	return err;
 }
@@ -109,6 +113,34 @@ static int uinput_request_submit(struct 
 	return request->retval;
 }
 
+static inline void uinput_init_requests(struct uinput_device *udev)
+{
+	spin_lock_init(&udev->requests_lock);
+	init_waitqueue_head(&udev->requests_waitq);
+	udev->requests_flushed = 0;
+}
+
+static void uinput_flush_requests(struct uinput_device *udev)
+{
+	struct uinput_request *request;
+	int id;
+
+	/*
+	 * get rid of all pending requests and set requests_flushed to prevent
+	 * more requests to be filled until we unregister the input device
+	 */
+	spin_lock(&udev->requests_lock);
+	udev->requests_flushed = 1;
+	for (id = 0; id < UINPUT_NUM_REQUESTS; id++) {
+		request = udev->requests[id];
+		if (request == NULL)
+			continue;
+		request->retval = -ENODEV;
+		uinput_request_done(udev, request);
+	}
+	spin_unlock(&udev->requests_lock);
+}
+
 static void uinput_dev_set_gain(struct input_dev *dev, u16 gain)
 {
 	uinput_dev_event(dev, EV_FF, FF_GAIN, gain);
@@ -180,9 +212,11 @@ static void uinput_destroy_device(struct
 	if (udev->dev) {
 		name = udev->dev->name;
 		phys = udev->dev->phys;
-		if (udev->state == UIST_CREATED)
+		if (udev->state == UIST_CREATED) {
+			uinput_flush_requests(udev);
 			input_unregister_device(udev->dev);
-		else
+			uinput_init_requests(udev);
+		} else
 			input_free_device(udev->dev);
 		kfree(name);
 		kfree(phys);
@@ -237,8 +271,7 @@ static int uinput_open(struct inode *ino
 
 	lock_kernel();
 	mutex_init(&newdev->mutex);
-	spin_lock_init(&newdev->requests_lock);
-	init_waitqueue_head(&newdev->requests_waitq);
+	uinput_init_requests(newdev);
 	init_waitqueue_head(&newdev->waitq);
 	newdev->state = UIST_NEW_DEVICE;
 
diff -puN include/linux/uinput.h~uinput-flush-all-pending-ff-effects-before-destroying-device include/linux/uinput.h
--- a/include/linux/uinput.h~uinput-flush-all-pending-ff-effects-before-destroying-device
+++ a/include/linux/uinput.h
@@ -74,6 +74,7 @@ struct uinput_device {
 	struct uinput_request	*requests[UINPUT_NUM_REQUESTS];
 	wait_queue_head_t	requests_waitq;
 	spinlock_t		requests_lock;
+	int			requests_flushed;
 };
 #endif	/* __KERNEL__ */
 
_

Patches currently in -mm which might be from aris@ruivo.org are

linux-next.patch

