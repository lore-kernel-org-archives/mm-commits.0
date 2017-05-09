From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-clarify-the-embedded_function_name-message.patch removed from
 -mm tree
Date: Tue, 09 May 2017 11:01:20 -0700
Message-ID: <20170509180120.kN_Mf8_Bm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34368 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752586AbdEISBV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:01:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: clarify the EMBEDDED_FUNCTION_NAME message
has been removed from the -mm tree.  Its filename was
     checkpatch-clarify-the-embedded_function_name-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: clarify the EMBEDDED_FUNCTION_NAME message

Try to make the conversion of embedded function names to "%s: ", __func__
a bit clearer.

Add a bit more information to the comment describing the test too.

Link: http://lkml.kernel.org/r/38f5d32f0aec1cd98cb9ceeedd6a736cc9a802db.1491759835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-clarify-the-embedded_function_name-message scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-clarify-the-embedded_function_name-message
+++ a/scripts/checkpatch.pl
@@ -5174,14 +5174,16 @@ sub process {
 			     "break quoted strings at a space character\n" . $hereprev);
 		}
 
-#check for an embedded function name in a string when the function is known
-# as part of a diff.  This does not work for -f --file checking as it
-#depends on patch context providing the function name
+# check for an embedded function name in a string when the function is known
+# This does not work very well for -f --file checking as it depends on patch
+# context providing the function name or a single line form for in-file
+# function declarations
 		if ($line =~ /^\+.*$String/ &&
 		    defined($context_function) &&
-		    get_quoted_string($line, $rawline) =~ /\b$context_function\b/) {
+		    get_quoted_string($line, $rawline) =~ /\b$context_function\b/ &&
+		    length(get_quoted_string($line, $rawline)) != (length($context_function) + 2)) {
 			WARN("EMBEDDED_FUNCTION_NAME",
-			     "Prefer using \"%s\", __func__ to embedded function names\n" . $herecurr);
+			     "Prefer using '\"%s...\", __func__' to using '$context_function', this function's name, in a string\n" . $herecurr);
 		}
 
 # check for spaces before a quoted newline
_

Patches currently in -mm which might be from joe@perches.com are


