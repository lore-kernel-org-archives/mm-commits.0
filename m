From: akpm@linux-foundation.org
Subject: + checkpatch-perform-indent-checks-on-perl.patch added to -mm tree
Date: Tue, 12 Aug 2008 15:27:12 -0700
Message-ID: <200808122227.m7CMRCgG016743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48622 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751852AbYHLW1t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 18:27:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: perform indent checks on perl
has been added to the -mm tree.  Its filename is
     checkpatch-perform-indent-checks-on-perl.patch

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
Subject: checkpatch: perform indent checks on perl
From: Andy Whitcroft <apw@shadowen.org>

So that we eat our own dog food ensure the indent checks apply to perl
too.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-perform-indent-checks-on-perl scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-perform-indent-checks-on-perl
+++ a/scripts/checkpatch.pl
@@ -1266,8 +1266,8 @@ sub process {
 			WARN("adding a line without newline at end of file\n" . $herecurr);
 		}
 
-# check we are in a valid source file *.[hc] if not then ignore this hunk
-		next if ($realfile !~ /\.[hc]$/);
+# check we are in a valid source file C or perl if not then ignore this hunk
+		next if ($realfile !~ /\.(h|c|pl)$/);
 
 # at the beginning of a line any tabs must come first and anything
 # more than 8 must use tabs.
@@ -1277,6 +1277,9 @@ sub process {
 			ERROR("code indent should use tabs where possible\n" . $herevet);
 		}
 
+# check we are in a valid C source file if not then ignore this hunk
+		next if ($realfile !~ /\.(h|c)$/);
+
 # check for RCS/CVS revision markers
 		if ($rawline =~ /^\+.*\$(Revision|Log|Id)(?:\$|)/) {
 			WARN("CVS style keyword markers, these will _not_ be updated\n". $herecurr);
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

