From: akpm@linux-foundation.org
Subject: + um-fix-oopsable-race-in-line_close.patch added to -mm tree
Date: Mon, 29 Aug 2011 14:35:39 -0700
Message-ID: <201108292135.p7TLZd0X030262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755084Ab1H2VgU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 17:36:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viro@ftp.linux.org.uk, richard@nod.at, viro@zeniv.linux.org.uk


The patch titled
     um: fix oopsable race in line_close()
has been added to the -mm tree.  Its filename is
     um-fix-oopsable-race-in-line_close.patch

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
Subject: um: fix oopsable race in line_close()
From: Al Viro <viro@ftp.linux.org.uk>

tty->count is decremented only after ->close() had been called and several
tasks can hit it in parallel.  As the result, using tty->count to check if
you are the last one is broken.  We end up leaving line->tty not reset to
NULL and the next IRQ on that sucker will blow up trying to dereference
pointers from kfree'd struct tty.

Fix is obvious: we need to use a counter of our own.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c        |   25 ++++++++++++-------------
 arch/um/include/shared/line.h |    1 +
 2 files changed, 13 insertions(+), 13 deletions(-)

diff -puN arch/um/drivers/line.c~um-fix-oopsable-race-in-line_close arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~um-fix-oopsable-race-in-line_close
+++ a/arch/um/drivers/line.c
@@ -399,8 +399,8 @@ int line_setup_irq(int fd, int input, in
  * is done under a spinlock.  Checking whether the device is in use is
  * line->tty->count > 1, also under the spinlock.
  *
- * tty->count serves to decide whether the device should be enabled or
- * disabled on the host.  If it's equal to 1, then we are doing the
+ * line->count serves to decide whether the device should be enabled or
+ * disabled on the host.  If it's equal to 0, then we are doing the
  * first open or last close.  Otherwise, open and close just return.
  */
 
@@ -414,16 +414,16 @@ int line_open(struct line *lines, struct
 		goto out_unlock;
 
 	err = 0;
-	if (tty->count > 1)
+	if (line->count++)
 		goto out_unlock;
 
-	spin_unlock(&line->count_lock);
-
+	BUG_ON(tty->driver_data);
 	tty->driver_data = line;
 	line->tty = tty;
 
+	spin_unlock(&line->count_lock);
 	err = enable_chan(line);
-	if (err)
+	if (err) /* line_close() will be called by our caller */
 		return err;
 
 	INIT_DELAYED_WORK(&line->task, line_timer_cb);
@@ -436,7 +436,7 @@ int line_open(struct line *lines, struct
 	chan_window_size(&line->chan_list, &tty->winsize.ws_row,
 			 &tty->winsize.ws_col);
 
-	return err;
+	return 0;
 
 out_unlock:
 	spin_unlock(&line->count_lock);
@@ -460,17 +460,16 @@ void line_close(struct tty_struct *tty, 
 	flush_buffer(line);
 
 	spin_lock(&line->count_lock);
-	if (!line->valid)
-		goto out_unlock;
+	BUG_ON(!line->valid);
 
-	if (tty->count > 1)
+	if (--line->count)
 		goto out_unlock;
 
-	spin_unlock(&line->count_lock);
-
 	line->tty = NULL;
 	tty->driver_data = NULL;
 
+	spin_unlock(&line->count_lock);
+
 	if (line->sigio) {
 		unregister_winch(tty);
 		line->sigio = 0;
@@ -498,7 +497,7 @@ static int setup_one_line(struct line *l
 
 	spin_lock(&line->count_lock);
 
-	if (line->tty != NULL) {
+	if (line->count) {
 		*error_out = "Device is already open";
 		goto out;
 	}
diff -puN arch/um/include/shared/line.h~um-fix-oopsable-race-in-line_close arch/um/include/shared/line.h
--- a/arch/um/include/shared/line.h~um-fix-oopsable-race-in-line_close
+++ a/arch/um/include/shared/line.h
@@ -33,6 +33,7 @@ struct line_driver {
 struct line {
 	struct tty_struct *tty;
 	spinlock_t count_lock;
+	unsigned long count;
 	int valid;
 
 	char *init_str;
_

Patches currently in -mm which might be from viro@ftp.linux.org.uk are

um-fix-oopsable-race-in-line_close.patch
um-winch_interrupt-can-happen-inside-of-free_winch.patch
um-fix-free_winch-mess.patch
um-ptrace_etfpxregs-had-been-wired-on-the-wrong-subarch.patch
um-fix-strrchr-problems.patch
um-clean-arch_ptrace-up-a-bit.patch
slab-leaks3-default-y.patch

