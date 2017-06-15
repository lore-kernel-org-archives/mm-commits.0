From: akpm@linux-foundation.org
Subject: +
 checkpatch-silence-perl-5260-unescaped-left-brace-warnings.patch added to
 -mm tree
Date: Thu, 15 Jun 2017 16:08:07 -0700
Message-ID: <59431357.e9ffnhJI47BVqnMU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47028 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdFOXII (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 19:08:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cyrilbur@gmail.com, joe@perches.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: silence perl 5.26.0 unescaped left brace warnings
has been added to the -mm tree.  Its filename is
     checkpatch-silence-perl-5260-unescaped-left-brace-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-silence-perl-5260-unescaped-left-brace-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-silence-perl-5260-unescaped-left-brace-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3554,7 +3554,7 @@ sub process {
 				$fixedline =~ s/\s*=\s*$/ = {/;
 				fix_insert_line($fixlinenr, $fixedline);
 				$fixedline = $line;
-				$fixedline =~ s/^(.\s*){\s*/$1/;
+				$fixedline =~ s/^(.\s*)\{\s*/$1/;
 				fix_insert_line($fixlinenr, $fixedline);
 			}
 		}
@@ -3895,7 +3895,7 @@ sub process {
 				my $fixedline = rtrim($prevrawline) . " {";
 				fix_insert_line($fixlinenr, $fixedline);
 				$fixedline = $rawline;
-				$fixedline =~ s/^(.\s*){\s*/$1\t/;
+				$fixedline =~ s/^(.\s*)\{\s*/$1\t/;
 				if ($fixedline !~ /^\+\s*$/) {
 					fix_insert_line($fixlinenr, $fixedline);
 				}
@@ -4384,7 +4384,7 @@ sub process {
 			if (ERROR("SPACING",
 				  "space required before the open brace '{'\n" . $herecurr) &&
 			    $fix) {
-				$fixed[$fixlinenr] =~ s/^(\+.*(?:do|\))){/$1 {/;
+				$fixed[$fixlinenr] =~ s/^(\+.*(?:do|\)))\{/$1 {/;
 			}
 		}
 
_

Patches currently in -mm which might be from cyrilbur@gmail.com are

checkpatch-silence-perl-5260-unescaped-left-brace-warnings.patch

