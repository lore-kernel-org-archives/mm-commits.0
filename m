From: akpm@linux-foundation.org
Subject: + checkpatch-add-missing-warn-argument-for-min_t-and-max_t-tests.patch added to -mm tree
Date: Wed, 17 Aug 2011 14:45:41 -0700
Message-ID: <201108172145.p7HLjf67030243@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138Ab1HQVpo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Aug 2011 17:45:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: teawater@gmail.com, joe@perches.com


The patch titled
     checkpatch: add missing WARN argument for min_t and max_t tests
has been added to the -mm tree.  Its filename is
     checkpatch-add-missing-warn-argument-for-min_t-and-max_t-tests.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

checkpatch-add-missing-warn-argument-for-min_t-and-max_t-tests.patch

