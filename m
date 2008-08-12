From: akpm@linux-foundation.org
Subject: + checkpatch-conditional-indent-labels-have-different-indent-rules.patch added to -mm tree
Date: Tue, 12 Aug 2008 15:26:46 -0700
Message-ID: <200808122226.m7CMQkme016698@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832AbYHLW12 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 18:27:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: conditional indent -- labels have different indent rules
has been added to the -mm tree.  Its filename is
     checkpatch-conditional-indent-labels-have-different-indent-rules.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: conditional indent -- labels have different indent rules
From: Andy Whitcroft <apw@shadowen.org>

Labels have different indent rules and must be ignored when checking the
conditional indent levels.  Also correct identify labels in single
statement conditionals.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-conditional-indent-labels-have-different-indent-rules scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-conditional-indent-labels-have-different-indent-rules
+++ a/scripts/checkpatch.pl
@@ -782,9 +782,9 @@ sub annotate_values {
 			}
 			$type = 'N';
 
-		} elsif ($cur =~ /^(if|while|typeof|__typeof__|for)\b/o) {
+		} elsif ($cur =~ /^(if|while|for)\b/o) {
 			print "COND($1)\n" if ($dbg_values > 1);
-			$av_pending = 'N';
+			$av_pending = 'E';
 			$type = 'N';
 
 		} elsif ($cur =~/^(case)/o) {
@@ -792,7 +792,7 @@ sub annotate_values {
 			$av_pend_colon = 'C';
 			$type = 'N';
 
-		} elsif ($cur =~/^(return|else|goto)/o) {
+		} elsif ($cur =~/^(return|else|goto|typeof|__typeof__)\b/o) {
 			print "KEYWORD($1)\n" if ($dbg_values > 1);
 			$type = 'N';
 
@@ -1846,6 +1846,11 @@ sub process {
 				$check = 0;
 			}
 
+			# Ignore the current line if it is label.
+			if ($s =~ /^\s*$Ident\s*:/) {
+				$check = 0;
+			}
+
 			my (undef, $sindent) = line_stats("+" . $s);
 
 			##print "line<$line> prevline<$prevline> indent<$indent> sindent<$sindent> check<$check> continuation<$continuation> s<$s>\n";
_

Patches currently in -mm which might be from apw@shadowen.org are

hugetlbfs-allocate-structures-for-reservation-tracking-outside-of-spinlocks.patch
allocate-structures-for-reservation-tracking-in-hugetlbfs-outside-of-spinlocks-v2.patch
checkpatch-square-brackets-exemption-for-array-slices-in-braces.patch
checkpatch-values-double-ampersand-may-be-unary.patch
checkpatch-conditional-indent-labels-have-different-indent-rules.patch
checkpatch-switch-indent-allow-plain-return.patch
checkpatch-add-tests-for-the-attribute-matcher.patch
checkpatch-____cacheline_aligned-et-al-are-modifiers.patch
checkpatch-complex-macros-fix-up-extension-handling.patch
checkpatch-fix-up-comment-checks-search-to-scan-the-entire-block.patch
checkpatch-include-asm-checks-should-be-anchored.patch
checkpatch-reduce-warnings-for-include-of-asm-fooh-to-check-from-arch-barc.patch
checkpatch-report-any-absolute-references-to-kernel-source-files.patch
checkpatch-report-the-real-first-line-of-all-suspect-indents.patch
checkpatch-suspect-indent-skip-over-preprocessor-label-and-blank-lines.patch
checkpatch-%lx-tests-should-hand-%%-as-a-literal.patch
checkpatch-report-the-correct-lines-for-single-statement-blocks.patch
checkpatch-perform-indent-checks-on-perl.patch
checkpatch-version-022.patch
page-owner-tracking-leak-detector.patch

