From: akpm@linux-foundation.org
Subject: + drivers-char-specialixc-convert-func_enter-to-func_exit.patch added to -mm tree
Date: Tue, 08 Feb 2011 15:28:24 -0800
Message-ID: <201102082328.p18NSO4E031978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754091Ab1BHX2c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Feb 2011 18:28:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, R.E.Wolff@BitWizard.nl


The patch titled
     drivers/char/specialix.c: convert func_enter to func_exit
has been added to the -mm tree.  Its filename is
     drivers-char-specialixc-convert-func_enter-to-func_exit.patch

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
Subject: drivers/char/specialix.c: convert func_enter to func_exit
From: Julia Lawall <julia@diku.dk>

Convert calls to func_enter on leaving a function to func_exit.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

- func_enter();
+ func_exit();
  return...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Roger Wolff <R.E.Wolff@BitWizard.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/specialix.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/char/specialix.c~drivers-char-specialixc-convert-func_enter-to-func_exit drivers/char/specialix.c
--- a/drivers/char/specialix.c~drivers-char-specialixc-convert-func_enter-to-func_exit
+++ a/drivers/char/specialix.c
@@ -1416,7 +1416,7 @@ static int sx_open(struct tty_struct *tt
 				 board, bp, port, SX_PORT(tty->index));
 
 	if (sx_paranoia_check(port, tty->name, "sx_open")) {
-		func_enter();
+		func_exit();
 		return -ENODEV;
 	}
 
@@ -1435,13 +1435,13 @@ static int sx_open(struct tty_struct *tt
 
 	error = sx_setup_port(bp, port);
 	if (error) {
-		func_enter();
+		func_exit();
 		return error;
 	}
 
 	error = block_til_ready(tty, filp, port);
 	if (error) {
-		func_enter();
+		func_exit();
 		return error;
 	}
 
@@ -1860,7 +1860,7 @@ static int sx_set_serial_info(struct spe
 	func_enter();
 
 	if (copy_from_user(&tmp, newinfo, sizeof(tmp))) {
-		func_enter();
+		func_exit();
 		return -EFAULT;
 	}
 
_

Patches currently in -mm which might be from julia@diku.dk are

linux-next.patch
fs-btrfs-inodec-eliminate-memory-leak.patch
drivers-char-bfin_jtag_commc-avoid-calling-put_tty_driver-on-null.patch
drivers-char-specialixc-convert-func_enter-to-func_exit.patch
drivers-w1-masters-omap_hdqc-add-missing-clk_put.patch

