From: akpm@linux-foundation.org
Subject: - checkpatch-types-some-types-may-also-be-identifiers.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:11 -0700
Message-ID: <200807242326.m6ONQBDD010952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43455 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755853AbYGXX0T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: types: some types may also be identifiers
has been removed from the -mm tree.  Its filename was
     checkpatch-types-some-types-may-also-be-identifiers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: types: some types may also be identifiers
From: Andy Whitcroft <apw@shadowen.org>

Some types such as typedefs may overlap real identifiers.  Be more
targetted about when a type can really exist.  Where it cannot let it be
an identifier.  This prevents false reporting of the minus '-' in unary
context in the following:

	foo[bar->bool - 1];

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-types-some-types-may-also-be-identifiers scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-types-some-types-may-also-be-identifiers
+++ a/scripts/checkpatch.pl
@@ -171,6 +171,7 @@ our @modifierList = (
 sub build_types {
 	my $mods = "(?:  \n" . join("|\n  ", @modifierList) . "\n)";
 	my $all = "(?:  \n" . join("|\n  ", @typeList) . "\n)";
+	$Modifier	= qr{(?:$Attribute|$Sparse|$mods)};
 	$NonptrType	= qr{
 			(?:const\s+)?
 			(?:$mods\s+)?
@@ -178,15 +179,14 @@ sub build_types {
 				(?:typeof|__typeof__)\s*\(\s*\**\s*$Ident\s*\)|
 				(?:${all}\b)
 			)
-			(?:\s+$Sparse|\s+const)*
+			(?:\s+$Modifier|\s+const)*
 		  }x;
 	$Type	= qr{
 			$NonptrType
 			(?:\s*\*+\s*const|\s*\*+|(?:\s*\[\s*\])+)?
-			(?:\s+$Inline|\s+$Sparse|\s+$Attribute|\s+$mods)*
+			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
 	$Declare	= qr{(?:$Storage\s+)?$Type};
-	$Modifier	= qr{(?:$Attribute|$Sparse|$mods)};
 }
 build_types();
 
@@ -715,7 +715,7 @@ sub annotate_values {
 				$av_preprocessor = 0;
 			}
 
-		} elsif ($cur =~ /^($Type)/) {
+		} elsif ($cur =~ /^($Type)\s*(?:$Ident|,|\))/) {
 			print "DECLARE($1)\n" if ($dbg_values > 1);
 			$type = 'T';
 
@@ -800,8 +800,9 @@ sub annotate_values {
 				print "PAREN('$1')\n" if ($dbg_values > 1);
 			}
 
-		} elsif ($cur =~ /^($Ident)\(/o) {
+		} elsif ($cur =~ /^($Ident)\s*\(/o) {
 			print "FUNC($1)\n" if ($dbg_values > 1);
+			$type = 'V';
 			$av_pending = 'V';
 
 		} elsif ($cur =~ /^($Ident|$Constant)/o) {
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
x86-implement-pte_special.patch
x86-implement-pte_special-fix.patch
mm-introduce-get_user_pages_fast.patch
mm-introduce-get_user_pages_fast-fix.patch
mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast.patch
x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
x86-lockless-get_user_pages_fast-fix.patch
x86-lockless-get_user_pages_fast-fix-2.patch
x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
x86-lockless-get_user_pages_fast-fix-warning.patch
dio-use-get_user_pages_fast.patch
splice-use-get_user_pages_fast.patch
page-owner-tracking-leak-detector.patch

