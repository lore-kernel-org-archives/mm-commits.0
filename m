From: akpm@linux-foundation.org
Subject: - stop_machine-now-uses-hard_irq_disable-fix.patch removed from -mm tree
Date: Thu, 10 May 2007 21:48:40 -0700
Message-ID: <200705110448.l4B4meJZ006366@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753689AbXEKEst (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 00:48:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, paulus@samba.org, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     stop_machine-now-uses-hard_irq_disable-fix
has been removed from the -mm tree.  Its filename was
     stop_machine-now-uses-hard_irq_disable-fix.patch

This patch was dropped because it was folded into stop_machine-now-uses-hard_irq_disable.patch

------------------------------------------------------
Subject: stop_machine-now-uses-hard_irq_disable-fix
From: Andrew Morton <akpm@linux-foundation.org>

kernel/built-in.o: In function `stopmachine':
stop_machine.c:(.text+0x3b9ff): undefined reference to `hard_irq_disable'
kernel/built-in.o: In function `do_stop':
stop_machine.c:(.text+0x3bb36): undefined reference to `hard_irq_disable'
make: *** [.tmp_vmlinux1] Error 1

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/stop_machine.c~stop_machine-now-uses-hard_irq_disable-fix kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-now-uses-hard_irq_disable-fix
+++ a/kernel/stop_machine.c
@@ -8,6 +8,8 @@
 #include <linux/sched.h>
 #include <linux/stop_machine.h>
 #include <linux/syscalls.h>
+#include <linux/interrupt.h>
+
 #include <asm/atomic.h>
 #include <asm/semaphore.h>
 #include <asm/uaccess.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
lib-hexdump.patch
stop_machine-now-uses-hard_irq_disable.patch
stop_machine-now-uses-hard_irq_disable-fix.patch
add-lzo1x-compression-support-to-the-kernel-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
submitchecklist-add-W-help.patch
ntfs-use-zero_user_page.patch
tty-add-compat_ioctl.patch
mpc52xx-psc-spi-master-driver-update-tidy.patch
use-defines-in-sys_getpriority-sys_setpriority-fix.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
pm3fb-preliminary-24-to-26-port-fix.patch
reiser4.patch
integrity-new-hooks.patch
integrity-evm-as-an-integrity-service-provider.patch
integrity-ima-integrity_measure-support.patch
integrity-tpm-internal-kernel-interface.patch
w1-build-fix.patch
