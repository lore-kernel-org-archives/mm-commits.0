From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-improve-embedded_function_name-test.patch removed from -mm tree
Date: Tue, 09 May 2017 11:01:10 -0700
Message-ID: <20170509180110.IvTMkU3a7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34340 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753901AbdEISBL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 May 2017 14:01:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve EMBEDDED_FUNCTION_NAME test
has been removed from the -mm tree.  Its filename was
     checkpatch-improve-embedded_function_name-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


