From: akpm@linux-foundation.org
Subject: [patch 45/94] checkpatch: add --strict test for lines
 ending in [ or (
Date: Fri, 17 Nov 2017 15:28:52 -0800
Message-ID: <20171117232852.YRVh2nNlE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55666 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759270AbdKQX2x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:28:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, vivien.didelot@savoirfairelinux.com

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
