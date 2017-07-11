From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-silence-perl-5260-unescaped-left-brace-warnings.patch removed
 from -mm tree
Date: Tue, 11 Jul 2017 12:27:02 -0700
Message-ID: <20170711192702.7Aj_rNRam%akpm__22104.3347417892$1499801229$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754662AbdGKT1D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Jul 2017 15:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cyrilbur@gmail.com, joe@perches.com, mm-commits@vger.kernel.org, stable@vger.kernel.org


The patch titled
     Subject: checkpatch: silence perl 5.26.0 unescaped left brace warnings
has been removed from the -mm tree.  Its filename was
     checkpatch-silence-perl-5260-unescaped-left-brace-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyril Bur <cyrilbur@gmail.com>
Subject: checkpatch: silence perl 5.26.0 unescaped left brace warnings

As of perl 5, version 26, subversion 0 (v5.26.0) some new warnings have
occurred when running checkpatch.

Unescaped left brace in regex is deprecated here (and will be fatal in
Perl 5.30), passed through in regex; marked by <-- HERE in m/^(.\s*){
<-- HERE \s*/ at scripts/checkpatch.pl line 3544.

Unescaped left brace in regex is deprecated here (and will be fatal in
Perl 5.30), passed through in regex; marked by <-- HERE in m/^(.\s*){
<-- HERE \s*/ at scripts/checkpatch.pl line 3885.

Unescaped left brace in regex is deprecated here (and will be fatal in
Perl 5.30), passed through in regex; marked by <-- HERE in
m/^(\+.*(?:do|\))){ <-- HERE / at scripts/checkpatch.pl line 4374.

It seems perfectly reasonable to do as the warning suggests and simply
escape the left brace in these three locations.

Link: http://lkml.kernel.org/r/20170607060135.17384-1-cyrilbur@gmail.com
Signed-off-by: Cyril Bur <cyrilbur@gmail.com>
Acked-by: Joe Perches <joe@perches.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-silence-perl-5260-unescaped-left-brace-warnings scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-silence-perl-5260-unescaped-left-brace-warnings
+++ a/scripts/checkpatch.pl
@@ -3555,7 +3555,7 @@ sub process {
 				$fixedline =~ s/\s*=\s*$/ = {/;
 				fix_insert_line($fixlinenr, $fixedline);
 				$fixedline = $line;
-				$fixedline =~ s/^(.\s*){\s*/$1/;
+				$fixedline =~ s/^(.\s*)\{\s*/$1/;
 				fix_insert_line($fixlinenr, $fixedline);
 			}
 		}
@@ -3896,7 +3896,7 @@ sub process {
 				my $fixedline = rtrim($prevrawline) . " {";
 				fix_insert_line($fixlinenr, $fixedline);
 				$fixedline = $rawline;
-				$fixedline =~ s/^(.\s*){\s*/$1\t/;
+				$fixedline =~ s/^(.\s*)\{\s*/$1\t/;
 				if ($fixedline !~ /^\+\s*$/) {
 					fix_insert_line($fixlinenr, $fixedline);
 				}
@@ -4385,7 +4385,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "space required before the open brace '{'\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$fixlinenr] =~ s/^(\+.*(?:do|\))){/$1 {/;
+				$fixed[$fixlinenr] =~ s/^(\+.*(?:do|\)))\{/$1 {/;
 			}
 		}
 
_

Patches currently in -mm which might be from cyrilbur@gmail.com are


