From: akpm@linux-foundation.org
Subject: + usb-storage-fix-bugs-in-the-disconnect-pathway.patch added to -mm tree
Date: Fri, 17 Aug 2007 13:40:55 -0700
Message-ID: <200708172040.l7HKetPv028519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54064 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752692AbXHQUqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 16:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stern@rowland.harvard.edu, greg@kroah.com, mdharm-usb@one-eyed-alien.net


The patch titled
     usb-storage: fix bugs in the disconnect pathway
has been added to the -mm tree.  Its filename is
     usb-storage-fix-bugs-in-the-disconnect-pathway.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: usb-storage: fix bugs in the disconnect pathway
From: Alan Stern <stern@rowland.harvard.edu>

This patch (as961) fixes a couple of bugs in the disconnect pathway of
usb-storage.

The first problem, which apparently has been around for a while
although nobody noticed it, shows up when an aborted command is still
pending when a disconnect occurs.  The SCSI error-handler will
continue to wait in command_abort() until the us->notify completion is
signalled.  Thus quiesce_and_remove_host() needs to signal it.

The second problem was introduced recently along with autosuspend
support.  Since usb_stor_scan_thread() now calls
usb_autopm_put_interface() before exiting, we can't simply leave the
scanning thread running after a disconnect; we must wait until the
thread exits.  This is solved by adding a new struct completion to the
private data structure.  Fortuitously, it allows the removal of the
rather clunky mechanism used in the past to insure that all threads
have finished before the module is unloaded.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/usb.c |   33 ++++++---------------------------
 drivers/usb/storage/usb.h |    1 +
 2 files changed, 7 insertions(+), 27 deletions(-)

diff -puN drivers/usb/storage/usb.c~usb-storage-fix-bugs-in-the-disconnect-pathway drivers/usb/storage/usb.c
--- a/drivers/usb/storage/usb.c~usb-storage-fix-bugs-in-the-disconnect-pathway
+++ a/drivers/usb/storage/usb.c
@@ -112,13 +112,6 @@ module_param(delay_use, uint, S_IRUGO | 
 MODULE_PARM_DESC(delay_use, "seconds to delay before using a new device");
 
 
-/* These are used to make sure the module doesn't unload before all the
- * threads have exited.
- */
-static atomic_t total_threads = ATOMIC_INIT(0);
-static DECLARE_COMPLETION(threads_gone);
-
-
 /*
  * The entries in this table correspond, line for line,
  * with the entries of us_unusual_dev_list[].
@@ -879,9 +872,6 @@ static void quiesce_and_remove_host(stru
 	usb_stor_stop_transport(us);
 	wake_up(&us->delay_wait);
 
-	/* It doesn't matter if the SCSI-scanning thread is still running.
-	 * The thread will exit when it sees the DISCONNECTING flag. */
-
 	/* queuecommand won't accept any new commands and the control
 	 * thread won't execute a previously-queued command.  If there
 	 * is such a command pending, complete it with an error. */
@@ -891,12 +881,16 @@ static void quiesce_and_remove_host(stru
 		scsi_lock(host);
 		us->srb->scsi_done(us->srb);
 		us->srb = NULL;
+		complete(&us->notify);		/* in case of an abort */
 		scsi_unlock(host);
 	}
 	mutex_unlock(&us->dev_mutex);
 
 	/* Now we own no commands so it's safe to remove the SCSI host */
 	scsi_remove_host(host);
+
+	/* Wait for the SCSI-scanning thread to stop */
+	wait_for_completion(&us->scanning_done);
 }
 
 /* Second stage of disconnect processing: deallocate all resources */
@@ -947,9 +941,8 @@ retry:
 		/* Should we unbind if no devices were detected? */
 	}
 
-	scsi_host_put(us_to_host(us));
 	usb_autopm_put_interface(us->pusb_intf);
-	complete_and_exit(&threads_gone, 0);
+	complete_and_exit(&us->scanning_done, 0);
 }
 
 
@@ -984,6 +977,7 @@ static int storage_probe(struct usb_inte
 	init_MUTEX_LOCKED(&(us->sema));
 	init_completion(&(us->notify));
 	init_waitqueue_head(&us->delay_wait);
+	init_completion(&us->scanning_done);
 
 	/* Associate the us_data structure with the USB device */
 	result = associate_dev(us, intf);
@@ -1033,11 +1027,6 @@ static int storage_probe(struct usb_inte
 		goto BadDevice;
 	}
 
-	/* Take a reference to the host for the scanning thread and
-	 * count it among all the threads we have launched.  Then
-	 * start it up. */
-	scsi_host_get(us_to_host(us));
-	atomic_inc(&total_threads);
 	usb_autopm_get_interface(intf); /* dropped in the scanning thread */
 	wake_up_process(th);
 
@@ -1104,16 +1093,6 @@ static void __exit usb_stor_exit(void)
 	US_DEBUGP("-- calling usb_deregister()\n");
 	usb_deregister(&usb_storage_driver) ;
 
-	/* Don't return until all of our control and scanning threads
-	 * have exited.  Since each thread signals threads_gone as its
-	 * last act, we have to call wait_for_completion the right number
-	 * of times.
-	 */
-	while (atomic_read(&total_threads) > 0) {
-		wait_for_completion(&threads_gone);
-		atomic_dec(&total_threads);
-	}
-
 	usb_usual_clear_present(USB_US_TYPE_STOR);
 }
 
diff -puN drivers/usb/storage/usb.h~usb-storage-fix-bugs-in-the-disconnect-pathway drivers/usb/storage/usb.h
--- a/drivers/usb/storage/usb.h~usb-storage-fix-bugs-in-the-disconnect-pathway
+++ a/drivers/usb/storage/usb.h
@@ -150,6 +150,7 @@ struct us_data {
 	struct semaphore	sema;		 /* to sleep thread on	    */
 	struct completion	notify;		 /* thread begin/end	    */
 	wait_queue_head_t	delay_wait;	 /* wait during scan, reset */
+	struct completion	scanning_done;	 /* wait for scan thread    */
 
 	/* subdriver information */
 	void			*extra;		 /* Any extra data          */
_

Patches currently in -mm which might be from stern@rowland.harvard.edu are

sysfs-dont-warn-on-removal-of-a-nonexistent-binary-file.patch
usb-storage-fix-bugs-in-the-disconnect-pathway.patch
