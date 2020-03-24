From: akpm@linux-foundation.org
Subject: + checkpatch-avoid-warning-about-uninitialized_var.patch
 added to -mm tree
Date: Mon, 23 Mar 2020 17:51:09 -0700
Message-ID: <20200324005109.zaAqJFC5m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727005AbgCXAvL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Mar 2020 20:51:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: avoid warning about uninitialized_var()
has been added to the -mm tree.  Its filename is
     checkpatch-avoid-warning-about-uninitialized_var.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/checkpatch-avoid-warning-about-uninitialized_var.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/checkpatch-avoid-warning-about-uninitialized_var.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: avoid warning about uninitialized_var()

WARNING: function definition argument 'flags' should also have an identifier name
#26: FILE: drivers/tty/serial/sh-sci.c:1348:
+       unsigned long uninitialized_var(flags);

Special-case uninitialized_var() to prevent this.

Link: http://lkml.kernel.org/r/7db7944761b0bd88c70eb17d4b7f40fe589e14ed.camel@perches.com
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/scripts/checkpatch.pl~checkpatch-avoid-warning-about-uninitialized_var
+++ a/scripts/checkpatch.pl
@@ -4071,7 +4071,7 @@ sub process {
 		}
 
 # check for function declarations without arguments like "int foo()"
-		if ($line =~ /(\b$Type\s+$Ident)\s*\(\s*\)/) {
+		if ($line =~ /(\b$Type\s*$Ident)\s*\(\s*\)/) {
 			if (ERROR("FUNCTION_WITHOUT_ARGS",
 				  "Bad function definition - $1() should probably be $1(void)\n" . $herecurr) &&
 			    $fix) {
@@ -6287,13 +6287,17 @@ sub process {
 		}
 
 # check for function declarations that have arguments without identifier names
+# while avoiding uninitialized_var(x)
 		if (defined $stat &&
-		    $stat =~ /^.\s*(?:extern\s+)?$Type\s*(?:$Ident|\(\s*\*\s*$Ident\s*\))\s*\(\s*([^{]+)\s*\)\s*;/s &&
-		    $1 ne "void") {
-			my $args = trim($1);
+		    $stat =~ /^.\s*(?:extern\s+)?$Type\s*(?:($Ident)|\(\s*\*\s*$Ident\s*\))\s*\(\s*([^{]+)\s*\)\s*;/s &&
+		    (!defined($1) ||
+		     (defined($1) && $1 ne "uninitialized_var")) &&
+		     $2 ne "void") {
+			my $args = trim($2);
 			while ($args =~ m/\s*($Type\s*(?:$Ident|\(\s*\*\s*$Ident?\s*\)\s*$balanced_parens)?)/g) {
 				my $arg = trim($1);
-				if ($arg =~ /^$Type$/ && $arg !~ /enum\s+$Ident$/) {
+				if ($arg =~ /^$Type$/ &&
+					$arg !~ /enum\s+$Ident$/) {
 					WARN("FUNCTION_ARGUMENTS",
 					     "function definition argument '$arg' should also have an identifier name\n" . $herecurr);
 				}
_

Patches currently in -mm which might be from joe@perches.com are

mm-use-fallthrough.patch
checkpatch-remove-email-address-comment-from-email-address-comparisons.patch
checkpatch-prefer-fallthrough-over-fallthrough-comments.patch
checkpatch-improve-gerrit-change-id-test.patch
checkpatch-avoid-warning-about-uninitialized_var.patch
