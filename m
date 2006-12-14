From: akpm@osdl.org
Subject: - tty_ioc-balance-tty_ldisc_ref.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:12:58 -0800
Message-ID: <200612140613.kBE6CwUq002091@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52319 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbWLNGNY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:13:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: error27@gmail.com, alan@redhat.com, mm-commits@vger.kernel.org


The patch titled
     tty_io.c balance tty_ldisc_ref()
has been removed from the -mm tree.  Its filename was
     tty_ioc-balance-tty_ldisc_ref.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: tty_io.c balance tty_ldisc_ref()
From: Dan Carpenter <error27@gmail.com>

tty_ldisc_deref() should only be called when tty_ldisc_ref() succeeds
otherwise it triggers a BUG().  There's already a function
tty_ldisc_flush() that flushes properly.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/tty_io.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/char/tty_io.c~tty_ioc-balance-tty_ldisc_ref drivers/char/tty_io.c
--- a/drivers/char/tty_io.c~tty_ioc-balance-tty_ldisc_ref
+++ a/drivers/char/tty_io.c
@@ -3335,18 +3335,13 @@ static void __do_SAK(struct work_struct 
 	int session;
 	int		i;
 	struct file	*filp;
-	struct tty_ldisc *disc;
 	struct fdtable *fdt;
 	
 	if (!tty)
 		return;
 	session = tty->session;
 	
-	/* We don't want an ldisc switch during this */
-	disc = tty_ldisc_ref(tty);
-	if (disc && disc->flush_buffer)
-		disc->flush_buffer(tty);
-	tty_ldisc_deref(disc);
+	tty_ldisc_flush(tty);
 
 	if (tty->driver->flush_buffer)
 		tty->driver->flush_buffer(tty);
_

Patches currently in -mm which might be from error27@gmail.com are

git-alsa.patch

