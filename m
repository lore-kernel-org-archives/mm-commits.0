From: akpm@linux-foundation.org
Subject: - checkpatch-possible-modifiers-handle-multiple-modifiers-and-trailing.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:46 -0700
Message-ID: <200807242326.m6ONQk6g011013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755914AbYGXX0y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: possible modifiers -- handle multiple modifiers and trailing
has been removed from the -mm tree.  Its filename was
     checkpatch-possible-modifiers-handle-multiple-modifiers-and-trailing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: possible modifiers -- handle multiple modifiers and trailing
From: Andy Whitcroft <apw@shadowen.org>

Add support for multiple modifiers such as:

	int __one __two foo;

Also handle trailing known modifiers when defecting modifiers:

	int __one foo __read_mostly;

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-possible-modifiers-handle-multiple-modifiers-and-trailing scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-possible-modifiers-handle-multiple-modifiers-and-trailing
+++ a/scripts/checkpatch.pl
@@ -859,8 +859,10 @@ sub possible {
 
 		} elsif ($possible =~ /\s/) {
 			$possible =~ s/\s*$Type\s*//g;
-			warn "MODIFIER: $possible ($line)\n" if ($dbg_possible);
-			push(@modifierList, $possible);
+			for my $modifier (split(' ', $possible)) {
+				warn "MODIFIER: $modifier ($possible) ($line)\n" if ($dbg_possible);
+				push(@modifierList, $modifier);
+			}
 
 		} else {
 			warn "POSSIBLE: $possible ($line)\n" if ($dbg_possible);
@@ -1186,7 +1188,7 @@ sub process {
 			} elsif ($s =~ /^.\s*$Ident\s*\(/s) {
 
 			# declarations always start with types
-			} elsif ($prev_values eq 'E' && $s =~ /^.\s*(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?((?:\s*$Ident)+)\b(?:\s+$Sparse)?\s*\**\s*(?:$Ident|\(\*[^\)]*\))\s*(?:;|=|,|\()/s) {
+			} elsif ($prev_values eq 'E' && $s =~ /^.\s*(?:$Storage\s+)?(?:$Inline\s+)?(?:const\s+)?((?:\s*$Ident)+?)\b(?:\s+$Sparse)?\s*\**\s*(?:$Ident|\(\*[^\)]*\))(?:\s*$Modifier)?\s*(?:;|=|,|\()/s) {
 				my $type = $1;
 				$type =~ s/\s+/ /g;
 				possible($type, "A:" . $s);
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

