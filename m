From: akpm@linux-foundation.org
Subject: + mm-page_owner-dump-page-owner-info-from-dump_page.patch added
 to -mm tree
Date: Tue, 24 Nov 2015 14:45:28 -0800
Message-ID: <5654e888.SmhZyFJhde3fJTes%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55771 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250AbbKXWp3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2015 17:45:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: dump page owner info from dump_page()
has been added to the -mm tree.  Its filename is
     mm-page_owner-dump-page-owner-info-from-dump_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-dump-page-owner-info-from-dump_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-dump-page-owner-info-from-dump_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, page_owner: dump page owner info from dump_page()

The page_owner mechanism is useful for dealing with memory leaks.  By
reading /sys/kernel/debug/page_owner one can determine the stack traces
leading to allocations of all pages, and find e.g.  a buggy driver.

This information might be also potentially useful for debugging, such as
the VM_BUG_ON_PAGE() calls to dump_page().  So let's print the stored info
from dump_page().

Example output:

page:ffffea0002868a00 count:1 mapcount:0 mapping:ffff8800bba8e958 index:0x63a22c
flags: 0x1fffff80000060(lru|active)
page dumped because: VM_BUG_ON_PAGE(1)
page->mem_cgroup:ffff880138efdc00
page allocated via order 0, migratetype Movable, gfp_mask 0x2420848(GFP_NOFS|GFP_NOFAIL|GFP_HARDWALL|GFP_MOVABLE)
 [<ffffffff81164e8a>] __alloc_pages_nodemask+0x15a/0xa30
 [<ffffffff811ab808>] alloc_pages_current+0x88/0x120
 [<ffffffff8115bc36>] __page_cache_alloc+0xe6/0x120
 [<ffffffff8115c226>] pagecache_get_page+0x56/0x200
 [<ffffffff812058c2>] __getblk_slow+0xd2/0x2b0
 [<ffffffff81205ae0>] __getblk_gfp+0x40/0x50
 [<ffffffffa0283abe>] jbd2_journal_get_descriptor_buffer+0x3e/0x90 [jbd2]
 [<ffffffffa027c793>] jbd2_journal_commit_transaction+0x8e3/0x1870 [jbd2]
page has been migrated, last migrate reason: compaction

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_owner.h |    9 +++++++++
 mm/debug.c                 |    2 ++
 mm/page_alloc.c            |    1 +
 mm/page_owner.c            |   25 +++++++++++++++++++++++++
 4 files changed, 37 insertions(+)

diff -puN include/linux/page_owner.h~mm-page_owner-dump-page-owner-info-from-dump_page include/linux/page_owner.h
--- a/include/linux/page_owner.h~mm-page_owner-dump-page-owner-info-from-dump_page
+++ a/include/linux/page_owner.h
@@ -13,6 +13,7 @@ extern void __set_page_owner(struct page
 extern gfp_t __get_page_owner_gfp(struct page *page);
 extern void __copy_page_owner(struct page *oldpage, struct page *newpage);
 extern void __set_page_owner_migrate_reason(struct page *page, int reason);
+extern void __dump_page_owner(struct page *page);
 
 static inline void reset_page_owner(struct page *page, unsigned int order)
 {
@@ -44,6 +45,11 @@ static inline void set_page_owner_migrat
 	if (static_branch_unlikely(&page_owner_inited))
 		__set_page_owner_migrate_reason(page, reason);
 }
+static inline void dump_page_owner(struct page *page)
+{
+	if (static_branch_unlikely(&page_owner_inited))
+		__dump_page_owner(page);
+}
 #else
 static inline void reset_page_owner(struct page *page, unsigned int order)
 {
@@ -62,5 +68,8 @@ static inline void copy_page_owner(struc
 static inline void set_page_owner_migrate_reason(struct page *page, int reason)
 {
 }
+static inline void dump_page_owner(struct page *page)
+{
+}
 #endif /* CONFIG_PAGE_OWNER */
 #endif /* __LINUX_PAGE_OWNER_H */
diff -puN mm/debug.c~mm-page_owner-dump-page-owner-info-from-dump_page mm/debug.c
--- a/mm/debug.c~mm-page_owner-dump-page-owner-info-from-dump_page
+++ a/mm/debug.c
@@ -10,6 +10,7 @@
 #include <linux/trace_events.h>
 #include <linux/memcontrol.h>
 #include <trace/events/gfpflags.h>
+#include <linux/page_owner.h>
 
 static const struct trace_print_flags pageflag_names[] = {
 	{1UL << PG_locked,		"locked"	},
@@ -118,6 +119,7 @@ void dump_page_badflags(struct page *pag
 void dump_page(struct page *page, const char *reason)
 {
 	dump_page_badflags(page, reason, 0);
+	dump_page_owner(page);
 }
 EXPORT_SYMBOL(dump_page);
 
diff -puN mm/page_alloc.c~mm-page_owner-dump-page-owner-info-from-dump_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_owner-dump-page-owner-info-from-dump_page
+++ a/mm/page_alloc.c
@@ -448,6 +448,7 @@ static void bad_page(struct page *page,
 	printk(KERN_ALERT "BUG: Bad page state in process %s  pfn:%05lx\n",
 		current->comm, page_to_pfn(page));
 	dump_page_badflags(page, reason, bad_flags);
+	dump_page_owner(page);
 
 	print_modules();
 	dump_stack();
diff -puN mm/page_owner.c~mm-page_owner-dump-page-owner-info-from-dump_page mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-dump-page-owner-info-from-dump_page
+++ a/mm/page_owner.c
@@ -193,6 +193,31 @@ err:
 	return -ENOMEM;
 }
 
+void __dump_page_owner(struct page *page)
+{
+	struct page_ext *page_ext = lookup_page_ext(page);
+	struct stack_trace trace = {
+		.nr_entries = page_ext->nr_entries,
+		.entries = &page_ext->trace_entries[0],
+	};
+	gfp_t gfp_mask = page_ext->gfp_mask;
+	int mt = gfpflags_to_migratetype(gfp_mask);
+
+	if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags)) {
+		pr_alert("page_owner info is not active (free page?)\n");
+		return;
+	}
+			                        ;
+	pr_alert("page allocated via order %u, migratetype %s, gfp_mask 0x%x",
+			page_ext->order, migratetype_names[mt], gfp_mask);
+	dump_gfpflag_names(gfp_mask);
+	print_stack_trace(&trace, 0);
+
+	if (page_ext->last_migrate_reason != -1)
+		pr_alert("page has been migrated, last migrate reason: %s\n",
+			migrate_reason_names[page_ext->last_migrate_reason]);
+}
+
 static ssize_t
 read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo.patch
mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
mm-debug-fix-wrongly-filtered-flags-in-dump_vma.patch
mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch

