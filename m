From: akpm@linux-foundation.org
Subject: [merged] panic-fix-stack-dump-print-on-direct-call-to-panic.patch removed from -mm tree
Date: Mon, 16 Apr 2012 13:15:44 -0700
Message-ID: <20120416201544.8447FA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:37999 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab2DPUPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Apr 2012 16:15:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jason.wessel@windriver.com, ak@linux.intel.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: panic: fix stack dump print on direct call to panic()
has been removed from the -mm tree.  Its filename was
     panic-fix-stack-dump-print-on-direct-call-to-panic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jason Wessel <jason.wessel@windriver.com>
Subject: panic: fix stack dump print on direct call to panic()

Commit 6e6f0a1f0 ("panic: don't print redundant backtraces on oops")
causes a regression where no stack trace will be printed at all for the
case where kernel code calls panic() directly while not processing an
oops, and of course there are 100's of instances of this type of call.

The original commit executed the check (!oops_in_progress), but this will
always be false because just before the dump_stack() there is a call to
bust_spinlocks(1), which does the following:

  void __attribute__((weak)) bust_spinlocks(int yes)
  {
	if (yes) {
		++oops_in_progress;

The proper way to resolve the problem that original commit tried to solve
is to avoid printing a stack dump from panic() when the either of the
following conditions is true:

  1) TAINT_DIE has been set (this is done by oops_end())
     This indicates and oops has already been printed.
  2) oops_in_progress > 1
     This guards against the rare case where panic() is invoked
     a second time, or in between oops_begin() and oops_end()

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: <stable@vger.kernel.org>	[3.3+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/panic.c~panic-fix-stack-dump-print-on-direct-call-to-panic kernel/panic.c
--- a/kernel/panic.c~panic-fix-stack-dump-print-on-direct-call-to-panic
+++ a/kernel/panic.c
@@ -97,7 +97,7 @@ void panic(const char *fmt, ...)
 	/*
 	 * Avoid nested stack-dumping if a panic occurs during oops processing
 	 */
-	if (!oops_in_progress)
+	if (!test_taint(TAINT_DIE) && oops_in_progress <= 1)
 		dump_stack();
 #endif
 
_

Patches currently in -mm which might be from jason.wessel@windriver.com are


