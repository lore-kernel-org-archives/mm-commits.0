From: akpm@linux-foundation.org
Subject: [merged] panic-dont-print-redundant-backtraces-on-oops.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:36:42 -0800
Message-ID: <20120113203643.1127A20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:42927 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUgo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:36:44 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so25473eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:36:44 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, holzheu@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: panic: don't print redundant backtraces on oops
has been removed from the -mm tree.  Its filename was
     panic-dont-print-redundant-backtraces-on-oops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: panic: don't print redundant backtraces on oops

When an oops causes a panic and panic prints another backtrace it's pretty
common to have the original oops data be scrolled away on a 80x50 screen.

The second backtrace is quite redundant and not needed anyways.

So don't print the panic backtrace when oops_in_progress is true.

[akpm@linux-foundation.org: add comment]
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/panic.c~panic-dont-print-redundant-backtraces-on-oops kernel/panic.c
--- a/kernel/panic.c~panic-dont-print-redundant-backtraces-on-oops
+++ a/kernel/panic.c
@@ -94,7 +94,11 @@ void panic(const char *fmt, ...)
 	va_end(args);
 	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
 #ifdef CONFIG_DEBUG_BUGVERBOSE
-	dump_stack();
+	/*
+	 * Avoid nested stack-dumping if a panic occurs during oops processing
+	 */
+	if (!oops_in_progress)
+		dump_stack();
 #endif
 
 	/*
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch

