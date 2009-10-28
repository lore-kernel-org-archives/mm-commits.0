From: akpm@linux-foundation.org
Subject: + checkpatch-trivial-fix-for-trailing-statements-check.patch added to -mm tree
Date: Wed, 28 Oct 2009 15:44:28 -0700
Message-ID: <200910282244.n9SMiS0r008414@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbZJ1Woa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Oct 2009 18:44:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: seto.hidetoshi@jp.fujitsu.com, apw@canonical.com


The patch titled
     checkpatch: trivial fix for trailing statements check
has been added to the -mm tree.  Its filename is
     checkpatch-trivial-fix-for-trailing-statements-check.patch

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

linux-next.patch
checkpatch-trivial-fix-for-trailing-statements-check.patch

