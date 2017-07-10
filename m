From: akpm@linux-foundation.org
Subject: [patch 106/115] checkpatch: improve multi-line alignment
 test
Date: Mon, 10 Jul 2017 15:52:30 -0700
Message-ID: <20170710225230._AZQsrIGt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43584 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754867AbdGJWwc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:52:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
@@ -2993,7 +2993,7 @@ sub process {
 
 # check multi-line statement indentation matches previous line
 		if ($^V && $^V ge 5.10.0 &&
-		    $prevline =~ /^\+([ \t]*)((?:$c90_Keywords(?:\s+if)\s*)|(?:$Declare\s*)?(?:$Ident|\(\s*\*\s*$Ident\s*\))\s*|$Ident\s*=\s*$Ident\s*)\(.*(\&\&|\|\||,)\s*$/) {
+		    $prevline =~ /^\+([ \t]*)((?:$c90_Keywords(?:\s+if)\s*)|(?:$Declare\s*)?(?:$Ident|\(\s*\*\s*$Ident\s*\))\s*|(?:\*\s*)*$Lval\s*=\s*$Ident\s*)\(.*(\&\&|\|\||,)\s*$/) {
 			$prevline =~ /^\+(\t*)(.*)$/;
 			my $oldindent = $1;
 			my $rest = $2;
_
