From: akpm@linux-foundation.org
Subject: [merged] um-remove-file-pointer-from-ioctl.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:38:23 -0700
Message-ID: <201103232042.p2NKfxSO028704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933344Ab1CWUze (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:55:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, alan@lxorguk.ukuu.org.uk, greg@kroah.com, jdike@addtoit.com, mm-commits@vger.kernel.org


The patch titled
     um: remove file pointer from ioctl
has been removed from the -mm tree.  Its filename was
     um-remove-file-pointer-from-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: remove file pointer from ioctl
From: Richard Weinberger <richard@nod.at>

Commit 6caa76b ("tty: now phase out the ioctl file pointer for good")
removed the ioctl file pointer.  User Mode Linux's line driver uses this
ioctl and needs a signature update too.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/drivers/line.c        |    4 ++--
 arch/um/include/shared/line.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/um/drivers/line.c~um-remove-file-pointer-from-ioctl arch/um/drivers/line.c
--- a/arch/um/drivers/line.c~um-remove-file-pointer-from-ioctl
+++ a/arch/um/drivers/line.c
@@ -255,8 +255,8 @@ static const struct {
 	{ KDSIGACCEPT, KERN_INFO,  "KDSIGACCEPT" },
 };
 
-int line_ioctl(struct tty_struct *tty, struct file * file,
-	       unsigned int cmd, unsigned long arg)
+int line_ioctl(struct tty_struct *tty, unsigned int cmd,
+				unsigned long arg)
 {
 	int ret;
 	int i;
diff -puN arch/um/include/shared/line.h~um-remove-file-pointer-from-ioctl arch/um/include/shared/line.h
--- a/arch/um/include/shared/line.h~um-remove-file-pointer-from-ioctl
+++ a/arch/um/include/shared/line.h
@@ -77,8 +77,8 @@ extern int line_chars_in_buffer(struct t
 extern void line_flush_buffer(struct tty_struct *tty);
 extern void line_flush_chars(struct tty_struct *tty);
 extern int line_write_room(struct tty_struct *tty);
-extern int line_ioctl(struct tty_struct *tty, struct file * file,
-		      unsigned int cmd, unsigned long arg);
+extern int line_ioctl(struct tty_struct *tty, unsigned int cmd,
+				unsigned long arg);
 extern void line_throttle(struct tty_struct *tty);
 extern void line_unthrottle(struct tty_struct *tty);
 
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
sysctl-restrict-write-access-to-dmesg_restrict.patch

