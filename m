From: akpm@linux-foundation.org
Subject: + tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously.patch added to -mm tree
Date: Tue, 18 Aug 2009 16:06:58 -0700
Message-ID: <200908182306.n7IN6xw9026301@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751919AbZHRXHJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Aug 2009 19:07:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@linux.intel.com, alan@lxorguk.ukuu.org.uk, benisty.e@gmail.com, greg@kroah.com, hidave.darkstar@gmail.com, rjw@sisk.pl


The patch titled
     tty: fix regression caused by "tty: make the kref destructor occur asynchronously"
has been added to the -mm tree.  Its filename is
     tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously.patch

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
Subject: tty: fix regression caused by "tty: make the kref destructor occur asynchronously"


The following commit make console open fails while booting:

	commit d966976924119acd35a431adbb95292082f73f8c
	Author: Alan Cox <alan@linux.intel.com>
	Date:   Tue Aug 11 10:23:05 2009 +1000

	tty: make the kref destructor occur asynchronously

Due to tty release routines runs in workqueue now, error like following
will be reported while booting:

INIT open /dev/console Input/output error

The reason is that now there's latency issue with closing, but when we
open a "closing not finished" tty, -EIO will be returned.

Fix it as alan's following suggestion:

Fun but its actually not a bug and the fix is wrong in itself as the port
may be closing but not yet being destructed, in which case it seems to do
the wrong thing.  Opening a tty that is closing (and could be closing for
long periods) is supposed to return -EIO.

I suspect a better way to deal with this and keep the old console timing
is to split tty->shutdown into two functions.

tty->shutdown() - called synchronously just before we dump the tty onto
the waitqueue for destruction

tty->cleanup() - called when the destructor runs.

We would then do the shutdown part which can occur in IRQ context fine,
before queueing the rest of the release (from tty->magic = 0 ...  the end)
to occur asynchronously

The USB update in -next would then need a call like

       if (tty->cleanup)
               tty->cleanup(tty);

at the top of the async function and the USB shutdown to be split between
shutdown and cleanup as the USB resource cleanup and final tidy cannot
occur synchronously as it needs to sleep.

In other words the logic becomes

       final kref put
               make object unfindable

       async
               clean it up

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Emmanuel Benisty <benisty.e@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c           |   15 ++++++++++-----
 drivers/usb/serial/usb-serial.c |    2 +-
 include/linux/tty_driver.h      |   13 +++++++++++--
 3 files changed, 22 insertions(+), 8 deletions(-)

diff -puN drivers/char/tty_io.c~tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously
+++ a/drivers/char/tty_io.c
@@ -1389,7 +1389,7 @@ EXPORT_SYMBOL(tty_shutdown);
  *	of ttys that the driver keeps.
  *
  *	This method gets called from a work queue so that the driver private
- *	shutdown ops can sleep (needed for USB at least)
+ *	cleanup ops can sleep (needed for USB at least)
  */
 static void release_one_tty(struct work_struct *work)
 {
@@ -1397,10 +1397,9 @@ static void release_one_tty(struct work_
 		container_of(work, struct tty_struct, hangup_work);
 	struct tty_driver *driver = tty->driver;
 
-	if (tty->ops->shutdown)
-		tty->ops->shutdown(tty);
-	else
-		tty_shutdown(tty);
+	if (tty->ops->cleanup)
+		tty->ops->cleanup(tty);
+
 	tty->magic = 0;
 	tty_driver_kref_put(driver);
 	module_put(driver->owner);
@@ -1415,6 +1414,12 @@ static void release_one_tty(struct work_
 static void queue_release_one_tty(struct kref *kref)
 {
 	struct tty_struct *tty = container_of(kref, struct tty_struct, kref);
+
+	if (tty->ops->shutdown)
+		tty->ops->shutdown(tty);
+	else
+		tty_shutdown(tty);
+
 	/* The hangup queue is now free so we can reuse it rather than
 	   waste a chunk of memory for each port */
 	INIT_WORK(&tty->hangup_work, release_one_tty);
diff -puN drivers/usb/serial/usb-serial.c~tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously drivers/usb/serial/usb-serial.c
--- a/drivers/usb/serial/usb-serial.c~tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously
+++ a/drivers/usb/serial/usb-serial.c
@@ -1269,7 +1269,7 @@ static const struct tty_operations seria
 	.chars_in_buffer =	serial_chars_in_buffer,
 	.tiocmget =		serial_tiocmget,
 	.tiocmset =		serial_tiocmset,
-	.shutdown = 		serial_do_free,
+	.cleanup = 		serial_do_free,
 	.install = 		serial_install,
 	.proc_fops =		&serial_proc_fops,
 };
diff -puN include/linux/tty_driver.h~tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously include/linux/tty_driver.h
--- a/include/linux/tty_driver.h~tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously
+++ a/include/linux/tty_driver.h
@@ -45,8 +45,16 @@
  *
  * void (*shutdown)(struct tty_struct * tty);
  *
- * 	This routine is called when a particular tty device is closed for
- *	the last time freeing up the resources.
+ * 	This routine is called synchronously when a particular tty device
+ *	is closed for the last time freeing up the resources.
+ *
+ *
+ * void (*cleanup)(struct tty_struct * tty);
+ *
+ *	This routine is called asynchronously when a particular tty device
+ *	is closed for the last time freeing up the resources. This is
+ *	actually the second part of shutdown for routines that might sleep.
+ *
  *
  * int (*write)(struct tty_struct * tty,
  * 		 const unsigned char *buf, int count);
@@ -233,6 +241,7 @@ struct tty_operations {
 	int  (*open)(struct tty_struct * tty, struct file * filp);
 	void (*close)(struct tty_struct * tty, struct file * filp);
 	void (*shutdown)(struct tty_struct *tty);
+	void (*cleanup)(struct tty_struct *tty);
 	int  (*write)(struct tty_struct * tty,
 		      const unsigned char *buf, int count);
 	int  (*put_char)(struct tty_struct *tty, unsigned char ch);
_

Patches currently in -mm which might be from alan@linux.intel.com are

linux-next.patch
tty-fix-regression-caused-by-tty-make-the-kref-destructor-occur-asynchronously.patch
scripts-get_maintainerpl-add-remove-duplicates.patch

