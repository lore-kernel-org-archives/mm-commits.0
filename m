From: akpm@linux-foundation.org
Subject: + mm-use-min3-max3-macros-to-avoid-shadow-warnings.patch added to -mm tree
Date: Wed, 03 Sep 2014 15:56:41 -0700
Message-ID: <54079ca9.8m2QQN4h6MIPW3eC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933446AbaICW4m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 18:56:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.d.rustad@intel.com, jeffrey.t.kirsher@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback.c: use min3/max3 macros to avoid shadow warnings
has been added to the -mm tree.  Its filename is
     mm-use-min3-max3-macros-to-avoid-shadow-warnings.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-min3-max3-macros-to-avoid-shadow-warnings.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-min3-max3-macros-to-avoid-shadow-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-use-min3-max3-macros-to-avoid-shadow-warnings.patch
init-resolve-shadow-warnings.patch
init-resolve-shadow-warnings-checkpatch-fixes.patch

