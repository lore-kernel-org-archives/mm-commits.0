From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb_cgroup-fix-illegal-access-to-memory.patch added
 to -mm tree
Date: Sat, 21 Mar 2020 13:41:26 -0700
Message-ID: <20200321204126.leTtJK7Hs%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:59066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbgCUUl1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 21 Mar 2020 16:41:27 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, gscrivan@redhat.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, tj@kernel.org


The patch titled
     Subject: hugetlb_cgroup: fix illegal access to memory
has been added to the -mm tree.  Its filename is
     hugetlb_cgroup-fix-illegal-access-to-memory.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb_cgroup-fix-illegal-access-to-memory.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb_cgroup-fix-illegal-access-to-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mina Almasry <almasrymina@google.com>
Subject: hugetlb_cgroup: fix illegal access to memory

This appears to be a mistake in commit faced7e0806cf ("mm: hugetlb
controller for cgroups v2").  Essentially that commit does a
hugetlb_cgroup_from_counter assuming that page_counter_try_charge has
initialized counter, but if page_counter_try_charge has failed then it
seems it does not initialize counter, so
hugetlb_cgroup_from_counter(counter) ends up pointing to random memory,
causing kasan to complain.

Solution, simply use h_cg, instead of
hugetlb_cgroup_from_counter(counter), since that is a reference to the
hugetlb_cgroup anyway.  After this change kasan ceases to complain.

Link: http://lkml.kernel.org/r/20200313223920.124230-1-almasrymina@google.com
Fixes: faced7e0806cf ("mm: hugetlb controller for cgroups v2")
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reported-by: syzbot+cac0c4e204952cf449b1@syzkaller.appspotmail.com
Acked-by: Giuseppe Scrivano <gscrivan@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/hugetlb_cgroup.c~hugetlb_cgroup-fix-illegal-access-to-memory
+++ a/mm/hugetlb_cgroup.c
@@ -240,8 +240,7 @@ again:
 	if (!page_counter_try_charge(&h_cg->hugepage[idx], nr_pages,
 				     &counter)) {
 		ret = -ENOMEM;
-		hugetlb_event(hugetlb_cgroup_from_counter(counter, idx), idx,
-			      HUGETLB_MAX);
+		hugetlb_event(h_cg, idx, HUGETLB_MAX);
 	}
 	css_put(&h_cg->css);
 done:
_

Patches currently in -mm which might be from almasrymina@google.com are

hugetlb_cgroup-fix-illegal-access-to-memory.patch
hugetlb_cgroup-add-hugetlb_cgroup-reservation-counter.patch
hugetlb_cgroup-add-interface-for-charge-uncharge-hugetlb-reservations.patch
mm-hugetlb_cgroup-fix-hugetlb_cgroup-migration.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings.patch
hugetlb-disable-region_add-file_region-coalescing.patch
hugetlb-disable-region_add-file_region-coalescing-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings.patch
hugetlb_cgroup-support-noreserve-mappings.patch
hugetlb-support-file_region-coalescing-again.patch
hugetlb-support-file_region-coalescing-again-fix.patch
hugetlb-support-file_region-coalescing-again-fix-2.patch
hugetlb_cgroup-add-hugetlb_cgroup-reservation-tests.patch
hugetlb_cgroup-add-hugetlb_cgroup-reservation-docs.patch
