From: akpm@linux-foundation.org
Subject: + mm-hugetlb_cgroup-fix-hugetlb_cgroup-migration.patch
 added to -mm tree
Date: Wed, 19 Feb 2020 12:27:56 -0800
Message-ID: <20200219202756.7yZjM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgBSU15 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 15:27:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shuah@kernel.org, shakeelb@google.com, sandipan@linux.ibm.com, rientjes@google.com, mike.kravetz@oracle.com, gthelen@google.com, cai@lca.pw, almasrymina@google.com


The patch titled
     Subject: mm/hugetlb_cgroup: fix hugetlb_cgroup migration
has been added to the -mm tree.  Its filename is
     mm-hugetlb_cgroup-fix-hugetlb_cgroup-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb_cgroup-fix-hugetlb_cgroup-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb_cgroup-fix-hugetlb_cgroup-migration.patch

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
@@ -796,8 +796,10 @@ void hugetlb_cgroup_migrate(struct page
 	spin_lock(&hugetlb_lock);
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

hugetlb_cgroup-add-hugetlb_cgroup-reservation-counter.patch
hugetlb_cgroup-add-interface-for-charge-uncharge-hugetlb-reservations.patch
mm-hugetlb_cgroup-fix-hugetlb_cgroup-migration.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings.patch
hugetlb-disable-region_add-file_region-coalescing.patch
hugetlb-disable-region_add-file_region-coalescing-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings.patch
hugetlb_cgroup-support-noreserve-mappings.patch
hugetlb-support-file_region-coalescing-again.patch
hugetlb_cgroup-add-hugetlb_cgroup-reservation-tests.patch
hugetlb_cgroup-add-hugetlb_cgroup-reservation-docs.patch
