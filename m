From: akpm@linux-foundation.org
Subject: + checkpatch-improve-embedded_function_name-test.patch added to
 -mm tree
Date: Tue, 28 Feb 2017 16:09:29 -0800
Message-ID: <58b61139.IFTUJxIrnHfCjl5J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38794 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751154AbdCAAJa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 19:09:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve EMBEDDED_FUNCTION_NAME test
has been added to the -mm tree.  Its filename is
     checkpatch-improve-embedded_function_name-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-embedded_function_name-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-embedded_function_name-test.patch

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
Subject: checkpatch: improve EMBEDDED_FUNCTION_NAME test

The existing behavior relies on patch context to identify function
declarations.  Add the ability to find function declarations when there is
an open brace in column 1.

This finds function declarations only in specific single line forms where
the function name is on a single line like:

int foo(args...)
{

and

int
foo(args...)
{

It does not recognize function declarations like:

int foo(int bar,
        int baz)
{

Link: http://lkml.kernel.org/r/738d74bbbe1a06b80f11ed504818107c68903095.1488155636.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-improve-embedded_function_name-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-embedded_function_name-test
+++ a/scripts/checkpatch.pl
@@ -3126,6 +3126,17 @@ sub process {
 # check we are in a valid C source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c)$/);
 
+# check if this appears to be the start function declaration, save the name
+		if ($sline =~ /^\+\{\s*$/ &&
+		    $prevline =~ /^\+(?:(?:(?:$Storage|$Inline)\s*)*\s*$Type\s*)?($Ident)\(/) {
+			$context_function = $1;
+		}
+
+# check if this appears to be the end of function declaration
+		if ($sline =~ /^\+\}\s*$/) {
+			undef $context_function;
+		}
+
 # check indentation of any line with a bare else
 # (but not if it is a multiple line "if (foo) return bar; else return baz;")
 # if the previous line is a break or return and is indented 1 tab more...
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-add-ability-to-find-bad-uses-of-vsprintf-%pfoo-extensions.patch
checkpatch-improve-embedded_function_name-test.patch

