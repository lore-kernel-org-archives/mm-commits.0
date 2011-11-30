From: akpm@linux-foundation.org
Subject: + mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch added to -mm tree
Date: Wed, 30 Nov 2011 15:01:32 -0800
Message-ID: <201111302301.pAUN1Xuh028936@wpaz9.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:58277 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab1K3XBf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2011 18:01:35 -0500
Received: by ghrr18 with SMTP id r18so157311ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2011 15:01:34 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, bsingharora@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com


The patch titled
     Subject: mm: page_cgroup: check page_cgroup arrays in lookup_page_cgroup() only when necessary
has been added to the -mm tree.  Its filename is
     mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_cgroup: check page_cgroup arrays in lookup_page_cgroup() only when necessary

lookup_page_cgroup() is usually used only against pages that are used in
userspace.

The exception is the CONFIG_DEBUG_VM-only memcg check from the page
allocator: it can run on pages without page_cgroup descriptors allocated
when the pages are fed into the page allocator for the first time during
boot or memory hotplug.

Include the array check only when CONFIG_DEBUG_VM is set and save the
unnecessary check in production kernels.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN mm/page_cgroup.c~mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary mm/page_cgroup.c
--- a/mm/page_cgroup.c~mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary
+++ a/mm/page_cgroup.c
@@ -28,9 +28,16 @@ struct page_cgroup *lookup_page_cgroup(s
 	struct page_cgroup *base;
 
 	base = NODE_DATA(page_to_nid(page))->node_page_cgroup;
+#ifdef CONFIG_DEBUG_VM
+	/*
+	 * The sanity checks the page allocator does upon freeing a
+	 * page can reach here before the page_cgroup arrays are
+	 * allocated when feeding a range of pages to the allocator
+	 * for the first time during bootup or memory hotplug.
+	 */
 	if (unlikely(!base))
 		return NULL;
-
+#endif
 	offset = pfn - NODE_DATA(page_to_nid(page))->node_start_pfn;
 	return base + offset;
 }
@@ -85,9 +92,16 @@ struct page_cgroup *lookup_page_cgroup(s
 {
 	unsigned long pfn = page_to_pfn(page);
 	struct mem_section *section = __pfn_to_section(pfn);
-
+#ifdef CONFIG_DEBUG_VM
+	/*
+	 * The sanity checks the page allocator does upon freeing a
+	 * page can reach here before the page_cgroup arrays are
+	 * allocated when feeding a range of pages to the allocator
+	 * for the first time during bootup or memory hotplug.
+	 */
 	if (!section->page_cgroup)
 		return NULL;
+#endif
 	return section->page_cgroup + pfn;
 }
 
_
Subject: Subject: mm: page_cgroup: check page_cgroup arrays in lookup_page_cgroup() only when necessary

Patches currently in -mm which might be from hannes@cmpxchg.org are

linux-next.patch
memcg-update-maintainers.patch
mm-page-writebackc-make-determine_dirtyable_memory-static-again.patch
vmscan-promote-shared-file-mapped-pages.patch
vmscan-activate-executable-pages-after-first-usage.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations-v3.patch
vmscan-add-task-name-to-warn_scan_unevictable-messages.patch
cgroups-add-res_counter_write_u64-api.patch
cgroups-new-resource-counter-inheritance-api.patch
cgroups-add-previous-cgroup-in-can_attach_task-attach_task-callbacks.patch
cgroups-new-cancel_attach_task-subsystem-callback.patch
cgroups-ability-to-stop-res-charge-propagation-on-bounded-ancestor.patch
cgroups-add-res-counter-common-ancestor-searching.patch
res_counter-allow-charge-failure-pointer-to-be-null.patch
cgroups-pull-up-res-counter-charge-failure-interpretation-to-caller.patch
cgroups-allow-subsystems-to-cancel-a-fork.patch
cgroups-add-a-task-counter-subsystem.patch
memcg-make-mem_cgroup_split_huge_fixup-more-efficient.patch
memcg-fix-pgpgin-pgpgout-documentation.patch
mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch

