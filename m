From: akpm@linux-foundation.org
Subject: + cris-lower-the-printk-level-in-cris-serial-driver.patch added to -mm tree
Date: Fri, 02 Sep 2011 16:25:15 -0700
Message-ID: <201109022325.p82NPFr2016704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724Ab1IBXZ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2011 19:25:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, geert@linux-m68k.org, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris: lower the printk level in cris serial driver
has been added to the -mm tree.  Its filename is
     cris-lower-the-printk-level-in-cris-serial-driver.patch

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
Subject: cris: lower the printk level in cris serial driver
From: WANG Cong <xiyou.wangcong@gmail.com>

KERN_CRIT is too high, replace those KERN_CRIT with KERN_ERR or
KERN_WARNING.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/crisv10.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/tty/serial/crisv10.c~cris-lower-the-printk-level-in-cris-serial-driver drivers/tty/serial/crisv10.c
--- a/drivers/tty/serial/crisv10.c~cris-lower-the-printk-level-in-cris-serial-driver
+++ a/drivers/tty/serial/crisv10.c
@@ -1788,7 +1788,7 @@ static unsigned int handle_descr_data(st
 	struct etrax_recv_buffer *buffer = phys_to_virt(descr->buf) - sizeof *buffer;
 
 	if (info->recv_cnt + recvl > 65536) {
-		printk(KERN_CRIT
+		printk(KERN_WARNING
 		       "%s: Too much pending incoming serial data! Dropping %u bytes.\n", __func__, recvl);
 		return 0;
 	}
@@ -3813,13 +3813,13 @@ rs_close(struct tty_struct *tty, struct 
 		 * one, we've got real problems, since it means the
 		 * serial port won't be shutdown.
 		 */
-		printk(KERN_CRIT
+		printk(KERN_ERR
 		       "rs_close: bad serial port count; tty->count is 1, "
 		       "info->count is %d\n", info->count);
 		info->count = 1;
 	}
 	if (--info->count < 0) {
-		printk(KERN_CRIT "rs_close: bad serial port count for ttyS%d: %d\n",
+		printk(KERN_ERR "rs_close: bad serial port count for ttyS%d: %d\n",
 		       info->line, info->count);
 		info->count = 0;
 	}
@@ -4452,7 +4452,7 @@ static int __init rs_init(void)
 #if defined(CONFIG_ETRAX_RS485_ON_PA)
 	if (cris_io_interface_allocate_pins(if_ser0, 'a', rs485_pa_bit,
 			rs485_pa_bit)) {
-		printk(KERN_CRIT "ETRAX100LX serial: Could not allocate "
+		printk(KERN_ERR "ETRAX100LX serial: Could not allocate "
 			"RS485 pin\n");
 		put_tty_driver(driver);
 		return -EBUSY;
@@ -4461,7 +4461,7 @@ static int __init rs_init(void)
 #if defined(CONFIG_ETRAX_RS485_ON_PORT_G)
 	if (cris_io_interface_allocate_pins(if_ser0, 'g', rs485_pa_bit,
 			rs485_port_g_bit)) {
-		printk(KERN_CRIT "ETRAX100LX serial: Could not allocate "
+		printk(KERN_ERR "ETRAX100LX serial: Could not allocate "
 			"RS485 pin\n");
 		put_tty_driver(driver);
 		return -EBUSY;
@@ -4494,7 +4494,7 @@ static int __init rs_init(void)
 		if (info->enabled) {
 			if (cris_request_io_interface(info->io_if,
 					info->io_if_description)) {
-				printk(KERN_CRIT "ETRAX100LX async serial: "
+				printk(KERN_ERR "ETRAX100LX async serial: "
 					"Could not allocate IO pins for "
 					"%s, port %d\n",
 					info->io_if_description, i);
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

cris-lower-the-printk-level-in-cris-serial-driver.patch
kexec-remove-kmsg_dump_kexec.patch

