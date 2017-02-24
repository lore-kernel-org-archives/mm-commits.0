From: akpm@linux-foundation.org
Subject: [patch 123/124] checkpatch: notice unbalanced else braces in a
 patch
Date: Fri, 24 Feb 2017 15:01:41 -0800
Message-ID: <58b0bb55.HHtLLyFpNaAkoYlq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39336 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751860AbdBXXBm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2017 18:01:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com

From: Joe Perches <joe@perches.com>
Subject: checkpatch: notice unbalanced else braces in a patch

Patches that add or modify code like
	} else
		<foo>
or
	else {
		<bar>

where one branch appears to have a brace and the other branch
does not have a brace should emit a --strict style message.

Link: http://lkml.kernel.org/r/c6be32747fc725cbc235802991746700a0f54fdc.1486754390.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-notice-unbalanced-else-braces-in-a-patch scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-notice-unbalanced-else-braces-in-a-patch
+++ a/scripts/checkpatch.pl
@@ -5104,6 +5104,12 @@ sub process {
 			}
 		}
 
+# check for single line unbalanced braces
+		if ($sline =~ /.\s*\}\s*else\s*$/ ||
+		    $sline =~ /.\s*else\s*\{\s*$/) {
+			CHK("BRACES", "Unbalanced braces around else statement\n" . $herecurr);
+		}
+
 # check for unnecessary blank lines around braces
 		if (($line =~ /^.\s*}\s*$/ && $prevrawline =~ /^.\s*$/)) {
 			if (CHK("BRACES",
_
