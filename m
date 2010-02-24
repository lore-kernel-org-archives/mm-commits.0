From: akpm@linux-foundation.org
Subject: + pps-serial-clients-support-update.patch added to -mm tree
Date: Wed, 24 Feb 2010 14:42:33 -0800
Message-ID: <201002242242.o1OMgXpo024740@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757453Ab0BXWnL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 17:43:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: giometti@linux.it, alan@lxorguk.ukuu.org.uk, dwmw2@infradead.org, greg@kroah.com, lasaine@lvk.cs.msu.su


The patch titled
     pps-serial-clients-support-update
has been added to the -mm tree.  Its filename is
     pps-serial-clients-support-update.patch

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
Subject: pps-serial-clients-support-update
From: Rodolfo Giometti <giometti@linux.it>

Adds support, by using the PPS line discipline, for the PPS sources
connected with the CD (Carrier Detect) pin of a serial port.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <greg@kroah.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pps/clients/pps-ldisc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/pps/clients/pps-ldisc.c~pps-serial-clients-support-update drivers/pps/clients/pps-ldisc.c
--- a/drivers/pps/clients/pps-ldisc.c~pps-serial-clients-support-update
+++ a/drivers/pps/clients/pps-ldisc.c
@@ -114,8 +114,8 @@ static int __init pps_tty_init(void)
 	n_tty_inherit_ops(&pps_ldisc_ops);
 
 	/* Save N_TTY's open()/close() methods */
-	n_tty_open = pps_ldisc_ops.open;
-	n_tty_close = pps_ldisc_ops.close;
+	alias_n_tty_open = pps_ldisc_ops.open;
+	alias_n_tty_close = pps_ldisc_ops.close;
 
 	/* Init PPS_TTY data */
 	pps_ldisc_ops.owner = THIS_MODULE;
_

Patches currently in -mm which might be from giometti@linux.it are

linux-next.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-add-new-method-n_tty_inherit_ops.patch
ldisc-n_tty-add-new-method-n_tty_inherit_ops-update.patch
pps-serial-clients-support.patch
pps-serial-clients-support-update.patch
serial-8250-enable-pps-support.patch
serial-amba-pl010-enable-pps-support.patch

