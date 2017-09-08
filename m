From: akpm@linux-foundation.org
Subject: [patch 023/126] mm/migrate: new migrate mode
 MIGRATE_SYNC_NO_COPY
Date: Fri, 08 Sep 2017 16:12:06 -0700
Message-ID: <20170908231206.RBZplURAk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51652 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752952AbdIHXMI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Sep 2017 19:12:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dan.j.williams@intel.com, dnellans@nvidia.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, jglisse@redhat.com, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, liubo95@huawei.com, mhairgrove@nvidia.com, mhocko@kernel.org, mm-commits@vger.kernel.org, paulmck@linux.vnet.ibm.com, ross.zwisler@linux.intel.com, SCheung@nvidia.com, sgutti@nvidia.com, torvalds@linux-foundation.org, vdavydov.dev@gmail.com

From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/migrate: new migrate mode MIGRATE_SYNC_NO_COPY

Introduce a new migration mode that allow to offload the copy to a device
DMA engine.  This changes the workflow of migration and not all
address_space migratepage callback can support this.

This is intended to be use by migrate_vma() which itself is use for thing
like HMM (see include/linux/hmm.h).

No additional per-filesystem migratepage testing is needed.  I disables
MIGRATE_SYNC_NO_COPY in all problematic migratepage() callback and i
added comment in those to explain why (part of this patch).  The commit
message is unclear it should say that any callback that wish to support
this new mode need to be aware of the difference in the migration flow
from other mode.

Some of these callbacks do extra locking while copying (aio, zsmalloc,
balloon, ...) and for DMA to be effective you want to copy multiple
pages in one DMA operations.  But in the problematic case you can not
easily hold the extra lock accross multiple call to this callback.

Usual flow is:

For each page {
 1 - lock page
 2 - call migratepage() callback
 3 - (extra locking in some migratepage() callback)
 4 - migrate page state (freeze refcount, update page cache, buffer
     head, ...)
 5 - copy page
 6 - (unlock any extra lock of migratepage() callback)
 7 - return from migratepage() callback
 8 - unlock page
}

The new mode MIGRATE_SYNC_NO_COPY:
 1 - lock multiple pages
For each page {
 2 - call migratepage() callback
 3 - abort in all problematic migratepage() callback
 4 - migrate page state (freeze refcount, update page cache, buffer
     head, ...)
} // finished all calls to migratepage() callback
 5 - DMA copy multiple pages
 6 - unlock all the pages

To support MIGRATE_SYNC_NO_COPY in the problematic case we would need a
new callback migratepages() (for instance) that deals with multiple
pages in one transaction.

Because the problematic cases are not important for current usage I did
not wanted to complexify this patchset even more for no good reason.

Link: http://lkml.kernel.org/r/20170817000548.32038-14-jglisse@redhat.com
Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Nellans <dnellans@nvidia.com>
Cc: Evgeny Baskakov <ebaskakov@nvidia.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mark Hairgrove <mhairgrove@nvidia.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Sherry Cheung <SCheung@nvidia.com>
Cc: Subhash Gutti <sgutti@nvidia.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Bob Liu <liubo95@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/aio.c                     |    8 +++++
 fs/f2fs/data.c               |    5 ++-
 fs/hugetlbfs/inode.c         |    5 ++-
 fs/ubifs/file.c              |    5 ++-
 include/linux/migrate.h      |    5 +++
 include/linux/migrate_mode.h |    5 +++
 mm/balloon_compaction.c      |    8 +++++
 mm/migrate.c                 |   52 +++++++++++++++++++++++++--------
 mm/zsmalloc.c                |    8 +++++
 9 files changed, 86 insertions(+), 15 deletions(-)

diff -puN fs/aio.c~mm-migrate-new-migrate-mode-migrate_sync_no_copy fs/aio.c
--- a/fs/aio.c~mm-migrate-new-migrate-mode-migrate_sync_no_copy
+++ a/fs/aio.c
@@ -373,6 +373,14 @@ static int aio_migratepage(struct addres
 	pgoff_t idx;
 	int rc;
 
+	/*
+	 * We cannot support the _NO_COPY case here, because copy needs to
+	 * happen under the ctx->completion_lock. That does not work with the
+	 * migration workflow of MIGRATE_SYNC_NO_COPY.
+	 */
+	if (mode == MIGRATE_SYNC_NO_COPY)
+		return -EINVAL;
+
 	rc = 0;
 
 	/* mapping->private_lock here protects against the kioctx teardown.  */
diff -puN fs/f2fs/data.c~mm-migrate-new-migrate-mode-migrate_sync_no_copy fs/f2fs/data.c
--- a/fs/f2fs/data.c~mm-migrate-new-migrate-mode-migrate_sync_no_copy
+++ a/fs/f2fs/data.c
@@ -2253,7 +2253,10 @@ int f2fs_migrate_page(struct address_spa
 		SetPagePrivate(newpage);
 	set_page_private(newpage, page_private(page));
 
-	migrate_page_copy(newpage, page);
+	if (mode != MIGRATE_SYNC_NO_COPY)
+		migrate_page_copy(newpage, page);
+	else
+		migrate_page_states(newpage, page);
 
 	return MIGRATEPAGE_SUCCESS;
 }
diff -puN fs/hugetlbfs/inode.c~mm-migrate-new-migrate-mode-migrate_sync_no_copy fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~mm-migrate-new-migrate-mode-migrate_sync_no_copy
+++ a/fs/hugetlbfs/inode.c
@@ -830,7 +830,10 @@ static int hugetlbfs_migrate_page(struct
 	rc = migrate_huge_page_move_mapping(mapping, newpage, page);
 	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
-	migrate_page_copy(newpage, page);
+	if (mode != MIGRATE_SYNC_NO_COPY)
+		migrate_page_copy(newpage, page);
+	else
+		migrate_page_states(newpage, page);
 
 	return MIGRATEPAGE_SUCCESS;
 }
diff -puN fs/ubifs/file.c~mm-migrate-new-migrate-mode-migrate_sync_no_copy fs/ubifs/file.c
--- a/fs/ubifs/file.c~mm-migrate-new-migrate-mode-migrate_sync_no_copy
+++ a/fs/ubifs/file.c
@@ -1490,7 +1490,10 @@ static int ubifs_migrate_page(struct add
 		SetPagePrivate(newpage);
 	}
 
-	migrate_page_copy(newpage, page);
+	if (mode != MIGRATE_SYNC_NO_COPY)
+		migrate_page_copy(newpage, page);
+	else
+		migrate_page_states(newpage, page);
 	return MIGRATEPAGE_SUCCESS;
 }
 #endif
diff -puN include/linux/migrate.h~mm-migrate-new-migrate-mode-migrate_sync_no_copy include/linux/migrate.h
--- a/include/linux/migrate.h~mm-migrate-new-migrate-mode-migrate_sync_no_copy
+++ a/include/linux/migrate.h
@@ -72,6 +72,7 @@ extern void putback_movable_page(struct
 
 extern int migrate_prep(void);
 extern int migrate_prep_local(void);
+extern void migrate_page_states(struct page *newpage, struct page *page);
 extern void migrate_page_copy(struct page *newpage, struct page *page);
 extern int migrate_huge_page_move_mapping(struct address_space *mapping,
 				  struct page *newpage, struct page *page);
@@ -92,6 +93,10 @@ static inline int isolate_movable_page(s
 static inline int migrate_prep(void) { return -ENOSYS; }
 static inline int migrate_prep_local(void) { return -ENOSYS; }
 
+static inline void migrate_page_states(struct page *newpage, struct page *page)
+{
+}
+
 static inline void migrate_page_copy(struct page *newpage,
 				     struct page *page) {}
 
diff -puN include/linux/migrate_mode.h~mm-migrate-new-migrate-mode-migrate_sync_no_copy include/linux/migrate_mode.h
--- a/include/linux/migrate_mode.h~mm-migrate-new-migrate-mode-migrate_sync_no_copy
+++ a/include/linux/migrate_mode.h
@@ -6,11 +6,16 @@
  *	on most operations but not ->writepage as the potential stall time
  *	is too significant
  * MIGRATE_SYNC will block when migrating pages
+ * MIGRATE_SYNC_NO_COPY will block when migrating pages but will not copy pages
+ *	with the CPU. Instead, page copy happens outside the migratepage()
+ *	callback and is likely using a DMA engine. See migrate_vma() and HMM
+ *	(mm/hmm.c) for users of this mode.
  */
 enum migrate_mode {
 	MIGRATE_ASYNC,
 	MIGRATE_SYNC_LIGHT,
 	MIGRATE_SYNC,
+	MIGRATE_SYNC_NO_COPY,
 };
 
 #endif		/* MIGRATE_MODE_H_INCLUDED */
diff -puN mm/balloon_compaction.c~mm-migrate-new-migrate-mode-migrate_sync_no_copy mm/balloon_compaction.c
--- a/mm/balloon_compaction.c~mm-migrate-new-migrate-mode-migrate_sync_no_copy
+++ a/mm/balloon_compaction.c
@@ -139,6 +139,14 @@ int balloon_page_migrate(struct address_
 {
 	struct balloon_dev_info *balloon = balloon_page_device(page);
 
+	/*
+	 * We can not easily support the no copy case here so ignore it as it
+	 * is unlikely to be use with ballon pages. See include/linux/hmm.h for
+	 * user of the MIGRATE_SYNC_NO_COPY mode.
+	 */
+	if (mode == MIGRATE_SYNC_NO_COPY)
+		return -EINVAL;
+
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 
diff -puN mm/migrate.c~mm-migrate-new-migrate-mode-migrate_sync_no_copy mm/migrate.c
--- a/mm/migrate.c~mm-migrate-new-migrate-mode-migrate_sync_no_copy
+++ a/mm/migrate.c
@@ -634,15 +634,10 @@ static void copy_huge_page(struct page *
 /*
  * Copy the page to its new location
  */
-void migrate_page_copy(struct page *newpage, struct page *page)
+void migrate_page_states(struct page *newpage, struct page *page)
 {
 	int cpupid;
 
-	if (PageHuge(page) || PageTransHuge(page))
-		copy_huge_page(newpage, page);
-	else
-		copy_highpage(newpage, page);
-
 	if (PageError(page))
 		SetPageError(newpage);
 	if (PageReferenced(page))
@@ -696,6 +691,17 @@ void migrate_page_copy(struct page *newp
 
 	mem_cgroup_migrate(page, newpage);
 }
+EXPORT_SYMBOL(migrate_page_states);
+
+void migrate_page_copy(struct page *newpage, struct page *page)
+{
+	if (PageHuge(page) || PageTransHuge(page))
+		copy_huge_page(newpage, page);
+	else
+		copy_highpage(newpage, page);
+
+	migrate_page_states(newpage, page);
+}
 EXPORT_SYMBOL(migrate_page_copy);
 
 /************************************************************
@@ -721,7 +727,10 @@ int migrate_page(struct address_space *m
 	if (rc != MIGRATEPAGE_SUCCESS)
 		return rc;
 
-	migrate_page_copy(newpage, page);
+	if (mode != MIGRATE_SYNC_NO_COPY)
+		migrate_page_copy(newpage, page);
+	else
+		migrate_page_states(newpage, page);
 	return MIGRATEPAGE_SUCCESS;
 }
 EXPORT_SYMBOL(migrate_page);
@@ -771,12 +780,15 @@ int buffer_migrate_page(struct address_s
 
 	SetPagePrivate(newpage);
 
-	migrate_page_copy(newpage, page);
+	if (mode != MIGRATE_SYNC_NO_COPY)
+		migrate_page_copy(newpage, page);
+	else
+		migrate_page_states(newpage, page);
 
 	bh = head;
 	do {
 		unlock_buffer(bh);
- 		put_bh(bh);
+		put_bh(bh);
 		bh = bh->b_this_page;
 
 	} while (bh != head);
@@ -835,8 +847,13 @@ static int fallback_migrate_page(struct
 {
 	if (PageDirty(page)) {
 		/* Only writeback pages in full synchronous migration */
-		if (mode != MIGRATE_SYNC)
+		switch (mode) {
+		case MIGRATE_SYNC:
+		case MIGRATE_SYNC_NO_COPY:
+			break;
+		default:
 			return -EBUSY;
+		}
 		return writeout(mapping, page);
 	}
 
@@ -973,7 +990,11 @@ static int __unmap_and_move(struct page
 		 * the retry loop is too short and in the sync-light case,
 		 * the overhead of stalling is too much
 		 */
-		if (mode != MIGRATE_SYNC) {
+		switch (mode) {
+		case MIGRATE_SYNC:
+		case MIGRATE_SYNC_NO_COPY:
+			break;
+		default:
 			rc = -EBUSY;
 			goto out_unlock;
 		}
@@ -1243,8 +1264,15 @@ static int unmap_and_move_huge_page(new_
 		return -ENOMEM;
 
 	if (!trylock_page(hpage)) {
-		if (!force || mode != MIGRATE_SYNC)
+		if (!force)
 			goto out;
+		switch (mode) {
+		case MIGRATE_SYNC:
+		case MIGRATE_SYNC_NO_COPY:
+			break;
+		default:
+			goto out;
+		}
 		lock_page(hpage);
 	}
 
diff -puN mm/zsmalloc.c~mm-migrate-new-migrate-mode-migrate_sync_no_copy mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-migrate-new-migrate-mode-migrate_sync_no_copy
+++ a/mm/zsmalloc.c
@@ -1969,6 +1969,14 @@ int zs_page_migrate(struct address_space
 	unsigned int obj_idx;
 	int ret = -EAGAIN;
 
+	/*
+	 * We cannot support the _NO_COPY case here, because copy needs to
+	 * happen under the zs lock, which does not work with
+	 * MIGRATE_SYNC_NO_COPY workflow.
+	 */
+	if (mode == MIGRATE_SYNC_NO_COPY)
+		return -EINVAL;
+
 	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
 
_
