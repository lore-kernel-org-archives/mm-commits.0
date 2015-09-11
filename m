From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-left-brace-warning.patch removed from -mm tree
Date: Fri, 11 Sep 2015 11:12:29 -0700
Message-ID: <55f3198d.s/sP0zj+G60LSTJ2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbbIKSM3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 14:12:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ewk@edkovsky.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix left brace warning
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-left-brace-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Eddie Kovsky <ewk@edkovsky.org>
Subject: checkpatch: fix left brace warning

Using checkpatch.pl with Perl 5.22.0 generates the following warning:

    Unescaped left brace in regex is deprecated, passed through in regex;

This patch fixes the warnings by escaping occurrences of the left brace
inside the regular expression.

Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-left-brace-warning scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-left-brace-warning
+++ a/scripts/checkpatch.pl
@@ -3571,7 +3571,7 @@ sub process {
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
 		if (($line=~/$Type\s*$Ident\(.*\).*\s*{/) and
-		    !($line=~/\#\s*define.*do\s{/) and !($line=~/}/)) {
+		    !($line=~/\#\s*define.*do\s\{/) and !($line=~/}/)) {
 			if (ERROR("OPEN_BRACE",
 				  "open brace '{' following function declarations go on the next line\n" . $herecurr) &&
 			    $fix) {
@@ -4083,8 +4083,8 @@ sub process {
 ## 		}
 
 #need space before brace following if, while, etc
-		if (($line =~ /\(.*\){/ && $line !~ /\($Type\){/) ||
-		    $line =~ /do{/) {
+		if (($line =~ /\(.*\)\{/ && $line !~ /\($Type\){/) ||
+		    $line =~ /do\{/) {
 			if (ERROR("SPACING",
 				  "space required before the open brace '{'\n" . $herecurr) &&
 			    $fix) {
@@ -4531,7 +4531,7 @@ sub process {
 			    $dstat !~ /^for\s*$Constant$/ &&				# for (...)
 			    $dstat !~ /^for\s*$Constant\s+(?:$Ident|-?$Constant)$/ &&	# for (...) bar()
 			    $dstat !~ /^do\s*{/ &&					# do {...
-			    $dstat !~ /^\({/ &&						# ({...
+			    $dstat !~ /^\(\{/ &&						# ({...
 			    $ctx !~ /^.\s*#\s*define\s+TRACE_(?:SYSTEM|INCLUDE_FILE|INCLUDE_PATH)\b/)
 			{
 				$ctx =~ s/\n*$//;
_

Patches currently in -mm which might be from ewk@edkovsky.org are


