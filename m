From: akpm@linux-foundation.org
Subject: - rename-pg_checked-page-flag-to-pg_owner_priv_1.patch removed from -mm tree
Date: Wed, 28 Feb 2007 00:25:29 -0800
Message-ID: <200702280825.l1S8PUsK010843@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:44867 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751895AbXB1IZl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 03:25:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, akpm@linux-foundation.org, jeremy@xensource.com, nickpiggin@yahoo.com.au, wli@holomorphy.com, mm-commits@vger.kernel.org


The patch titled
     rename PG_checked page flag to PG_owner_priv_1
has been removed from the -mm tree.  Its filename was
     rename-pg_checked-page-flag-to-pg_owner_priv_1.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: rename PG_checked page flag to PG_owner_priv_1
From: Jeremy Fitzhardinge <jeremy@goop.org>

Rename PG_checked to PG_owner_priv_1 to reflect its availablilty as a
subsystem/filesystem private flag.  A subsystem which "owns" a page (for
example, a pagecache page belonging to a filesystem) may use this flag for
whatever it wants.

ext2/3/4 are the only current in-tree users of this flag.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: William Lee Irwin III <wli@holomorphy.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/dir.c              |    6 +++---
 fs/ext3/inode.c            |   10 +++++-----
 fs/ext4/inode.c            |   10 +++++-----
 include/linux/page-flags.h |    8 ++++----
 mm/page_alloc.c            |    2 +-
 5 files changed, 18 insertions(+), 18 deletions(-)

diff -puN fs/ext2/dir.c~rename-pg_checked-page-flag-to-pg_owner_priv_1 fs/ext2/dir.c
--- a/fs/ext2/dir.c~rename-pg_checked-page-flag-to-pg_owner_priv_1
+++ a/fs/ext2/dir.c
@@ -112,7 +112,7 @@ static void ext2_check_page(struct page 
 	if (offs != limit)
 		goto Eend;
 out:
-	SetPageChecked(page);
+	SetPageOwnerPriv(page);
 	return;
 
 	/* Too bad, we had an error */
@@ -152,7 +152,7 @@ Eend:
 		dir->i_ino, (page->index<<PAGE_CACHE_SHIFT)+offs,
 		(unsigned long) le32_to_cpu(p->inode));
 fail:
-	SetPageChecked(page);
+	SetPageOwnerPriv(page);
 	SetPageError(page);
 }
 
@@ -165,7 +165,7 @@ static struct page * ext2_get_page(struc
 		kmap(page);
 		if (!PageUptodate(page))
 			goto fail;
-		if (!PageChecked(page))
+		if (!PageOwnerPriv(page))
 			ext2_check_page(page);
 		if (PageError(page))
 			goto fail;
diff -puN fs/ext3/inode.c~rename-pg_checked-page-flag-to-pg_owner_priv_1 fs/ext3/inode.c
--- a/fs/ext3/inode.c~rename-pg_checked-page-flag-to-pg_owner_priv_1
+++ a/fs/ext3/inode.c
@@ -1596,12 +1596,12 @@ static int ext3_journalled_writepage(str
 		goto no_write;
 	}
 
-	if (!page_has_buffers(page) || PageChecked(page)) {
+	if (!page_has_buffers(page) || PageOwnerPriv(page)) {
 		/*
 		 * It's mmapped pagecache.  Add buffers and journal it.  There
 		 * doesn't seem much point in redirtying the page here.
 		 */
-		ClearPageChecked(page);
+		ClearPageOwnerPriv(page);
 		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
 					ext3_get_block);
 		if (ret != 0) {
@@ -1658,7 +1658,7 @@ static void ext3_invalidatepage(struct p
 	 * If it's a full truncate we just forget about the pending dirtying
 	 */
 	if (offset == 0)
-		ClearPageChecked(page);
+		ClearPageOwnerPriv(page);
 
 	journal_invalidatepage(journal, page, offset);
 }
@@ -1667,7 +1667,7 @@ static int ext3_releasepage(struct page 
 {
 	journal_t *journal = EXT3_JOURNAL(page->mapping->host);
 
-	WARN_ON(PageChecked(page));
+	WARN_ON(PageOwnerPriv(page));
 	if (!page_has_buffers(page))
 		return 0;
 	return journal_try_to_free_buffers(journal, page, wait);
@@ -1763,7 +1763,7 @@ out:
  */
 static int ext3_journalled_set_page_dirty(struct page *page)
 {
-	SetPageChecked(page);
+	SetPageOwnerPriv(page);
 	return __set_page_dirty_nobuffers(page);
 }
 
diff -puN fs/ext4/inode.c~rename-pg_checked-page-flag-to-pg_owner_priv_1 fs/ext4/inode.c
--- a/fs/ext4/inode.c~rename-pg_checked-page-flag-to-pg_owner_priv_1
+++ a/fs/ext4/inode.c
@@ -1595,12 +1595,12 @@ static int ext4_journalled_writepage(str
 		goto no_write;
 	}
 
-	if (!page_has_buffers(page) || PageChecked(page)) {
+	if (!page_has_buffers(page) || PageOwnerPriv(page)) {
 		/*
 		 * It's mmapped pagecache.  Add buffers and journal it.  There
 		 * doesn't seem much point in redirtying the page here.
 		 */
-		ClearPageChecked(page);
+		ClearPageOwnerPriv(page);
 		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
 					ext4_get_block);
 		if (ret != 0) {
@@ -1657,7 +1657,7 @@ static void ext4_invalidatepage(struct p
 	 * If it's a full truncate we just forget about the pending dirtying
 	 */
 	if (offset == 0)
-		ClearPageChecked(page);
+		ClearPageOwnerPriv(page);
 
 	jbd2_journal_invalidatepage(journal, page, offset);
 }
@@ -1666,7 +1666,7 @@ static int ext4_releasepage(struct page 
 {
 	journal_t *journal = EXT4_JOURNAL(page->mapping->host);
 
-	WARN_ON(PageChecked(page));
+	WARN_ON(PageOwnerPriv(page));
 	if (!page_has_buffers(page))
 		return 0;
 	return jbd2_journal_try_to_free_buffers(journal, page, wait);
@@ -1762,7 +1762,7 @@ out:
  */
 static int ext4_journalled_set_page_dirty(struct page *page)
 {
-	SetPageChecked(page);
+	SetPageOwnerPriv(page);
 	return __set_page_dirty_nobuffers(page);
 }
 
diff -puN include/linux/page-flags.h~rename-pg_checked-page-flag-to-pg_owner_priv_1 include/linux/page-flags.h
--- a/include/linux/page-flags.h~rename-pg_checked-page-flag-to-pg_owner_priv_1
+++ a/include/linux/page-flags.h
@@ -76,7 +76,7 @@
 #define PG_active		 6
 #define PG_slab			 7	/* slab debug (Suparna wants this) */
 
-#define PG_checked		 8	/* kill me in 2.5.<early>. */
+#define PG_owner_priv_1		 8	/* subsystem/owner-private flag*/
 #define PG_arch_1		 9
 #define PG_reserved		10
 #define PG_private		11	/* If pagecache, has fs-private data */
@@ -165,9 +165,9 @@ static inline void SetPageUptodate(struc
 #define PageHighMem(page)	0 /* needed to optimize away at compile time */
 #endif
 
-#define PageChecked(page)	test_bit(PG_checked, &(page)->flags)
-#define SetPageChecked(page)	set_bit(PG_checked, &(page)->flags)
-#define ClearPageChecked(page)	clear_bit(PG_checked, &(page)->flags)
+#define PageOwnerPriv(page)	test_bit(PG_owner_priv_1, &(page)->flags)
+#define SetPageOwnerPriv(page)	set_bit(PG_owner_priv_1, &(page)->flags)
+#define ClearPageOwnerPriv(page)	clear_bit(PG_owner_priv_1, &(page)->flags)
 
 #define PageReserved(page)	test_bit(PG_reserved, &(page)->flags)
 #define SetPageReserved(page)	set_bit(PG_reserved, &(page)->flags)
diff -puN mm/page_alloc.c~rename-pg_checked-page-flag-to-pg_owner_priv_1 mm/page_alloc.c
--- a/mm/page_alloc.c~rename-pg_checked-page-flag-to-pg_owner_priv_1
+++ a/mm/page_alloc.c
@@ -600,7 +600,7 @@ static int prep_new_page(struct page *pa
 
 	page->flags &= ~(1 << PG_uptodate | 1 << PG_error |
 			1 << PG_referenced | 1 << PG_arch_1 |
-			1 << PG_checked | 1 << PG_mappedtodisk);
+			1 << PG_owner_priv_1 | 1 << PG_mappedtodisk);
 	set_page_private(page, 0);
 	set_page_refcounted(page);
 
_

Patches currently in -mm which might be from jeremy@goop.org are

make-hvc_consolec-compile-on-non-powerpc-remove-no_irq.patch
xen-paravirt_ops-no-need-to-use-traditional-for-processing-asm-in-arch-i386.patch
xen-paravirt_ops-clean-up-elf-note-generation.patch
xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt_ops-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
