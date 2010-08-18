From: akpm@linux-foundation.org
Subject: + checkpatch-returning-errno-typically-should-be-negative.patch added to -mm tree
Date: Wed, 18 Aug 2010 13:25:21 -0700
Message-ID: <201008182025.o7IKPLQ7010339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539Ab0HRUZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 16:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, akpm@linux-foundation.org


The patch titled
     checkpatch: returning errno typically should be negative
has been added to the -mm tree.  Its filename is
     checkpatch-returning-errno-typically-should-be-negative.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: returning errno typically should be negative
From: Andy Whitcroft <apw@canonical.com>

Add a (strict mode only) test to check for non-negative returns of what
appear to be errno values as the majority case these should indeed be
negative.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-returning-errno-typically-should-be-negative scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-returning-errno-typically-should-be-negative
+++ a/scripts/checkpatch.pl
@@ -2204,6 +2204,13 @@ sub process {
 				ERROR("space required before the open parenthesis '('\n" . $herecurr);
 			}
 		}
+# Return of what appears to be an errno should normally be -'ve
+		if ($line =~ /^.\s*return\s*(E[A-Z]*)\s*;/) {
+			my $name = $1;
+			if ($name ne 'EOF' && $name ne 'ERROR') {
+				WARN("return of an errno should typically be -ve (return -$1)\n" . $herecurr);
+			}
+		}
 
 # Need a space before open parenthesis after if, while etc
 		if ($line=~/\b(if|while|for|switch)\(/) {
_

Patches currently in -mm which might be from apw@canonical.com are

checkpatch-fix-regressions-in-fix-handling-of-leading-spaces.patch
checkpatch-types-may-sit-on-a-line-on-their-own.patch
checkpatch-suggest-cleanpatch-and-cleanfile-when-appropriate.patch
checkpatch-ensure-we-do-not-collapse-bracketed-sections-into-constants.patch
checkpatch-handle-casts-better-fixing-false-categorisation-of-as-binary.patch
checkpatch-returning-errno-typically-should-be-negative.patch
checkpatch-add-check-for-space-after-struct-union-and-enum.patch
checkpatch-simplify-and-consolidate-missing-space-after-checks.patch
checkpatch-ensure-kconfig-help-checks-only-apply-when-we-are-adding-help.patch
checkpatch-check-for-incorrect-permissions.patch
checkpatch-add-additional-attribute-defines.patch
checkpatch-update-copyright-dates.patch
checkpatch-clean-up-structure-definition-macro-handline.patch
checkpatch-handle-export_symbol-for-device_attr-and-similar.patch
checkpatch-statement-block-context-analyser-should-look-at-sanitised-lines.patch
checkpatch-version-031.patch

