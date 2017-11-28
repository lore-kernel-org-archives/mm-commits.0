From: akpm@linux-foundation.org
Subject: + mm-memcg-fix-mem_cgroup_swapout-for-thps.patch added to -mm
 tree
Date: Tue, 28 Nov 2017 13:35:31 -0800
Message-ID: <5a1dd6a3.rtVHHk6MQSGa3/S7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40900 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752220AbdK1Vfc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Nov 2017 16:35:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shakeelb@google.com, gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org, vdavydov.dev@gmail.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, memcg: fix mem_cgroup_swapout() for THPs
has been added to the -mm tree.  Its filename is
     mm-memcg-fix-mem_cgroup_swapout-for-thps.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-fix-mem_cgroup_swapout-for-thps.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-fix-mem_cgroup_swapout-for-thps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm, memcg: fix mem_cgroup_swapout() for THPs

d6810d730022 ("memcg, THP, swap: make mem_cgroup_swapout() support THP")
changed mem_cgroup_swapout() to support transparent huge page (THP). 
However the patch missed one location which should be changed for
correctly handling THPs.  The resulting bug will cause the memory cgroups
whose THPs were swapped out to become zombies on deletion.

Link: http://lkml.kernel.org/r/20171128161941.20931-1-shakeelb@google.com
Fixes: d6810d730022 ("memcg, THP, swap: make mem_cgroup_swapout() support THP")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcg-fix-mem_cgroup_swapout-for-thps mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-fix-mem_cgroup_swapout-for-thps
+++ a/mm/memcontrol.c
@@ -6044,7 +6044,7 @@ void mem_cgroup_swapout(struct page *pag
 	memcg_check_events(memcg, page);
 
 	if (!mem_cgroup_is_root(memcg))
-		css_put(&memcg->css);
+		css_put_many(&memcg->css, nr_entries);
 }
 
 /**
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-memcg-fix-mem_cgroup_swapout-for-thps.patch
mm-mlock-vmscan-no-more-skipping-pagevecs.patch
vfs-remove-might_sleep-from-clear_inode.patch

