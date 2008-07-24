From: akpm@linux-foundation.org
Subject: - checkpatch-allow-for-type-modifiers-on-multiple-declarations.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:33:34 -0700
Message-ID: <200807242333.m6ONXYTl011939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756860AbYGXXdm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:33:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: allow for type modifiers on multiple declarations
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-for-type-modifiers-on-multiple-declarations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: allow for type modifiers on multiple declarations
From: Andy Whitcroft <apw@shadowen.org>

Allow for type modifiers mid declaration on multiple declarations:

	struct mxser_mstatus ms, __user *msu = argp;

Reported by Jiri Slaby.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-allow-for-type-modifiers-on-multiple-declarations scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-for-type-modifiers-on-multiple-declarations
+++ a/scripts/checkpatch.pl
@@ -721,6 +721,10 @@ sub annotate_values {
 			print "DECLARE($1)\n" if ($dbg_values > 1);
 			$type = 'T';
 
+		} elsif ($cur =~ /^($Modifier)\s*/) {
+			print "MODIFIER($1)\n" if ($dbg_values > 1);
+			$type = 'T';
+
 		} elsif ($cur =~ /^(\#\s*define\s*$Ident)(\(?)/o) {
 			print "DEFINE($1,$2)\n" if ($dbg_values > 1);
 			$av_preprocessor = 1;
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

