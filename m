From: akpm@osdl.org
Subject: + tty-remove-useless-memory-barrier.patch added to -mm tree
Date: Sun, 10 Dec 2006 11:39:28 -0800
Message-ID: <200612101939.kBAJdSXO001113@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:54242 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762368AbWLJTjk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 10 Dec 2006 14:39:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ralf@linux-mips.org, alan@lxorguk.ukuu.org.uk


The patch titled
     tty: remove useless memory barrier
has been added to the -mm tree.  Its filename is
     tty-remove-useless-memory-barrier.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

origin.patch
sysctl-remove-unused-context-param.patch
dont-build-some-broken-isdn-drivers-on-big-endian-mips.patch
mips-dbg_io-stray-brackets-fix.patch
git-mtd.patch
git-net.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pci-legacy-resource-fix.patch
pci-legacy-resource-fix-tidy.patch
tty-remove-useless-memory-barrier.patch
getting-rid-of-all-casts-of-kalloc-calls.patch

