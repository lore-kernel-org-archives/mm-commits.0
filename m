From: akpm@linux-foundation.org
Subject: - checkpatch-handle-comment-quote-nesting-correctly.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:13:46 -0700
Message-ID: <200810182313.m9INDkVj028261@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751472AbYJRXNz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: apw@shadowen.org, jaswinder@infradead.org, mm-commits@vger.kernel.org


The patch titled
     checkpatch: handle comment/quote nesting correctly
has been removed from the -mm tree.  Its filename was
     checkpatch-handle-comment-quote-nesting-correctly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: handle comment/quote nesting correctly
From: Andy Whitcroft <apw@shadowen.org>

Ensure that a close comment cannot incorrectly trigger in the middle of a
string.  Reported by Jaswinder Singh.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Cc: Jaswinder Singh <jaswinder@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-handle-comment-quote-nesting-correctly scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-handle-comment-quote-nesting-correctly
+++ a/scripts/checkpatch.pl
@@ -335,7 +335,7 @@ sub sanitise_line {
 			$off++;
 			next;
 		}
-		if (substr($line, $off, 2) eq '*/') {
+		if ($sanitise_quote eq '*/' && substr($line, $off, 2) eq '*/') {
 			$sanitise_quote = '';
 			substr($res, $off, 2, "$;$;");
 			$off++;
_

Patches currently in -mm which might be from apw@shadowen.org are

origin.patch
mm-hugetlbc-make-functions-static-use-null-rather-than-0.patch

