From: akpm@linux-foundation.org
Subject: - uml-console-driver-cleanups.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:35:48 -0800
Message-ID: <200802052235.m15MZT7o012617@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60621 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762307AbYBEWla (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: console driver cleanups
has been removed from the -mm tree.  Its filename was
     uml-console-driver-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: console driver cleanups
From: Jeff Dike <jdike@addtoit.com>

Console driver cleanups -
	Changed an instance of foo = bar + foo to foo += bar
	Removed checks of tty->stopped - I don't think the low-level
driver has any business looking at that
	Removed an annoying warning

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff -puN arch/um/drivers/line.c~uml-console-driver-cleanups arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~uml-console-driver-cleanups
+++ a/arch/um/drivers/line.c
@@ -48,7 +48,7 @@ static int write_room(struct line *line)
 	n = line->head - line->tail;
 
 	if (n <= 0)
-		n = LINE_BUFSIZE + n; /* The other case */
+		n += LINE_BUFSIZE; /* The other case */
 	return n - 1;
 }
 
@@ -58,17 +58,10 @@ int line_write_room(struct tty_struct *t
 	unsigned long flags;
 	int room;
 
-	if (tty->stopped)
-		return 0;
-
 	spin_lock_irqsave(&line->lock, flags);
 	room = write_room(line);
 	spin_unlock_irqrestore(&line->lock, flags);
 
-	/*XXX: Warning to remove */
-	if (0 == room)
-		printk(KERN_DEBUG "%s: %s: no room left in buffer\n",
-		       __FUNCTION__,tty->name);
 	return room;
 }
 
@@ -79,8 +72,7 @@ int line_chars_in_buffer(struct tty_stru
 	int ret;
 
 	spin_lock_irqsave(&line->lock, flags);
-
-	/*write_room subtracts 1 for the needed NULL, so we readd it.*/
+	/* write_room subtracts 1 for the needed NULL, so we readd it.*/
 	ret = LINE_BUFSIZE - (write_room(line) + 1);
 	spin_unlock_irqrestore(&line->lock, flags);
 
@@ -184,10 +176,6 @@ void line_flush_buffer(struct tty_struct
 	unsigned long flags;
 	int err;
 
-	/*XXX: copied from line_write, verify if it is correct!*/
-	if (tty->stopped)
-		return;
-
 	spin_lock_irqsave(&line->lock, flags);
 	err = flush_buffer(line);
 	spin_unlock_irqrestore(&line->lock, flags);
@@ -213,9 +201,6 @@ int line_write(struct tty_struct *tty, c
 	unsigned long flags;
 	int n, ret = 0;
 
-	if (tty->stopped)
-		return 0;
-
 	spin_lock_irqsave(&line->lock, flags);
 	if (line->head != line->tail)
 		ret = buffer_data(line, buf, len);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
