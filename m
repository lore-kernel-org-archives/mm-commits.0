From: akpm@linux-foundation.org
Subject: + mm-fix-build-warnings-in-linux-compactionh.patch added to -mm
 tree
Date: Tue, 14 Jun 2016 13:58:05 -0700
Message-ID: <57606fdd.XLeZG2gYFaw1aPqt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbcFNU6G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Jun 2016 16:58:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aquini@redhat.com, gi-oh.kim@profitbricks.com, koct9i@gmail.com, rdunlap@infradead.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix build warnings in <linux/compaction.h>
has been added to the -mm tree.  Its filename is
     mm-fix-build-warnings-in-linux-compactionh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-build-warnings-in-linux-compactionh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-build-warnings-in-linux-compactionh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
 include/linux/balloon_compaction.h |    2 +-
 include/linux/compaction.h         |   16 ----------------
 include/linux/migrate.h            |   15 +++++++++++++++
 mm/zsmalloc.c                      |    4 ++--
 6 files changed, 25 insertions(+), 25 deletions(-)

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
@@ -46,7 +46,7 @@
 #include <linux/pagemap.h>
 #include <linux/page-flags.h>
 #include <linux/node.h>
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
@@ -52,7 +52,7 @@
 #include <linux/zsmalloc.h>
 #include <linux/zpool.h>
 #include <linux/mount.h>
-#include <linux/compaction.h>
+#include <linux/migrate.h>
 #include <linux/pagemap.h>
 #include <trace/events/zsmalloc.h>
 
@@ -2122,7 +2122,7 @@ int zs_page_migrate(struct address_space
 	put_page(page);
 	page = newpage;
 
-	ret = 0;
+	ret = MIGRATEPAGE_SUCCESS;
 unpin_objects:
 	for (addr = s_addr + offset; addr < s_addr + pos;
 						addr += class->size) {
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-use-put_page-to-free-page-instead-of-putback_lru_page.patch
mm-migrate-support-non-lru-movable-page-migration.patch
mm-balloon-use-general-non-lru-movable-page-feature.patch
zsmalloc-keep-max_object-in-size_class.patch
zsmalloc-use-bit_spin_lock.patch
zsmalloc-use-accessor.patch
zsmalloc-factor-page-chain-functionality-out.patch
zsmalloc-introduce-zspage-structure.patch
zsmalloc-separate-free_zspage-from-putback_zspage.patch
zsmalloc-use-freeobj-for-index.patch
zsmalloc-page-migration-support.patch
zsmalloc-page-migration-support-fix.patch
zram-use-__gfp_movable-for-memory-allocation.patch
zsmalloc-use-obj_tag_bit-for-bit-shifter.patch
mm-add-nr_zsmalloc-to-vmstat.patch
mm-add-nr_zsmalloc-to-vmstat-fix-2.patch
mm-fix-build-warnings-in-linux-compactionh.patch

