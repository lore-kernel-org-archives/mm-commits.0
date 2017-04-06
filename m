From: akpm@linux-foundation.org
Subject: +
 mm-swap_cgroup-reschedule-when-neeed-in-swap_cgroup_swapoff.patch added to
 -mm tree
Date: Thu, 06 Apr 2017 15:50:05 -0700
Message-ID: <58e6c61d.rjqin8adTBTJg+V6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49110 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752775AbdDFWuG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Apr 2017 18:50:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap_cgroup: reschedule when neeed in swap_cgroup_swapoff()
has been added to the -mm tree.  Its filename is
     mm-swap_cgroup-reschedule-when-neeed-in-swap_cgroup_swapoff.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap_cgroup-reschedule-when-neeed-in-swap_cgroup_swapoff.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap_cgroup-reschedule-when-neeed-in-swap_cgroup_swapoff.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, swap_cgroup: reschedule when neeed in swap_cgroup_swapoff()

We got need_resched() warnings in swap_cgroup_swapoff() because
swap_cgroup_ctrl[type].length is particularly large.

Reschedule when needed.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1704061315270.80559@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/swap_cgroup.c~mm-swap_cgroup-reschedule-when-neeed-in-swap_cgroup_swapoff mm/swap_cgroup.c
--- a/mm/swap_cgroup.c~mm-swap_cgroup-reschedule-when-neeed-in-swap_cgroup_swapoff
+++ a/mm/swap_cgroup.c
@@ -201,6 +201,8 @@ void swap_cgroup_swapoff(int type)
 			struct page *page = map[i];
 			if (page)
 				__free_page(page);
+			if (!(i % SWAP_CLUSTER_MAX))
+				cond_resched();
 		}
 		vfree(map);
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

mm-thp-fix-setting-of-defermadvise-thp-defrag-mode.patch
mm-swap_cgroup-reschedule-when-neeed-in-swap_cgroup_swapoff.patch
mm-vmstat-print-non-populated-zones-in-zoneinfo.patch
mm-vmstat-suppress-pcp-stats-for-unpopulated-zones-in-zoneinfo.patch

