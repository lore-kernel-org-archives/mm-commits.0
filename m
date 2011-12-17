From: akpm@linux-foundation.org
Subject: + panic-dont-print-redundant-backtraces-on-oops.patch added to -mm tree
Date: Fri, 16 Dec 2011 16:54:24 -0800
Message-ID: <20111217005425.276D8100165@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:36453 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab1LQAy0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2011 19:54:26 -0500
Received: by qcsg15 with SMTP id g15so501952qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2011 16:54:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ak@linux.intel.com, holzheu@linux.vnet.ibm.com


The patch titled
     Subject: panic: don't print redundant backtraces on oops
has been added to the -mm tree.  Its filename is
     panic-dont-print-redundant-backtraces-on-oops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: panic: don't print redundant backtraces on oops

When an oops causes a panic and panic prints another backtrace it's pretty
common to have the original oops data be scrolled away on a 80x50 screen.

The second backtrace is quite redundant and not needed anyways.

So don't print the panic backtrace when oops_in_progress is true.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/panic.c~panic-dont-print-redundant-backtraces-on-oops kernel/panic.c
--- a/kernel/panic.c~panic-dont-print-redundant-backtraces-on-oops
+++ a/kernel/panic.c
@@ -94,7 +94,8 @@ void panic(const char *fmt, ...)
 	va_end(args);
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
 #ifdef CONFIG_DEBUG_BUGVERBOSE
-	dump_stack();
+	if (!oops_in_progress)
+		dump_stack();
 #endif
 
 	/*
_
Subject: Subject: panic: don't print redundant backtraces on oops

Patches currently in -mm which might be from ak@linux.intel.com are

linux-next.patch
brlocks-lglocks-clean-up-code.patch
brlocks-lglocks-clean-up-code-checkpatch-fixes.patch
panic-dont-print-redundant-backtraces-on-oops.patch
panic-dont-print-redundant-backtraces-on-oops-fix.patch
vfs-cache-request_queue-in-struct-block_device.patch
dio-optimize-cache-misses-in-the-submission-path-v2.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-fix.patch

