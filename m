From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-support-file_region-coalescing-again.patch
 added to -mm tree
Date: Tue, 11 Feb 2020 15:19:27 -0800
Message-ID: <20200211231927.uRHBj9LPL%akpm@linux-foundation.org>
References: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727905AbgBKXTa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Feb 2020 18:19:30 -0500
In-Reply-To: <20200203173311.6269a8be06a05e5a4aa08a93@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, gthelen@google.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rientjes@google.com, sandipan@linux.ibm.com, shakeelb@google.com, shuah@kernel.org


The patch titled
     Subject: hugetlb: support file_region coalescing again
has been added to the -mm tree.  Its filename is
     hugetlb-support-file_region-coalescing-again.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-support-file_region-coalescing-again.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-support-file_region-coalescing-again.patch

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
Subject: hugetlb: support file_region coalescing again

An earlier patch in this series disabled file_region coalescing in order
to hang the hugetlb_cgroup uncharge info on the file_region entries.

This patch re-adds support for coalescing of file_region entries. 
Essentially everytime we add an entry, we call a recursive function that
tries to coalesce the added region with the regions next to it.  The worst
case call depth for this function is 3: one to coalesce with the region
next to it, one to coalesce to the region prev, and one to reach the base
case.

This is an important performance optimization as private mappings add
their entries page by page, and we could incur big performance costs for
large mappings with lots of file_region entries in their resv_map.

Link: http://lkml.kernel.org/r/20200211213128.73302-7-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   85 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

--- a/mm/hugetlb.c~hugetlb-support-file_region-coalescing-again
+++ a/mm/hugetlb.c
@@ -276,6 +276,86 @@ static void record_hugetlb_cgroup_unchar
 #endif
 }
 
+static bool has_same_uncharge_info(struct file_region *rg,
+				   struct file_region *org)
+{
+#ifdef CONFIG_CGROUP_HUGETLB
+	return rg && org &&
+	       rg->reservation_counter == org->reservation_counter &&
+	       rg->css == org->css;
+
+#else
+	return true;
+#endif
+}
+
+#ifdef CONFIG_DEBUG_VM
+static void dump_resv_map(struct resv_map *resv)
+{
+	struct list_head *head = &resv->regions;
+	struct file_region *rg = NULL;
+
+	pr_err("--------- start print resv_map ---------\n");
+	list_for_each_entry(rg, head, link) {
+		pr_err("rg->from=%ld, rg->to=%ld, rg->reservation_counter=%px, rg->css=%px\n",
+		       rg->from, rg->to, rg->reservation_counter, rg->css);
+	}
+	pr_err("--------- end print resv_map ---------\n");
+}
+
+/* Debug function to loop over the resv_map and make sure that coalescing is
+ * working.
+ */
+static void check_coalesce_bug(struct resv_map *resv)
+{
+	struct list_head *head = &resv->regions;
+	struct file_region *rg = NULL, *nrg = NULL;
+
+	list_for_each_entry(rg, head, link) {
+		nrg = list_next_entry(rg, link);
+
+		if (&nrg->link == head)
+			break;
+
+		if (nrg->reservation_counter && nrg->from == rg->to &&
+		    nrg->reservation_counter == rg->reservation_counter &&
+		    nrg->css == rg->css) {
+			dump_resv_map(resv);
+			VM_BUG_ON(true);
+		}
+	}
+}
+#endif
+
+static void coalesce_file_region(struct resv_map *resv, struct file_region *rg)
+{
+	struct file_region *nrg = NULL, *prg = NULL;
+
+	prg = list_prev_entry(rg, link);
+	if (&prg->link != &resv->regions && prg->to == rg->from &&
+	    has_same_uncharge_info(prg, rg)) {
+		prg->to = rg->to;
+
+		list_del(&rg->link);
+		kfree(rg);
+
+		coalesce_file_region(resv, prg);
+		return;
+	}
+
+	nrg = list_next_entry(rg, link);
+	if (&nrg->link != &resv->regions && nrg->from == rg->to &&
+	    has_same_uncharge_info(nrg, rg)) {
+		nrg->from = rg->from;
+
+		list_del(&rg->link);
+		kfree(rg);
+
+		coalesce_file_region(resv, nrg);
+		return;
+	}
+}
+
 /* Must be called with resv->lock held. Calling this with count_only == true
  * will count the number of pages to be added but will not modify the linked
  * list. If regions_needed != NULL and count_only == true, then regions_needed
@@ -327,6 +407,7 @@ static long add_reservation_in_range(str
 				record_hugetlb_cgroup_uncharge_info(h_cg, h,
 								    resv, nrg);
 				list_add(&nrg->link, rg->link.prev);
+				coalesce_file_region(resv, nrg);
 			} else if (regions_needed)
 				*regions_needed += 1;
 		}
@@ -344,11 +425,15 @@ static long add_reservation_in_range(str
 				resv, last_accounted_offset, t);
 			record_hugetlb_cgroup_uncharge_info(h_cg, h, resv, nrg);
 			list_add(&nrg->link, rg->link.prev);
+			coalesce_file_region(resv, nrg);
 		} else if (regions_needed)
 			*regions_needed += 1;
 	}
 
 	VM_BUG_ON(add < 0);
+#ifdef CONFIG_DEBUG_VM
+	check_coalesce_bug(resv);
+#endif
 	return add;
 }
 
_

Patches currently in -mm which might be from almasrymina@google.com are

hugetlb_cgroup-add-hugetlb_cgroup-reservation-counter.patch
hugetlb_cgroup-add-interface-for-charge-uncharge-hugetlb-reservations.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings.patch
hugetlb-disable-region_add-file_region-coalescing.patch
hugetlb_cgroup-add-accounting-for-shared-mappings.patch
hugetlb_cgroup-support-noreserve-mappings.patch
hugetlb-support-file_region-coalescing-again.patch
hugetlb_cgroup-add-hugetlb_cgroup-reservation-tests.patch
hugetlb_cgroup-add-hugetlb_cgroup-reservation-docs.patch
