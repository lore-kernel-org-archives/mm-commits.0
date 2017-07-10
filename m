From: akpm@linux-foundation.org
Subject: [patch 102/115] checkpatch: improve tests for multiple
 line function definitions
Date: Mon, 10 Jul 2017 15:52:19 -0700
Message-ID: <20170710225219.3VFL3eHLH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43552 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754848AbdGJWwU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2017 18:52:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, david.kershner@unisys.com, joe@perches.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
@@ -5899,7 +5899,8 @@ sub process {
 			     "externs should be avoided in .c files\n" .  $herecurr);
 		}
 
-		if ($realfile =~ /\.[ch]$/ && defined $stat &&
+# check for function declarations that have arguments without identifier names
+		if (defined $stat &&
 		    $stat =~ /^.\s*(?:extern\s+)?$Type\s*$Ident\s*\(\s*([^{]+)\s*\)\s*;/s &&
 		    $1 ne "void") {
 			my $args = trim($1);
@@ -5912,6 +5913,29 @@ sub process {
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
