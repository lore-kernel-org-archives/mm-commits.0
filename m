From: akpm@linux-foundation.org
Subject: [patch 053/114] checkpatch: avoid some false positives for
 TABSTOP declaration test
Date: Tue, 06 Feb 2018 15:39:06 -0800
Message-ID: <20180206233906.S5pAHbVa2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55046 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932067AbeBFXjI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:39:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, sven@narfation.org, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: checkpatch: avoid some false positives for TABSTOP declaration test

Using an open bracket after what seems to be a declaration can also be a
function definition and declaration argument line continuation so remove
the open bracket from the possible declaration/definition matching.

e.g.:
	int foobar(int a;
		   int *b[]);

Link: http://lkml.kernel.org/r/1515704479.9619.171.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Reported-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-avoid-some-false-positives-for-tabstop-declaration-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-avoid-some-false-positives-for-tabstop-declaration-test
+++ a/scripts/checkpatch.pl
@@ -3020,7 +3020,7 @@ sub process {
 
 # check indentation starts on a tab stop
 		if ($^V && $^V ge 5.10.0 &&
-		    $sline =~ /^\+\t+( +)(?:$c90_Keywords\b|\{\s*$|\}\s*(?:else\b|while\b|\s*$)|$Declare\s*$Ident\s*[;=\[])/) {
+		    $sline =~ /^\+\t+( +)(?:$c90_Keywords\b|\{\s*$|\}\s*(?:else\b|while\b|\s*$)|$Declare\s*$Ident\s*[;=])/) {
 			my $indent = length($1);
 			if ($indent % 8) {
 				if (WARN("TABSTOP",
_
