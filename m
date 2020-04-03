From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb_cgroup-fix-hugetlb_cgroup-migration.patch removed from -mm tree
Date: Fri, 03 Apr 2020 13:40:33 -0700
Message-ID: <20200403204033.nuJnpql4n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727835AbgDCUke (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:40:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, cai@lca.pw, gthelen@google.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, sandipan@linux.ibm.com, shakeelb@google.com, shuah@kernel.org


The patch titled
     Subject: mm/hugetlb_cgroup: fix hugetlb_cgroup migration
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_cgroup-fix-hugetlb_cgroup-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from almasrymina@google.com are
