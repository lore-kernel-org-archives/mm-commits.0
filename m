From: akpm@linux-foundation.org
Subject: + swap-cond_resched-in-swap_cgroup_prepare.patch added to -mm
 tree
Date: Mon, 05 Jun 2017 14:29:37 -0700
Message-ID: <5935cd41.y1kLyeJjrwfdGH98%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50362 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdFEV3i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jun 2017 17:29:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuzhao@google.com, mhocko@suse.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swap: cond_resched in swap_cgroup_prepare()
has been added to the -mm tree.  Its filename is
     swap-cond_resched-in-swap_cgroup_prepare.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swap-cond_resched-in-swap_cgroup_prepare.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swap-cond_resched-in-swap_cgroup_prepare.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

swap-cond_resched-in-swap_cgroup_prepare.patch

