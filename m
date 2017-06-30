From: akpm@linux-foundation.org
Subject: + checkpatch-improve-multi-line-alignment-test.patch added to -mm tree
Date: Fri, 30 Jun 2017 12:02:40 -0700
Message-ID: <5956a050.9BlLBQZ8nO6R0exL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34096 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751072AbdF3TCl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 30 Jun 2017 15:02:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve multi-line alignment test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-multi-line-alignment-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-multi-line-alignment-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-multi-line-alignment-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve multi-line alignment test

The current test fails to warn about improper alignment with code like

	foo->bar = func(arg1,
				arg2);

because foo->bar is not a single identifier.

Convert the $Ident to $Lval which allows for multiple dereferences.

Link: http://lkml.kernel.org/r/01c35b9b6a12a415e57746d45d589bfaad39952a.1498841563.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-multi-line-alignment-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-multi-line-alignment-test
+++ a/scripts/checkpatch.pl
@@ -2992,7 +2992,7 @@ sub process {
 
 # check multi-line statement indentation matches previous line
 		if ($^V && $^V ge 5.10.0 &&
-		    $prevline =~ /^\+([ \t]*)((?:$c90_Keywords(?:\s+if)\s*)|(?:$Declare\s*)?(?:$Ident|\(\s*\*\s*$Ident\s*\))\s*|$Ident\s*=\s*$Ident\s*)\(.*(\&\&|\|\||,)\s*$/) {
+		    $prevline =~ /^\+([ \t]*)((?:$c90_Keywords(?:\s+if)\s*)|(?:$Declare\s*)?(?:$Ident|\(\s*\*\s*$Ident\s*\))\s*|(?:\*\s*)*$Lval\s*=\s*$Ident\s*)\(.*(\&\&|\|\||,)\s*$/) {
 			$prevline =~ /^\+(\t*)(.*)$/;
 			my $oldindent = $1;
 			my $rest = $2;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch
checkpatch-improve-tests-for-multiple-line-function-definitions.patch
checkpatch-improve-macro-reuse-test.patch
checkpatch-improve-multi-line-alignment-test.patch

