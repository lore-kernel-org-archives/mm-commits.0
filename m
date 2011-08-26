From: akpm@linux-foundation.org
Subject: [merged] cris-add-arch-cris-include-asm-serialh.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:07:02 -0700
Message-ID: <201108261903.p7QJ3kBP005722@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753302Ab1HZTEW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:04:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, jesper.nilsson@axis.com, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     cris: add arch/cris/include/asm/serial.h
has been removed from the -mm tree.  Its filename was
     cris-add-arch-cris-include-asm-serialh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cris: add arch/cris/include/asm/serial.h
From: WANG Cong <xiyou.wangcong@gmail.com>

Fix the following build errors:

src/drivers/tty/serial/8250_early.c:160: error: 'BASE_BAUD' undeclared (first use in this function): 1 errors in 1 logs
        v3.0/cris/cris-allyesconfig
src/drivers/tty/serial/8250_early.c:160: error: (Each undeclared identifier is reported only once: 1 errors in 1 logs
        v3.0/cris/cris-allyesconfig
src/drivers/tty/serial/8250_early.c:160: error: for each function it appears in.): 1 errors in 1 logs
        v3.0/cris/cris-allyesconfig
src/drivers/tty/serial/8250_early.c:37:24: error: asm/serial.h: No such file or directory: 1 errors in 1 logs
        v3.0/cris/cris-allyesconfig

I am not sure if (1843200 / 16) is suitable for cris, but most other
arch's define it as this value.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/include/asm/serial.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN /dev/null arch/cris/include/asm/serial.h
--- /dev/null
+++ a/arch/cris/include/asm/serial.h
@@ -0,0 +1,10 @@
+#ifndef _ASM_SERIAL_H
+#define _ASM_SERIAL_H
+
+/*
+ * This assumes you have a 1.8432 MHz clock for your UART.
+ */
+#define BASE_BAUD (1843200 / 16)
+
+#endif /* _ASM_SERIAL_H */
+
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
kexec-remove-kmsg_dump_kexec.patch

