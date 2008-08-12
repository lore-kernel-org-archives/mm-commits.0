From: akpm@linux-foundation.org
Subject: + checkpatch-complex-macros-fix-up-extension-handling.patch added to -mm tree
Date: Tue, 12 Aug 2008 15:26:54 -0700
Message-ID: <200808122226.m7CMQsia016710@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57139 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871AbYHLWbI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 18:31:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: complex macros -- fix up extension handling
has been added to the -mm tree.  Its filename is
     checkpatch-complex-macros-fix-up-extension-handling.patch

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
Subject: checkpatch: complex macros -- fix up extension handling
From: Andy Whitcroft <apw@shadowen.org>

Only pull in new extension lines where the current contents ends with a \.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-complex-macros-fix-up-extension-handling scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-complex-macros-fix-up-extension-handling
+++ a/scripts/checkpatch.pl
@@ -1977,8 +1977,8 @@ sub process {
 			# Extract the remainder of the define (if any) and
 			# rip off surrounding spaces, and trailing \'s.
 			$rest = '';
-			while ($off != 0 || ($cnt > 0 && $rest =~ /(?:^|\\)\s*$/)) {
-				#print "ADDING $off <" . substr($lines[$ln - 1], $off) . ">\n";
+			while ($off != 0 || ($cnt > 0 && $rest =~ /\\\s*$/)) {
+				#print "ADDING cnt<$cnt> $off <" . substr($lines[$ln - 1], $off) . "> rest<$rest>\n";
 				if ($off != 0 || $lines[$ln - 1] !~ /^-/) {
 					$rest .= substr($lines[$ln - 1], $off) . "\n";
 					$cnt--;
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

