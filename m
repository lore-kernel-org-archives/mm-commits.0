From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-dont-check-pl-files-improve-absolute-path-commit-log-test.patch
 removed from -mm tree
Date: Wed, 14 Dec 2016 11:27:52 -0800
Message-ID: <58519d38.1hoaGlCAW0yKWF13%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45828 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754079AbcLNT3j (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 14:29:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, xypron.glpk@gmx.de, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: don't check .pl files, improve absolute path commit log test
has been removed from the -mm tree.  Its filename was
     checkpatch-dont-check-pl-files-improve-absolute-path-commit-log-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: don't check .pl files, improve absolute path commit log test

perl files (*.pl) are mostly inappropriate to check coding styles so
exempt them from long line checks and various .[ch] file type tests.

And as well, only scan absolute paths in the commit log, not in the patch.

Link: http://lkml.kernel.org/r/85b101d50acafe6c0261d9f7df283c827da52c4a.1477340110.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-dont-check-pl-files-improve-absolute-path-commit-log-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-dont-check-pl-files-improve-absolute-path-commit-log-test
+++ a/scripts/checkpatch.pl
@@ -2601,20 +2601,6 @@ sub process {
 				$herecurr) if (!$emitted_corrupt++);
 		}
 
-# Check for absolute kernel paths.
-		if ($tree) {
-			while ($line =~ m{(?:^|\s)(/\S*)}g) {
-				my $file = $1;
-
-				if ($file =~ m{^(.*?)(?::\d+)+:?$} &&
-				    check_absolute_file($1, $herecurr)) {
-					#
-				} else {
-					check_absolute_file($file, $herecurr);
-				}
-			}
-		}
-
 # UTF-8 regex found at http://www.w3.org/International/questions/qa-forms-utf-8.en.php
 		if (($realfile =~ /^$/ || $line =~ /^\+/) &&
 		    $rawline !~ m/^$UTF8*$/) {
@@ -2652,6 +2638,20 @@ sub process {
 			    "8-bit UTF-8 used in possible commit log\n" . $herecurr);
 		}
 
+# Check for absolute kernel paths in commit message
+		if ($tree && $in_commit_log) {
+			while ($line =~ m{(?:^|\s)(/\S*)}g) {
+				my $file = $1;
+
+				if ($file =~ m{^(.*?)(?::\d+)+:?$} &&
+				    check_absolute_file($1, $herecurr)) {
+					#
+				} else {
+					check_absolute_file($file, $herecurr);
+				}
+			}
+		}
+
 # Check for various typo / spelling mistakes
 		if (defined($misspellings) &&
 		    ($in_commit_log || $line =~ /^(?:\+|Subject:)/i)) {
@@ -2805,7 +2805,7 @@ sub process {
 		}
 
 # check we are in a valid source file if not then ignore this hunk
-		next if ($realfile !~ /\.(h|c|s|S|pl|sh|dtsi|dts)$/);
+		next if ($realfile !~ /\.(h|c|s|S|sh|dtsi|dts)$/);
 
 # line length limit (with some exclusions)
 #
_

Patches currently in -mm which might be from joe@perches.com are


