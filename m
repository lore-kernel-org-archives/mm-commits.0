From: akpm@linux-foundation.org
Subject: - checkpatch-allow-printk-strings-to-exceed-80-characters-to-maintain-their-searchability.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:26 -0700
Message-ID: <200807242326.m6ONQQk8010978@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755884AbYGXX0e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: allow printk strings to exceed 80 characters to maintain their searchability
has been removed from the -mm tree.  Its filename was
     checkpatch-allow-printk-strings-to-exceed-80-characters-to-maintain-their-searchability.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: allow printk strings to exceed 80 characters to maintain their searchability
From: Andy Whitcroft <apw@shadowen.org>

Allow printk strings to break the 80 character width limits, thus keeping
them complete and searchable.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-allow-printk-strings-to-exceed-80-characters-to-maintain-their-searchability scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-allow-printk-strings-to-exceed-80-characters-to-maintain-their-searchability
+++ a/scripts/checkpatch.pl
@@ -1138,7 +1138,9 @@ sub process {
 		}
 #80 column limit
 		if ($line =~ /^\+/ && $prevrawline !~ /\/\*\*/ &&
-		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ && $length > 80)
+		    $rawline !~ /^.\s*\*\s*\@$Ident\s/ &&
+		    $line !~ /^\+\s*printk\s*\(\s*(?:KERN_\S+\s*)?"[X\t]*"\s*(?:,|\)\s*;)\s*$/ &&
+		    $length > 80)
 		{
 			WARN("line over 80 characters\n" . $herecurr);
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

