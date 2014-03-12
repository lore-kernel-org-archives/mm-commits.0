From: akpm@linux-foundation.org
Subject: + memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix.patch
 added to -mm tree
Date: Wed, 12 Mar 2014 14:04:04 -0700
Message-ID: <5320cbc4.J4v0SXuJeta5IGT/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58051 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaCLVEF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Mar 2014 17:04:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hannes@cmpxchg.org, mhocko@suse.cz

Subject: + memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix.patch added to -mm tree
To: mhocko@suse.cz,hannes@cmpxchg.org
From: akpm@linux-foundation.org
Date: Wed, 12 Mar 2014 14:04:04 -0700


The patch titled
     Subject: memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix
has been added to the -mm tree.  Its filename is
     memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix

add charge mm helper

Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   61 ++++++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 23 deletions(-)

diff -puN mm/memcontrol.c~memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix
+++ a/mm/memcontrol.c
@@ -2757,6 +2757,35 @@ bypass:
 	return -EINTR;
 }
 
+/**
+ * mem_cgroup_try_charge_mm - try charging a mm
+ * @mm: mm_struct to charge
+ * @nr_pages: number of pages to charge
+ * @oom: trigger OOM if reclaim fails
+ *
+ * Returns the charged mem_cgroup associated with the given mm_struct or
+ * NULL the charge failed.
+ */
+static struct mem_cgroup *mem_cgroup_try_charge_mm(struct mm_struct *mm,
+				 gfp_t gfp_mask,
+				 unsigned int nr_pages,
+				 bool oom)
+
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	memcg = get_mem_cgroup_from_mm(mm);
+	ret = mem_cgroup_try_charge(memcg, gfp_mask, nr_pages, oom);
+	css_put(&memcg->css);
+	if (ret == -EINTR)
+		memcg = root_mem_cgroup;
+	else if (ret)
+		memcg = NULL;
+
+	return memcg;
+}
+
 /*
  * Somemtimes we have to undo a charge we got by try_charge().
  * This function is for that and do uncharge, put css's refcnt.
@@ -3827,7 +3856,6 @@ int mem_cgroup_newpage_charge(struct pag
 	unsigned int nr_pages = 1;
 	struct mem_cgroup *memcg;
 	bool oom = true;
-	int ret;
 
 	if (mem_cgroup_disabled())
 		return 0;
@@ -3846,13 +3874,9 @@ int mem_cgroup_newpage_charge(struct pag
 		oom = false;
 	}
 
-	memcg = get_mem_cgroup_from_mm(mm);
-	ret = mem_cgroup_try_charge(memcg, gfp_mask, nr_pages, oom);
-	css_put(&memcg->css);
-	if (ret == -EINTR)
-		memcg = root_mem_cgroup;
-	else if (ret)
-		return ret;
+	memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, nr_pages, oom);
+	if (!memcg)
+		return -ENOMEM;
 	__mem_cgroup_commit_charge(memcg, page, nr_pages,
 				   MEM_CGROUP_CHARGE_TYPE_ANON, false);
 	return 0;
@@ -3913,15 +3937,10 @@ int mem_cgroup_try_charge_swapin(struct
 	 */
 	if (!PageSwapCache(page)) {
 		struct mem_cgroup *memcg;
-		int ret;
 
-		memcg = get_mem_cgroup_from_mm(mm);
-		ret = mem_cgroup_try_charge(memcg, gfp_mask, 1, true);
-		css_put(&memcg->css);
-		if (ret == -EINTR)
-			memcg = root_mem_cgroup;
-		else if (ret)
-			return ret;
+		memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1, true);
+		if (!memcg)
+			return -ENOMEM;
 		*memcgp = memcg;
 		return 0;
 	}
@@ -3995,13 +4014,9 @@ int mem_cgroup_cache_charge(struct page
 	if (unlikely(!mm))
 		memcg = root_mem_cgroup;
 	else {
-		memcg = get_mem_cgroup_from_mm(mm);
-		ret = mem_cgroup_try_charge(memcg, gfp_mask, 1, true);
-		css_put(&memcg->css);
-		if (ret == -EINTR)
-			memcg = root_mem_cgroup;
-		else if (ret)
-			return ret;
+		memcg = mem_cgroup_try_charge_mm(mm, gfp_mask, 1, true);
+		if (!memcg)
+			return -ENOMEM;
 	}
 	__mem_cgroup_commit_charge(memcg, page, 1, type, false);
 	return 0;
_

Patches currently in -mm which might be from mhocko@suse.cz are

mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-hugetlb-mark-some-bootstrap-functions-as-__init.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
madvise-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
drop_caches-add-some-documentation-and-info-message.patch
mm-exclude-memory-less-nodes-from-zone_reclaim.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-memcg-remove-unnecessary-preemption-disabling.patch
mm-memcg-remove-mem_cgroup_move_account_page_stat.patch
mm-memcg-inline-mem_cgroup_charge_common.patch
mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch
memcg-remove-unnecessary-mm-check-from-try_get_mem_cgroup_from_mm.patch
memcg-get_mem_cgroup_from_mm.patch
memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix.patch
memcg-rename-high-level-charging-functions.patch
printk-remove-duplicated-check-for-log-level.patch
printk-remove-obsolete-check-for-log-level-c.patch
printk-add-comment-about-tricky-check-for-text-buffer-size.patch
printk-use-also-the-last-bytes-in-the-ring-buffer.patch
printk-do-not-compute-the-size-of-the-message-twice.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch

