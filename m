From: akpm@linux-foundation.org
Subject: [patch 051/114] checkpatch: improve the TABSTOP test to
 include declarations
Date: Tue, 06 Feb 2018 15:38:59 -0800
Message-ID: <20180206233859.LiPlNlZAz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55024 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754126AbeBFXjB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:39:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
