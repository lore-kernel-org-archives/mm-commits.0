From: akpm@linux-foundation.org
Subject: + checkpatch-notice-unbalanced-else-braces-in-a-patch.patch added to -mm tree
Date: Tue, 14 Feb 2017 17:05:52 -0800
Message-ID: <58a3a970.LTUvusugGEmcNeMf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33754 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751103AbdBOBFx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Feb 2017 20:05:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: notice unbalanced else braces in a patch
has been added to the -mm tree.  Its filename is
     checkpatch-notice-unbalanced-else-braces-in-a-patch.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-notice-unbalanced-else-braces-in-a-patch.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-notice-unbalanced-else-braces-in-a-patch.patch

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

checkpatch-warn-on-embedded-function-names.patch
checkpatch-warn-on-logging-continuations.patch
checkpatch-notice-unbalanced-else-braces-in-a-patch.patch
checkpatchpl-warn-against-using-%z-fix.patch

