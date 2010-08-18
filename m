From: akpm@linux-foundation.org
Subject: + checkpatch-handle-casts-better-fixing-false-categorisation-of-as-binary.patch added to -mm tree
Date: Wed, 18 Aug 2010 13:25:19 -0700
Message-ID: <201008182025.o7IKPJ3g010334@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539Ab0HRU0B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 16:26:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, khali@linux-fr.org


The patch titled
     checkpatch: handle casts better fixing false categorisation of : as binary
has been added to the -mm tree.  Its filename is
     checkpatch-handle-casts-better-fixing-false-categorisation-of-as-binary.patch

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
Subject: checkpatch: handle casts better fixing false categorisation of : as binary
From: Andy Whitcroft <apw@canonical.com>

The following incantation is triggering categorisation of its colon (:) as
a binary form, which it is not:

	return foo ? (s8)bar : baz;

Handle casts differently from types in the categoriser, allowing us to
better track (s8)bar as a value and not a declaration.

Reported-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-handle-casts-better-fixing-false-categorisation-of-as-binary scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-handle-casts-better-fixing-false-categorisation-of-as-binary
+++ a/scripts/checkpatch.pl
@@ -845,6 +845,11 @@ sub annotate_values {
 				$av_preprocessor = 0;
 			}
 
+		} elsif ($cur =~ /^(\(\s*$Type\s*)\)/) {
+			print "CAST($1)\n" if ($dbg_values > 1);
+			push(@av_paren_type, $type);
+			$type = 'C';
+
 		} elsif ($cur =~ /^($Type)\s*(?:$Ident|,|\)|\(|\s*$)/) {
 			print "DECLARE($1)\n" if ($dbg_values > 1);
 			$type = 'T';
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

