From: akpm@linux-foundation.org
Subject: + checkpatch-square-brackets-exemption-for-array-slices-in-braces.patch added to -mm tree
Date: Tue, 12 Aug 2008 15:26:42 -0700
Message-ID: <200808122226.m7CMQgam016692@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457AbYHLW1U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 18:27:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: square brackets -- exemption for array slices in braces
has been added to the -mm tree.  Its filename is
     checkpatch-square-brackets-exemption-for-array-slices-in-braces.patch

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
Subject: checkpatch: square brackets -- exemption for array slices in braces
From: Andy Whitcroft <apw@shadowen.org>

It is wholy reasonable to have square brackets representing array slices
in braces on the same line.  These should be spaced.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-square-brackets-exemption-for-array-slices-in-braces scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-square-brackets-exemption-for-array-slices-in-braces
+++ a/scripts/checkpatch.pl
@@ -1493,11 +1493,13 @@ sub process {
 
 # check for spacing round square brackets; allowed:
 #  1. with a type on the left -- int [] a;
-#  2. at the beginning of a line for slice initialisers -- [0..10] = 5,
+#  2. at the beginning of a line for slice initialisers -- [0...10] = 5,
+#  3. inside a curly brace -- = { [0...10] = 5 }
 		while ($line =~ /(.*?\s)\[/g) {
 			my ($where, $prefix) = ($-[1], $1);
 			if ($prefix !~ /$Type\s+$/ &&
-			    ($where != 0 || $prefix !~ /^.\s+$/)) {
+			    ($where != 0 || $prefix !~ /^.\s+$/) &&
+			    $prefix !~ /{\s+$/) {
 				ERROR("space prohibited before open square bracket '['\n" . $herecurr);
 			}
 		}
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

