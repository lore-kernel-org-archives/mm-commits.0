From: akpm@linux-foundation.org
Subject: + checkpatch-add-check-for-space-after-struct-union-and-enum.patch added to -mm tree
Date: Wed, 18 Aug 2010 13:25:23 -0700
Message-ID: <201008182025.o7IKPNC3010342@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57365 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754145Ab0HRUbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 16:31:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, joe@perches.com


The patch titled
     checkpatch: add check for space after struct, union, and enum
has been added to the -mm tree.  Its filename is
     checkpatch-add-check-for-space-after-struct-union-and-enum.patch

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
Subject: checkpatch: add check for space after struct, union, and enum
From: Andy Whitcroft <apw@canonical.com>

Add spacing checks for struct, union, and enum definitions.  Check the
spacing after type and before the equals (=) and open brace ({).

Based on a patch by Joe Perches.

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-check-for-space-after-struct-union-and-enum scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-check-for-space-after-struct-union-and-enum
+++ a/scripts/checkpatch.pl
@@ -1905,6 +1905,16 @@ sub process {
 			ERROR("open brace '{' following function declarations go on the next line\n" . $herecurr);
 		}
 
+# missing space after union or struct definition
+		if ($rawline =~ /^\+\s*(union|struct)\s+$Ident[=\{]/) {
+		    WARN("Missing space after struct or union definition\n" . $herecurr);
+		}
+
+# missing space after enum definition
+		if ($rawline =~ /^\+\s*enum\{/) {
+		    WARN("Missing space after enum definition\n" . $herecurr);
+		}
+
 # open braces for enum, union and struct go on the same line.
 		if ($line =~ /^.\s*{/ &&
 		    $prevline =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?\s*$/) {
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

