From: akpm@linux-foundation.org
Subject: [merged] drivers-char-specialixc-convert-func_enter-to-func_exit.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:56 -0700
Message-ID: <201103250725.p2P7PoG0026079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38911 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933724Ab1CYHZ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, R.E.Wolff@BitWizard.nl, mm-commits@vger.kernel.org


The patch titled
     drivers/staging/tty/specialix.c: convert func_enter to func_exit
has been removed from the -mm tree.  Its filename was
     drivers-char-specialixc-convert-func_enter-to-func_exit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/staging/tty/specialix.c: convert func_enter to func_exit
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

 drivers/staging/tty/specialix.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/staging/tty/specialix.c~drivers-char-specialixc-convert-func_enter-to-func_exit drivers/staging/tty/specialix.c
--- a/drivers/staging/tty/specialix.c~drivers-char-specialixc-convert-func_enter-to-func_exit
+++ a/drivers/staging/tty/specialix.c
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

origin.patch
linux-next.patch
fs-btrfs-inodec-eliminate-memory-leak.patch

