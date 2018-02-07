From: akpm@linux-foundation.org
Subject: [merged] checkpatch-improve-open_brace-test.patch removed
 from -mm tree
Date: Wed, 07 Feb 2018 11:57:50 -0800
Message-ID: <20180207195750.HGk5hdPuA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59790 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754281AbeBGT5v (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:57:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org, songliubraving@fb.com


The patch titled
     Subject: checkpatch: improve OPEN_BRACE test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-open_brace-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve OPEN_BRACE test

Some structure definitions that use macros trip the OPEN_BRACE test.

e.g. +struct bpf_map_def SEC("maps") control_map = {

Improve the test by using $balanced_parens instead of a .*

Miscellanea:

o Use $sline so any comments are ignored
o Correct the message output from declaration to definition
o Remove unnecessary parentheses

Link: http://lkml.kernel.org/r/db9b772999d1d2fbda3b9ee24bbca81a87837e13.1517543491.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-open_brace-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-open_brace-test
+++ a/scripts/checkpatch.pl
@@ -3919,10 +3919,12 @@ sub process {
 
 # function brace can't be on same line, except for #defines of do while,
 # or if closed on same line
-		if (($line=~/$Type\s*$Ident\(.*\).*\s*{/) and
-		    !($line=~/\#\s*define.*do\s\{/) and !($line=~/}/)) {
+		if ($^V && $^V ge 5.10.0 &&
+		    $sline =~ /$Type\s*$Ident\s*$balanced_parens\s*\{/ &&
+		    $sline !~ /\#\s*define\b.*do\s*\{/ &&
+		    $sline !~ /}/) {
 			if (ERROR("OPEN_BRACE",
-				  "open brace '{' following function declarations go on the next line\n" . $herecurr) &&
+				  "open brace '{' following function definitions go on the next line\n" . $herecurr) &&
 			    $fix) {
 				fix_delete_line($fixlinenr, $rawline);
 				my $fixed_line = $rawline;
_

Patches currently in -mm which might be from joe@perches.com are


