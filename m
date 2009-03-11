From: akpm@linux-foundation.org
Subject: [merged] intel-agp-fix-a-panic-with-1m-of-shared-memory-no-gtt-entries.patch removed from -mm tree
Date: Wed, 11 Mar 2009 11:09:40 -0700
Message-ID: <200903111809.n2BI9eg2019968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46466 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752806AbZCKSNB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Mar 2009 14:13:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lkundrak@v3.sk, airlied@linux.ie, eric@anholt.net, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     intel-agp: fix a panic with 1M of shared memory, no GTT entries
has been removed from the -mm tree.  Its filename was
     intel-agp-fix-a-panic-with-1m-of-shared-memory-no-gtt-entries.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Eric Anholt <eric@anholt.net>
Cc: <stable@kernel.org>
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

origin.patch

