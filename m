From: akpm@linux-foundation.org
Subject: - checkpatch-types-cannot-start-mid-word-for-pointer-tests.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:55 -0700
Message-ID: <200807242326.m6ONQt1c011029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58037 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755916AbYGXX1D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: types cannot start mid word for pointer tests
has been removed from the -mm tree.  Its filename was
     checkpatch-types-cannot-start-mid-word-for-pointer-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: types cannot start mid word for pointer tests
From: Andy Whitcroft <apw@shadowen.org>

When checking spacing for pointer checks the type cannot start in the
middle of a word, ie. this is not 'int * bar':

	x = fooint * bar;

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN scripts/checkpatch.pl~checkpatch-types-cannot-start-mid-word-for-pointer-tests scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-types-cannot-start-mid-word-for-pointer-tests
+++ a/scripts/checkpatch.pl
@@ -1435,11 +1435,11 @@ sub process {
 			ERROR("\"(foo $1 )\" should be \"(foo $1)\"\n" .
 				$herecurr);
 
-		} elsif ($line =~ m{$NonptrType(\*+)(?:\s+(?:$Attribute|$Sparse))?\s+[A-Za-z\d_]+}) {
+		} elsif ($line =~ m{\b$NonptrType(\*+)(?:\s+(?:$Attribute|$Sparse))?\s+[A-Za-z\d_]+}) {
 			ERROR("\"foo$1 bar\" should be \"foo $1bar\"\n" .
 				$herecurr);
 
-		} elsif ($line =~ m{$NonptrType\s+(\*+)(?!\s+(?:$Attribute|$Sparse))\s+[A-Za-z\d_]+}) {
+		} elsif ($line =~ m{\b$NonptrType\s+(\*+)(?!\s+(?:$Attribute|$Sparse))\s+[A-Za-z\d_]+}) {
 			ERROR("\"foo $1 bar\" should be \"foo $1bar\"\n" .
 				$herecurr);
 		}
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

