From: akpm@linux-foundation.org
Subject: [patch 121/126] mm: fix build warnings in <linux/compaction.h>
Date: Tue, 26 Jul 2016 15:26:50 -0700
Message-ID: <5797e3aa.EEoVQGCH9m0mX5Tz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57155 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbcGZW0v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Jul 2016 18:26:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, minchan@kernel.org, aquini@redhat.com, gi-oh.kim@profitbricks.com, koct9i@gmail.com, rdunlap@infradead.org, vbabka@suse.cz

From: Minchan Kim <minchan@kernel.org>
Subject: mm: fix build warnings in <linux/compaction.h>

Randy reported below build error.

> In file included from ../include/linux/balloon_compaction.h:48:0,
>                  from ../mm/balloon_compaction.c:11:
> ../include/linux/compaction.h:237:51: warning: 'struct node' declared inside parameter list [enabled by default]
>  static inline int compaction_register_node(struct node *node)
> ../include/linux/compaction.h:237:51: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
> ../include/linux/compaction.h:242:54: warning: 'struct node' declared inside parameter list [enabled by default]
>  static inline void compaction_unregister_node(struct node *node)
>

It was caused by non-lru page migration which needs compaction.h but
compaction.h doesn't include any header to be standalone.

I think proper header for non-lru page migration is migrate.h rather
than compaction.h because migrate.h has already headers needed to work
non-lru page migration indirectly like isolate_mode_t, migrate_mode
MIGRATEPAGE_SUCCESS.

[akpm@linux-foundation.org: revert mm-balloon-use-general-non-lru-movable-page-feature-fix.patch temp fix]
Link: http://lkml.kernel.org/r/20160610003304.GE29779@bbox
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_migration    |   11 ++++++-----
 drivers/virtio/virtio_balloon.c    |    2 +-
 include/linux/balloon_compaction.h |    3 +--
 include/linux/compaction.h         |   16 ----------------
 include/linux/migrate.h            |   15 +++++++++++++++
 mm/zsmalloc.c                      |    4 ++--
 6 files changed, 25 insertions(+), 26 deletions(-)

diff -puN Documentation/vm/page_migration~mm-fix-build-warnings-in-linux-compactionh Documentation/vm/page_migration
--- a/Documentation/vm/page_migration~mm-fix-build-warnings-in-linux-compactionh
+++ a/Documentation/vm/page_migration
@@ -181,11 +181,12 @@ After isolation, VM calls migratepage of
 The function of migratepage is to move content of the old page to new page
 and set up fields of struct page newpage. Keep in mind that you should
 indicate to the VM the oldpage is no longer movable via __ClearPageMovable()
-under page_lock if you migrated the oldpage successfully and returns 0.
-If driver cannot migrate the page at the moment, driver can return -EAGAIN.
-On -EAGAIN, VM will retry page migration in a short time because VM interprets
--EAGAIN as "temporal migration failure". On returning any error except -EAGAIN,
-VM will give up the page migration without retrying in this time.
+under page_lock if you migrated the oldpage successfully and returns
+MIGRATEPAGE_SUCCESS. If driver cannot migrate the page at the moment, driver
+can return -EAGAIN. On -EAGAIN, VM will retry page migration in a short time
+because VM interprets -EAGAIN as "temporal migration failure". On returning
+any error except -EAGAIN, VM will give up the page migration without retrying
+in this time.
 
 Driver shouldn't touch page.lru field VM using in the functions.
 
diff -puN drivers/virtio/virtio_balloon.c~mm-fix-build-warnings-in-linux-compactionh drivers/virtio/virtio_balloon.c
--- a/drivers/virtio/virtio_balloon.c~mm-fix-build-warnings-in-linux-compactionh
+++ a/drivers/virtio/virtio_balloon.c
@@ -493,7 +493,7 @@ static int virtballoon_migratepage(struc
 
 	put_page(page); /* balloon reference */
 
-	return 0;
+	return MIGRATEPAGE_SUCCESS;
 }
 
 static struct dentry *balloon_mount(struct file_system_type *fs_type,
diff -puN include/linux/balloon_compaction.h~mm-fix-build-warnings-in-linux-compactionh include/linux/balloon_compaction.h
--- a/include/linux/balloon_compaction.h~mm-fix-build-warnings-in-linux-compactionh
+++ a/include/linux/balloon_compaction.h
@@ -45,8 +45,7 @@
 #define _LINUX_BALLOON_COMPACTION_H
 #include <linux/pagemap.h>
 #include <linux/page-flags.h>
-#include <linux/node.h>
-#include <linux/compaction.h>
+#include <linux/migrate.h>
 #include <linux/gfp.h>
 #include <linux/err.h>
 #include <linux/fs.h>
diff -puN include/linux/compaction.h~mm-fix-build-warnings-in-linux-compactionh include/linux/compaction.h
--- a/include/linux/compaction.h~mm-fix-build-warnings-in-linux-compactionh
+++ a/include/linux/compaction.h
@@ -54,9 +54,6 @@ enum compact_result {
 struct alloc_context; /* in mm/internal.h */
 
 #ifdef CONFIG_COMPACTION
-extern int PageMovable(struct page *page);
-extern void __SetPageMovable(struct page *page, struct address_space *mapping);
-extern void __ClearPageMovable(struct page *page);
 extern int sysctl_compact_memory;
 extern int sysctl_compaction_handler(struct ctl_table *table, int write,
 			void __user *buffer, size_t *length, loff_t *ppos);
@@ -154,19 +151,6 @@ extern void kcompactd_stop(int nid);
 extern void wakeup_kcompactd(pg_data_t *pgdat, int order, int classzone_idx);
 
 #else
-static inline int PageMovable(struct page *page)
-{
-	return 0;
-}
-static inline void __SetPageMovable(struct page *page,
-			struct address_space *mapping)
-{
-}
-
-static inline void __ClearPageMovable(struct page *page)
-{
-}
-
 static inline enum compact_result try_to_compact_pages(gfp_t gfp_mask,
 			unsigned int order, int alloc_flags,
 			const struct alloc_context *ac,
diff -puN include/linux/migrate.h~mm-fix-build-warnings-in-linux-compactionh include/linux/migrate.h
--- a/include/linux/migrate.h~mm-fix-build-warnings-in-linux-compactionh
+++ a/include/linux/migrate.h
@@ -71,6 +71,21 @@ static inline int migrate_huge_page_move
 
 #endif /* CONFIG_MIGRATION */
 
+#ifdef CONFIG_COMPACTION
+extern int PageMovable(struct page *page);
+extern void __SetPageMovable(struct page *page, struct address_space *mapping);
+extern void __ClearPageMovable(struct page *page);
+#else
+static inline int PageMovable(struct page *page) { return 0; };
+static inline void __SetPageMovable(struct page *page,
+				struct address_space *mapping)
+{
+}
+static inline void __ClearPageMovable(struct page *page)
+{
+}
+#endif
+
 #ifdef CONFIG_NUMA_BALANCING
 extern bool pmd_trans_migrating(pmd_t pmd);
 extern int migrate_misplaced_page(struct page *page,
diff -puN mm/zsmalloc.c~mm-fix-build-warnings-in-linux-compactionh mm/zsmalloc.c
--- a/mm/zsmalloc.c~mm-fix-build-warnings-in-linux-compactionh
+++ a/mm/zsmalloc.c
@@ -50,7 +50,7 @@
 #include <linux/zsmalloc.h>
 #include <linux/zpool.h>
 #include <linux/mount.h>
-#include <linux/compaction.h>
+#include <linux/migrate.h>
 #include <linux/pagemap.h>
 
 #define ZSPAGE_MAGIC	0x58
@@ -2107,7 +2107,7 @@ int zs_page_migrate(struct address_space
 	put_page(page);
 	page = newpage;
 
-	ret = 0;
+	ret = MIGRATEPAGE_SUCCESS;
 unpin_objects:
 	for (addr = s_addr + offset; addr < s_addr + pos;
 						addr += class->size) {
_
