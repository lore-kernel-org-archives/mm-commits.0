From: akpm@linux-foundation.org
Subject: + checkpatch-complex-macro-should-allow-the-empty-do-while-loop.patch added to -mm tree
Date: Wed, 30 Nov 2011 14:20:02 -0800
Message-ID: <201111302220.pAUMK3oR006540@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:54965 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab1K3WUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 17:20:08 -0500
Received: by ggnp2 with SMTP id p2so152129ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 14:20:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: complex macro should allow the empty do while loop
has been added to the -mm tree.  Its filename is
     checkpatch-complex-macro-should-allow-the-empty-do-while-loop.patch

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
From: Andy Whitcroft <apw@canonical.com>
Subject: checkpatch: complex macro should allow the empty do while loop

It is common to stub out a function as below, this is triggering a complex
macro format incorrectly.  Sort this out:

    #define cma_early_regions_reserve(reserve)   do { } while (0)

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-complex-macro-should-allow-the-empty-do-while-loop scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-complex-macro-should-allow-the-empty-do-while-loop
+++ a/scripts/checkpatch.pl
@@ -2838,7 +2838,7 @@ sub process {
 			    $dstat !~ /^(?:$Ident|-?$Constant)$/ &&			# 10 // foo()
 			    $dstat !~ /$exceptions/ &&
 			    $dstat !~ /^\.$Ident\s*=/ &&				# .foo =
-			    $dstat !~ /^do\s*$Constant\s*while\s*$Constant;$/ &&	# do {...} while (...);
+			    $dstat !~ /^do\s*$Constant\s*while\s*$Constant;?$/ &&	# do {...} while (...); // do {...} while (...)
 			    $dstat !~ /^for\s*$Constant$/ &&				# for (...)
 			    $dstat !~ /^for\s*$Constant\s+(?:$Ident|-?$Constant)$/ &&	# for (...) bar()
 			    $dstat !~ /^do\s*{/ &&					# do {...
_
Subject: Subject: checkpatch: complex macro should allow the empty do while loop

Patches currently in -mm which might be from apw@canonical.com are

origin.patch
checkpatch-correctly-track-the-end-of-preprocessor-commands-in-context.patch
checkpatch-check-for-common-memset-parameter-issues-against-statments.patch
checkpatch-improve-memset-and-min-max-with-cast-checking.patch
checkpatch-is-not-a-valid-modifier.patch
checkpatch-optimise-statement-scanner-when-mid-statement.patch
checkpatch-only-apply-kconfig-help-checks-for-options-which-prompt.patch
checkpatch-fix-export_symbol-handling-following-a-function.patch
checkpatch-complex-macro-should-allow-the-empty-do-while-loop.patch
checkpatch-fix-return-is-not-a-function-square-bracket-handling.patch
checkpatch-fix-complex-macros-handling-of-square-brackets.patch
checkpatch-ensure-cast-type-is-unique-in-the-context-parser.patch
checkpatch-typeof-may-have-more-complex-arguments.patch

