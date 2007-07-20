From: akpm@linux-foundation.org
Subject: + x86_64-include-asm-bugsh-in-bugsc-for-check_bugs.patch added to -mm tree
Date: Fri, 20 Jul 2007 13:42:43 -0700
Message-ID: <200707202042.l6KKghBX015503@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56332 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754885AbXGTUnX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 16:43:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josh@kernel.org, ak@suse.de


The patch titled
     x86_64: include asm/bugs.h in bugs.c for check_bugs prototype
has been added to the -mm tree.  Its filename is
     x86_64-include-asm-bugsh-in-bugsc-for-check_bugs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: include asm/bugs.h in bugs.c for check_bugs prototype
From: Josh Triplett <josh@kernel.org>

C files should include the header files that prototype their functions.

Eliminates a sparse warning:
warning: symbol 'check_bugs' was not declared. Should it be static?

Signed-off-by: Josh Triplett <josh@kernel.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/bugs.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN arch/x86_64/kernel/bugs.c~x86_64-include-asm-bugsh-in-bugsc-for-check_bugs arch/x86_64/kernel/bugs.c
--- a/arch/x86_64/kernel/bugs.c~x86_64-include-asm-bugsh-in-bugsc-for-check_bugs
+++ a/arch/x86_64/kernel/bugs.c
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <asm/alternative.h>
+#include <asm/bugs.h>
 #include <asm/processor.h>
 #include <asm/mtrr.h>
 
_

Patches currently in -mm which might be from josh@kernel.org are

origin.patch
immunize-rcu_dereference-against-crazy-compiler-writers.patch
i386-include-asm-bugsh-in-bugsc-for-check_bugs-prototype.patch
x86_64-include-asm-bugsh-in-bugsc-for-check_bugs.patch
mark-sysrq_sched_debug_show-static.patch
i386-mark-pit_clockevent-static.patch
cfs-mark-print_cfs_stats-static.patch
