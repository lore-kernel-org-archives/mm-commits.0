From: akpm@linux-foundation.org
Subject: + checkpatch-report-any-absolute-references-to-kernel-source-files.patch added to -mm tree
Date: Tue, 12 Aug 2008 15:27:02 -0700
Message-ID: <200808122227.m7CMR24U016728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbYHLWbI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 18:31:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@shadowen.org


The patch titled
     checkpatch: report any absolute references to kernel source files
has been added to the -mm tree.  Its filename is
     checkpatch-report-any-absolute-references-to-kernel-source-files.patch

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
Subject: checkpatch: report any absolute references to kernel source files
From: Andy Whitcroft <apw@shadowen.org>

Absolute references to kernel source files are generally only useful
locally to the originator of the patch.  Check for any such references and
report them.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   41 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-report-any-absolute-references-to-kernel-source-files scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-report-any-absolute-references-to-kernel-source-files
+++ a/scripts/checkpatch.pl
@@ -958,6 +958,33 @@ sub CHK {
 	}
 }
 
+sub check_absolute_file {
+	my ($absolute, $herecurr) = @_;
+	my $file = $absolute;
+
+	##print "absolute<$absolute>\n";
+
+	# See if any suffix of this path is a path within the tree.
+	while ($file =~ s@^[^/]*/@@) {
+		if (-f "$root/$file") {
+			##print "file<$file>\n";
+			last;
+		}
+	}
+	if (! -f _)  {
+		return 0;
+	}
+
+	# It is, so see if the prefix is acceptable.
+	my $prefix = $absolute;
+	substr($prefix, -length($file)) = '';
+
+	##print "prefix<$prefix>\n";
+	if ($prefix ne ".../") {
+		WARN("use relative pathname instead of absolute in changelog text\n" . $herecurr);
+	}
+}
+
 sub process {
 	my $filename = shift;
 
@@ -1168,6 +1195,20 @@ sub process {
 				$herecurr) if (!$emitted_corrupt++);
 		}
 
+# Check for absolute kernel paths.
+		if ($tree) {
+			while ($line =~ m{(?:^|\s)(/\S*)}g) {
+				my $file = $1;
+
+				if ($file =~ m{^(.*?)(?::\d+)+:?$} &&
+				    check_absolute_file($1, $herecurr)) {
+					#
+				} else {
+					check_absolute_file($file, $herecurr);
+				}
+			}
+		}
+
 # UTF-8 regex found at http://www.w3.org/International/questions/qa-forms-utf-8.en.php
 		if (($realfile =~ /^$/ || $line =~ /^\+/) &&
 		    $rawline !~ m/^$UTF8*$/) {
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

