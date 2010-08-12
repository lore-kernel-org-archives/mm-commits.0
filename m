From: akpm@linux-foundation.org
Subject: + ip2-remove-unneeded-null-check.patch added to -mm tree
Date: Thu, 12 Aug 2010 13:48:57 -0700
Message-ID: <201008122048.o7CKmvB4011929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754962Ab0HLUtB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Aug 2010 16:49:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, greg@kroah.com, mhw@wittsend.com


The patch titled
     ip2: remove unneeded NULL check
has been added to the -mm tree.  Its filename is
     ip2-remove-unneeded-null-check.patch

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
Subject: ip2: remove unneeded NULL check
From: Dan Carpenter <error27@gmail.com>

We don't pass NULL tty pointers to the close function, and anyway we
already dereferenced it at this point.  This check can be removed.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: "Michael H. Warfield" <mhw@wittsend.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/ip2main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/ip2/ip2main.c~ip2-remove-unneeded-null-check drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~ip2-remove-unneeded-null-check
+++ a/drivers/char/ip2/ip2main.c
@@ -1650,7 +1650,7 @@ ip2_close( PTTY tty, struct file *pFile 
 	/* disable DSS reporting */
 	i2QueueCommands(PTYPE_INLINE, pCh, 100, 4,
 				CMD_DCD_NREP, CMD_CTS_NREP, CMD_DSR_NREP, CMD_RI_NREP);
-	if ( !tty || (tty->termios->c_cflag & HUPCL) ) {
+	if (tty->termios->c_cflag & HUPCL) {
 		i2QueueCommands(PTYPE_INLINE, pCh, 100, 2, CMD_RTSDN, CMD_DTRDN);
 		pCh->dataSetOut &= ~(I2_DTR | I2_RTS);
 		i2QueueCommands( PTYPE_INLINE, pCh, 100, 1, CMD_PAUSE(25));
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
ip2-remove-unneeded-null-check.patch
ip2-return-efault-on-copy_to_user-errors.patch

