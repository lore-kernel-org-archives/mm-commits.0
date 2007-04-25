From: akpm@linux-foundation.org
Subject: - fix-possible-null-pointer-access-in-8250-serial-driver.patch removed from -mm tree
Date: Wed, 25 Apr 2007 13:38:21 -0700
Message-ID: <200704252038.l3PKcLYE012217@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993132AbXDYUjy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 Apr 2007 16:39:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: izumi2005@soft.fujitsu.com, kaneshige.kenji@jp.fujitsu.com, rmk@arm.linux.org.uk, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Fix possible NULL pointer access in 8250 serial driver
has been removed from the -mm tree.  Its filename was
     fix-possible-null-pointer-access-in-8250-serial-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix possible NULL pointer access in 8250 serial driver
From: Taku Izumi <izumi2005@soft.fujitsu.com>

I encountered the following kernel panic.  The cause of this problem was
NULL pointer access in check_modem_status() in 8250.c.  I confirmed this
problem is fixed by the attached patch, but I don't know this is the
correct fix.

sadc[4378]: NaT consumption 2216203124768 [1]
Modules linked in: binfmt_misc dm_mirror dm_mod thermal processor fan
container button sg e100 eepro100 mii ehci_hcd ohci_hcd

Pid: 4378, CPU 0, comm: sadc
psr : 00001210085a2010 ifs : 8000000000000289 ip : [<a000000100482071>]
Not tainted
ip is at check_modem_status+0xf1/0x360
unat: 0000000000000000 pfs : 0000000000000289 rsc : 0000000000000003
rnat: 800000000000cc18 bsps: 0000000000000000 pr : 0000000000aa6a99
ldrs: 0000000000000000 ccv : 0000000000000000 fpsr: 0009804c8a70033f
csd : 0000000000000000 ssd : 0000000000000000
b0 : a000000100481fb0 b6 : a0000001004822e0 b7 : a000000100477f20
f6 : 1003e2222222222222222 f7 : 0ffdba200000000000000
f8 : 100018000000000000000 f9 : 10002a000000000000000
f10 : 0fffdccccccccc8c00000 f11 : 1003e0000000000000000
r1 : a000000100b9af40 r2 : 0000000000000008 r3 : a000000100ad4e21
r8 : 00000000000000bb r9 : 0000000000000001 r10 : 0000000000000000
r11 : a000000100ad4d58 r12 : e0000000037b7df0 r13 : e0000000037b0000
r14 : 0000000000000001 r15 : 0000000000000018 r16 : a000000100ad4d6c
r17 : 0000000000000000 r18 : 0000000000000000 r19 : 0000000000000000
r20 : a00000010099bc88 r21 : 00000000000000bb r22 : 00000000000000bb
r23 : c003fffffc0ff3fe r24 : c003fffffc000000 r25 : 00000000000ff3fe
r26 : a0000001009b7ad0 r27 : 0000000000000001 r28 : a0000001009b7ad8
r29 : 0000000000000000 r30 : a0000001009b7ad0 r31 : a0000001009b7ad0

Call Trace:
[<a000000100013940>] show_stack+0x40/0xa0
sp=e0000000037b7810 bsp=e0000000037b1118
[<a0000001000145a0>] show_regs+0x840/0x880
sp=e0000000037b79e0 bsp=e0000000037b10c0
[<a0000001000368e0>] die+0x1c0/0x2c0
sp=e0000000037b79e0 bsp=e0000000037b1078
[<a000000100036a30>] die_if_kernel+0x50/0x80
sp=e0000000037b7a00 bsp=e0000000037b1048
[<a000000100037c40>] ia64_fault+0x11e0/0x1300
sp=e0000000037b7a00 bsp=e0000000037b0fe8
[<a00000010000bdc0>] ia64_leave_kernel+0x0/0x280
sp=e0000000037b7c20 bsp=e0000000037b0fe8
[<a000000100482070>] check_modem_status+0xf0/0x360
sp=e0000000037b7df0 bsp=e0000000037b0fa0
[<a000000100482300>] serial8250_get_mctrl+0x20/0xa0
sp=e0000000037b7df0 bsp=e0000000037b0f80
[<a000000100478170>] uart_read_proc+0x250/0x860
sp=e0000000037b7df0 bsp=e0000000037b0ee0
[<a0000001001c16d0>] proc_file_read+0x1d0/0x4c0
sp=e0000000037b7e10 bsp=e0000000037b0e80
[<a0000001001394b0>] vfs_read+0x1b0/0x300
sp=e0000000037b7e20 bsp=e0000000037b0e30
[<a000000100139cd0>] sys_read+0x70/0xe0
sp=e0000000037b7e20 bsp=e0000000037b0db0
[<a00000010000bc20>] ia64_ret_from_syscall+0x0/0x20
sp=e0000000037b7e30 bsp=e0000000037b0db0
[<a000000000010620>] __kernel_syscall_via_break+0x0/0x20
sp=e0000000037b8000 bsp=e0000000037b0db0


Fix the possible NULL pointer access in check_modem_status() in 8250.c.  The
check_modem_status() would access 'info' member of uart_port structure, but it
is not initialized before uart_open() is called.  The check_modem_status() can
be called through /proc/tty/driver/serial before uart_open() is called.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Signed-off-by: Taku Izumi <izumi2005@soft.fujitsu.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/serial/8250.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/serial/8250.c~fix-possible-null-pointer-access-in-8250-serial-driver drivers/serial/8250.c
--- a/drivers/serial/8250.c~fix-possible-null-pointer-access-in-8250-serial-driver
+++ a/drivers/serial/8250.c
@@ -1310,7 +1310,8 @@ static unsigned int check_modem_status(s
 {
 	unsigned int status = serial_in(up, UART_MSR);
 
-	if (status & UART_MSR_ANY_DELTA && up->ier & UART_IER_MSI) {
+	if (status & UART_MSR_ANY_DELTA && up->ier & UART_IER_MSI &&
+	    up->port.info != NULL) {
 		if (status & UART_MSR_TERI)
 			up->port.icount.rng++;
 		if (status & UART_MSR_DDSR)
_

Patches currently in -mm which might be from izumi2005@soft.fujitsu.com are

origin.patch
