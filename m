From: akpm@linux-foundation.org
Subject: [merged] fs-mbcache-make-count_objects-more-robust.patch
 removed from -mm tree
Date: Thu, 30 Nov 2017 12:19:02 -0800
Message-ID: <20171130201902.Zd-YzmAAm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52416 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdK3UTD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:19:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jiang.biao2@zte.com.cn, mhocko@kernel.org, minchan@kernel.org, mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, zhong.weidong@zte.com.cn


The patch titled
     Subject: fs/mbcache.c: make count_objects() more robust
has been removed from the -mm tree.  Its filename was
     fs-mbcache-make-count_objects-more-robust.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jiang Biao <jiang.biao2@zte.com.cn>
Subject: fs/mbcache.c: make count_objects() more robust

When running ltp stress test for 7*24 hours, vmscan occasionally emits the
following warning continuously:

mb_cache_scan+0x0/0x3f0 negative objects to delete
nr=-9232265467809300450
...

Tracing shows the freeable(mb_cache_count returns) is -1, which causes the
continuous accumulation and overflow of total_scan.

This patch makes sure that mb_cache_count() cannot return a negative
value, which makes the mbcache shrinker more robust.

Link: http://lkml.kernel.org/r/1511753419-52328-1-git-send-email-jiang.biao2@zte.com.cn
Signed-off-by: Jiang Biao <jiang.biao2@zte.com.cn>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <zhong.weidong@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/mbcache.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/mbcache.c~fs-mbcache-make-count_objects-more-robust fs/mbcache.c
--- a/fs/mbcache.c~fs-mbcache-make-count_objects-more-robust
+++ a/fs/mbcache.c
@@ -269,6 +269,9 @@ static unsigned long mb_cache_count(stru
 	struct mb_cache *cache = container_of(shrink, struct mb_cache,
 					      c_shrink);
 
+	/* Unlikely, but not impossible */
+	if (unlikely(cache->c_entry_count < 0))
+		return 0;
 	return cache->c_entry_count;
 }
 
_

Patches currently in -mm which might be from jiang.biao2@zte.com.cn are


