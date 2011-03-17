From: akpm@linux-foundation.org
Subject: + um-remove-file-pointer-from-ioctl.patch added to -mm tree
Date: Thu, 17 Mar 2011 15:35:46 -0700
Message-ID: <201103172235.p2HMZkv2015011@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754180Ab1CQWgd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Mar 2011 18:36:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@nod.at, alan@lxorguk.ukuu.org.uk, greg@kroah.com, jdike@addtoit.com


The patch titled
     um: remove file pointer from ioctl
has been added to the -mm tree.  Its filename is
     um-remove-file-pointer-from-ioctl.patch

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
um-remove-file-pointer-from-ioctl.patch
sysctl-restrict-write-access-to-dmesg_restrict.patch

