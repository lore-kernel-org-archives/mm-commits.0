From: akpm@linux-foundation.org
Subject: - checkpatch-possible-modifiers-are-not-being-correctly-matched.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:38 -0700
Message-ID: <200807242326.m6ONQcuL010997@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54690 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755906AbYGXX0q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: possible modifiers are not being correctly matched
has been removed from the -mm tree.  Its filename was
     checkpatch-possible-modifiers-are-not-being-correctly-matched.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: possible modifiers are not being correctly matched
From: Andy Whitcroft <apw@shadowen.org>

Although we are finding the added modifier in the declaration below
we are not correctly matching it as a type.  Fix the declaration.

    static void __ref *vmem_alloc_pages(unsigned int order)
    {
    }

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-possible-modifiers-are-not-being-correctly-matched scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-possible-modifiers-are-not-being-correctly-matched
+++ a/scripts/checkpatch.pl
@@ -168,12 +168,11 @@ our @modifierList = (
 );
 
 sub build_types {
-	my $mods = "(?:  \n" . join("|\n  ", @modifierList) . "\n)";
-	my $all = "(?:  \n" . join("|\n  ", @typeList) . "\n)";
+	my $mods = "(?x:  \n" . join("|\n  ", @modifierList) . "\n)";
+	my $all = "(?x:  \n" . join("|\n  ", @typeList) . "\n)";
 	$Modifier	= qr{(?:$Attribute|$Sparse|$mods)};
 	$NonptrType	= qr{
-			(?:const\s+)?
-			(?:$mods\s+)?
+			(?:$Modifier\s+|const\s+)*
 			(?:
 				(?:typeof|__typeof__)\s*\(\s*\**\s*$Ident\s*\)|
 				(?:${all}\b)
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

