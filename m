From: akpm@linux-foundation.org
Subject: + 8250c-portlock-is-irq-safe.patch added to -mm tree
Date: Mon, 28 Jul 2008 23:53:59 -0700
Message-ID: <200807290653.m6T6rxxh019665@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751935AbYG2Gyq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 02:54:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: petkovbb@googlemail.com, alan@lxorguk.ukuu.org.uk, mingo@elte.hu, petkovbb@gmail.com


The patch titled
     8250.c: port.lock is irq-safe
has been added to the -mm tree.  Its filename is
     8250c-portlock-is-irq-safe.patch

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
Subject: 8250.c: port.lock is irq-safe
From: Borislav Petkov <petkovbb@googlemail.com>

serial8250_startup() doesn't disable interrupts while taking the &up->port.lock
which might race against the interrupt handler serial8250_interrupt(), which
when entered, will deadlock waiting for the lock to be released.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
Tested-by: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/serial/8250.c~8250c-portlock-is-irq-safe drivers/serial/8250.c
--- a/drivers/serial/8250.c~8250c-portlock-is-irq-safe
+++ a/drivers/serial/8250.c
@@ -1885,7 +1885,7 @@ static int serial8250_startup(struct uar
 		 * the interrupt is enabled.  Delays are necessary to
 		 * allow register changes to become visible.
 		 */
-		spin_lock(&up->port.lock);
+		spin_lock_irqsave(&up->port.lock, flags);
 		if (up->port.flags & UPF_SHARE_IRQ)
 			disable_irq_nosync(up->port.irq);
 
@@ -1901,7 +1901,7 @@ static int serial8250_startup(struct uar
 
 		if (up->port.flags & UPF_SHARE_IRQ)
 			enable_irq(up->port.irq);
-		spin_unlock(&up->port.lock);
+		spin_unlock_irqrestore(&up->port.lock, flags);
 
 		/*
 		 * If the interrupt is not reasserted, setup a timer to
_

Patches currently in -mm which might be from petkovbb@googlemail.com are

origin.patch
8250c-portlock-is-irq-safe.patch
cdrom-dont-check-cdc_play_audio-in-cdrom_count_tracks.patch

