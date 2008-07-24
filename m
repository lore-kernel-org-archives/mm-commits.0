From: akpm@linux-foundation.org
Subject: - checkpatch-complex-macros-need-to-ignore-comments.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:53 -0700
Message-ID: <200807242326.m6ONQrN5011026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34055 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755934AbYGXX1B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:27:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: complex macros need to ignore comments
has been removed from the -mm tree.  Its filename was
     checkpatch-complex-macros-need-to-ignore-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: complex macros need to ignore comments
From: Andy Whitcroft <apw@shadowen.org>

Ensure we ignore comments in complex macro detection else we incorrectly
report this:

	#define PFM_GROUP_PERM_ANY     -1      /* any user/group */

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    1 +
 1 file changed, 1 insertion(+)

diff -puN scripts/checkpatch.pl~checkpatch-complex-macros-need-to-ignore-comments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-complex-macros-need-to-ignore-comments
+++ a/scripts/checkpatch.pl
@@ -1972,6 +1972,7 @@ sub process {
 			} else {
 				$dstat =~ s/^.\s*\#\s*define\s+$Ident\s*//;
 			}
+			$dstat =~ s/$;//g;
 			$dstat =~ s/\\\n.//g;
 			$dstat =~ s/^\s*//s;
 			$dstat =~ s/\s*$//s;
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

