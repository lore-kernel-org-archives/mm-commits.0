From: akpm@linux-foundation.org
Subject: [merged] drivers-char-bfin_jtag_commc-avoid-calling-put_tty_driver-on-null.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:53 -0700
Message-ID: <201103250725.p2P7PlhD026076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933937Ab1CYHZ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, torbenh@gmx.de, mm-commits@vger.kernel.org


The patch titled
     drivers/tty/bfin_jtag_comm.c: avoid calling put_tty_driver on NULL
has been removed from the -mm tree.  Its filename was
     drivers-char-bfin_jtag_commc-avoid-calling-put_tty_driver-on-null.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/tty/bfin_jtag_comm.c: avoid calling put_tty_driver on NULL
From: Julia Lawall <julia@diku.dk>

put_tty_driver calls tty_driver_kref_put on its argument, and then
tty_driver_kref_put calls kref_put on the address of a field of this
argument.  kref_put checks for NULL, but in this case the field is likely
to have some offset and so the result of taking its address will not be
NULL.  Labels are added to be able to skip over the call to put_tty_driver
when the argument will be NULL.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression *x;
@@

*if (x == NULL)
{ ...
* put_tty_driver(x);
  ...
  return ...;
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Torben Hohn <torbenh@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/bfin_jtag_comm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/tty/bfin_jtag_comm.c~drivers-char-bfin_jtag_commc-avoid-calling-put_tty_driver-on-null drivers/tty/bfin_jtag_comm.c
--- a/drivers/tty/bfin_jtag_comm.c~drivers-char-bfin_jtag_commc-avoid-calling-put_tty_driver-on-null
+++ a/drivers/tty/bfin_jtag_comm.c
@@ -251,11 +251,11 @@ static int __init bfin_jc_init(void)
 	bfin_jc_write_buf.head = bfin_jc_write_buf.tail = 0;
 	bfin_jc_write_buf.buf = kmalloc(CIRC_SIZE, GFP_KERNEL);
 	if (!bfin_jc_write_buf.buf)
-		goto err;
+		goto err_buf;
 
 	bfin_jc_driver = alloc_tty_driver(1);
 	if (!bfin_jc_driver)
-		goto err;
+		goto err_driver;
 
 	bfin_jc_driver->owner        = THIS_MODULE;
 	bfin_jc_driver->driver_name  = DRV_NAME;
@@ -275,7 +275,9 @@ static int __init bfin_jc_init(void)
 
  err:
 	put_tty_driver(bfin_jc_driver);
+ err_driver:
 	kfree(bfin_jc_write_buf.buf);
+ err_buf:
 	kthread_stop(bfin_jc_kthread);
 	return ret;
 }
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
fs-btrfs-inodec-eliminate-memory-leak.patch

