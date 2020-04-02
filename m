From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 143/155] mm/hugetlb_cgroup: fix hugetlb_cgroup
 migration
Date: Wed, 01 Apr 2020 21:11:18 -0700
Message-ID: <20200402041118.HG0A0BuH_%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726136AbgDBELV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:11:21 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, almasrymina@google.com, cai@lca.pw, gthelen@google.com, linux-mm@kvack.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, sandipan@linux.ibm.com, shakeelb@google.com, shuah@kernel.org, torvalds@linux-foundation.org

From: Mina Almasry <almasrymina@google.com>
Subject: mm/hugetlb_cgroup: fix hugetlb_cgroup migration

commit c32300516047 ("hugetlb_cgroup: add interface for charge/uncharge
hugetlb reservations") mistakingly doesn't handle the migration of *both*
the reservation hugetlb_cgroup and the fault hugetlb_cgroup correctly.

What should happen is that both cgroups shuold be queried from the old
page, then both set to NULL on the old page, then both inserted into the
new page.

The mistake also creates the following warning:

mm/hugetlb_cgroup.c: In function 'hugetlb_cgroup_migrate':
mm/hugetlb_cgroup.c:777:25: warning: variable 'h_cg' set but not used
[-Wunused-but-set-variable]
  struct hugetlb_cgroup *h_cg;
                         ^~~~

Solution is to add the missing steps, namly setting the reservation
hugetlb_cgroup to NULL on the old page, and setting the fault
hugetlb_cgroup on the new page.

Link: http://lkml.kernel.org/r/20200218194727.46995-1-almasrymina@google.com
Fixes: c32300516047 ("hugetlb_cgroup: add interface for charge/uncharge hugetlb reservations")
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reported-by: Qian Cai <cai@lca.pw>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hugetlb_cgroup.c~mm-hugetlb_cgroup-fix-hugetlb_cgroup-migration
+++ a/mm/hugetlb_cgroup.c
@@ -797,8 +797,10 @@ void hugetlb_cgroup_migrate(struct page
 	h_cg = hugetlb_cgroup_from_page(oldhpage);
 	h_cg_rsvd = hugetlb_cgroup_from_page_rsvd(oldhpage);
 	set_hugetlb_cgroup(oldhpage, NULL);
+	set_hugetlb_cgroup_rsvd(oldhpage, NULL);
 
 	/* move the h_cg details to new cgroup */
+	set_hugetlb_cgroup(newhpage, h_cg);
 	set_hugetlb_cgroup_rsvd(newhpage, h_cg_rsvd);
 	list_move(&newhpage->lru, &h->hugepage_activelist);
 	spin_unlock(&hugetlb_lock);
_
