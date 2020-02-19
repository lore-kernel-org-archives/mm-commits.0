From: akpm@linux-foundation.org
Subject: + hugetlb-support-file_region-coalescing-again-fix.patch
 added to -mm tree
Date: Wed, 19 Feb 2020 15:37:29 -0800
Message-ID: <20200219233729.CqDk3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgBSXha (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 18:37:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shakeelb@google.com, rientjes@google.com, rdunlap@infradead.org, mike.kravetz@oracle.com, gthelen@google.com, almasrymina@google.com


The patch titled
     Subject: hugetlb: fix CONFIG_CGROUP_HUGETLB ifdefs
has been added to the -mm tree.  Its filename is
     hugetlb-support-file_region-coalescing-again-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-support-file_region-coalescing-again-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-support-file_region-coalescing-again-fix.patch

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
Subject: hugetlb: fix CONFIG_CGROUP_HUGETLB ifdefs

Fixes an #ifdef bug in the patch referred to below that was causing a
build error when CONFIG_DEBUG_VM && !CONFIG_CCGROUP_HUGETLB.

Link: http://lkml.kernel.org/r/20200214204544.231482-1-almasrymina@google.com
Fixes: b5f16a533ce8a ("hugetlb: support file_region coalescing again")
Signed-off-by: Mina Almasry <almasrymina@google.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlb-support-file_region-coalescing-again-fix
+++ a/mm/hugetlb.c
@@ -289,7 +289,7 @@ static bool has_same_uncharge_info(struc
 #endif
 }
 
-#ifdef CONFIG_DEBUG_VM
+#if defined(CONFIG_DEBUG_VM) && defined(CONFIG_CGROUP_HUGETLB)
 static void dump_resv_map(struct resv_map *resv)
 {
 	struct list_head *head = &resv->regions;
@@ -325,6 +325,10 @@ static void check_coalesce_bug(struct re
 		}
 	}
 }
+#else
+static void check_coalesce_bug(struct resv_map *resv)
+{
+}
 #endif
 
 static void coalesce_file_region(struct resv_map *resv, struct file_region *rg)
@@ -431,9 +435,7 @@ static long add_reservation_in_range(str
 	}
 
 	VM_BUG_ON(add < 0);
-#ifdef CONFIG_DEBUG_VM
 	check_coalesce_bug(resv);
-#endif
 	return add;
 }
 
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
hugetlb-support-file_region-coalescing-again-fix.patch
hugetlb_cgroup-add-hugetlb_cgroup-reservation-tests.patch
hugetlb_cgroup-add-hugetlb_cgroup-reservation-docs.patch
