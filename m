From: akpm@linux-foundation.org
Subject: - checkpatch-check-spacing-for-square-brackets.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:33:30 -0700
Message-ID: <200807242333.m6ONXU8J011933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756427AbYGXXdi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:33:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: check spacing for square brackets
has been removed from the -mm tree.  Its filename was
     checkpatch-check-spacing-for-square-brackets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: check spacing for square brackets
From: Andy Whitcroft <apw@shadowen.org>

Check on the spacing before square brackets.  We should only allow spaces
there if this is part of a type definition or an initialialiser.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-check-spacing-for-square-brackets scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-check-spacing-for-square-brackets
+++ a/scripts/checkpatch.pl
@@ -1435,6 +1435,17 @@ sub process {
 			ERROR("open brace '{' following $1 go on the same line\n" . $hereprev);
 		}
 
+# check for spacing round square brackets; allowed:
+#  1. with a type on the left -- int [] a;
+#  2. at the beginning of a line for slice initialisers -- [0..10] = 5,
+		while ($line =~ /(.*?\s)\[/g) {
+			my ($where, $prefix) = ($-[1], $1);
+			if ($prefix !~ /$Type\s+$/ &&
+			    ($where != 0 || $prefix !~ /^.\s+$/)) {
+				ERROR("space prohibited before open square bracket '['\n" . $herecurr);
+			}
+		}
+
 # check for spaces between functions and their parentheses.
 		while ($line =~ /($Ident)\s+\(/g) {
 			my $name = $1;
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

