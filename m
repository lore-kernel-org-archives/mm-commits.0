From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 3/5] hugetlb_cgroup: fix illegal access to memory
Date: Sat, 28 Mar 2020 19:17:22 -0700
Message-ID: <20200329021722.W_psAYHe4%akpm@linux-foundation.org>
References: <20200328191456.4fc0b9ca86780f26c122399e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbgC2CRX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 28 Mar 2020 22:17:23 -0400
In-Reply-To: <20200328191456.4fc0b9ca86780f26c122399e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, almasrymina@google.com, gscrivan@redhat.com, linux-mm@kvack.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, tj@kernel.org, torvalds@linux-foundation.org

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
Acked-by: Tejun Heo <tj@kernel.org>
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
