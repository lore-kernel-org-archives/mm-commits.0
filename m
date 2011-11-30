From: akpm@linux-foundation.org
Subject: + checkpatch-typeof-may-have-more-complex-arguments.patch added to -mm tree
Date: Wed, 30 Nov 2011 14:20:14 -0800
Message-ID: <201111302220.pAUMKEai007016@wpaz5.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vw0-f74.google.com ([209.85.212.74]:52387 "EHLO
	mail-vw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1K3WUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 17:20:16 -0500
Received: by mail-vw0-f74.google.com with SMTP id ez10so134788vbb.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 14:20:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: typeof may have more complex arguments
has been added to the -mm tree.  Its filename is
     checkpatch-typeof-may-have-more-complex-arguments.patch

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
Subject: checkpatch: typeof may have more complex arguments

typeof may have various more complex forms as its arguement, not just an
identifier.  For now allow us to leak to the first close perenthesis ')'.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-typeof-may-have-more-complex-arguments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-typeof-may-have-more-complex-arguments
+++ a/scripts/checkpatch.pl
@@ -315,7 +315,7 @@ sub build_types {
 	$NonptrType	= qr{
 			(?:$Modifier\s+|const\s+)*
 			(?:
-				(?:typeof|__typeof__)\s*\(\s*\**\s*$Ident\s*\)|
+				(?:typeof|__typeof__)\s*\([^\)]*\)|
 				(?:$typeTypedefs\b)|
 				(?:${all}\b)
 			)
_
Subject: Subject: checkpatch: typeof may have more complex arguments

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

