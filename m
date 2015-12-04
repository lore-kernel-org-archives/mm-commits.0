From: akpm@linux-foundation.org
Subject: + mm-debug-move-bad-flags-printing-to-bad_page.patch added to -mm tree
Date: Fri, 04 Dec 2015 15:46:19 -0800
Message-ID: <566225cb.MEVQkynTFLs+ETD8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48425 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbLDXqU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Dec 2015 18:46:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, debug: move bad flags printing to bad_page()
has been added to the -mm tree.  Its filename is
     mm-debug-move-bad-flags-printing-to-bad_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-debug-move-bad-flags-printing-to-bad_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-debug-move-bad-flags-printing-to-bad_page.patch

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
Subject: mm, debug: move bad flags printing to bad_page()

Since bad_page() is the only user of the badflags parameter of
dump_page_badflags(), we can move the code to bad_page() and simplify a
bit.

The dump_page_badflags() function is renamed to __dump_page() and can
still be called separately from dump_page() for temporary debug prints
where page_owner info is not desired.

The only user-visible change is that page->mem_cgroup is printed before
the bad flags.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmdebug.h |    3 +--
 mm/debug.c              |   14 +++-----------
 mm/page_alloc.c         |   10 +++++++---
 3 files changed, 11 insertions(+), 16 deletions(-)

diff -puN include/linux/mmdebug.h~mm-debug-move-bad-flags-printing-to-bad_page include/linux/mmdebug.h
--- a/include/linux/mmdebug.h~mm-debug-move-bad-flags-printing-to-bad_page
+++ a/include/linux/mmdebug.h
@@ -14,8 +14,7 @@ extern const struct trace_print_flags vm
 extern const struct trace_print_flags gfpflag_names[];
 
 extern void dump_page(struct page *page, const char *reason);
-extern void dump_page_badflags(struct page *page, const char *reason,
-			       unsigned long badflags);
+extern void __dump_page(struct page *page, const char *reason);
 void dump_vma(const struct vm_area_struct *vma);
 void dump_mm(const struct mm_struct *mm);
 
diff -puN mm/debug.c~mm-debug-move-bad-flags-printing-to-bad_page mm/debug.c
--- a/mm/debug.c~mm-debug-move-bad-flags-printing-to-bad_page
+++ a/mm/debug.c
@@ -109,25 +109,17 @@ const struct trace_print_flags gfpflag_n
 	{0, NULL},
 };
 
-void dump_page_badflags(struct page *page, const char *reason,
-		unsigned long badflags)
+void __dump_page(struct page *page, const char *reason)
 {
-	unsigned long printflags = page->flags;
-
 	pr_emerg("page:%p count:%d mapcount:%d mapping:%p index:%#lx\n",
 		  page, atomic_read(&page->_count), page_mapcount(page),
 		  page->mapping, page->index);
 	BUILD_BUG_ON(ARRAY_SIZE(pageflag_names) != __NR_PAGEFLAGS + 1);
 
-	pr_emerg("flags: %#lx(%pgp)\n", printflags, &printflags);
+	pr_emerg("flags: %#lx(%pgp)\n", page->flags, &page->flags);
 
 	if (reason)
 		pr_alert("page dumped because: %s\n", reason);
-	if (page->flags & badflags) {
-		printflags = page->flags & badflags;
-		pr_alert("bad because of flags: %#lx(%pgp)\n", printflags,
-								&printflags);
-	}
 #ifdef CONFIG_MEMCG
 	if (page->mem_cgroup)
 		pr_alert("page->mem_cgroup:%p\n", page->mem_cgroup);
@@ -136,7 +128,7 @@ void dump_page_badflags(struct page *pag
 
 void dump_page(struct page *page, const char *reason)
 {
-	dump_page_badflags(page, reason, 0);
+	__dump_page(page, reason);
 	dump_page_owner(page);
 }
 EXPORT_SYMBOL(dump_page);
diff -puN mm/page_alloc.c~mm-debug-move-bad-flags-printing-to-bad_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-debug-move-bad-flags-printing-to-bad_page
+++ a/mm/page_alloc.c
@@ -428,7 +428,7 @@ static void bad_page(struct page *page,
 			goto out;
 		}
 		if (nr_unshown) {
-			printk(KERN_ALERT
+			pr_alert(
 			      "BUG: Bad page state: %lu messages suppressed\n",
 				nr_unshown);
 			nr_unshown = 0;
@@ -438,9 +438,13 @@ static void bad_page(struct page *page,
 	if (nr_shown++ == 0)
 		resume = jiffies + 60 * HZ;
 
-	printk(KERN_ALERT "BUG: Bad page state in process %s  pfn:%05lx\n",
+	pr_alert("BUG: Bad page state in process %s  pfn:%05lx\n",
 		current->comm, page_to_pfn(page));
-	dump_page_badflags(page, reason, bad_flags);
+	__dump_page(page, reason);
+	bad_flags &= page->flags;
+	if (bad_flags)
+		pr_alert("bad because of flags: %#lx(%pgp)\n",
+						bad_flags, &bad_flags);
 	dump_page_owner(page);
 
 	print_modules();
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-fix-swapped-movable-and-reclaimable-in-proc-pagetypeinfo.patch
mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch
mm-debug-fix-wrongly-filtered-flags-in-dump_vma.patch
mm-debug-fix-wrongly-filtered-flags-in-dump_vma-fix.patch
mm-page_owner-print-symbolic-migratetype-of-both-page-and-pageblock.patch
mm-page_owner-convert-page_owner_inited-to-static-key.patch
mm-page_owner-copy-page-owner-info-during-migration.patch
mm-page_owner-track-and-print-last-migrate-reason.patch
mm-page_owner-track-and-print-last-migrate-reason-fix.patch
mm-debug-introduce-dump_gfpflag_names-for-symbolic-printing-of-gfp_flags.patch
mm-page_owner-dump-page-owner-info-from-dump_page.patch
mm-page_owner-dump-page-owner-info-from-dump_page-fix.patch
mm-page_alloc-print-symbolic-gfp_flags-on-allocation-failure.patch
mm-oom-print-symbolic-gfp_flags-in-oom-warning.patch
mm-printk-introduce-new-format-string-for-flags.patch
mm-page_owner-provide-symbolic-page-flags-and-gfp_flags.patch
mm-debug-move-bad-flags-printing-to-bad_page.patch

