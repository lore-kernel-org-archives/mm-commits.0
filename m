From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-improve-tests-for-fixes-long-lines-and-stack-dumps-in-commit-log.patch removed from -mm tree
Date: Mon, 09 Nov 2015 12:12:52 -0800
Message-ID: <5640fe44.0+9hrGvS4CKyp85K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbKIUMw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:12:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, sds@tycho.nsa.gov, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve tests for fixes:, long lines and stack dumps in commit log
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-tests-for-fixes-long-lines-and-stack-dumps-in-commit-log.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve tests for fixes:, long lines and stack dumps in commit log

Including BUG and stack dumps in commit logs makes checkpatch produce some
false positive warning messages.

checkpatch has multiple types of false positives:

o Commit message lines > 75 chars
o Stack dump address are mistaken for git commit IDs
o Link: and Fixes: lines are allowed to be > 75 chars.
o Fixes: style doesn't require ("<commit_description>")
  parentheses and double quotes like other uses of
  git commit ID and description.

Fix these.

Miscellanea:

o Move the test for checking $commit_log_possible_stack_dump
  above the test for a long line commit message
o Add test for hex address surrounded by square or angle brackets

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   51 ++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-tests-for-fixes-long-lines-and-stack-dumps-in-commit-log scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-tests-for-fixes-long-lines-and-stack-dumps-in-commit-log
+++ a/scripts/checkpatch.pl
@@ -2313,42 +2313,43 @@ sub process {
 			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
 		}
 
+# Check if the commit log is in a possible stack dump
+		if ($in_commit_log && !$commit_log_possible_stack_dump &&
+		    ($line =~ /^\s*(?:WARNING:|BUG:)/ ||
+		     $line =~ /^\s*\[\s*\d+\.\d{6,6}\s*\]/ ||
+					# timestamp
+		     $line =~ /^\s*\[\<[0-9a-fA-F]{8,}\>\]/)) {
+					# stack dump address
+			$commit_log_possible_stack_dump = 1;
+		}
+
 # Check for line lengths > 75 in commit log, warn once
 		if ($in_commit_log && !$commit_log_long_line &&
-                   length($line) > 75 &&
-                   !($line =~ /^\s*[a-zA-Z0-9_\/\.]+\s+\|\s+\d+/ ||
-                                       # file delta changes
-                     $line =~ /^\s*(?:[\w\.\-]+\/)++[\w\.\-]+:/ ||
-                                       # filename then :
-                     $line =~ /^\s*(?:Fixes:|Link:)/i ||
-                                       # A Fixes: or Link: line
-                     $commit_log_possible_stack_dump)) {
+		    length($line) > 75 &&
+		    !($line =~ /^\s*[a-zA-Z0-9_\/\.]+\s+\|\s+\d+/ ||
+					# file delta changes
+		      $line =~ /^\s*(?:[\w\.\-]+\/)++[\w\.\-]+:/ ||
+					# filename then :
+		      $line =~ /^\s*(?:Fixes:|Link:)/i ||
+					# A Fixes: or Link: line
+		      $commit_log_possible_stack_dump)) {
 			WARN("COMMIT_LOG_LONG_LINE",
 			     "Possible unwrapped commit description (prefer a maximum 75 chars per line)\n" . $herecurr);
 			$commit_log_long_line = 1;
 		}
 
-# Check if the commit log is in a possible stack dump
-               if ($in_commit_log && !$commit_log_possible_stack_dump &&
-                   ($line =~ /^\s*(?:WARNING:|BUG:)/ ||
-                    $line =~ /^\s*\[\s*\d+\.\d{6,6}\s*\]/ ||
-                               # timestamp
-                    $line =~ /^\s*\[\<[0-9a-fA-F]{8,}\>\]/)) {
-                               # stack dump address
-                       $commit_log_possible_stack_dump = 1;
-               }
-
 # Reset possible stack dump if a blank line is found
-               if ($in_commit_log && $commit_log_possible_stack_dump &&
-                   $line =~ /^\s*$/) {
-                       $commit_log_possible_stack_dump = 0;
-               }
+		if ($in_commit_log && $commit_log_possible_stack_dump &&
+		    $line =~ /^\s*$/) {
+			$commit_log_possible_stack_dump = 0;
+		}
 
 # Check for git id commit length and improperly formed commit descriptions
-		if ($in_commit_log &&
+		if ($in_commit_log && !$commit_log_possible_stack_dump &&
 		    ($line =~ /\bcommit\s+[0-9a-f]{5,}\b/i ||
-                    ($line =~ /\b[0-9a-f]{12,40}\b/i &&
-                     $line !~ /\bfixes:\s*[0-9a-f]{12,40}/i))) {
+		     ($line =~ /\b[0-9a-f]{12,40}\b/i &&
+		      $line !~ /[\<\[][0-9a-f]{12,40}[\>\]]/i &&
+		      $line !~ /\bfixes:\s*[0-9a-f]{12,40}/i))) {
 			my $init_char = "c";
 			my $orig_commit = "";
 			my $short = 1;
_

Patches currently in -mm which might be from joe@perches.com are


