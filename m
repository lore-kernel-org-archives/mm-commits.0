From: akpm@linux-foundation.org
Subject: + drivers-char-synclinkc-inbreak-mgsl_put_char.patch added to -mm tree
Date: Thu, 01 May 2008 03:33:24 -0700
Message-ID: <200805011033.m41AXO0Y000938@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252AbYEAKeY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 06:34:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, paulkf@microgate.com


The patch titled
     drivers/char/synclink.c: inbreak mgsl_put_char()
has been added to the -mm tree.  Its filename is
     drivers-char-synclinkc-inbreak-mgsl_put_char.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/synclink.c: inbreak mgsl_put_char()
From: Andrew Morton <akpm@linux-foundation.org>

Repair the effects of

commit 55da77899c1472d83452c914fa179d00ea96df65
Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date:   Wed Apr 30 00:54:07 2008 -0700

    synclink series: switch to int put_char method
    
    Signed-off-by: Alan Cox <alan@redhat.com>
    Cc: Paul Fulghum <paulkf@microgate.com>
    Cc: Jiri Slaby <jirislaby@gmail.com>

drivers/char/synclink_gt.c: In function 'put_char':
drivers/char/synclink_gt.c:919: warning: 'ret' may be used uninitialized in this function

and do some whitespace repair and unneeded-cast-removal in there as well.

Cc: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/synclink.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN drivers/char/synclink.c~drivers-char-synclinkc-inbreak-mgsl_put_char drivers/char/synclink.c
--- a/drivers/char/synclink.c~drivers-char-synclinkc-inbreak-mgsl_put_char
+++ a/drivers/char/synclink.c
@@ -2028,13 +2028,13 @@ static void mgsl_change_params(struct mg
  */
 static int mgsl_put_char(struct tty_struct *tty, unsigned char ch)
 {
-	struct mgsl_struct *info = (struct mgsl_struct *)tty->driver_data;
+	struct mgsl_struct *info = tty->driver_data;
 	unsigned long flags;
-	int ret;
+	int ret = 0;
 
-	if ( debug_level >= DEBUG_LEVEL_INFO ) {
-		printk( "%s(%d):mgsl_put_char(%d) on %s\n",
-			__FILE__,__LINE__,ch,info->device_name);
+	if (debug_level >= DEBUG_LEVEL_INFO) {
+		printk("%s(%d):mgsl_put_char(%d) on %s\n",
+			__FILE__, __LINE__, ch, info->device_name);
 	}		
 	
 	if (mgsl_paranoia_check(info, tty->name, "mgsl_put_char"))
@@ -2043,9 +2043,9 @@ static int mgsl_put_char(struct tty_stru
 	if (!tty || !info->xmit_buf)
 		return 0;
 
-	spin_lock_irqsave(&info->irq_spinlock,flags);
+	spin_lock_irqsave(&info->irq_spinlock, flags);
 	
-	if ( (info->params.mode == MGSL_MODE_ASYNC ) || !info->tx_active ) {
+	if ((info->params.mode == MGSL_MODE_ASYNC ) || !info->tx_active) {
 		if (info->xmit_cnt < SERIAL_XMIT_SIZE - 1) {
 			info->xmit_buf[info->xmit_head++] = ch;
 			info->xmit_head &= SERIAL_XMIT_SIZE-1;
@@ -2053,7 +2053,7 @@ static int mgsl_put_char(struct tty_stru
 			ret = 1;
 		}
 	}
-	spin_unlock_irqrestore(&info->irq_spinlock,flags);
+	spin_unlock_irqrestore(&info->irq_spinlock, flags);
 	return ret;
 	
 }	/* end of mgsl_put_char() */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
pnp-fix-printk-format-warnings.patch
drivers-char-synclinkc-inbreak-mgsl_put_char.patch

