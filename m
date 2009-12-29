From: akpm@linux-foundation.org
Subject: [merged] char-mxser-remove-unnecessary-tty-test.patch removed from -mm tree
Date: Tue, 29 Dec 2009 13:33:45 -0800
Message-ID: <200912292133.nBTLXjdb008726@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751670AbZL2VeL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Dec 2009 16:34:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     char: mxser, remove unnecessary tty test
has been removed from the -mm tree.  Its filename was
     char-mxser-remove-unnecessary-tty-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: char: mxser, remove unnecessary tty test
From: Jiri Slaby <jirislaby@gmail.com>

Stanse found unnecessary test in mxser_startup.

tty is dereferenced earlier, the test is superfluous. Remove it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mxser.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/mxser.c~char-mxser-remove-unnecessary-tty-test drivers/char/mxser.c
--- a/drivers/char/mxser.c~char-mxser-remove-unnecessary-tty-test
+++ a/drivers/char/mxser.c
@@ -895,8 +895,7 @@ static int mxser_activate(struct tty_por
 	if (inb(info->ioaddr + UART_LSR) == 0xff) {
 		spin_unlock_irqrestore(&info->slock, flags);
 		if (capable(CAP_SYS_ADMIN)) {
-			if (tty)
-				set_bit(TTY_IO_ERROR, &tty->flags);
+			set_bit(TTY_IO_ERROR, &tty->flags);
 			return 0;
 		} else
 			return -ENODEV;
_

Patches currently in -mm which might be from jirislaby@gmail.com are

linux-next.patch
scsi-aacraid-fix-memory-leak.patch
scsi-remove-unnecessary-null-test.patch
scsi-lpfc-fix-memory-leak.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

