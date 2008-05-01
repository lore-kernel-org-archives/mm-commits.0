From: akpm@linux-foundation.org
Subject: - ip2-switch-remaining-direct-call-of-ops-flush_buffer.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:00 -0700
Message-ID: <200805010931.m419V0Cm030820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755655AbYEAJbc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ip2: switch remaining direct call of ops->flush_buffer
has been removed from the -mm tree.  Its filename was
     ip2-switch-remaining-direct-call-of-ops-flush_buffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ip2: switch remaining direct call of ops->flush_buffer
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Signed-off-by: Alan Cox <alan@redhat.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/ip2/ip2main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/char/ip2/ip2main.c~ip2-switch-remaining-direct-call-of-ops-flush_buffer drivers/char/ip2/ip2main.c
--- a/drivers/char/ip2/ip2main.c~ip2-switch-remaining-direct-call-of-ops-flush_buffer
+++ a/drivers/char/ip2/ip2main.c
@@ -1616,9 +1616,8 @@ ip2_close( PTTY tty, struct file *pFile 
 
 	serviceOutgoingFifo ( pCh->pMyBord );
 
-	if ( tty->driver->ops->flush_buffer )
-		tty->driver->ops->flush_buffer(tty);
 	tty_ldisc_flush(tty);
+	tty_driver_flush_buffer(tty);
 	tty->closing = 0;
 	
 	pCh->pTTY = NULL;
_

Patches currently in -mm which might be from alan@lxorguk.ukuu.org.uk are

origin.patch
add-time_is_after_jiffies-and-others-which-compare-with-jiffies.patch
pata_atiixp-simplex-clear.patch
pata_atiixp-dont-disable.patch
8390-split-8390-support-into-a-pausing-and-a-non-pausing-driver-core.patch
parisc-new-termios-definitions.patch
generic-irq-let-setup_irq-reenable-a-shared-irq.patch
8250-switch-8250-drivers-to-use-_nocache-ioremaps.patch
sxc-fix-printk-warnings-on-sparc32.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

