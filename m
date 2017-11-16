From: akpm@linux-foundation.org
Subject: [patch 116/131] mm: mlock: remove lru_add_drain_all()
Date: Wed, 15 Nov 2017 17:38:26 -0800
Message-ID: <20171116013826.WNtItrTiD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40514 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933653AbdKPBi2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:38:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bsingharora@gmail.com, gthelen@google.com, hughd@google.com, iamjoonsoo.kim@lge.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, minchan@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com, torvalds@linux-foundation.org, vbabka@suse.cz, xieyisheng1@huawei.com

From: Shakeel Butt <shakeelb@google.com>
Subject: mm: mlock: remove lru_add_drain_all()

lru_add_drain_all() is not required by mlock() and it will drain
everything that has been cached at the time mlock is called.  And that is
not really related to the memory which will be faulted in (and cached) and
mlocked by the syscall itself.

If anything lru_add_drain_all() should be called _after_ pages have been
mlocked and faulted in but even that is not strictly needed because those
pages would get to the appropriate LRUs lazily during the reclaim path. 
Moreover follow_page_pte (gup) will drain the local pcp LRU cache.

On larger machines the overhead of lru_add_drain_all() in mlock() can be
significant when mlocking data already in memory.  We have observed high
latency in mlock() due to lru_add_drain_all() when the users were mlocking
in memory tmpfs files.

[mhocko@suse.com: changelog fix]
Link: http://lkml.kernel.org/r/20171019222507.2894-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/mlock.c~mm-mlock-remove-lru_add_drain_all mm/mlock.c
--- a/mm/mlock.c~mm-mlock-remove-lru_add_drain_all
+++ a/mm/mlock.c
@@ -670,8 +670,6 @@ static __must_check int do_mlock(unsigne
 	if (!can_do_mlock())
 		return -EPERM;
 
-	lru_add_drain_all();	/* flush pagevec */
-
 	len = PAGE_ALIGN(len + (offset_in_page(start)));
 	start &= PAGE_MASK;
 
@@ -798,9 +796,6 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	if (!can_do_mlock())
 		return -EPERM;
 
-	if (flags & MCL_CURRENT)
-		lru_add_drain_all();	/* flush pagevec */
