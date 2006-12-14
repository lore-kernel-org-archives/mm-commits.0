From: akpm@osdl.org
Subject: - tty-remove-useless-memory-barrier.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:10:44 -0800
Message-ID: <200612140610.kBE6AhQD002024@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52202 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbWLNGLI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:11:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     tty: remove useless memory barrier
has been removed from the -mm tree.  Its filename was
     tty-remove-useless-memory-barrier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty: remove useless memory barrier
From: Ralf Baechle <ralf@linux-mips.org>

I don't see why there is a memory barrier in copy_from_read_buf() at all. 
Even if it was useful spin_unlock_irqrestore implies a barrier.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/n_tty.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/char/n_tty.c~tty-remove-useless-memory-barrier drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~tty-remove-useless-memory-barrier
+++ a/drivers/char/n_tty.c
@@ -1151,7 +1151,6 @@ static int copy_from_read_buf(struct tty
 	n = min(*nr, n);
 	spin_unlock_irqrestore(&tty->read_lock, flags);
 	if (n) {
-		mb();
 		retval = copy_to_user(*b, &tty->read_buf[tty->read_tail], n);
 		n -= retval;
 		spin_lock_irqsave(&tty->read_lock, flags);
_

Patches currently in -mm which might be from ralf@linux-mips.org are

fix-namespace-conflict-between-w9968cfc-on-mips.patch
make-lm70_remove-a-__devexit-function.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pci-legacy-resource-fix.patch
pci-legacy-resource-fix-tidy.patch
xfs-remove-useless-wmb-memory-barrier.patch

