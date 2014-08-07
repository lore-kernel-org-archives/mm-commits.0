From: akpm@linux-foundation.org
Subject: [merged]
 checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:08:49 -0700
Message-ID: <53e3dcd1.lzPDnbWzdPX22s7s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:38829 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaHGUIu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:08:50 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so612357qap.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:08:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linux@rasmusvillemoes.dk, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch.pl: also suggest 'else if' when if follows brace
has been removed from the -mm tree.  Its filename was
     checkpatchpl-also-suggest-else-if-when-if-follows-brace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: checkpatch.pl: also suggest 'else if' when if follows brace

This might help a kernel hacker think twice before blindly adding a
newline.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Acked-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatchpl-also-suggest-else-if-when-if-follows-brace scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatchpl-also-suggest-else-if-when-if-follows-brace
+++ a/scripts/checkpatch.pl
@@ -3621,7 +3621,7 @@ sub process {
 # if should not continue a brace
 		if ($line =~ /}\s*if\b/) {
 			ERROR("TRAILING_STATEMENTS",
-			      "trailing statements should be on next line\n" .
+			      "trailing statements should be on next line (or did you mean 'else if'?)\n" .
 				$herecurr);
 		}
 # case and default should not have general statements after them
_

Patches currently in -mm which might be from linux@rasmusvillemoes.dk are

origin.patch
linux-next.patch

