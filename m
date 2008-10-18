From: akpm@linux-foundation.org
Subject: - checkpatch-trailing-statements-ensure-we-report-the-end-of-the-line.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:14:14 -0700
Message-ID: <200810182314.m9INEE6C028361@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbYJRXOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:14:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: trailing statements ensure we report the end of the line
has been removed from the -mm tree.  Its filename was
     checkpatch-trailing-statements-ensure-we-report-the-end-of-the-line.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: trailing statements ensure we report the end of the line
From: Andy Whitcroft <apw@shadowen.org>

When reporting some complex trailing statements we report only the
starting line of the error, that tends to imply the shown line is in error
and confuse the reader.  As we do know where the actual error is report
that line too with an appropriate gap marker where applicable.

    #ERROR: trailing statements should be on next line
    #1: FILE: Z202.c:1:
    +       for (pbh = page_buffers(bh->b_page); pbh != bh;
    +               pbh = pbh->b_this_page, key++);
    #ERROR: trailing statements should be on next line
    #4: FILE: Z202.c:4:
    +       for (pbh = page_buffers(bh->b_page);
    [...]
    +               pbh = pbh->b_this_page, key++);

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-trailing-statements-ensure-we-report-the-end-of-the-line scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-trailing-statements-ensure-we-report-the-end-of-the-line
+++ a/scripts/checkpatch.pl
@@ -2001,7 +2001,16 @@ sub process {
 			if (length($c) && $s !~ /^\s*{?\s*\\*\s*$/ &&
 			    $c !~ /}\s*while\s*/)
 			{
-				ERROR("trailing statements should be on next line\n" . $herecurr);
+				# Find out how long the conditional actually is.
+				my @newlines = ($c =~ /\n/gs);
+				my $cond_lines = 1 + $#newlines;
+
+				my $stat_real = raw_line($linenr, $cond_lines);
+				if (defined($stat_real) && $cond_lines > 1) {
+					$stat_real = "[...]\n$stat_real";
+				}
+
+				ERROR("trailing statements should be on next line\n" . $herecurr . $stat_real);
 			}
 		}
 
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

