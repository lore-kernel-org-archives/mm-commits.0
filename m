From: akpm@linux-foundation.org
Subject: +
 checkpatch-improve-tests-for-multiple-line-function-definitions.patch added to -mm tree
Date: Thu, 15 Jun 2017 16:06:46 -0700
Message-ID: <59431306.AI6v66R3oybHvQqa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47016 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751677AbdFOXGr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Jun 2017 19:06:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, david.kershner@unisys.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: improve tests for multiple line function definitions
has been added to the -mm tree.  Its filename is
     checkpatch-improve-tests-for-multiple-line-function-definitions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-improve-tests-for-multiple-line-function-definitions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-improve-tests-for-multiple-line-function-definitions.patch

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
Subject: checkpatch: improve tests for multiple line function definitions

Add a block that identifies multiple line function definitions.

Save the function name into $context_function to improve the embedded
function name test.

Look for misplaced open brace on the function definition.
Emit an OPEN_BRACE error when the function definition is similar to

     void foo(int arg1,
              int arg2) {

Miscellanea:

o Remove the $realfile test in function declaration w/o named arguments test
o Comment the function declaration w/o named arguments test

Link: http://lkml.kernel.org/r/de620ed6ebab75fdfa323741ada2134a0f545892.1496835238.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: David Kershner <david.kershner@unisys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-improve-tests-for-multiple-line-function-definitions scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-improve-tests-for-multiple-line-function-definitions
+++ a/scripts/checkpatch.pl
@@ -5915,7 +5915,8 @@ sub process {
 			     "externs should be avoided in .c files\n" .  $herecurr);
 		}
 
-		if ($realfile =~ /\.[ch]$/ && defined $stat &&
+# check for function declarations that have arguments without identifier names
+		if (defined $stat &&
 		    $stat =~ /^.\s*(?:extern\s+)?$Type\s*$Ident\s*\(\s*([^{]+)\s*\)\s*;/s &&
 		    $1 ne "void") {
 			my $args = trim($1);
@@ -5928,6 +5929,29 @@ sub process {
 			}
 		}
 
+# check for function definitions
+		if ($^V && $^V ge 5.10.0 &&
+		    defined $stat &&
+		    $stat =~ /^.\s*(?:$Storage\s+)?$Type\s*($Ident)\s*$balanced_parens\s*{/s) {
+			$context_function = $1;
+
+# check for multiline function definition with misplaced open brace
+			my $ok = 0;
+			my $cnt = statement_rawlines($stat);
+			my $herectx = $here . "\n";
+			for (my $n = 0; $n < $cnt; $n++) {
+				my $rl = raw_line($linenr, $n);
+				$herectx .=  $rl . "\n";
+				$ok = 1 if ($rl =~ /^[ \+]\{/);
+				$ok = 1 if ($rl =~ /\{/ && $n == 0);
+				last if $rl =~ /^[ \+].*\{/;
+			}
+			if (!$ok) {
+				ERROR("OPEN_BRACE",
+				      "open brace '{' following function definitions go on the next line\n" . $herectx);
+			}
+		}
+
 # checks for new __setup's
 		if ($rawline =~ /\b__setup\("([^"]*)"/) {
 			my $name = $1;
_

Patches currently in -mm which might be from joe@perches.com are

checkpatch-improve-the-unnecessary-oom-message-test.patch
checkpatch-warn-when-a-maintainers-entry-isnt-t.patch
checkpatch-fix-stepping-through-statements-with-stat-and-ctx_statement_block.patch
checkpatch-improve-tests-for-multiple-line-function-definitions.patch

