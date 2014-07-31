From: akpm@linux-foundation.org
Subject: [merged]
 mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits.patch removed
 from -mm tree
Date: Thu, 31 Jul 2014 13:22:02 -0700
Message-ID: <53daa56a.qm3C9goycJr0mwZY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:42195 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaGaUWD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 Jul 2014 16:22:03 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so931780iec.1
        for <mm-commits@vger.kernel.org>; Thu, 31 Jul 2014 13:22:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: MPatlasov@parallels.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mpatlasov@parallels.com, riel@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback.c: fix divide by zero in bdi_dirty_limits()
has been removed from the -mm tree.  Its filename was
     mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Maxim Patlasov <MPatlasov@parallels.com>
Subject: mm/page-writeback.c: fix divide by zero in bdi_dirty_limits()

Under memory pressure, it is possible for dirty_thresh, calculated by
global_dirty_limits() in balance_dirty_pages(), to equal zero.  Then, if
strictlimit is true, bdi_dirty_limits() tries to resolve the proportion:

  bdi_bg_thresh : bdi_thresh = background_thresh : dirty_thresh

by dividing by zero.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page-writeback.c~mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits
+++ a/mm/page-writeback.c
@@ -1306,9 +1306,9 @@ static inline void bdi_dirty_limits(stru
 	*bdi_thresh = bdi_dirty_limit(bdi, dirty_thresh);
 
 	if (bdi_bg_thresh)
-		*bdi_bg_thresh = div_u64((u64)*bdi_thresh *
-					 background_thresh,
-					 dirty_thresh);
+		*bdi_bg_thresh = dirty_thresh ? div_u64((u64)*bdi_thresh *
+							background_thresh,
+							dirty_thresh) : 0;
 
 	/*
 	 * In order to avoid the stacked BDI deadlock we need
_

Patches currently in -mm which might be from MPatlasov@parallels.com are

origin.patch
mm-add-strictlimit-knob-v2.patch

