From: akpm@linux-foundation.org
Subject: + serial167-kill-unused-variables.patch added to -mm tree
Date: Wed, 21 Apr 2010 16:46:38 -0700
Message-ID: <201004212346.o3LNkcsF016951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55387 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755697Ab0DUXrb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Apr 2010 19:47:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: geert@linux-m68k.org, alan@lxorguk.ukuu.org.uk, greg@kroah.com


The patch titled
     serial167: kill unused variables
has been added to the -mm tree.  Its filename is
     serial167-kill-unused-variables.patch

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
Subject: serial167: kill unused variables
From: Geert Uytterhoeven <geert@linux-m68k.org>

commits 638157bc1461f6718eeca06bedd9a09cf1f35c36 ("serial167: prepare to
push BKL down into drivers") and 4165fe4ef7305609a96c7f248cefb9c414d0ede5
("tty: Fix up char drivers request_room usage") removed code without
removing the corresponding variables:

| drivers/char/serial167.c: In function 'cd2401_rx_interrupt':
| drivers/char/serial167.c:630: warning: unused variable 'len'
| drivers/char/serial167.c: In function 'cy_ioctl':
| drivers/char/serial167.c:1531: warning: unused variable 'val'

Remove the variables to kill the warnings.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/serial167.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/char/serial167.c~serial167-kill-unused-variables drivers/char/serial167.c
--- a/drivers/char/serial167.c~serial167-kill-unused-variables
+++ a/drivers/char/serial167.c
@@ -627,7 +627,6 @@ static irqreturn_t cd2401_rx_interrupt(i
 	char data;
 	int char_count;
 	int save_cnt;
-	int len;
 
 	/* determine the channel and change to that context */
 	channel = (u_short) (base_addr[CyLICR] >> 2);
@@ -1528,7 +1527,6 @@ static int
 cy_ioctl(struct tty_struct *tty, struct file *file,
 	 unsigned int cmd, unsigned long arg)
 {
-	unsigned long val;
 	struct cyclades_port *info = tty->driver_data;
 	int ret_val = 0;
 	void __user *argp = (void __user *)arg;
_

Patches currently in -mm which might be from geert@linux-m68k.org are

linux-next.patch
serial167-kill-unused-variables.patch
endian-define-__byte_order.patch
m68k-use-asm-generic-scatterlisth.patch

