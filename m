From: akpm@linux-foundation.org
Subject: + checkpatch-simplify-and-consolidate-missing-space-after-checks.patch added to -mm tree
Date: Wed, 18 Aug 2010 13:25:25 -0700
Message-ID: <201008182025.o7IKPP9r010345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36573 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753489Ab0HRUbp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 16:31:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: simplify and consolidate "missing space after" checks
has been added to the -mm tree.  Its filename is
     checkpatch-simplify-and-consolidate-missing-space-after-checks.patch

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
Subject: checkpatch: simplify and consolidate "missing space after" checks
From: Andy Whitcroft <apw@canonical.com>

Commonise the code for missing spaces after struct, union, and enum such
that they share the same code.  Ensure we cover all the common cases in
each case.  Check against the sanitised line to ensure we do not report on
comments and strings.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-simplify-and-consolidate-missing-space-after-checks scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-simplify-and-consolidate-missing-space-after-checks
+++ a/scripts/checkpatch.pl
@@ -1905,22 +1905,17 @@ sub process {
 			ERROR("open brace '{' following function declarations go on the next line\n" . $herecurr);
 		}
 
-# missing space after union or struct definition
-		if ($rawline =~ /^\+\s*(union|struct)\s+$Ident[=\{]/) {
-		    WARN("Missing space after struct or union definition\n" . $herecurr);
-		}
-
-# missing space after enum definition
-		if ($rawline =~ /^\+\s*enum\{/) {
-		    WARN("Missing space after enum definition\n" . $herecurr);
-		}
-
 # open braces for enum, union and struct go on the same line.
 		if ($line =~ /^.\s*{/ &&
 		    $prevline =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?\s*$/) {
 			ERROR("open brace '{' following $1 go on the same line\n" . $hereprev);
 		}
 
+# missing space after union, struct or enum definition
+		if ($line =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?(?:\s+$Ident)?[=\{]/) {
+		    WARN("missing space after $1 definition\n" . $herecurr);
+		}
+
 # check for spacing round square brackets; allowed:
 #  1. with a type on the left -- int [] a;
 #  2. at the beginning of a line for slice initialisers -- [0...10] = 5,
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

