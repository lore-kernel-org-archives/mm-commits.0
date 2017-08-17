From: akpm@linux-foundation.org
Subject: + mm-migrate-new-migrate-mode-migrate_sync_no_copy.patch added to -mm tree
Date: Thu, 17 Aug 2017 14:42:11 -0700
Message-ID: <59960db3.Hcp+LGUrlH1/dTC7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40646 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753342AbdHQVmN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 17:42:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jglisse@redhat.com, SCheung@nvidia.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, bsingharora@gmail.com, dan.j.williams@intel.com, dnellans@nvidia.com, ebaskakov@nvidia.com, hannes@cmpxchg.org, jhubbard@nvidia.com, kirill.shutemov@linux.intel.com, mhairgrove@nvidia.com, mhocko@kernel.org, paulmck@linux.vnet.ibm.com, ross.zwisler@linux.intel.com, sgutti@nvidia.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/migrate: new migrate mode MIGRATE_SYNC_NO_COPY
has been added to the -mm tree.  Its filename is
     mm-migrate-new-migrate-mode-migrate_sync_no_copy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-new-migrate-mode-migrate_sync_no_copy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-new-migrate-mode-migrate_sync_no_copy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jérôme Glisse <jglisse@redhat.com>
Subject: mm/migrate: new migrate mode MIGRATE_SYNC_NO_COPY

Introduce a new migration mode that allow to offload the copy to a device
DMA engine.  This changes the workflow of migration and not all
address_space migratepage callback can support this.  So it needs to be
tested in those cases.

This is intended to be use by migrate_vma() which itself is use for thing
like HMM (see include/linux/hmm.h).

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
@@ -2252,7 +2252,10 @@ int f2fs_migrate_page(struct address_spa
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
@@ -633,15 +633,10 @@ static void copy_huge_page(struct page *
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
@@ -695,6 +690,17 @@ void migrate_page_copy(struct page *newp
 
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
@@ -720,7 +726,10 @@ int migrate_page(struct address_space *m
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
@@ -770,12 +779,15 @@ int buffer_migrate_page(struct address_s
 
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
@@ -834,8 +846,13 @@ static int fallback_migrate_page(struct
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
 
@@ -972,7 +989,11 @@ static int __unmap_and_move(struct page
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
@@ -1242,8 +1263,15 @@ static int unmap_and_move_huge_page(new_
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

Patches currently in -mm which might be from jglisse@redhat.com are

hmm-heterogeneous-memory-management-documentation-v3.patch
mm-hmm-heterogeneous-memory-management-hmm-for-short-v5.patch
mm-hmm-mirror-mirror-process-address-space-on-device-with-hmm-helpers-v3.patch
mm-hmm-mirror-helper-to-snapshot-cpu-page-table-v4.patch
mm-hmm-mirror-device-page-fault-handler.patch
mm-zone_device-new-type-of-zone_device-for-unaddressable-memory-v5.patch
mm-zone_device-special-case-put_page-for-device-private-pages-v4.patch
mm-memcontrol-allow-to-uncharge-page-without-using-page-lru-field.patch
mm-memcontrol-support-memory_device_private-v4.patch
mm-hmm-devmem-device-memory-hotplug-using-zone_device-v7.patch
mm-hmm-devmem-dummy-hmm-device-for-zone_device-memory-v3.patch
mm-migrate-new-migrate-mode-migrate_sync_no_copy.patch
mm-migrate-new-memory-migration-helper-for-use-with-device-memory-v5.patch
mm-migrate-migrate_vma-unmap-page-from-vma-while-collecting-pages.patch
mm-migrate-support-un-addressable-zone_device-page-in-migration-v3.patch
mm-migrate-allow-migrate_vma-to-alloc-new-page-on-empty-entry-v4.patch
mm-device-public-memory-device-memory-cache-coherent-with-cpu-v5.patch
mm-hmm-add-new-helper-to-hotplug-cdm-memory-region-v3.patch
lib-interval_tree-fast-overlap-detection-fix.patch

