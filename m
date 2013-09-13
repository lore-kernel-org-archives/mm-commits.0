From: akpm@linux-foundation.org
Subject: [merged]
 thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch removed
 from -mm tree
Date: Fri, 13 Sep 2013 13:02:54 -0700
Message-ID: <52336f6e.5RZdLi04b/Mlh49C%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab3IMUCz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@linux.intel.com, viro@zeniv.linux.org.uk, quning@google.com, mgorman@suse.de, jack@suse.cz, hughd@google.com, fengguang.wu@intel.com, dhillf@gmail.com, dave.hansen@linux.intel.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: [merged] thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,dave.hansen@linux.intel.com,dhillf@gmail.com,fengguang.wu@intel.com,hughd@google.com,jack@suse.cz,mgorman@suse.de,quning@google.com,viro@zeniv.linux.org.uk,willy@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:54 -0700


The patch titled
     Subject: thp: account anon transparent huge pages into NR_ANON_PAGES
has been removed from the -mm tree.  Its filename was
     thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: account anon transparent huge pages into NR_ANON_PAGES

We use NR_ANON_PAGES as base for reporting AnonPages to user.  There's not
much sense in not accounting transparent huge pages there, but add them on
printing to user.

Let's account transparent huge pages in NR_ANON_PAGES in the first place.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hugh Dickins <hughd@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: Ning Qu <quning@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c |    6 ------
 fs/proc/meminfo.c   |    6 ------
 mm/huge_memory.c    |    1 -
 mm/rmap.c           |   18 +++++++++---------
 4 files changed, 9 insertions(+), 22 deletions(-)

diff -puN drivers/base/node.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages drivers/base/node.c
--- a/drivers/base/node.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages
+++ a/drivers/base/node.c
@@ -125,13 +125,7 @@ static ssize_t node_read_meminfo(struct
 		       nid, K(node_page_state(nid, NR_WRITEBACK)),
 		       nid, K(node_page_state(nid, NR_FILE_PAGES)),
 		       nid, K(node_page_state(nid, NR_FILE_MAPPED)),
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		       nid, K(node_page_state(nid, NR_ANON_PAGES)
-			+ node_page_state(nid, NR_ANON_TRANSPARENT_HUGEPAGES) *
-			HPAGE_PMD_NR),
-#else
 		       nid, K(node_page_state(nid, NR_ANON_PAGES)),
-#endif
 		       nid, K(node_page_state(nid, NR_SHMEM)),
 		       nid, node_page_state(nid, NR_KERNEL_STACK) *
 				THREAD_SIZE / 1024,
diff -puN fs/proc/meminfo.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages fs/proc/meminfo.c
--- a/fs/proc/meminfo.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages
+++ a/fs/proc/meminfo.c
@@ -132,13 +132,7 @@ static int meminfo_proc_show(struct seq_
 		K(i.freeswap),
 		K(global_page_state(NR_FILE_DIRTY)),
 		K(global_page_state(NR_WRITEBACK)),
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-		K(global_page_state(NR_ANON_PAGES)
-		  + global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
-		  HPAGE_PMD_NR),
-#else
 		K(global_page_state(NR_ANON_PAGES)),
-#endif
 		K(global_page_state(NR_FILE_MAPPED)),
 		K(global_page_state(NR_SHMEM)),
 		K(global_page_state(NR_SLAB_RECLAIMABLE) +
diff -puN mm/huge_memory.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages mm/huge_memory.c
--- a/mm/huge_memory.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages
+++ a/mm/huge_memory.c
@@ -1661,7 +1661,6 @@ static void __split_huge_page_refcount(s
 	BUG_ON(atomic_read(&page->_count) <= 0);
 
 	__mod_zone_page_state(zone, NR_ANON_TRANSPARENT_HUGEPAGES, -1);
-	__mod_zone_page_state(zone, NR_ANON_PAGES, HPAGE_PMD_NR);
 
 	ClearPageCompound(page);
 	compound_unlock(page);
diff -puN mm/rmap.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages mm/rmap.c
--- a/mm/rmap.c~thp-account-anon-transparent-huge-pages-into-nr_anon_pages
+++ a/mm/rmap.c
@@ -1052,11 +1052,11 @@ void do_page_add_anon_rmap(struct page *
 {
 	int first = atomic_inc_and_test(&page->_mapcount);
 	if (first) {
-		if (!PageTransHuge(page))
-			__inc_zone_page_state(page, NR_ANON_PAGES);
-		else
+		if (PageTransHuge(page))
 			__inc_zone_page_state(page,
 					      NR_ANON_TRANSPARENT_HUGEPAGES);
+		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
+				hpage_nr_pages(page));
 	}
 	if (unlikely(PageKsm(page)))
 		return;
@@ -1085,10 +1085,10 @@ void page_add_new_anon_rmap(struct page
 	VM_BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	SetPageSwapBacked(page);
 	atomic_set(&page->_mapcount, 0); /* increment count (starts at -1) */
-	if (!PageTransHuge(page))
-		__inc_zone_page_state(page, NR_ANON_PAGES);
-	else
+	if (PageTransHuge(page))
 		__inc_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
+	__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
+			hpage_nr_pages(page));
 	__page_set_anon_rmap(page, vma, address, 1);
 	if (!mlocked_vma_newpage(vma, page)) {
 		SetPageActive(page);
@@ -1148,11 +1148,11 @@ void page_remove_rmap(struct page *page)
 		goto out;
 	if (anon) {
 		mem_cgroup_uncharge_page(page);
-		if (!PageTransHuge(page))
-			__dec_zone_page_state(page, NR_ANON_PAGES);
-		else
+		if (PageTransHuge(page))
 			__dec_zone_page_state(page,
 					      NR_ANON_TRANSPARENT_HUGEPAGES);
+		__mod_zone_page_state(page_zone(page), NR_ANON_PAGES,
+				-hpage_nr_pages(page));
 	} else {
 		__dec_zone_page_state(page, NR_FILE_MAPPED);
 		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_MAPPED);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
thp-mm-locking-tail-page-is-a-bug.patch
thp-mm-locking-tail-page-is-a-bug-fix.patch
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

