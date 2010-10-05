From: akpm@linux-foundation.org
Subject: + vcs-add-poll-fasync-support-update.patch added to -mm tree
Date: Tue, 05 Oct 2010 12:35:39 -0700
Message-ID: <201010051935.o95JZdwt015411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40558 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754976Ab0JETfo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Oct 2010 15:35:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nico@fluxnic.net, alan@linux.intel.com, greg@kroah.com, nicolas.pitre@canonical.com


The patch titled
     vcs-add-poll-fasync-support-update
has been added to the -mm tree.  Its filename is
     vcs-add-poll-fasync-support-update.patch

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
Subject: vcs-add-poll-fasync-support-update
From: Nicolas Pitre <nico@fluxnic.net>

The /dev/vcs* devices are used, amongst other things, by accessibility
applications such as BRLTTY to display the screen content onto refreshable
braille displays.  Currently this is performed by constantly reading from
/dev/vcsa0 whether or not the screen content has changed.  Given the
default braille refresh rate of 25 times per second, this easily qualifies
as the biggest source of wake-up events preventing laptops from entering
deeper power saving states.

To avoid this periodic polling, let's add support for select()/poll() and
SIGIO with the /dev/vcs* devices.  The implemented semantic is to report
data availability whenever the corresponding vt has seen some update after
the last read() operation.  The application still has to lseek() back
as usual in order to read() the new data.

Not to create unwanted overhead, the needed data structure is allocated
and the vt notification callback is registered only when the poll or
fasync method is invoked for the first time per file instance.

Signed-off-by: Nicolas Pitre <nicolas.pitre@canonical.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/vc_screen.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff -puN drivers/char/vc_screen.c~vcs-add-poll-fasync-support-update drivers/char/vc_screen.c
--- a/drivers/char/vc_screen.c~vcs-add-poll-fasync-support-update
+++ a/drivers/char/vc_screen.c
@@ -27,7 +27,6 @@
 #include <linux/tty.h>
 #include <linux/interrupt.h>
 #include <linux/mm.h>
-#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/vt_kern.h>
@@ -37,10 +36,11 @@
 #include <linux/device.h>
 #include <linux/smp_lock.h>
 #include <linux/sched.h>
-#include <linux/notifier.h>
+#include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/signal.h>
 #include <linux/slab.h>
+#include <linux/notifier.h>
 
 #include <asm/uaccess.h>
 #include <asm/byteorder.h>
@@ -54,7 +54,7 @@
 struct vcs_poll_data {
 	struct notifier_block notifier;
 	unsigned int cons_num;
-	int has_read;
+	bool seen_last_update;
 	wait_queue_head_t waitq;
 	struct fasync_struct *fasync;
 };
@@ -78,7 +78,7 @@ vcs_notifier(struct notifier_block *nb, 
 	if (currcons != vc->vc_num)
 		return NOTIFY_DONE;
 
-	poll->has_read = 0;
+	poll->seen_last_update = false;
 	wake_up_interruptible(&poll->waitq);
 	kill_fasync(&poll->fasync, SIGIO, POLL_IN);
 	return NOTIFY_OK;
@@ -110,6 +110,14 @@ vcs_poll_data_get(struct file *file)
 		return NULL;
 	}
 
+	/*
+	 * This code may be called either through ->poll() or ->fasync().
+	 * If we have two threads using the same file descriptor, they could
+	 * both enter this function, both notice that the structure hasn't
+	 * been allocated yet and go ahead allocating it in parallel, but
+	 * only one of them must survive and be shared otherwise we'd leak
+	 * memory with a dangling notifier callback.
+	 */
 	spin_lock(&file->f_lock);
 	if (!file->private_data) {
 		file->private_data = poll;
@@ -215,7 +223,7 @@ vcs_read(struct file *file, char __user 
 		goto unlock_out;
 	poll = file->private_data;
 	if (count && poll)
-		poll->has_read = 1;
+		poll->seen_last_update = true;
 	read = 0;
 	ret = 0;
 	while (count) {
@@ -547,7 +555,7 @@ vcs_poll(struct file *file, poll_table *
 
 	if (poll) {
 		poll_wait(file, &poll->waitq, wait);
-		if (!poll->has_read)
+		if (!poll->seen_last_update)
 			ret = POLLIN | POLLRDNORM;
 	}
 	return ret;
_

Patches currently in -mm which might be from nico@fluxnic.net are

linux-next.patch
vcs-add-poll-fasync-support.patch
vcs-add-poll-fasync-support-fix.patch
vcs-add-poll-fasync-support-fix-fix.patch
vcs-add-poll-fasync-support-update.patch
vcs-invoke-the-vt-update-callback-when-dev-vcs-is-written-to.patch

