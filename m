From: akpm@linux-foundation.org
Subject: + ifdef-missing-in-arch-mips-pmc-sierra-yosemite-setupc.patch added to -mm tree
Date: Mon, 05 Feb 2007 13:24:59 -0800
Message-ID: <200702052124.l15LOx2K031586@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34341 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933456AbXBEVZJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 16:25:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca


The patch titled
     ifdef missing in arch/mips/pmc-sierra/yosemite/setup.c
has been added to the -mm tree.  Its filename is
     ifdef-missing-in-arch-mips-pmc-sierra-yosemite-setupc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ifdef missing in arch/mips/pmc-sierra/yosemite/setup.c
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

ifdef missing in arch/mips/pmc-sierra/yosemite/setup.c

early_serial_setup is only defined when CONFIG_SERIAL_8250 is set.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/pmc-sierra/yosemite/setup.c |    2 ++
 1 files changed, 2 insertions(+)

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

ifdef-missing-in-arch-mips-pmc-sierra-yosemite-setupc.patch
relay-add-cpu-hotplug-support.patch
local_t-documentation.patch
local_t-documentation-fix.patch
order-of-lockdep-off-on-in-vprintk-should-be-changed.patch
minimize-lockdep_on-off-side-effect.patch
