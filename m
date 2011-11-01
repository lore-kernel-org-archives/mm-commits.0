From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:16:56 -0700
Message-ID: <201111012116.pA1LGuAI015019@wpaz17.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:16877 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1KAVRE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:17:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, akpm@linux-foundation.org, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add a --strict check for utf-8 in commit logs
has been removed from the -mm tree.  Its filename was
     checkpatch-add-a-strict-check-for-utf-8-in-commit-logs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add a --strict check for utf-8 in commit logs

Some find using utf-8 in commit logs inappropriate.

Some patch commit logs contain unintended utf-8 characters when doing
things like copy/pasting compilation output.

Look for the start of any commit log by skipping initial lines that look
like email headers and "From: " lines.

Stop looking for utf-8 at the first signature line.

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-a-strict-check-for-utf-8-in-commit-logs scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-a-strict-check-for-utf-8-in-commit-logs
+++ a/scripts/checkpatch.pl
@@ -240,9 +240,8 @@ our $NonptrType;
 our $Type;
 our $Declare;
 
-our $UTF8	= qr {
-	[\x09\x0A\x0D\x20-\x7E]              # ASCII
-	| [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
+our $NON_ASCII_UTF8	= qr{
+	[\xC2-\xDF][\x80-\xBF]               # non-overlong 2-byte
 	|  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
 	| [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}  # straight 3-byte
 	|  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
@@ -251,6 +250,11 @@ our $UTF8	= qr {
 	|  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
 }x;
 
+our $UTF8	= qr{
+	[\x09\x0A\x0D\x20-\x7E]              # ASCII
+	| $NON_ASCII_UTF8
+}x;
+
 our $typeTypedefs = qr{(?x:
 	(?:__)?(?:u|s|be|le)(?:8|16|32|64)|
 	atomic_t
@@ -1330,6 +1334,9 @@ sub process {
 	my $signoff = 0;
 	my $is_patch = 0;
 
+	my $in_header_lines = 1;
+	my $in_commit_log = 0;		#Scanning lines before patch
+
 	our @report = ();
 	our $cnt_lines = 0;
 	our $cnt_error = 0;
@@ -1497,7 +1504,6 @@ sub process {
 		if ($line =~ /^diff --git.*?(\S+)$/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@;
-
 		} elsif ($line =~ /^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@;
@@ -1536,6 +1542,7 @@ sub process {
 # Check the patch for a signoff:
 		if ($line =~ /^\s*signed-off-by:/i) {
 			$signoff++;
+			$in_commit_log = 0;
 		}
 
 # Check signature styles
@@ -1613,6 +1620,21 @@ sub process {
 			    "Invalid UTF-8, patch and commit message should be encoded in UTF-8\n" . $hereptr);
 		}
 
+# Check if it's the start of a commit log
+# (not a header line and we haven't seen the patch filename)
+		if ($in_header_lines && $realfile =~ /^$/ &&
+		    $rawline !~ /^(commit\b|from\b|\w+:).+$/i) {
+			$in_header_lines = 0;
+			$in_commit_log = 1;
+		}
+
+# Still not yet in a patch, check for any UTF-8
+		if ($in_commit_log && $realfile =~ /^$/ &&
+		    $rawline =~ /$NON_ASCII_UTF8/) {
+			CHK("UTF8_BEFORE_PATCH",
+			    "8-bit UTF-8 used in possible commit log\n" . $herecurr);
+		}
+
 # ignore non-hunk lines and lines being removed
 		next if (!$hunk_line || $line =~ /^-/);
 
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

