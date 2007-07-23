From: akpm@linux-foundation.org
Subject: - i386-touch_nmi_watchdog-in-print_trace_address.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:33:48 -0700
Message-ID: <200707230933.l6N9XmCE016325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35938 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756838AbXGWJeg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:34:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konrad@darnok.org, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: touch_nmi_watchdog() in print_trace_address()
has been removed from the -mm tree.  Its filename was
     i386-touch_nmi_watchdog-in-print_trace_address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: touch_nmi_watchdog() in print_trace_address()
From: Konrad Rzeszutek <konrad@darnok.org>

Prevent NMI watchdog triggering during long sysrq-T outputs.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/traps.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/i386/kernel/traps.c~i386-touch_nmi_watchdog-in-print_trace_address arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~i386-touch_nmi_watchdog-in-print_trace_address
+++ a/arch/i386/kernel/traps.c
@@ -211,6 +211,7 @@ static void print_trace_address(void *da
 {
 	printk("%s [<%08lx>] ", (char *)data, addr);
 	print_symbol("%s\n", addr);
+	touch_nmi_watchdog();
 }
 
 static struct stacktrace_ops print_trace_ops = {
_

Patches currently in -mm which might be from konrad@darnok.org are
