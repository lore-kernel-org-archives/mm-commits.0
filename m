From: akpm@osdl.org
Subject: + uml-fix-previous-console-locking.patch added to -mm tree
Date: Fri, 05 Jan 2007 12:13:29 -0800
Message-ID: <200701052013.l05KDTVC031087@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57169 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbXAEUNc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 5 Jan 2007 15:13:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: fix previous console locking
has been added to the -mm tree.  Its filename is
     uml-fix-previous-console-locking.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: fix previous console locking
From: Jeff Dike <jdike@addtoit.com>

Eliminate the open_mutex after complaints from Blaisorblade.  It turns out
that the tty count provides the information needed to tell whether we are the
first opener or last closer.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/drivers/line.c |   48 ++++++---------------------------------
 arch/um/include/line.h |    1 
 2 files changed, 8 insertions(+), 41 deletions(-)

diff -puN arch/um/drivers/line.c~uml-fix-previous-console-locking arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-fix-previous-console-locking
+++ a/arch/um/drivers/line.c
@@ -425,42 +425,15 @@ int line_setup_irq(int fd, int input, in
  * However, in this case, mconsole requests can come in "from the
  * side", and race with opens and closes.
  *
- * The problem comes from line_setup not wanting to sleep if
- * the device is open or being opened.  This can happen because the
- * first opener of a device is responsible for setting it up on the
- * host, and that can sleep.  The open of a port device will sleep
- * until someone telnets to it.
+ * mconsole config requests will want to be sure the device isn't in
+ * use, and get_config, open, and close will want a stable
+ * configuration.  The checking and modification of the configuration
+ * is done under a spinlock.  Checking whether the device is in use is
+ * line->tty->count > 1, also under the spinlock.
  *
- * The obvious solution of putting everything under a mutex fails
- * because then trying (and failing) to change the configuration of an
- * open(ing) device will block until the open finishes.  The right
- * thing to happen is for it to fail immediately.
- *
- * We can put the opening (and closing) of the host device under a
- * separate lock, but that has to be taken before the count lock is
- * released.  Otherwise, you open a window in which another open can
- * come through and assume that the host side is opened and working.
- *
- * So, if the tty count is one, open will take the open mutex
- * inside the count lock.  Otherwise, it just returns. This will sleep
- * if the last close is pending, and will block a setup or get_config,
- * but that should not last long.
- *
- * So, what we end up with is that open and close take the count lock.
- * If the first open or last close are happening, then the open mutex
- * is taken inside the count lock and the host opening or closing is done.
- *
- * setup and get_config only take the count lock.  setup modifies the
- * device configuration only if the open count is zero.  Arbitrarily
- * long blocking of setup doesn't happen because something would have to be
- * waiting for an open to happen.  However, a second open with
- * tty->count == 1 can't happen, and a close can't happen until the open
- * had finished.
- *
- * We can't maintain our own count here because the tty layer doesn't
- * match opens and closes.  It will call close if an open failed, and
- * a tty hangup will result in excess closes.  So, we rely on
- * tty->count instead.  It is one on both the first open and last close.
+ * tty->count serves to decide whether the device should be enabled or
+ * disabled on the host.  If it's equal to 1, then we are doing the
+ * first open or last close.  Otherwise, open and close just return.
  */
 
 int line_open(struct line *lines, struct tty_struct *tty)
@@ -476,7 +449,6 @@ int line_open(struct line *lines, struct
 	if(tty->count > 1)
 		goto out_unlock;
 
-	mutex_lock(&line->open_mutex);
 	spin_unlock(&line->count_lock);
 
 	tty->driver_data = line;
@@ -493,7 +465,6 @@ int line_open(struct line *lines, struct
 	chan_window_size(&line->chan_list, &tty->winsize.ws_row,
 			 &tty->winsize.ws_col);
 
-	mutex_unlock(&line->open_mutex);
 	return err;
 
 out_unlock:
@@ -523,7 +494,6 @@ void line_close(struct tty_struct *tty, 
 	if(tty->count > 1)
 		goto out_unlock;
 
-	mutex_lock(&line->open_mutex);
 	spin_unlock(&line->count_lock);
 
 	line->tty = NULL;
@@ -534,7 +504,6 @@ void line_close(struct tty_struct *tty, 
 		line->sigio = 0;
         }
 
-	mutex_unlock(&line->open_mutex);
 	return;
 
 out_unlock:
@@ -755,7 +724,6 @@ void lines_init(struct line *lines, int 
 	for(i = 0; i < nlines; i++){
 		line = &lines[i];
 		INIT_LIST_HEAD(&line->chan_list);
-		mutex_init(&line->open_mutex);
 
 		if(line->init_str == NULL)
 			continue;
diff -puN arch/um/include/line.h~uml-fix-previous-console-locking arch/um/include/line.h
--- a/arch/um/include/line.h~uml-fix-previous-console-locking
+++ a/arch/um/include/line.h
@@ -35,7 +35,6 @@ struct line {
 	spinlock_t count_lock;
 	int valid;
 
-	struct mutex open_mutex;
 	char *init_str;
 	int init_pri;
 	struct list_head chan_list;
_

Patches currently in -mm which might be from jdike@addtoit.com are

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
