From: akpm@linux-foundation.org
Subject: + mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits.patch added to -mm tree
Date: Fri, 11 Jul 2014 15:27:59 -0700
Message-ID: <53c064ef.aNY0sCc/qrTL8Jfk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f202.google.com ([209.85.192.202]:44474 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaGKW2A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Jul 2014 18:28:00 -0400
Received: by mail-pd0-f202.google.com with SMTP id r10so384204pdi.3
        for <mm-commits@vger.kernel.org>; Fri, 11 Jul 2014 15:28:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: MPatlasov@parallels.com, fengguang.wu@intel.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, mpatlasov@parallels.com, riel@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page-writeback.c: fix divide by zero in bdi_dirty_limits()
has been added to the -mm tree.  Its filename is
     mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits.patch
mm-add-strictlimit-knob-v2.patch

