From: akpm@linux-foundation.org
Subject: + panic-fix-stack-dump-print-on-direct-call-to-panic.patch added to -mm tree
Date: Tue, 10 Apr 2012 12:20:39 -0700
Message-ID: <20120410192039.ACD13A026A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:42857 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905Ab2DJTUm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Apr 2012 15:20:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jason.wessel@windriver.com, ak@linux.intel.com, stable@vger.kernel.org


The patch titled
     Subject: panic: fix stack dump print on direct call to panic()
has been added to the -mm tree.  Its filename is
     panic-fix-stack-dump-print-on-direct-call-to-panic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: panic: fix stack dump print on direct call to panic()

Patches currently in -mm which might be from jason.wessel@windriver.com are

panic-fix-stack-dump-print-on-direct-call-to-panic.patch

