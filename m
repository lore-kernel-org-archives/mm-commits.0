From: akpm@linux-foundation.org
Subject: +
 checkpatch-dont-warn-on-some-function-pointer-return-styles.patch added to
 -mm tree
Date: Mon, 10 Feb 2014 16:04:57 -0800
Message-ID: <52f96929.R3IanVak2mZq1NaP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59939 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaBKAE5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 19:04:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, joe@perches.com

Subject: + checkpatch-dont-warn-on-some-function-pointer-return-styles.patch added to -mm tree
To: joe@perches.com
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 16:04:57 -0800


The patch titled
     Subject: checkpatch: don't warn on some function pointer return styles
has been added to the -mm tree.  Its filename is
     checkpatch-dont-warn-on-some-function-pointer-return-styles.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-dont-warn-on-some-function-pointer-return-styles.patch

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
Subject: checkpatch: don't warn on some function pointer return styles

Checks for some function pointer return styles are too strict.  Fix them.

Multiple spaces after function pointer return types are allowed.
	int  (*foo)(int bar)

Spaces after function pointer returns of pointer types are not required.
	int *(*foo)(int bar)

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   31 +++++++++++++++++++++----------
 1 file changed, 21 insertions(+), 10 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-dont-warn-on-some-function-pointer-return-styles scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-dont-warn-on-some-function-pointer-return-styles
+++ a/scripts/checkpatch.pl
@@ -2848,10 +2848,7 @@ sub process {
 # Function pointer declarations
 # check spacing between type, funcptr, and args
 # canonical declaration is "type (*funcptr)(args...)"
-#
-# the $Declare variable will capture all spaces after the type
-# so check it for trailing missing spaces or multiple spaces
-		if ($line =~ /^.\s*($Declare)\((\s*)\*(\s*)$Ident(\s*)\)(\s*)\(/) {
+		if ($line =~ /^.\s*($Declare)\((\s*)\*(\s*)($Ident)(\s*)\)(\s*)\(/) {
 			my $declare = $1;
 			my $pre_pointer_space = $2;
 			my $post_pointer_space = $3;
@@ -2859,16 +2856,30 @@ sub process {
 			my $post_funcname_space = $5;
 			my $pre_args_space = $6;
 
-			if ($declare !~ /\s$/) {
+# the $Declare variable will capture all spaces after the type
+# so check it for a missing trailing missing space but pointer return types
+# don't need a space so don't warn for those.
+			my $post_declare_space = "";
+			if ($declare =~ /(\s+)$/) {
+				$post_declare_space = $1;
+				$declare = rtrim($declare);
+			}
+			if ($declare !~ /\*$/ && $post_declare_space =~ /^$/) {
 				WARN("SPACING",
 				     "missing space after return type\n" . $herecurr);
+				$post_declare_space = " ";
 			}
 
 # unnecessary space "type  (*funcptr)(args...)"
-			elsif ($declare =~ /\s{2,}$/) {
-				WARN("SPACING",
-				     "Multiple spaces after return type\n" . $herecurr);
-			}
+# This test is not currently implemented because these declarations are
+# equivalent to
+#	int  foo(int bar, ...)
+# and this is form shouldn't/doesn't generate a checkpatch warning.
+#
+#			elsif ($declare =~ /\s{2,}$/) {
+#				WARN("SPACING",
+#				     "Multiple spaces after return type\n" . $herecurr);
+#			}
 
 # unnecessary space "type ( *funcptr)(args...)"
 			if (defined $pre_pointer_space &&
@@ -2900,7 +2911,7 @@ sub process {
 
 			if (show_type("SPACING") && $fix) {
 				$fixed[$linenr - 1] =~
-				    s/^(.\s*$Declare)\(\s*\*\s*($Ident)\s*\)\s*\(/rtrim($1) . " " . "\(\*$2\)\("/ex;
+				    s/^(.\s*)$Declare\s*\(\s*\*\s*$Ident\s*\)\s*\(/$1 . $declare . $post_declare_space . '(*' . $funcname . ')('/ex;
 			}
 		}
 
_

Patches currently in -mm which might be from joe@perches.com are

get_maintainer-fix-detection-of-git-repository.patch
checkpatch-fix-detection-of-git-repository.patch
mm-utilc-add-kstrimdup.patch
checkpatch-add-test-for-long-udelay.patch
checkpatch-dont-warn-on-some-function-pointer-return-styles.patch
linux-next.patch

