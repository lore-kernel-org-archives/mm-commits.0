From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-add-strict-test-for-precedence-challenged-macro-arguments.patch
 removed from -mm tree
Date: Wed, 12 Oct 2016 12:23:24 -0700
Message-ID: <57fe8dac.QB81zSPr7aDybr9b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33197 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755992AbcJLTYb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 15:24:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@canonical.com, dan.carpenter@oracle.com, julia.lawall@lip6.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: add --strict test for precedence challenged macro arguments
has been removed from the -mm tree.  Its filename was
     checkpatch-add-strict-test-for-precedence-challenged-macro-arguments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: add --strict test for precedence challenged macro arguments

Add a test for macro arguents that have a non-comma leading or trailing
operator where the argument isn't parenthesized to avoid possible precedence
issues.

Link: http://lkml.kernel.org/r/47715508972f8d786f435e583ff881dbeee3a114.1473745855.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-strict-test-for-precedence-challenged-macro-arguments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-strict-test-for-precedence-challenged-macro-arguments
+++ a/scripts/checkpatch.pl
@@ -4836,7 +4836,7 @@ sub process {
 # check if any macro arguments are reused (ignore '...' and 'type')
 			foreach my $arg (@def_args) {
 			        next if ($arg =~ /\.\.\./);
-			        next if ($arg =~ /^type$/);
+			        next if ($arg =~ /^type$/i);
 				my $tmp = $define_stmt;
 				$tmp =~ s/\b(typeof|__typeof__|__builtin\w+|typecheck\s*\(\s*$Type\s*,|\#+)\s*\(*\s*$arg\s*\)*\b//g;
 				$tmp =~ s/\#\s*$arg\b//g;
@@ -4845,6 +4845,13 @@ sub process {
 				if ($use_cnt > 1) {
 					CHK("MACRO_ARG_REUSE",
 					    "Macro argument reuse '$arg' - possible side-effects?\n" . "$herectx");
+				    }
+# check if any macro arguments may have other precedence issues
+				if ($define_stmt =~ m/($Operators)?\s*\b$arg\b\s*($Operators)?/m &&
+				    ((defined($1) && $1 ne ',') ||
+				     (defined($2) && $2 ne ','))) {
+					CHK("MACRO_ARG_PRECEDENCE",
+					    "Macro argument '$arg' may be better as '($arg)' to avoid precedence issues\n" . "$herectx");
 				}
 			}
 
_

Patches currently in -mm which might be from joe@perches.com are


