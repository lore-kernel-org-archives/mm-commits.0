From: akpm@linux-foundation.org
Subject: - ifdef-missing-in-arch-mips-pmc-sierra-yosemite-setupc.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:52:55 -0800
Message-ID: <200702071952.l17Jqtja025278@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33703 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422816AbXBGTxI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:53:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     ifdef missing in arch/mips/pmc-sierra/yosemite/setup.c
has been removed from the -mm tree.  Its filename was
     ifdef-missing-in-arch-mips-pmc-sierra-yosemite-setupc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ifdef missing in arch/mips/pmc-sierra/yosemite/setup.c
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

ifdef missing in arch/mips/pmc-sierra/yosemite/setup.c

early_serial_setup is only defined when CONFIG_SERIAL_8250 is set.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/pmc-sierra/yosemite/setup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/mips/pmc-sierra/yosemite/setup.c~ifdef-missing-in-arch-mips-pmc-sierra-yosemite-setupc arch/mips/pmc-sierra/yosemite/setup.c
--- a/arch/mips/pmc-sierra/yosemite/setup.c~ifdef-missing-in-arch-mips-pmc-sierra-yosemite-setupc
+++ a/arch/mips/pmc-sierra/yosemite/setup.c
@@ -171,6 +171,7 @@ static void __init py_map_ocd(void)
 
 static void __init py_uart_setup(void)
 {
+#ifdef CONFIG_SERIAL_8250
 	struct uart_port up;
 
 	/*
@@ -188,6 +189,7 @@ static void __init py_uart_setup(void)
 
 	if (early_serial_setup(&up))
 		printk(KERN_ERR "Early serial init of port 0 failed\n");
+#endif //CONFIG_SERIAL_8250
 }
 
 static void __init py_rtc_setup(void)
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
kernel-time-clocksourcec-needs-struct-task_struct-on-m68k.patch
relay-add-cpu-hotplug-support.patch
local_t-documentation.patch
local_t-documentation-fix.patch
order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
minimize-lockdep_on-off-side-effect.patch
