From: akpm@linux-foundation.org
Subject: [merged]
 checkpatch-avoid-warning-about-uninitialized_var.patch removed from -mm
 tree
Date: Tue, 07 Apr 2020 19:01:46 -0700
Message-ID: <20200408020146.BaLsiHpqe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHCBr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: avoid warning about uninitialized_var()
has been removed from the -mm tree.  Its filename was
     checkpatch-avoid-warning-about-uninitialized_var.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: avoid warning about uninitialized_var()

WARNING: function definition argument 'flags' should also have an identifier name
#26: FILE: drivers/tty/serial/sh-sci.c:1348:
+       unsigned long uninitialized_var(flags);

Special-case uninitialized_var() to prevent this.

Link: http://lkml.kernel.org/r/7db7944761b0bd88c70eb17d4b7f40fe589e14ed.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
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
