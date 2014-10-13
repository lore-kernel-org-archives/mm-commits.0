From: akpm@linux-foundation.org
Subject: [merged] mm-use-min3-max3-macros-to-avoid-shadow-warnings.patch
 removed from -mm tree
Date: Mon, 13 Oct 2014 11:20:33 -0700
Message-ID: <543c17f1.C4rCYW8qFY3d+1TP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbaJMSUd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 14:20:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.d.rustad@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback.c: use min3/max3 macros to avoid shadow warnings
has been removed from the -mm tree.  Its filename was
     mm-use-min3-max3-macros-to-avoid-shadow-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mark Rustad <mark.d.rustad@intel.com>
Subject: mm/page-writeback.c: use min3/max3 macros to avoid shadow warnings

Nested calls to min/max functions result in shadow warnings in W=2 builds.
 Avoid the warning by using the min3 and max3 macros to get the min/max of
3 values instead of nested calls.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/page-writeback.c~mm-use-min3-max3-macros-to-avoid-shadow-warnings mm/page-writeback.c
--- a/mm/page-writeback.c~mm-use-min3-max3-macros-to-avoid-shadow-warnings
+++ a/mm/page-writeback.c
@@ -1075,13 +1075,13 @@ static void bdi_update_dirty_ratelimit(s
 	}
 
 	if (dirty < setpoint) {
-		x = min(bdi->balanced_dirty_ratelimit,
-			 min(balanced_dirty_ratelimit, task_ratelimit));
+		x = min3(bdi->balanced_dirty_ratelimit,
+			 balanced_dirty_ratelimit, task_ratelimit);
 		if (dirty_ratelimit < x)
 			step = x - dirty_ratelimit;
 	} else {
-		x = max(bdi->balanced_dirty_ratelimit,
-			 max(balanced_dirty_ratelimit, task_ratelimit));
+		x = max3(bdi->balanced_dirty_ratelimit,
+			 balanced_dirty_ratelimit, task_ratelimit);
 		if (dirty_ratelimit > x)
 			step = dirty_ratelimit - x;
 	}
_

Patches currently in -mm which might be from mark.d.rustad@intel.com are

origin.patch
init-resolve-shadow-warnings.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch
ipc-resolve-shadow-warnings.patch
linux-next.patch

