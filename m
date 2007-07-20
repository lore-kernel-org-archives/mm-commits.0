From: akpm@linux-foundation.org
Subject: + i386-touch_nmi_watchdog-in-print_trace_address.patch added to -mm tree
Date: Fri, 20 Jul 2007 14:04:21 -0700
Message-ID: <200707202104.l6KL4LfB016316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55172 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755922AbXGTVEk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 17:04:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konrad@darnok.org, ak@suse.de


The patch titled
     i386: touch_nmi_watchdog() in print_trace_address()
has been added to the -mm tree.  Its filename is
     i386-touch_nmi_watchdog-in-print_trace_address.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: touch_nmi_watchdog() in print_trace_address()
From: Konrad Rzeszutek <konrad@darnok.org>

Prevent NMI watchdog triggering during long sysrq-T outputs.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/traps.c |    1 +
 1 files changed, 1 insertion(+)

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

origin.patch
i386-touch_nmi_watchdog-in-print_trace_address.patch
