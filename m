From: akpm@linux-foundation.org
Subject: - checkpatch-macro-complexity-checks-are-meaningless-in-linker-scripts.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:40 -0700
Message-ID: <200807242326.m6ONQeaO011000@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753974AbYGXX0s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: macro complexity checks are meaningless in linker scripts
has been removed from the -mm tree.  Its filename was
     checkpatch-macro-complexity-checks-are-meaningless-in-linker-scripts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: macro complexity checks are meaningless in linker scripts
From: Andy Whitcroft <apw@shadowen.org>

Exclude vmlinux.lds.h from the macro complexity checks.  They will never
apply sanely here.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-macro-complexity-checks-are-meaningless-in-linker-scripts scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-macro-complexity-checks-are-meaningless-in-linker-scripts
+++ a/scripts/checkpatch.pl
@@ -1860,7 +1860,8 @@ sub process {
 # multi-statement macros should be enclosed in a do while loop, grab the
 # first statement and ensure its the whole macro if its not enclosed
 # in a known good container
-		if ($line =~ /^.\s*\#\s*define\s*$Ident(\()?/) {
+		if ($realfile !~ m@/vmlinux.lds.h$@ &&
+		    $line =~ /^.\s*\#\s*define\s*$Ident(\()?/) {
 			my $ln = $linenr;
 			my $cnt = $realcnt;
 			my ($off, $dstat, $dcond, $rest);
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

