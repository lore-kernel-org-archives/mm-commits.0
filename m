From: akpm@linux-foundation.org
Subject: - checkpatch-switch-report-trailing-statements-on-case-and-default.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:26:28 -0700
Message-ID: <200807242326.m6ONQSS0010981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755885AbYGXX0g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:26:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: switch -- report trailing statements on case and default
has been removed from the -mm tree.  Its filename was
     checkpatch-switch-report-trailing-statements-on-case-and-default.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: switch -- report trailing statements on case and default
From: Andy Whitcroft <apw@shadowen.org>

Report trailing statements on case and default lines.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN scripts/checkpatch.pl~checkpatch-switch-report-trailing-statements-on-case-and-default scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-switch-report-trailing-statements-on-case-and-default
+++ a/scripts/checkpatch.pl
@@ -1244,6 +1244,10 @@ sub process {
 				ERROR("switch and case should be at the same indent\n$hereline$err");
 			}
 		}
+		if ($line =~ /^.\s*(?:case\s*.*|default\s*):/g &&
+		    $line !~ /\G(?:\s*{)?(?:\s*$;*)(?:\s*\\)?\s*$/g) {
+			ERROR("trailing statements should be on next line\n" . $herecurr);
+		}
 
 # if/while/etc brace do not go on next line, unless defining a do while loop,
 # or if that brace on the next line is for something else
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

