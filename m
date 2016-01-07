From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-page_owner-copy-page-owner-info-during-migration.patch removed from -mm
 tree
Date: Thu, 07 Jan 2016 15:50:04 -0800
Message-ID: <568ef9ac.jyk0KnUzPIRVmen6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34895 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbcAGXuF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2016 18:50:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: copy page owner info during migration
has been removed from the -mm tree.  Its filename was
     mm-page_owner-copy-page-owner-info-during-migration.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_owner: copy page owner info during migration

The page_owner mechanism stores gfp_flags of an allocation and stack trace
that lead to it.  During page migration, the original information is
practically replaced by the allocation of free page as the migration
target.  Arguably this is less useful and might lead to all the page_owner
info for migratable pages gradually converge towards compaction or numa
balancing migrations.  It has also lead to inaccuracies such as one fixed
by commit e2cfc91120fa ("mm/page_owner: set correct gfp_mask on
page_owner").

This patch thus introduces copying the page_owner info during migration. 
However, since the fact that the page has been migrated from its original
place might be useful for debugging, the next patch will introduce a way
to track that information as well.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_owner.h |   10 +++++++++-
 mm/migrate.c               |    3 +++
 mm/page_owner.c            |   25 +++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)

diff -puN include/linux/page_owner.h~mm-page_owner-copy-page-owner-info-during-migration include/linux/page_owner.h
--- a/include/linux/page_owner.h~mm-page_owner-copy-page-owner-info-during-migration
+++ a/include/linux/page_owner.h
@@ -11,6 +11,7 @@ extern void __reset_page_owner(struct pa
 extern void __set_page_owner(struct page *page,
 			unsigned int order, gfp_t gfp_mask);
 extern gfp_t __get_page_owner_gfp(struct page *page);
+extern void __copy_page_owner(struct page *oldpage, struct page *newpage);
 
 static inline void reset_page_owner(struct page *page, unsigned int order)
 {
@@ -32,6 +33,11 @@ static inline gfp_t get_page_owner_gfp(s
 	else
 		return 0;
 }
+static inline void copy_page_owner(struct page *oldpage, struct page *newpage)
+{
+	if (static_branch_unlikely(&page_owner_inited))
+		__copy_page_owner(oldpage, newpage);
+}
 #else
 static inline void reset_page_owner(struct page *page, unsigned int order)
 {
@@ -44,6 +50,8 @@ static inline gfp_t get_page_owner_gfp(s
 {
 	return 0;
 }
-
+static inline void copy_page_owner(struct page *oldpage, struct page *newpage)
+{
+}
 #endif /* CONFIG_PAGE_OWNER */
 #endif /* __LINUX_PAGE_OWNER_H */
diff -puN mm/migrate.c~mm-page_owner-copy-page-owner-info-during-migration mm/migrate.c
--- a/mm/migrate.c~mm-page_owner-copy-page-owner-info-during-migration
+++ a/mm/migrate.c
@@ -38,6 +38,7 @@
 #include <linux/balloon_compaction.h>
 #include <linux/mmu_notifier.h>
 #include <linux/page_idle.h>
+#include <linux/page_owner.h>
 
 #include <asm/tlbflush.h>
 
@@ -578,6 +579,8 @@ void migrate_page_copy(struct page *newp
 	 */
 	if (PageWriteback(newpage))
 		end_page_writeback(newpage);
+
+	copy_page_owner(page, newpage);
 }
 
 /************************************************************
diff -puN mm/page_owner.c~mm-page_owner-copy-page-owner-info-during-migration mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-copy-page-owner-info-during-migration
+++ a/mm/page_owner.c
@@ -84,6 +84,31 @@ gfp_t __get_page_owner_gfp(struct page *
 	return page_ext->gfp_mask;
 }
 
+void __copy_page_owner(struct page *oldpage, struct page *newpage)
+{
+	struct page_ext *old_ext = lookup_page_ext(oldpage);
+	struct page_ext *new_ext = lookup_page_ext(newpage);
+	int i;
+
+	new_ext->order = old_ext->order;
+	new_ext->gfp_mask = old_ext->gfp_mask;
+	new_ext->nr_entries = old_ext->nr_entries;
+
+	for (i = 0; i < ARRAY_SIZE(new_ext->trace_entries); i++)
+		new_ext->trace_entries[i] = old_ext->trace_entries[i];
+
+	/*
+	 * We don't clear the bit on the oldpage as it's going to be freed
+	 * after migration. Until then, the info can be useful in case of
+	 * a bug, and the overal stats will be off a bit only temporarily.
+	 * Also, migrate_misplaced_transhuge_page() can still fail the
+	 * migration and then we want the oldpage to retain the info. But
+	 * in that case we also don't need to explicitly clear the info from
+	 * the new page, which will be freed.
+	 */
+	__set_bit(PAGE_EXT_OWNER, &new_ext->flags);
+}
+
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		struct page *page, struct page_ext *page_ext)
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch

