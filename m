From: akpm@linux-foundation.org
Subject: + checkpatch-check-line-endings-in-text-format-files.patch added to -mm tree
Date: Tue, 02 Sep 2008 17:50:30 -0700
Message-ID: <200809030050.m830oUDe021502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39427 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755079AbYICAuj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Sep 2008 20:50:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: check line endings in text format files
has been added to the -mm tree.  Its filename is
     checkpatch-check-line-endings-in-text-format-files.patch

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
Subject: checkpatch: check line endings in text format files
From: Andy Whitcroft <apw@shadowen.org>

Firmware may be included in the kernel as .ihex files.  These are
inherantly text, but not source.  The line ending checks are applicable to
these kinds of file, allow just these checks to apply to all files.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-check-line-endings-in-text-format-files scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-line-endings-in-text-format-files
+++ a/scripts/checkpatch.pl
@@ -1241,9 +1241,6 @@ sub process {
 #ignore lines being removed
 		if ($line=~/^-/) {next;}
 
-# check we are in a valid source file if not then ignore this hunk
-		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
-
 #trailing whitespace
 		if ($line =~ /^\+.*\015/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
@@ -1253,6 +1250,10 @@ sub process {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
 			ERROR("trailing whitespace\n" . $herevet);
 		}
+
+# check we are in a valid source file if not then ignore this hunk
+		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
+
 #80 column limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
 		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
_

Patches currently in -mm which might be from apw@shadowen.org are

mm-make-setup_zone_migrate_reserve-aware-of-overlapping-nodes.patch
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
page-owner-tracking-leak-detector.patch

