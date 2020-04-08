From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-gerrit-change-id-test.patch
 removed from -mm tree
Date: Tue, 07 Apr 2020 19:01:41 -0700
Message-ID: <20200408020141.wM5vxp3zW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbgDHCBm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, john.stultz@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve Gerrit Change-Id: test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-gerrit-change-id-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve Gerrit Change-Id: test

The Gerrit Change-Id: entry is sometimes placed after a Signed-off-by:
line.  When this occurs, the Gerrit warning is not currently emitted as
the first Signed-off-by: signature sets a flag to stop looking.

Change the test to add a test for the --- patch separator and emit the
warning before any before the --- and also before any diff file name.

Link: http://lkml.kernel.org/r/2f6d5f8766fe7439a116c77ea8cc721a3f2d77a2.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-improve-gerrit-change-id-test
+++ a/scripts/checkpatch.pl
@@ -2335,6 +2335,7 @@ sub process {
 	my $is_binding_patch = -1;
 	my $in_header_lines = $file ? 0 : 1;
 	my $in_commit_log = 0;		#Scanning lines before patch
+	my $has_patch_separator = 0;	#Found a --- line
 	my $has_commit_log = 0;		#Encountered lines before patch
 	my $commit_log_lines = 0;	#Number of commit log lines
 	my $commit_log_possible_stack_dump = 0;
@@ -2660,6 +2661,12 @@ sub process {
 			}
 		}
 
+# Check for patch separator
+		if ($line =~ /^---$/) {
+			$has_patch_separator = 1;
+			$in_commit_log = 0;
+		}
+
 # Check if MAINTAINERS is being updated.  If so, there's probably no need to
 # emit the "does MAINTAINERS need updating?" message on file add/move/delete
 		if ($line =~ /^\s*MAINTAINERS\s*\|/) {
@@ -2759,10 +2766,10 @@ sub process {
 			     "A patch subject line should describe the change not the tool that found it\n" . $herecurr);
 		}
 
-# Check for unwanted Gerrit info
-		if ($in_commit_log && $line =~ /^\s*change-id:/i) {
+# Check for Gerrit Change-Ids not in any patch context
+		if ($realfile eq '' && !$has_patch_separator && $line =~ /^\s*change-id:/i) {
 			ERROR("GERRIT_CHANGE_ID",
-			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
+			      "Remove Gerrit Change-Id's before submitting upstream\n" . $herecurr);
 		}
 
 # Check if the commit log is in a possible stack dump
_

Patches currently in -mm which might be from joe@perches.com are
