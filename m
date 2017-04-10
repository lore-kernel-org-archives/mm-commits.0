From: akpm@linux-foundation.org
Subject: + checkpatch-clarify-the-embedded_function_name-message.patch
 added to -mm tree
Date: Mon, 10 Apr 2017 15:15:32 -0700
Message-ID: <58ec0404.RFD1Pm/9Nrd7o3+O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59510 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752155AbdDJWPd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 18:15:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: clarify the EMBEDDED_FUNCTION_NAME message
has been added to the -mm tree.  Its filename is
     checkpatch-clarify-the-embedded_function_name-message.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-clarify-the-embedded_function_name-message.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-clarify-the-embedded_function_name-message.patch

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

checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions.patch
checkpatch-improve-embedded_function_name-test.patch
checkpatch-allow-space-leading-blank-lines-in-email-headers.patch
checkpatch-avoid-suggesting-struct-definitions-should-be-const.patch
checkpatch-improve-multistatement_macro_use_do_while-test.patch
checkpatch-clarify-the-embedded_function_name-message.patch
treewide-correct-diffrent-and-banlance-typos.patch

