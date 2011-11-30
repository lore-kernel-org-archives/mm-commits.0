From: akpm@linux-foundation.org
Subject: + checkpatch-is-not-a-valid-modifier.patch added to -mm tree
Date: Wed, 30 Nov 2011 14:19:50 -0800
Message-ID: <201111302219.pAUMJpqL001401@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:53118 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1K3WTw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 17:19:52 -0500
Received: by yenq8 with SMTP id q8so16276yen.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 14:19:52 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: ## is not a valid modifier
has been added to the -mm tree.  Its filename is
     checkpatch-is-not-a-valid-modifier.patch

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
Subject: checkpatch: ## is not a valid modifier

Inserting a # into the modifiers list will incorrectly add the null string
to the modifiers list, leading to an infinite loop.  As neither of these
is a valid modifier form simply ignore them.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-is-not-a-valid-modifier scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-is-not-a-valid-modifier
+++ a/scripts/checkpatch.pl
@@ -1224,7 +1224,9 @@ sub possible {
 			case|
 			else|
 			asm|__asm__|
-			do
+			do|
+			\#|
+			\#\#|
 		)(?:\s|$)|
 		^(?:typedef|struct|enum)\b
 	    )}x;
_
Subject: Subject: checkpatch: ## is not a valid modifier

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

