From: akpm@linux-foundation.org
Subject: + checkpatch-suspect-code-indent-must-stop-at-else-elif.patch added to -mm tree
Date: Wed, 08 Oct 2008 15:23:47 -0700
Message-ID: <200810082223.m98MNmIG013619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56706 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755276AbYJHWX4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Oct 2008 18:23:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: suspect code indent must stop at #else/#elif
has been added to the -mm tree.  Its filename is
     checkpatch-suspect-code-indent-must-stop-at-else-elif.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: suspect code indent must stop at #else/#elif
From: Andy Whitcroft <apw@shadowen.org>

When we hit and #else or #elif we know we are meeting an alternative piece
of code.  All bets are off on indent if we did not see the open of the
control so stop checking.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-suspect-code-indent-must-stop-at-else-elif scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-suspect-code-indent-must-stop-at-else-elif
+++ a/scripts/checkpatch.pl
@@ -1468,6 +1468,12 @@ sub process {
 			while ($cond_ptr != $cond_lines) {
 				$cond_ptr = $cond_lines;
 
+				# If we see an #else/#elif then the code
+				# is not linear.
+				if ($s =~ /^\s*\#\s*(?:else|elif)/) {
+					$check = 0;
+				}
+
 				# Ignore:
 				#  1) blank lines, they should be at 0,
 				#  2) preprocessor lines, and
_

Patches currently in -mm which might be from apw@shadowen.org are

mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch
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
checkpatch-case-default-checks-should-only-check-changed-lines.patch
checkpatch-suppress-errors-triggered-by-short-patch.patch
checkpatch-handle-comment-quote-nesting-correctly.patch
checkpatch-check-line-endings-in-text-format-files.patch
checkpatch-suspect-indent-count-condition-lines-correctly.patch
checkpatch-ensure-we-only-apply-checks-to-the-lines-within-hunks.patch
checkpatch-version-023.patch
checkpatch-do-is-not-a-possible-type.patch
checkpatch-labels-are-not-possible-types.patch
checkpatch-handle-do-without-braces-if-we-have-enough-context.patch
checkpatch-macros-which-define-structure-members-are-not-complex.patch
checkpatch-accept-any-sized-le-be-type.patch
checkpatch-pull-out-known-acceptable-typedefs.patch
checkpatch-suspect-code-indent-must-stop-at-else-elif.patch
checkpatch-complex-macros-checks-miss-square-brackets.patch
checkpatch-define_-macros-are-real-definitions-for-exports.patch
checkpatch-trailing-statements-ensure-we-report-the-end-of-the-line.patch
checkpatch-suspect-indent-handle-macro-continuation.patch
checkpatch-allow-for-comments-either-side-of-a-brace-on-case.patch
checkpatch-version-024.patch
page-owner-tracking-leak-detector.patch

