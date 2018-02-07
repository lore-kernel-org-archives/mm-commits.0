From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-improve-the-tabstop-test-to-include-declarations.patch removed
 from -mm tree
Date: Wed, 07 Feb 2018 11:57:39 -0800
Message-ID: <20180207195739.lhSEvJG8y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59694 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754446AbeBGT5l (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:57:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve the TABSTOP test to include declarations
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-the-tabstop-test-to-include-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: improve the TABSTOP test to include declarations

Declarations should start on a tabstop too.

Link: http://lkml.kernel.org/r/1b5f97673f36595956ad43329f77bf1a5546d2ff.1513976662.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-the-tabstop-test-to-include-declarations scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-the-tabstop-test-to-include-declarations
+++ a/scripts/checkpatch.pl
@@ -3020,7 +3020,7 @@ sub process {
 
 # check indentation starts on a tab stop
 		if ($^V && $^V ge 5.10.0 &&
-		    $sline =~ /^\+\t+( +)(?:$c90_Keywords\b|\{\s*$|\}\s*(?:else\b|while\b|\s*$))/) {
+		    $sline =~ /^\+\t+( +)(?:$c90_Keywords\b|\{\s*$|\}\s*(?:else\b|while\b|\s*$)|$Declare\s*$Ident\s*[;=\[])/) {
 			my $indent = length($1);
 			if ($indent % 8) {
 				if (WARN("TABSTOP",
_

Patches currently in -mm which might be from joe@perches.com are


