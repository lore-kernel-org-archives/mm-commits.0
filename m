From: akpm@linux-foundation.org
Subject: [to-be-updated]
 reduce-purge_lock-range-and-hold-time-of-vmap_area_lock.patch removed from
 -mm tree
Date: Wed, 19 Oct 2016 10:45:03 -0700
Message-ID: <5807b11f./wU3TgmRuW/gdwE4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58228 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941581AbcJSRpE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 19 Oct 2016 13:45:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: z00281421@notesmail.huawei.com, chris@chris-wilson.co.uk, hannes@cmpxchg.org, hch@infradead.org, iamjoonsoo.kim@lge.com, joe@perches.com, kuleshovmail@gmail.com, mgorman@techsingularity.net, rientjes@google.com, shawn.lin@rock-chips.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: reduce purge_lock range and hold time of vmap_area_lock
has been removed from the -mm tree.  Its filename was
     reduce-purge_lock-range-and-hold-time-of-vmap_area_lock.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: z00281421 <z00281421@notesmail.huawei.com>
Subject: mm/vmalloc.c: reduce purge_lock range and hold time of vmap_area_lock

Link: http://lkml.kernel.org/r/1476757521-3262-1-git-send-email-zhouxianrong@huawei.com
Signed-off-by: z00281421 <z00281421@notesmail.huawei.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Shawn Lin <shawn.lin@rock-chips.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Alexander Kuleshov <kuleshovmail@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/vmalloc.c~reduce-purge_lock-range-and-hold-time-of-vmap_area_lock mm/vmalloc.c
--- a/mm/vmalloc.c~reduce-purge_lock-range-and-hold-time-of-vmap_area_lock
+++ a/mm/vmalloc.c
@@ -661,13 +661,18 @@ static void __purge_vmap_area_lazy(unsig
 	if (nr || force_flush)
 		flush_tlb_kernel_range(*start, *end);
 
+	spin_unlock(&purge_lock);
+
 	if (nr) {
+		unsigned char batch = 0;
 		spin_lock(&vmap_area_lock);
-		llist_for_each_entry_safe(va, n_va, valist, purge_list)
+		llist_for_each_entry_safe(va, n_va, valist, purge_list) {
 			__free_vmap_area(va);
+			if (!batch++)
+				cond_resched_lock(&vmap_area_lock);
+		}
 		spin_unlock(&vmap_area_lock);
 	}
-	spin_unlock(&purge_lock);
 }
 
 /*
_

Patches currently in -mm which might be from z00281421@notesmail.huawei.com are


