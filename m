From: akpm@linux-foundation.org
Subject: - checkpatch-possible-types-__asm__-is-never-a-type.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:16 -0700
Message-ID: <200807242326.m6ONQGx3010959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755859AbYGXX0Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: possible types: __asm__ is never a type
has been removed from the -mm tree.  Its filename was
     checkpatch-possible-types-__asm__-is-never-a-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: possible types: __asm__ is never a type
From: Andy Whitcroft <apw@shadowen.org>

We are false matching __asm__ as a type, and then tripping the external
function checks.  Squash.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-possible-types-__asm__-is-never-a-type scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-possible-types-__asm__-is-never-a-type
+++ a/scripts/checkpatch.pl
@@ -846,7 +846,7 @@ sub possible {
 	if ($possible !~ /^(?:$Storage|$Type|DEFINE_\S+)$/ &&
 	    $possible ne 'goto' && $possible ne 'return' &&
 	    $possible ne 'case' && $possible ne 'else' &&
-	    $possible ne 'asm' &&
+	    $possible ne 'asm' && $possible ne '__asm__' &&
 	    $possible !~ /^(typedef|struct|enum)\b/) {
 		# Check for modifiers.
 		$possible =~ s/\s*$Storage\s*//g;
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

