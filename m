From: akpm@linux-foundation.org
Subject: + char-mxser-remove-unnecessary-tty-test.patch added to -mm tree
Date: Wed, 30 Sep 2009 12:58:56 -0700
Message-ID: <200909301958.n8UJwu52026476@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58349 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755107AbZI3T7B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 15:59:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     char: mxser, remove unnecessary tty test
has been added to the -mm tree.  Its filename is
     char-mxser-remove-unnecessary-tty-test.patch

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
@@ -905,8 +905,7 @@ static int mxser_startup(struct tty_stru
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

char-vt_ioctl-fix-bkl-imbalance.patch
linux-next.patch
isdn-hisax-fix-lock-imbalance.patch
isdn-eicon-use-offsetof.patch
isdn-eicon-return-on-error.patch
qla2xxx-fix-null-ptr-dereference-in-fail-path-in-queue-create-code.patch
icom-converting-space-to-tabs.patch
cyclades-read-buffer-overflow.patch
serial167-fix-read-buffer-overflow.patch
cyclades-allow-overriding-isa-defaults-also-when-the-driver-is-built-in.patch
char-mxser-remove-unnecessary-tty-test.patch
reiser4.patch
fs-reiser4-add-parenths-around-x-y.patch

