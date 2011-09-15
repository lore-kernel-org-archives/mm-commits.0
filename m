From: akpm@linux-foundation.org
Subject: [merged] cris-fix-a-build-error-in-drivers-tty-serial-crisv10c.patch removed from -mm tree
Date: Thu, 15 Sep 2011 12:36:38 -0700
Message-ID: <201109151936.p8FJacTS010741@hpaq13.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:10463 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934580Ab1IOTgn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2011 15:36:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: fix a build error in drivers/tty/serial/crisv10.c
has been removed from the -mm tree.  Its filename was
     cris-fix-a-build-error-in-drivers-tty-serial-crisv10c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
cris-lower-the-printk-level-in-cris-serial-driver.patch
kexec-remove-kmsg_dump_kexec.patch

