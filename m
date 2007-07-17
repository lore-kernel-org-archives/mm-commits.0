From: akpm@linux-foundation.org
Subject: - inhibit-nmi-watchdog-when-alt-sysrq-t-operation-is-underway.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:02:37 -0700
Message-ID: <200707172302.l6HN2b10011587@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42945 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757890AbXGQXQI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konrad@darnok.org, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Inhibit NMI watchdog when Alt-SysRq-T operation is underway
has been removed from the -mm tree.  Its filename was
     inhibit-nmi-watchdog-when-alt-sysrq-t-operation-is-underway.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Inhibit NMI watchdog when Alt-SysRq-T operation is underway
From: Konrad Rzeszutek <konrad@darnok.org>

On large memory configuration with not so fast CPUs the NMI watchdog is
triggered when memory addresses are being gathered and printed.  The code
paths for Alt-SysRq-t are sprinkled with touch_nmi_watchdog in various
places but not in this routine (or in the loop that utilizes this
function).  The patch has been tested for regression on large CPU+memory
configuration (128 logical CPUs + 224 GB) and 1,2,4,16-CPU sockets with
various memory sizes (1,2,4,6,20).

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/traps.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86_64/kernel/traps.c~inhibit-nmi-watchdog-when-alt-sysrq-t-operation-is-underway arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~inhibit-nmi-watchdog-when-alt-sysrq-t-operation-is-underway
+++ a/arch/x86_64/kernel/traps.c
@@ -330,6 +330,7 @@ static int print_trace_stack(void *data,
 
 static void print_trace_address(void *data, unsigned long addr)
 {
+	touch_nmi_watchdog();
 	printk_address(addr);
 }
 
_

Patches currently in -mm which might be from konrad@darnok.org are

origin.patch
