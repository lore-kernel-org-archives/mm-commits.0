From: akpm@linux-foundation.org
Subject: + intel-agp-fix-a-panic-with-1m-of-shared-memory-no-gtt-entries.patch added to -mm tree
Date: Thu, 29 Jan 2009 00:21:22 -0800
Message-ID: <200901290821.n0T8LMhP007856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52582 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752766AbZA2IVc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Jan 2009 03:21:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lkundrak@v3.sk, airlied@linux.ie, eric@anholt.net


The patch titled
     intel-agp: fix a panic with 1M of shared memory, no GTT entries
has been added to the -mm tree.  Its filename is
     intel-agp-fix-a-panic-with-1m-of-shared-memory-no-gtt-entries.patch

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
Subject: intel-agp: fix a panic with 1M of shared memory, no GTT entries
From: Lubomir Rintel <lkundrak@v3.sk>

When GTT size is equal to amount of video memory, the amount of GTT
entries is computed lower than zero, which is invalid and leads to
off-by-one error in intel_i915_configure()

Originally posted here:
http://bugzilla.kernel.org/show_bug.cgi?id=12539
http://bugzilla.redhat.com/show_bug.cgi?id=445592

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Lubomir Rintel <lkundrak@v3.sk>
Cc: Dave Airlie <airlied@linux.ie>
Cc: Eric Anholt <eric@anholt.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/intel-agp.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/char/agp/intel-agp.c~intel-agp-fix-a-panic-with-1m-of-shared-memory-no-gtt-entries drivers/char/agp/intel-agp.c
--- a/drivers/char/agp/intel-agp.c~intel-agp-fix-a-panic-with-1m-of-shared-memory-no-gtt-entries
+++ a/drivers/char/agp/intel-agp.c
@@ -633,13 +633,15 @@ static void intel_i830_init_gtt_entries(
 			break;
 		}
 	}
-	if (gtt_entries > 0)
+	if (gtt_entries > 0) {
 		dev_info(&agp_bridge->dev->dev, "detected %dK %s memory\n",
 		       gtt_entries / KB(1), local ? "local" : "stolen");
-	else
+		gtt_entries /= KB(4);
+	} else {
 		dev_info(&agp_bridge->dev->dev,
 		       "no pre-allocated video memory detected\n");
-	gtt_entries /= KB(4);
+		gtt_entries = 0;
+	}
 
 	intel_private.gtt_entries = gtt_entries;
 }
_

Patches currently in -mm which might be from lkundrak@v3.sk are

intel-agp-fix-a-panic-with-1m-of-shared-memory-no-gtt-entries.patch

