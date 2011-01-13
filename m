From: akpm@linux-foundation.org
Subject: [merged] scripts-checkpatchpl-add-check-for-multiple-terminating-semicolons-and-casts-of-vmalloc.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:06:38 -0800
Message-ID: <201101132009.p0DK9JJ1029961@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42088 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933651Ab1AMUJ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:09:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, apw@shadowen.org, mm-commits@vger.kernel.org


The patch titled
     scripts/checkpatch.pl: add check for multiple terminating semicolons and casts of vmalloc
has been removed from the -mm tree.  Its filename was
     scripts-checkpatchpl-add-check-for-multiple-terminating-semicolons-and-casts-of-vmalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scripts/checkpatch.pl: add check for multiple terminating semicolons and casts of vmalloc
From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~scripts-checkpatchpl-add-check-for-multiple-terminating-semicolons-and-casts-of-vmalloc scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~scripts-checkpatchpl-add-check-for-multiple-terminating-semicolons-and-casts-of-vmalloc
+++ a/scripts/checkpatch.pl
@@ -2785,10 +2785,15 @@ sub process {
 		}
 
 # check for pointless casting of kmalloc return
-		if ($line =~ /\*\s*\)\s*k[czm]alloc\b/) {
+		if ($line =~ /\*\s*\)\s*[kv][czm]alloc(_node){0,1}\b/) {
 			WARN("unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
 		}
 
+# check for multiple semicolons
+		if ($line =~ /;\s*;\s*$/) {
+		    WARN("Statements terminations use 1 semicolon\n" . $herecurr);
+		}
+
 # check for gcc specific __FUNCTION__
 		if ($line =~ /__FUNCTION__/) {
 			WARN("__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mm-convert-sprintf_symbol-to-%ps.patch

