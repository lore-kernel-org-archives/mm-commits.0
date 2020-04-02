From: akpm@linux-foundation.org
Subject: [folded-merged]
 hugetlb-support-file_region-coalescing-again-fix.patch removed from -mm
 tree
Date: Wed, 01 Apr 2020 20:39:46 -0700
Message-ID: <20200402033946.cG7TJk91i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgDBDjr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 1 Apr 2020 23:39:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, gthelen@google.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rdunlap@infradead.org, rientjes@google.com, shakeelb@google.com


The patch titled
     Subject: hugetlb: fix CONFIG_CGROUP_HUGETLB ifdefs
has been removed from the -mm tree.  Its filename was
     hugetlb-support-file_region-coalescing-again-fix.patch

This patch was dropped because it was folded into hugetlb-support-file_region-coalescing-again.patch

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
hugetlb_cgroup-add-accounting-for-shared-mappings.patch
hugetlb_cgroup-support-noreserve-mappings.patch
hugetlb-support-file_region-coalescing-again.patch
hugetlb-support-file_region-coalescing-again-fix-2.patch
hugetlb_cgroup-add-hugetlb_cgroup-reservation-tests.patch
hugetlb_cgroup-add-hugetlb_cgroup-reservation-docs.patch
