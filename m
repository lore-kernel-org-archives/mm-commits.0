From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-improve-the-embedded-function-name-test-for-patch-contexts.patch
 removed from -mm tree
Date: Tue, 09 May 2017 11:01:29 -0700
Message-ID: <20170509180129.gcWdssO0-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34390 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754053AbdEISBa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:01:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve the embedded function name test for patch contexts
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-the-embedded-function-name-test-for-patch-contexts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve the embedded function name test for patch contexts

The current test works only for a single patch context as it is done in
the foreach ($rawlines) loop that precedes the loop where the actual
$context_function variable is used.

Move the set of $context_function into the foreach (@lines) loop where it
is useful for each patch context.

Link: http://lkml.kernel.org/r/6c675a31c74fbfad4fc45b9f462303d60ca2a283.1493486091.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-the-embedded-function-name-test-for-patch-contexts scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-the-embedded-function-name-test-for-patch-contexts
+++ a/scripts/checkpatch.pl
@@ -2213,8 +2213,7 @@ sub process {
 			}
 			#next;
 		}
-		if ($rawline=~/^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@(.*)/) {
-			my $context = $4;
+		if ($rawline =~ /^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
 			$realline=$1-1;
 			if (defined $2) {
 				$realcnt=$3+1;
@@ -2223,12 +2222,6 @@ sub process {
 			}
 			$in_comment = 0;
 
-			if ($context =~ /\b(\w+)\s*\(/) {
-				$context_function = $1;
-			} else {
-				undef $context_function;
-			}
-
 			# Guestimate if this is a continuing comment.  Run
 			# the context looking for a comment "edge".  If this
 			# edge is a close comment then we must be in a comment
@@ -2299,7 +2292,8 @@ sub process {
 
 #extract the line range in the file after the patch is applied
 		if (!$in_commit_log &&
-		    $line =~ /^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@/) {
+		    $line =~ /^\@\@ -\d+(?:,\d+)? \+(\d+)(,(\d+))? \@\@(.*)/) {
+			my $context = $4;
 			$is_patch = 1;
 			$first_line = $linenr + 1;
 			$realline=$1-1;
@@ -2315,6 +2309,11 @@ sub process {
 			%suppress_whiletrailers = ();
 			%suppress_export = ();
 			$suppress_statement = 0;
+			if ($context =~ /\b(\w+)\s*\(/) {
+				$context_function = $1;
+			} else {
+				undef $context_function;
+			}
 			next;
 
 # track the line number as we move through the hunk, note that
_

Patches currently in -mm which might be from joe@perches.com are


