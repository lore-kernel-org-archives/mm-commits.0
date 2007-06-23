From: akpm@linux-foundation.org
Subject: - tty-restore-locked-ioctl-file-op.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:26:53 -0700
Message-ID: <200706231926.l5NJQrHJ022011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46656 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752904AbXFWT1E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:27:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paulkf@microgate.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     tty: restore locked ioctl file op
has been removed from the -mm tree.  Its filename was
     tty-restore-locked-ioctl-file-op.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty: restore locked ioctl file op
From: Paul Fulghum <paulkf@microgate.com>

Restore tty locked ioctl handler which was replaced with
an unlocked ioctl handler in hung_up_tty_fops by the patch:

commit e10cc1df1d2014f68a4bdcf73f6dd122c4561f94
Author: Paul Fulghum <paulkf@microgate.com>
Date:   Thu May 10 22:22:50 2007 -0700

    tty: add compat_ioctl

This was reported in:
[Bug 8473] New: Oops: 0010 [1] SMP

The bug is caused by switching to hung_up_tty_fops in do_tty_hangup.  An
ioctl call can be waiting on BLK after testing for existence of the locked
ioctl handler in the normal tty fops, but before calling the locked ioctl
handler.  If a hangup occurs at that point, the locked ioctl fop is NULL
and an oops occurs.

(akpm: we can remove my debugging code from do_ioctl() now, but it'll be OK to
do that for 2.6.23)

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/tty_io.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN drivers/char/tty_io.c~tty-restore-locked-ioctl-file-op drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty-restore-locked-ioctl-file-op
+++ a/drivers/char/tty_io.c
@@ -1173,8 +1173,14 @@ static unsigned int hung_up_tty_poll(str
 	return POLLIN | POLLOUT | POLLERR | POLLHUP | POLLRDNORM | POLLWRNORM;
 }
 
-static long hung_up_tty_ioctl(struct file * file,
-			      unsigned int cmd, unsigned long arg)
+static int hung_up_tty_ioctl(struct inode * inode, struct file * file,
+			     unsigned int cmd, unsigned long arg)
+{
+	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
+}
+
+static long hung_up_tty_compat_ioctl(struct file * file,
+				     unsigned int cmd, unsigned long arg)
 {
 	return cmd == TIOCSPGRP ? -ENOTTY : -EIO;
 }
@@ -1222,8 +1228,8 @@ static const struct file_operations hung
 	.read		= hung_up_tty_read,
 	.write		= hung_up_tty_write,
 	.poll		= hung_up_tty_poll,
-	.unlocked_ioctl = hung_up_tty_ioctl,
-	.compat_ioctl	= hung_up_tty_ioctl,
+	.ioctl		= hung_up_tty_ioctl,
+	.compat_ioctl	= hung_up_tty_compat_ioctl,
 	.release	= tty_release,
 };
 
_

Patches currently in -mm which might be from paulkf@microgate.com are

char-n_hdlc-allow-restartsys-retval-of-tty-write.patch
audit-add-tty-input-auditing.patch
audit-add-tty-input-auditing-fix.patch
revert-vanishing-ioctl-handler-debugging.patch
