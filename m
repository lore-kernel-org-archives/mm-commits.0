From: akpm@linux-foundation.org
Subject: [merged] swap-cond_resched-in-swap_cgroup_prepare.patch
 removed from -mm tree
Date: Wed, 21 Jun 2017 15:05:27 -0700
Message-ID: <20170621220527.aU6OIiIu9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36610 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751667AbdFUWF2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Jun 2017 18:05:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org, stable@vger.kernel.org, vdavydov.dev@gmail.com, yuzhao@google.com


The patch titled
     Subject: swap: cond_resched in swap_cgroup_prepare()
has been removed from the -mm tree.  Its filename was
     swap-cond_resched-in-swap_cgroup_prepare.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: swap: cond_resched in swap_cgroup_prepare()

Saw need_resched() warnings when swapping on large swapfile (TBs) because
continuously allocating many pages in swap_cgroup_prepare() took too long.

We already cond_resched when freeing page in swap_cgroup_swapoff().  Do
the same for the page allocation.

Link: http://lkml.kernel.org/r/20170604200109.17606-1-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_cgroup.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/swap_cgroup.c~swap-cond_resched-in-swap_cgroup_prepare mm/swap_cgroup.c
--- a/mm/swap_cgroup.c~swap-cond_resched-in-swap_cgroup_prepare
+++ a/mm/swap_cgroup.c
@@ -48,6 +48,9 @@ static int swap_cgroup_prepare(int type)
 		if (!page)
 			goto not_enough_page;
 		ctrl->map[idx] = page;
+
+		if (!(idx % SWAP_CLUSTER_MAX))
+			cond_resched();
 	}
 	return 0;
 not_enough_page:
_

Patches currently in -mm which might be from yuzhao@google.com are


