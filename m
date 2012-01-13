From: akpm@linux-foundation.org
Subject: [merged] mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:33:46 -0800
Message-ID: <20120113203346.C63811E004D@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:51298 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759096Ab2AMUdr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:33:47 -0500
Received: by mail-gy0-f202.google.com with SMTP id r18so207082ghr.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:33:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, bsingharora@gmail.com, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_cgroup: check page_cgroup arrays in lookup_page_cgroup() only when necessary
has been removed from the -mm tree.  Its filename was
     mm-page_cgroup-check-page_cgroup-arrays-in-lookup_page_cgroup-only-when-necessary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
