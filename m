From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-avoid-some-false-positives-for-tabstop-declaration-test.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 11:57:47 -0800
Message-ID: <20180207195747.lyx1mHYAE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59774 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754446AbeBGT5s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:57:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org, sven@narfation.org


The patch titled
     Subject: checkpatch: avoid some false positives for TABSTOP declaration test
has been removed from the -mm tree.  Its filename was
     checkpatch-avoid-some-false-positives-for-tabstop-declaration-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from joe@perches.com are


