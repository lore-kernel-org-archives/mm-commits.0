From: akpm@linux-foundation.org
Subject: + checkpatch-clean-up-structure-definition-macro-handline.patch added to -mm tree
Date: Wed, 18 Aug 2010 13:25:36 -0700
Message-ID: <201008182025.o7IKPaI8010362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754145Ab0HRUbo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Aug 2010 16:31:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com


The patch titled
     checkpatch: clean up structure definition macro handline
has been added to the -mm tree.  Its filename is
     checkpatch-clean-up-structure-definition-macro-handline.patch

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
Subject: checkpatch: clean up structure definition macro handline
From: Andy Whitcroft <apw@canonical.com>

Handle definitions such as the following correctly, it is not
a complex statement:

    #define PREALLOC(NAME, START, END, FLAGS) {     \
		    .name = (NAME),                 \
		    .start = (START),               \
		    .end = (END),                   \
		    .flags = (FLAGS)                \
	    },

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-clean-up-structure-definition-macro-handline scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-clean-up-structure-definition-macro-handline
+++ a/scripts/checkpatch.pl
@@ -2476,8 +2476,8 @@ sub process {
 				\.$Ident\s*=\s*|
 				^\"|\"$
 			}x;
-			#print "REST<$rest> dstat<$dstat>\n";
-			if ($rest ne '') {
+			#print "REST<$rest> dstat<$dstat> ctx<$ctx>\n";
+			if ($rest ne '' && $rest ne ',') {
 				if ($rest !~ /while\s*\(/ &&
 				    $dstat !~ /$exceptions/)
 				{
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

