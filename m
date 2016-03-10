From: akpm@linux-foundation.org
Subject: [merged]
 mm-__delete_from_page_cache-show-bad-page-if-mapped.patch removed from -mm
 tree
Date: Thu, 10 Mar 2016 10:57:55 -0800
Message-ID: <56e1c3b3.dQz8qKXN1C39TM1D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbcCJS54 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2016 13:57:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: __delete_from_page_cache show Bad page if mapped
has been removed from the -mm tree.  Its filename was
     mm-__delete_from_page_cache-show-bad-page-if-mapped.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: __delete_from_page_cache show Bad page if mapped

Commit e1534ae95004 ("mm: differentiate page_mapped() from page_mapcount()
for compound pages") changed the famous BUG_ON(page_mapped(page)) in
__delete_from_page_cache() to VM_BUG_ON_PAGE(page_mapped(page)): which
gives us more info when CONFIG_DEBUG_VM=y, but nothing at all when not.

Although it has not usually been very helpul, being hit long after the
error in question, we do need to know if it actually happens on users'
systems; but reinstating a crash there is likely to be opposed :)

In the non-debug case, pr_alert("BUG: Bad page cache") plus dump_page(),
dump_stack(), add_taint() - I don't really believe LOCKDEP_NOW_UNRELIABLE,
but that seems to be the standard procedure now.  Move that, or the
VM_BUG_ON_PAGE(), up before the deletion from tree: so that the
unNULLified page->mapping gives a little more information.

If the inode is being evicted (rather than truncated), it won't have any
vmas left, so it's safe(ish) to assume that the raised mapcount is
erroneous, and we can discount it from page_count to avoid leaking the
page (I'm less worried by leaking the occasional 4kB, than losing a
potential 2MB page with each 4kB page leaked).

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-__delete_from_page_cache-show-bad-page-if-mapped mm/filemap.c
--- a/mm/filemap.c~mm-__delete_from_page_cache-show-bad-page-if-mapped
+++ a/mm/filemap.c
@@ -195,6 +195,30 @@ void __delete_from_page_cache(struct pag
 	else
 		cleancache_invalidate_page(mapping, page);
 
+	VM_BUG_ON_PAGE(page_mapped(page), page);
+	if (!IS_ENABLED(CONFIG_DEBUG_VM) && unlikely(page_mapped(page))) {
+		int mapcount;
+
+		pr_alert("BUG: Bad page cache in process %s  pfn:%05lx\n",
+			 current->comm, page_to_pfn(page));
+		dump_page(page, "still mapped when deleted");
+		dump_stack();
+		add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
+
+		mapcount = page_mapcount(page);
+		if (mapping_exiting(mapping) &&
+		    page_count(page) >= mapcount + 2) {
+			/*
+			 * All vmas have already been torn down, so it's
+			 * a good bet that actually the page is unmapped,
+			 * and we'd prefer not to leak it: if we're wrong,
+			 * some other bad page check should catch it later.
+			 */
+			page_mapcount_reset(page);
+			atomic_sub(mapcount, &page->_count);
+		}
+	}
+
 	page_cache_tree_delete(mapping, page, shadow);
 
 	page->mapping = NULL;
@@ -205,7 +229,6 @@ void __delete_from_page_cache(struct pag
 		__dec_zone_page_state(page, NR_FILE_PAGES);
 	if (PageSwapBacked(page))
 		__dec_zone_page_state(page, NR_SHMEM);
-	VM_BUG_ON_PAGE(page_mapped(page), page);
 
 	/*
 	 * At this point page must be either written or cleaned by truncate.
_

Patches currently in -mm which might be from hughd@google.com are


