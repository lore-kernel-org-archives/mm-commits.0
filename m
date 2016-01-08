From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-debug-move-bad-flags-printing-to-bad_page.patch removed from -mm tree
Date: Thu, 07 Jan 2016 16:27:23 -0800
Message-ID: <568f026b.yNl7slVAq1fww3c3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbcAHA1Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2016 19:27:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.com, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, debug: move bad flags printing to bad_page()
has been removed from the -mm tree.  Its filename was
     mm-debug-move-bad-flags-printing-to-bad_page.patch

This patch was dropped because an updated version will be merged

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
@@ -9,8 +9,7 @@ struct vm_area_struct;
 struct mm_struct;
 
 extern void dump_page(struct page *page, const char *reason);
-extern void dump_page_badflags(struct page *page, const char *reason,
-			       unsigned long badflags);
+extern void __dump_page(struct page *page, const char *reason);
 void dump_vma(const struct vm_area_struct *vma);
 void dump_mm(const struct mm_struct *mm);
 
diff -puN mm/debug.c~mm-debug-move-bad-flags-printing-to-bad_page mm/debug.c
--- a/mm/debug.c~mm-debug-move-bad-flags-printing-to-bad_page
+++ a/mm/debug.c
@@ -111,25 +111,17 @@ const struct trace_print_flags gfpflag_n
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
@@ -138,7 +130,7 @@ void dump_page_badflags(struct page *pag
 
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

mm-documentation-clarify-proc-pid-status-vmswap-limitations-for-shmem.patch
mm-proc-account-for-shmem-swap-in-proc-pid-smaps.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-shmem-mappings.patch
mm-proc-reduce-cost-of-proc-pid-smaps-for-unpopulated-shmem-mappings.patch

