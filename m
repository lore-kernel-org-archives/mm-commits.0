From: akpm@linux-foundation.org
Subject: +
 mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch added to -mm tree
Date: Wed, 17 Dec 2014 13:34:59 -0800
Message-ID: <5491f703.xEEPNTw/qJwV7gzM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42572 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbaLQVfA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Dec 2014 16:35:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, jack@suse.cz, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory: merge shared-writable dirtying branches in do_wp_page()
has been added to the -mm tree.  Its filename is
     mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memory: merge shared-writable dirtying branches in do_wp_page()

Whether there is a vm_ops->page_mkwrite or not, the page dirtying is
pretty much the same.  Make sure the page references are the same in both
cases, then merge the two branches.

It's tempting to go even further and page-lock the !page_mkwrite case, to
get it in line with everybody else setting the page table and thus further
simplify the model.  But that's not quite compelling enough to justify
dropping the pte lock, then relocking and verifying the entry for
filesystems without ->page_mkwrite, which notably includes tmpfs.  Leave
it for now and lock the page late in the !page_mkwrite case.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   48 +++++++++++++++++-------------------------------
 1 file changed, 17 insertions(+), 31 deletions(-)

diff -puN mm/memory.c~mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page mm/memory.c
--- a/mm/memory.c~mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page
+++ a/mm/memory.c
@@ -2033,7 +2033,7 @@ static int do_wp_page(struct mm_struct *
 	pte_t entry;
 	int ret = 0;
 	int page_mkwrite = 0;
-	struct page *dirty_page = NULL;
+	bool dirty_shared = false;
 	unsigned long mmun_start = 0;	/* For mmu_notifiers */
 	unsigned long mmun_end = 0;	/* For mmu_notifiers */
 	struct mem_cgroup *memcg;
@@ -2084,6 +2084,7 @@ static int do_wp_page(struct mm_struct *
 		unlock_page(old_page);
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 					(VM_WRITE|VM_SHARED))) {
+		page_cache_get(old_page);
 		/*
 		 * Only catch write-faults on shared writable pages,
 		 * read-only shared pages can get COWed by
@@ -2091,7 +2092,7 @@ static int do_wp_page(struct mm_struct *
 		 */
 		if (vma->vm_ops && vma->vm_ops->page_mkwrite) {
 			int tmp;
-			page_cache_get(old_page);
+
 			pte_unmap_unlock(page_table, ptl);
 			tmp = do_page_mkwrite(vma, old_page, address);
 			if (unlikely(!tmp || (tmp &
@@ -2111,11 +2112,10 @@ static int do_wp_page(struct mm_struct *
 				unlock_page(old_page);
 				goto unlock;
 			}
-
 			page_mkwrite = 1;
 		}
-		dirty_page = old_page;
-		get_page(dirty_page);
+
+		dirty_shared = true;
 
 reuse:
 		/*
@@ -2134,43 +2134,29 @@ reuse:
 		pte_unmap_unlock(page_table, ptl);
 		ret |= VM_FAULT_WRITE;
 
-		if (!dirty_page)
-			return ret;
-
-		if (!page_mkwrite) {
+		if (dirty_shared) {
 			struct address_space *mapping;
 			int dirtied;
 
-			lock_page(dirty_page);
-			dirtied = set_page_dirty(dirty_page);
-			VM_BUG_ON_PAGE(PageAnon(dirty_page), dirty_page);
-			mapping = dirty_page->mapping;
-			unlock_page(dirty_page);
+			if (!page_mkwrite)
+				lock_page(old_page);
 
-			if (dirtied && mapping) {
-				/*
-				 * Some device drivers do not set page.mapping
-				 * but still dirty their pages
-				 */
-				balance_dirty_pages_ratelimited(mapping);
-			}
+			dirtied = set_page_dirty(old_page);
+			VM_BUG_ON_PAGE(PageAnon(old_page), old_page);
+			mapping = old_page->mapping;
+			unlock_page(old_page);
+			page_cache_release(old_page);
 
-			file_update_time(vma->vm_file);
-		}
-		put_page(dirty_page);
-		if (page_mkwrite) {
-			struct address_space *mapping = dirty_page->mapping;
-
-			set_page_dirty(dirty_page);
-			unlock_page(dirty_page);
-			page_cache_release(dirty_page);
-			if (mapping)	{
+			if ((dirtied || page_mkwrite) && mapping) {
 				/*
 				 * Some device drivers do not set page.mapping
 				 * but still dirty their pages
 				 */
 				balance_dirty_pages_ratelimited(mapping);
 			}
+
+			if (!page_mkwrite)
+				file_update_time(vma->vm_file);
 		}
 
 		return ret;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-update.patch
mm-page_alloc-embed-oom-killing-naturally-into-allocation-slowpath-fix.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask.patch
mm-page_allocc-__alloc_pages_nodemask-dont-alter-arg-gfp_mask-fix.patch
mm-protect-set_page_dirty-from-ongoing-truncation.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch

