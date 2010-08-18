From: akpm@linux-foundation.org
Subject: + checkpatch-fix-regressions-in-fix-handling-of-leading-spaces.patch added to -mm tree
Date: Wed, 18 Aug 2010 13:25:09 -0700
Message-ID: <201008182025.o7IKP9jM010315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944Ab0HRUZn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 16:25:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: fix regressions in "fix handling of leading spaces"
has been added to the -mm tree.  Its filename is
     checkpatch-fix-regressions-in-fix-handling-of-leading-spaces.patch

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
Subject: checkpatch: fix regressions in "fix handling of leading spaces"
From: Andy Whitcroft <apw@canonical.com>

The patch "checkpatch: fix handling of leading spaces" added checks for
leading spaces on lines, but this introduces regressions.  Firstly it does
not correctly detect when we are in a comment.  Secondly it does not allow
for preprocessor command spacing.  Finally it does not allow for label
indentation which is required to be less than one tab.  Fix these up:

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-regressions-in-fix-handling-of-leading-spaces scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-regressions-in-fix-handling-of-leading-spaces
+++ a/scripts/checkpatch.pl
@@ -1459,10 +1459,13 @@ sub process {
 		}
 
 # check for spaces at the beginning of a line.
-		if ($rawline =~ /^\+ / && $rawline !~ /\+ +\*/)  {
+# Exceptions:
+#  1) within comments
+#  2) indented preprocessor commands
+#  3) hanging labels
+		if ($rawline =~ /^\+ / && $line !~ /\+ *(?:$;|#|$Ident:)/)  {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			WARN("please, no space for starting a line, \
-				excluding comments\n" . $herevet);
+			WARN("please, no spaces at the start of a line\n" . $herevet);
 		}
 
 # check we are in a valid C source file if not then ignore this hunk
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

