From: akpm@linux-foundation.org
Subject: + checkpatch-fix-return-is-not-a-function-square-bracket-handling.patch added to -mm tree
Date: Wed, 30 Nov 2011 14:20:05 -0800
Message-ID: <201111302220.pAUMK6Gt020163@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:38146 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1K3WUH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 17:20:07 -0500
Received: by ghrr18 with SMTP id r18so151822ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 14:20:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: apw@canonical.com, joe@perches.com


The patch titled
     Subject: checkpatch: fix 'return is not a function' square bracket handling
has been added to the -mm tree.  Its filename is
     checkpatch-fix-return-is-not-a-function-square-bracket-handling.patch

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
Subject: checkpatch: fix 'return is not a function' square bracket handling

We are incorrectly matching square brackets '[' and ']' leading to false
positives on more complex functions as below:

    return (dt3155_fbuffer[m]->ready_head -
	dt3155_fbuffer[m]->ready_len +
	dt3155_fbuffer[m]->nbuffers)%
	(dt3155_fbuffer[m]->nbuffers);

Signed-off-by: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-return-is-not-a-function-square-bracket-handling scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-return-is-not-a-function-square-bracket-handling
+++ a/scripts/checkpatch.pl
@@ -2609,7 +2609,7 @@ sub process {
 			# Flatten any parentheses
 			$value =~ s/\(/ \(/g;
 			$value =~ s/\)/\) /g;
-			while ($value =~ s/\[[^\{\}]*\]/1/ ||
+			while ($value =~ s/\[[^\[\]]*\]/1/ ||
 			       $value !~ /(?:$Ident|-?$Constant)\s*
 					     $Compare\s*
 					     (?:$Ident|-?$Constant)/x &&
_
Subject: Subject: checkpatch: fix 'return is not a function' square bracket handling

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

