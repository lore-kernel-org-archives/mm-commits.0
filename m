From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-strict-test-for-lines-ending-in-or.patch removed from -mm
 tree
Date: Mon, 20 Nov 2017 13:24:48 -0800
Message-ID: <20171120212448.RlfURYjjw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40620 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbdKTVYt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:24:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org, vivien.didelot@savoirfairelinux.com


The patch titled
     Subject: checkpatch: add --strict test for lines ending in [ or (
has been removed from the -mm tree.  Its filename was
     checkpatch-add-strict-test-for-lines-ending-in-or.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add --strict test for lines ending in [ or (

Lines that end in an open bracket or open parenthesis are generally hard
to follow.  Lines following those ending with open parenthesis are also
rarely aligned to that open parenthesis.

Suggest not ending lines with '[' or '('

Link: http://lkml.kernel.org/r/8fd0b2b4a7482064254e37931eb9302a81d5aa2f.1508340786.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-test-for-lines-ending-in-or scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-test-for-lines-ending-in-or
+++ a/scripts/checkpatch.pl
@@ -3184,6 +3184,12 @@ sub process {
 # check we are in a valid C source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c)$/);
 
+# check for unusual line ending [ or (
+		if ($line =~ /^\+.*([\[\(])\s*$/) {
+			CHK("OPEN_ENDED_LINE",
+			    "Lines should not end with a '$1'\n" . $herecurr);
+		}
+
 # check if this appears to be the start function declaration, save the name
 		if ($sline =~ /^\+\{\s*$/ &&
 		    $prevline =~ /^\+(?:(?:(?:$Storage|$Inline)\s*)*\s*$Type\s*)?($Ident)\(/) {
_

Patches currently in -mm which might be from joe@perches.com are


