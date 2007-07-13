From: akpm@linux-foundation.org
Subject: + inhibit-nmi-watchdog-when-alt-sysrq-t-operation-is-underway.patch added to -mm tree
Date: Fri, 13 Jul 2007 16:46:00 -0700
Message-ID: <200707132346.l6DNk0Or029361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47567 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752246AbXGMXqV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 19:46:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konrad@darnok.org, ak@suse.de


The patch titled
     Inhibit NMI watchdog when Alt-SysRq-T operation is underway
has been added to the -mm tree.  Its filename is
     inhibit-nmi-watchdog-when-alt-sysrq-t-operation-is-underway.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 1 insertion(+)

diff -puN arch/x86_64/kernel/traps.c~inhibit-nmi-watchdog-when-alt-sysrq-t-operation-is-underway arch/x86_64/kernel/traps.c
--- a/arch/x86_64/kernel/traps.c~inhibit-nmi-watchdog-when-alt-sysrq-t-operation-is-underway
+++ a/arch/x86_64/kernel/traps.c
@@ -397,6 +397,7 @@ static int print_trace_stack(void *data,
 
 static void print_trace_address(void *data, unsigned long addr)
 {
+	touch_nmi_watchdog();
 	printk_address(addr);
 }
 
_

Patches currently in -mm which might be from konrad@darnok.org are

inhibit-nmi-watchdog-when-alt-sysrq-t-operation-is-underway.patch
i386-speedup-touch_nmi_watchdog.patch
x86_64-speedup-touch_nmi_watchdog.patch
