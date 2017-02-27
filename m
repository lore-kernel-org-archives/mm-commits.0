From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-notice-unbalanced-else-braces-in-a-patch.patch removed from -mm
 tree
Date: Mon, 27 Feb 2017 12:29:29 -0800
Message-ID: <58b48c29.JZ2ElU3BnQOI/88I%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33586 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbdB0Ubs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:31:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: notice unbalanced else braces in a patch
has been removed from the -mm tree.  Its filename was
     checkpatch-notice-unbalanced-else-braces-in-a-patch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from joe@perches.com are

checkpatchpl-warn-against-using-%z-fix.patch

