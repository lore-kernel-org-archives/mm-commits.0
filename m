From: akpm@linux-foundation.org
Subject: + floppy-use-wait_event_interruptible.patch added to -mm tree
Date: Mon, 14 Jun 2010 12:39:28 -0700
Message-ID: <201006141939.o5EJdSou026930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753774Ab0FNTjc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 15:39:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shemminger@vyatta.com, axboe@kernel.dk


The patch titled
     floppy: use wait_event_interruptible
has been added to the -mm tree.  Its filename is
     floppy-use-wait_event_interruptible.patch

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
Subject: floppy: use wait_event_interruptible
From: Stephen Hemminger <shemminger@vyatta.com>

Convert wait loops to use wait_event_ macros.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/floppy.c |   59 +++++----------------------------------
 1 file changed, 9 insertions(+), 50 deletions(-)

diff -puN drivers/block/floppy.c~floppy-use-wait_event_interruptible drivers/block/floppy.c
--- a/drivers/block/floppy.c~floppy-use-wait_event_interruptible
+++ a/drivers/block/floppy.c
@@ -514,8 +514,6 @@ static unsigned long fdc_busy;
 static DECLARE_WAIT_QUEUE_HEAD(fdc_wait);
 static DECLARE_WAIT_QUEUE_HEAD(command_done);
 
-#define NO_SIGNAL (!interruptible || !signal_pending(current))
-
 /* Errors during formatting are counted here. */
 static int format_errors;
 
@@ -858,36 +856,15 @@ static void set_fdc(int drive)
 }
 
 /* locks the driver */
-static int _lock_fdc(int drive, bool interruptible, int line)
+static int lock_fdc(int drive, bool interruptible)
 {
-	if (atomic_read(&usage_count) == 0) {
-		pr_err("Trying to lock fdc while usage count=0 at line %d\n",
-		       line);
+	if (WARN(atomic_read(&usage_count) == 0,
+		 "Trying to lock fdc while usage count=0\n"))
 		return -1;
-	}
 
-	if (test_and_set_bit(0, &fdc_busy)) {
-		DECLARE_WAITQUEUE(wait, current);
-		add_wait_queue(&fdc_wait, &wait);
-
-		for (;;) {
-			set_current_state(TASK_INTERRUPTIBLE);
-
-			if (!test_and_set_bit(0, &fdc_busy))
-				break;
-
-			schedule();
-
-			if (!NO_SIGNAL) {
-				remove_wait_queue(&fdc_wait, &wait);
-				return -EINTR;
-			}
-		}
+	if (wait_event_interruptible(fdc_wait, !test_and_set_bit(0, &fdc_busy)))
+		return -EINTR;
 
-		set_current_state(TASK_RUNNING);
-		remove_wait_queue(&fdc_wait, &wait);
-		flush_scheduled_work();
-	}
 	command_status = FD_COMMAND_NONE;
 
 	__reschedule_timeout(drive, "lock fdc");
@@ -895,9 +872,6 @@ static int _lock_fdc(int drive, bool int
 	return 0;
 }
 
-#define lock_fdc(drive, interruptible)			\
-	_lock_fdc(drive, interruptible, __LINE__)
-
 /* unlocks the driver */
 static void unlock_fdc(void)
 {
@@ -2015,25 +1989,10 @@ static int wait_til_done(void (*handler)
 
 	schedule_bh(handler);
 
-	if (command_status < 2 && NO_SIGNAL) {
-		DECLARE_WAITQUEUE(wait, current);
-
-		add_wait_queue(&command_done, &wait);
-		for (;;) {
-			set_current_state(interruptible ?
-					  TASK_INTERRUPTIBLE :
-					  TASK_UNINTERRUPTIBLE);
-
-			if (command_status >= 2 || !NO_SIGNAL)
-				break;
-
-			is_alive(__func__, "");
-			schedule();
-		}
-
-		set_current_state(TASK_RUNNING);
-		remove_wait_queue(&command_done, &wait);
-	}
+	if (interruptible)
+		wait_event_interruptible(command_done, command_status >= 2);
+	else
+		wait_event(command_done, command_status >= 2);
 
 	if (command_status < 2) {
 		cancel_activity();
_

Patches currently in -mm which might be from shemminger@vyatta.com are

linux-next.patch
floppy-initialize-debug-jiffies-offset.patch
floppy-remove-unnecessary-inlines.patch
floppy-silence-warning-during-disk-test.patch
floppy-use-atomic-type-for-usage_count.patch
floppy-cmos-attribute-should-be-static.patch
floppy-fix-signed-unsigned-warnings.patch
floppy-use-wait_event_interruptible.patch
floppy-use-warning-macros.patch
floppy-make-controller-const.patch

