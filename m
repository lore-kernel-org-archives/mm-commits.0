From: akpm@linux-foundation.org
Subject: - checkpatch-comment-detection-ignore-macro-continuation-when-detecting-associated-comments.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:18 -0700
Message-ID: <200807242326.m6ONQIHZ010962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47016 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755869AbYGXX00 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: comment detection: ignore macro continuation when detecting associated comments
has been removed from the -mm tree.  Its filename was
     checkpatch-comment-detection-ignore-macro-continuation-when-detecting-associated-comments.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: comment detection: ignore macro continuation when detecting associated comments
From: Andy Whitcroft <apw@shadowen.org>

When looking for an associated comment they may be suffixed by a macro
continuation.  Ignore this.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-comment-detection-ignore-macro-continuation-when-detecting-associated-comments scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-comment-detection-ignore-macro-continuation-when-detecting-associated-comments
+++ a/scripts/checkpatch.pl
@@ -631,7 +631,7 @@ sub ctx_locate_comment {
 	my ($first_line, $end_line) = @_;
 
 	# Catch a comment on the end of the line itself.
-	my ($current_comment) = ($rawlines[$end_line - 1] =~ m@.*(/\*.*\*/)\s*$@);
+	my ($current_comment) = ($rawlines[$end_line - 1] =~ m@.*(/\*.*\*/)\s*(?:\\\s*)?$@);
 	return $current_comment if (defined $current_comment);
 
 	# Look through the context and try and figure out if there is a
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

