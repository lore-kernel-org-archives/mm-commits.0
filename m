From: akpm@linux-foundation.org
Subject: +
 checkpatch-improve-kalloc-with-multiplication-and-sizeof-test.patch added
 to -mm tree
Date: Wed, 26 Apr 2017 15:35:18 -0700
Message-ID: <590120a6.IRryQvkCjetdgszg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59346 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031775AbdDZWfV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 26 Apr 2017 18:35:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve k.alloc with multiplication and sizeof test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-kalloc-with-multiplication-and-sizeof-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-kalloc-with-multiplication-and-sizeof-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-kalloc-with-multiplication-and-sizeof-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve k.alloc with multiplication and sizeof test

Find multi-line uses of k.alloc by using the $stat variable and not the
$line variable.  This can still --fix only the single line variant though.

Link: http://lkml.kernel.org/r/3f4b23d37cd4c7d8628eefc25afe83ba8fb3ab55.1493167076.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-kalloc-with-multiplication-and-sizeof-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-kalloc-with-multiplication-and-sizeof-test
+++ a/scripts/checkpatch.pl
@@ -5922,7 +5922,8 @@ sub process {
 
 # check for k[mz]alloc with multiplies that could be kmalloc_array/kcalloc
 		if ($^V && $^V ge 5.10.0 &&
-		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)\s*,/) {
+		    defined $stat &&
+		    $stat =~ /^\+\s*($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)\s*,/) {
 			my $oldfunc = $3;
 			my $a1 = $4;
 			my $a2 = $10;
@@ -5936,11 +5937,17 @@ sub process {
 			}
 			if ($r1 !~ /^sizeof\b/ && $r2 =~ /^sizeof\s*\S/ &&
 			    !($r1 =~ /^$Constant$/ || $r1 =~ /^[A-Z_][A-Z0-9_]*$/)) {
+				my $ctx = '';
+				my $herectx = $here . "\n";
+				my $cnt = statement_rawlines($stat);
+				for (my $n = 0; $n < $cnt; $n++) {
+					$herectx .= raw_line($linenr, $n) . "\n";
+				}
 				if (WARN("ALLOC_WITH_MULTIPLY",
-					 "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr) &&
+					 "Prefer $newfunc over $oldfunc with multiply\n" . $herectx) &&
+				    $cnt == 1 &&
 				    $fix) {
 					$fixed[$fixlinenr] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
