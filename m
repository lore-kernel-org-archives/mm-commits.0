From: akpm@linux-foundation.org
Subject: + uml-console-driver-cleanups.patch added to -mm tree
Date: Mon, 05 Nov 2007 18:29:16 -0800
Message-ID: <200711060229.lA62TGZ1031851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755460AbXKFC3T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 21:29:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: console driver cleanups
has been added to the -mm tree.  Its filename is
     uml-console-driver-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

uml-correctly-strip-kernel-defines-from-userspace-cflags.patch
git-kvm.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
