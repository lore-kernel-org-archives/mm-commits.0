From: akpm@linux-foundation.org
Subject: - isicom-fix-buffer-allocation.patch removed from -mm tree
Date: Thu, 01 May 2008 02:30:56 -0700
Message-ID: <200805010930.m419UuDZ030813@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755625AbYEAJbe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alan@lxorguk.ukuu.org.uk, alan@redhat.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     isicom: fix buffer allocation
has been removed from the -mm tree.  Its filename was
     isicom-fix-buffer-allocation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: isicom: fix buffer allocation
From: Alan Cox <alan@lxorguk.ukuu.org.uk>

Fix the rather strange buffer management on open that turned up while auditing
for BKL dependencies.

Signed-off-by: Alan Cox <alan@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN drivers/char/isicom.c~isicom-fix-buffer-allocation drivers/char/isicom.c
--- a/drivers/char/isicom.c~isicom-fix-buffer-allocation
+++ a/drivers/char/isicom.c
@@ -813,15 +813,13 @@ static int isicom_setup_port(struct isi_
 		return 0;
 	if (!port->xmit_buf) {
 		/* Relies on BKL */
-		void *xmit_buf = (void *)get_zeroed_page(GFP_KERNEL);
-
-		if (xmit_buf == NULL)
+		unsigned long page  = get_zeroed_page(GFP_KERNEL);
+		if (page == 0)
 			return -ENOMEM;
-		if (port->xmit_buf) {
-			free_page((unsigned long)xmit_buf);
-			return -ERESTARTSYS;
-		}
-		port->xmit_buf = xmit_buf;
+		if (port->xmit_buf)
+			free_page(page);
+		else
+			port->xmit_buf = (unsigned char *) page;
 	}
 
 	spin_lock_irqsave(&card->card_lock, flags);
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

