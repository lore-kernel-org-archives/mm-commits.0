From: akpm@linux-foundation.org
Subject: + cris-fix-a-build-error-in-drivers-tty-serial-crisv10c.patch added to -mm tree
Date: Fri, 02 Sep 2011 16:29:10 -0700
Message-ID: <201109022329.p82NTA3w016780@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724Ab1IBX3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Sep 2011 19:29:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jesper.nilsson@axis.com, starvik@axis.com


The patch titled
     cris: fix a build error in drivers/tty/serial/crisv10.c
has been added to the -mm tree.  Its filename is
     cris-fix-a-build-error-in-drivers-tty-serial-crisv10c.patch

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
Subject: cris: fix a build error in drivers/tty/serial/crisv10.c
From: WANG Cong <xiyou.wangcong@gmail.com>

drivers/tty/serial/crisv10.c:4453: error: 'if_ser0' undeclared (first use in this function): 2 errors in 2 logs
        v3.1-rc4/cris/cris-allmodconfig v3.1-rc4/cris/cris-allyesconfig
drivers/tty/serial/crisv10.c:4453: error: (Each undeclared identifier is reported only once: 2 errors in 2 logs
        v3.1-rc4/cris/cris-allmodconfig v3.1-rc4/cris/cris-allyesconfig
drivers/tty/serial/crisv10.c:4453: error: for each function it appears in.): 2 errors in 2 logs
        v3.1-rc4/cris/cris-allmodconfig v3.1-rc4/cris/cris-allyesconfig

"if_ser0" is a typo, it should be "if_serial_0".

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/tty/serial/crisv10.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/tty/serial/crisv10.c~cris-fix-a-build-error-in-drivers-tty-serial-crisv10c drivers/tty/serial/crisv10.c
--- a/drivers/tty/serial/crisv10.c~cris-fix-a-build-error-in-drivers-tty-serial-crisv10c
+++ a/drivers/tty/serial/crisv10.c
@@ -4450,7 +4450,7 @@ static int __init rs_init(void)
 
 #if defined(CONFIG_ETRAX_RS485)
 #if defined(CONFIG_ETRAX_RS485_ON_PA)
-	if (cris_io_interface_allocate_pins(if_ser0, 'a', rs485_pa_bit,
+	if (cris_io_interface_allocate_pins(if_serial_0, 'a', rs485_pa_bit,
 			rs485_pa_bit)) {
 		printk(KERN_CRIT "ETRAX100LX serial: Could not allocate "
 			"RS485 pin\n");
@@ -4459,7 +4459,7 @@ static int __init rs_init(void)
 	}
 #endif
 #if defined(CONFIG_ETRAX_RS485_ON_PORT_G)
-	if (cris_io_interface_allocate_pins(if_ser0, 'g', rs485_pa_bit,
+	if (cris_io_interface_allocate_pins(if_serial_0, 'g', rs485_pa_bit,
 			rs485_port_g_bit)) {
 		printk(KERN_CRIT "ETRAX100LX serial: Could not allocate "
 			"RS485 pin\n");
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

cris-fix-a-build-error-in-drivers-tty-serial-crisv10c.patch
cris-lower-the-printk-level-in-cris-serial-driver.patch
kexec-remove-kmsg_dump_kexec.patch

