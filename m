From: akpm@linux-foundation.org
Subject: [merged] checkpatch-add-missing-warn-argument-for-min_t-and-max_t-tests.patch removed from -mm tree
Date: Fri, 26 Aug 2011 12:06:28 -0700
Message-ID: <201108261903.p7QJ3Cld005663@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47453 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626Ab1HZTDn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Aug 2011 15:03:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: teawater@gmail.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     checkpatch: add missing WARN argument for min_t and max_t tests
has been removed from the -mm tree.  Its filename was
     checkpatch-add-missing-warn-argument-for-min_t-and-max_t-tests.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch: add missing WARN argument for min_t and max_t tests
From: Hui Zhu <teawater@gmail.com>

The test for bad usage of min_t() and max_t() is missing the --ignore
type.  Add it.

Signed-off-by: Hui Zhu <teawater@gmail.com>
Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-add-missing-warn-argument-for-min_t-and-max_t-tests scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-add-missing-warn-argument-for-min_t-and-max_t-tests
+++ a/scripts/checkpatch.pl
@@ -2574,7 +2574,8 @@ sub process {
 				} else {
 					$cast = $cast2;
 				}
-				WARN("$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
+				WARN("MINMAX",
+				     "$call() should probably be ${call}_t($cast, $arg1, $arg2)\n" . $herecurr);
 			}
 		}
 
_

Patches currently in -mm which might be from teawater@gmail.com are

origin.patch

