From: akpm@linux-foundation.org
Subject: [merged] checkpatch-extend-line-continuation-test.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:10:28 -0800
Message-ID: <20121218201028.959A0100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:35159 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2LRUK3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:10:29 -0500
Received: by mail-yh0-f73.google.com with SMTP id 47so125925yhr.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:10:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, jg1.han@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: extend line continuation test
has been removed from the -mm tree.  Its filename was
     checkpatch-extend-line-continuation-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: checkpatch: extend line continuation test

Preprocessor directives and asm statements should be allowed to have a
line continuation.

Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-extend-line-continuation-test scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-extend-line-continuation-test
+++ a/scripts/checkpatch.pl
@@ -3009,10 +3009,12 @@ sub process {
 				}
 			}
 
-# check for line continuations outside of #defines
+# check for line continuations outside of #defines, preprocessor #, and asm
 
 		} else {
 			if ($prevline !~ /^..*\\$/ &&
+			    $line !~ /^\+\s*\#.*\\$/ &&		# preprocessor
+			    $line !~ /^\+.*\b(__asm__|asm)\b.*\\$/ &&	# asm
 			    $line =~ /^\+.*\\$/) {
 				WARN("LINE_CONTINUATIONS",
 				     "Avoid unnecessary line continuations\n" . $herecurr);
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

