From: akpm@linux-foundation.org
Subject: [merged] checkpatch-trivial-fix-for-trailing-statements-check.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:09:03 -0800
Message-ID: <201003091909.o29J93Lt031492@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755915Ab0CITJ7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:09:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: seto.hidetoshi@jp.fujitsu.com, apw@canonical.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: trivial fix for trailing statements check
has been removed from the -mm tree.  Its filename was
     checkpatch-trivial-fix-for-trailing-statements-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: trivial fix for trailing statements check
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

In case if the statement and the conditional are in one line, the line
appears in the report doubly.

And items of this check have no blank line before the next item.

This patch fixes these trivial problems, to improve readability of the
report.

[sample.c]
  > if (cond1
  >        && cond2
  >        && cond3) func_foo();
  >
  > if (cond4) func_bar();

Before:
  > ERROR: trailing statements should be on next line
  > #1: FILE: sample.c:1:
  > +if (cond1
  > [...]
  > +       && cond3) func_foo();
  > ERROR: trailing statements should be on next line
  > #5: FILE: sample.c:5:
  > +if (cond4) func_bar();
  > +if (cond4) func_bar();
  > total: 2 errors, 0 warnings, 5 lines checked

After:
  > ERROR: trailing statements should be on next line
  > #1: FILE: sample.c:1:
  > +if (cond1
  > [...]
  > +       && cond3) func_foo();
  >
  > ERROR: trailing statements should be on next line
  > #5: FILE: sample.c:5:
  > +if (cond4) func_bar();
  >
  > total: 2 errors, 0 warnings, 5 lines checked

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-trivial-fix-for-trailing-statements-check scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-trivial-fix-for-trailing-statements-check
+++ a/scripts/checkpatch.pl
@@ -2182,8 +2182,10 @@ sub process {
 				# Find out how long the conditional actually is.
 				my @newlines = ($c =~ /\n/gs);
 				my $cond_lines = 1 + $#newlines;
+				my $stat_real = '';
 
-				my $stat_real = raw_line($linenr, $cond_lines);
+				$stat_real = raw_line($linenr, $cond_lines)
+							. "\n" if ($cond_lines);
 				if (defined($stat_real) && $cond_lines > 1) {
 					$stat_real = "[...]\n$stat_real";
 				}
_

Patches currently in -mm which might be from seto.hidetoshi@jp.fujitsu.com are

posix-cpu-timers-reset-expire-cache-when-no-timer-is-running.patch
cpu-timers-simplify-rlimit_cpu-handling.patch
cpu-timers-cleanup-arm_timer.patch
cpu-timers-return-correct-previous-timer-reload-value.patch
cpu-timers-change-sigev_none-timer-implementation.patch
cpu-timers-assure-to-not-iterate-over-all-threads-in-fastpath_timer_check.patch
cpu-timers-optimize-run_posix_cpu_timers.patch

