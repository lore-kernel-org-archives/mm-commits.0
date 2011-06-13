From: akpm@linux-foundation.org
Subject: + memcg-fix-init_page_cgroup-nid-with-sparsemem.patch added to -mm tree
Date: Mon, 13 Jun 2011 14:23:37 -0700
Message-ID: <201106132123.p5DLNcWr022712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46549 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753922Ab1FMVYL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Jun 2011 17:24:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
has been added to the -mm tree.  Its filename is
     memcg-fix-init_page_cgroup-nid-with-sparsemem.patch

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
Subject: From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

added some clean ups.
==
From 45b8881201f73015c4e0352eb7e434f6e9c53fdd Mon Sep 17 00:00:00 2001
Date: Mon, 13 Jun 2011 10:09:17 +0900
Subject: [PATCH 2/5] [BUGFIX] memcg: fix init_page_cgroup nid with sparsemem

commit 21a3c96 makes page_cgroup allocation as NUMA aware. But that caused
a problem https://bugzilla.kernel.org/show_bug.cgi?id=36192.

The problem was getting a NID from invalid struct pages, which was not
initialized because it was out-of-node, out of [node_start_pfn, node_end_pfn)

Now, with sparsemem, page_cgroup_init scans pfn from 0 to max_pfn.
But this may scan a pfn which is not on any node and can access
memmap which is not initialized.

This makes page_cgroup_init() for SPARSEMEM node aware and remove
a code to get nid from page->flags. (Then, we'll use valid NID
always.)

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Changelog :
  - use better macros as node_start/end_pfn(), PAGE_SECTION_MASK..etc
  - pull out error handling code, which is rarely called.
  - fixed MEM_GOING_ONLINE case.
  - Add more comments and updated patch descriptions.
---

index 74ccff6..0742633 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_cgroup.c |   67 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 51 insertions(+), 16 deletions(-)

diff -puN mm/page_cgroup.c~memcg-fix-init_page_cgroup-nid-with-sparsemem mm/page_cgroup.c
--- a/mm/page_cgroup.c~memcg-fix-init_page_cgroup-nid-with-sparsemem
+++ a/mm/page_cgroup.c
@@ -162,13 +162,13 @@ static void free_page_cgroup(void *addr)
 }
 #endif
 
-static int __meminit init_section_page_cgroup(unsigned long pfn)
+static int __meminit init_section_page_cgroup(unsigned long pfn, int nid)
 {
 	struct page_cgroup *base, *pc;
 	struct mem_section *section;
 	unsigned long table_size;
 	unsigned long nr;
-	int nid, index;
+	int index;
 
 	nr = pfn_to_section_nr(pfn);
 	section = __nr_to_section(nr);
@@ -176,7 +176,6 @@ static int __meminit init_section_page_c
 	if (section->page_cgroup)
 		return 0;
 
-	nid = page_to_nid(pfn_to_page(pfn));
 	table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
 	base = alloc_page_cgroup(table_size, nid);
 
@@ -196,7 +195,11 @@ static int __meminit init_section_page_c
 		pc = base + index;
 		init_page_cgroup(pc, nr);
 	}
-
+	/*
+	 * Passed "pfn" may not be aligned to SECTION. For calculation,
+	 * nedd to apply a mask.
+	 */
+	pfn &= PAGE_SECTION_MASK;
 	section->page_cgroup = base - pfn;
 	total_usage += table_size;
 	return 0;
@@ -225,10 +228,20 @@ int __meminit online_page_cgroup(unsigne
 	start = start_pfn & ~(PAGES_PER_SECTION - 1);
 	end = ALIGN(start_pfn + nr_pages, PAGES_PER_SECTION);
 
+	if (nid == -1) {
+		/*
+		 * In this case, "nid" already exists and contains valid memory.
+		 * "start_pfn" passed for us is a pfn which is args for online_
+		 * _pages(), and start_pfn should exists.
+		 */
+		nid = pfn_to_nid(start_pfn);
+		VM_BUG_ON(!node_state(nid, N_ONLINE));
+	}
+
 	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION) {
 		if (!pfn_present(pfn))
 			continue;
-		fail = init_section_page_cgroup(pfn);
+		fail = init_section_page_cgroup(pfn, nid);
 	}
 	if (!fail)
 		return 0;
@@ -284,25 +297,47 @@ static int __meminit page_cgroup_callbac
 void __init page_cgroup_init(void)
 {
 	unsigned long pfn;
-	int fail = 0;
+	int nid;
 
 	if (mem_cgroup_disabled())
 		return;
 
-	for (pfn = 0; !fail && pfn < max_pfn; pfn += PAGES_PER_SECTION) {
-		if (!pfn_present(pfn))
-			continue;
-		fail = init_section_page_cgroup(pfn);
-	}
-	if (fail) {
-		printk(KERN_CRIT "try 'cgroup_disable=memory' boot option\n");
-		panic("Out of memory");
-	} else {
-		hotplug_memory_notifier(page_cgroup_callback, 0);
+	for_each_node_state(nid, N_HIGH_MEMORY) {
+		unsigned long start_pfn, end_pfn;
+
+		start_pfn = node_start_pfn(nid);
+		end_pfn = node_end_pfn(nid);
+		/*
+		 * start_pfn and end_pfn may not be aligned to SECTION and
+		 * page->flags of out of node pages are not initialized. So,
+		 * we scan [start_pfn, the biggest section's pfn < end_pfn), here.
+		 */
+		for (pfn = start_pfn;
+		     pfn < end_pfn;
+                     pfn = ALIGN(pfn + 1, PAGES_PER_SECTION)) {
+
+			if (!pfn_valid(pfn))
+				continue;
+			/*
+			 * Nodes's pfn can be overlapped.
+			 * We know some arch can have nodes layout as
+			 * -------------pfn-------------->
+			 * N0 | N1 | N2 | N0 | N1 | N2|....
+			 */
+			if (pfn_to_nid(pfn) != nid)
+				continue;
+			if (init_section_page_cgroup(pfn, nid))
+				goto oom;
+		}
 	}
+	hotplug_memory_notifier(page_cgroup_callback, 0);
 	printk(KERN_INFO "allocated %ld bytes of page_cgroup\n", total_usage);
 	printk(KERN_INFO "please try 'cgroup_disable=memory' option if you don't"
 	" want memory cgroups\n");
+	return;
+oom:
+	printk(KERN_CRIT "try 'cgroup_disable=memory' boot option\n");
+	panic("Out of memory");
 }
 
 void __meminit pgdat_page_cgroup_init(struct pglist_data *pgdat)
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

vmscanmemcg-memcg-aware-swap-token.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscan-implement-swap-token-trace.patch
vmscan-implement-swap-token-priority-aging.patch
memcg-add-documentation-for-the-memorynumastat-api.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
mm-increase-reclaim_distance-to-30.patch
mm-fix-wrong-kunmap_atomic-pointer.patch
mm-memory_hotplugc-fix-building-of-node-hotplug-zonelist.patch
mm-memorynuma_stat-fix-file-permission.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem.patch
memcg-fix-init_page_cgroup-nid-with-sparsemem-fix.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves.patch
memcg-clear-mm-owner-when-last-possible-owner-leaves-fix.patch
memcg-fix-wrong-check-of-noswap-with-softlimit.patch
memcg-fix-percpu-cached-charge-draining-frequency.patch
memcg-fix-percpu-cached-charge-draining-frequency-fix.patch
memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

