From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-avoid-some-commit-message-long-line-warnings.patch removed from
 -mm tree
Date: Fri, 11 Sep 2015 11:12:27 -0700
Message-ID: <55f3198b.ILadt19xnu7jHALZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbbIKSM1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, pebolle@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: avoid some commit message long line warnings
has been removed from the -mm tree.  Its filename was
     checkpatch-avoid-some-commit-message-long-line-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: avoid some commit message long line warnings

Fixes: and Link: lines may exceed 75 chars in the commit log.

So too can stack dump and dmesg lines and lines that seem
like filenames.

And Fixes: lines don't need to have a "commit" prefix before the
commit id.

Add exceptions for these types of lines.

Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-avoid-some-commit-message-long-line-warnings scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-avoid-some-commit-message-long-line-warnings
+++ a/scripts/checkpatch.pl
@@ -1953,9 +1953,9 @@ sub process {
 	our $clean = 1;
 	my $signoff = 0;
 	my $is_patch = 0;
-
 	my $in_header_lines = $file ? 0 : 1;
 	my $in_commit_log = 0;		#Scanning lines before patch
+       my $commit_log_possible_stack_dump = 0;
 	my $commit_log_long_line = 0;
 	my $commit_log_has_diff = 0;
 	my $reported_maintainer_file = 0;
@@ -2314,16 +2314,40 @@ sub process {
 
 # Check for line lengths > 75 in commit log, warn once
 		if ($in_commit_log && !$commit_log_long_line &&
-		    length($line) > 75) {
+                   length($line) > 75 &&
+                   !($line =~ /^\s*[a-zA-Z0-9_\/\.]+\s+\|\s+\d+/ ||
+                                       # file delta changes
+                     $line =~ /^\s*(?:[\w\.\-]+\/)++[\w\.\-]+:/ ||
+                                       # filename then :
+                     $line =~ /^\s*(?:Fixes:|Link:)/i ||
+                                       # A Fixes: or Link: line
+                     $commit_log_possible_stack_dump)) {
 			WARN("COMMIT_LOG_LONG_LINE",
 			     "Possible unwrapped commit description (prefer a maximum 75 chars per line)\n" . $herecurr);
 			$commit_log_long_line = 1;
 		}
 
+# Check if the commit log is in a possible stack dump
+               if ($in_commit_log && !$commit_log_possible_stack_dump &&
+                   ($line =~ /^\s*(?:WARNING:|BUG:)/ ||
+                    $line =~ /^\s*\[\s*\d+\.\d{6,6}\s*\]/ ||
+                               # timestamp
+                    $line =~ /^\s*\[\<[0-9a-fA-F]{8,}\>\]/)) {
+                               # stack dump address
+                       $commit_log_possible_stack_dump = 1;
+               }
+
+# Reset possible stack dump if a blank line is found
+               if ($in_commit_log && $commit_log_possible_stack_dump &&
+                   $line =~ /^\s*$/) {
+                       $commit_log_possible_stack_dump = 0;
+               }
+
 # Check for git id commit length and improperly formed commit descriptions
 		if ($in_commit_log &&
 		    ($line =~ /\bcommit\s+[0-9a-f]{5,}\b/i ||
-		     $line =~ /\b[0-9a-f]{12,40}\b/i)) {
+                    ($line =~ /\b[0-9a-f]{12,40}\b/i &&
+                     $line !~ /\bfixes:\s*[0-9a-f]{12,40}/i))) {
 			my $init_char = "c";
 			my $orig_commit = "";
 			my $short = 1;
_

Patches currently in -mm which might be from joe@perches.com are

fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void.patch

