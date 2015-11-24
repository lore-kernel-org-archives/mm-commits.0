From: akpm@linux-foundation.org
Subject: + mm-page_owner-convert-page_owner_inited-to-static-key.patch
 added to -mm tree
Date: Tue, 24 Nov 2015 14:45:20 -0800
Message-ID: <5654e880.2NxlL7dmNxfS9/O3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55745 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbbKXWpV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Nov 2015 17:45:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vbabka@suse.cz, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, mhocko@suse.cz, minchan@kernel.org, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_owner: convert page_owner_inited to static key
has been added to the -mm tree.  Its filename is
     mm-page_owner-convert-page_owner_inited-to-static-key.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-convert-page_owner_inited-to-static-key.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-convert-page_owner_inited-to-static-key.patch

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
Subject: mm, page_owner: convert page_owner_inited to static key

CONFIG_PAGE_OWNER attempts to impose negligible runtime overhead when
enabled during compilation, but not actually enabled during runtime by
boot param page_owner=on.  This overhead can be further reduced using the
static key mechanism, which this patch does.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.txt |    9 +++++----
 include/linux/page_owner.h      |   22 ++++++++++------------
 mm/page_owner.c                 |    9 +++++----
 mm/vmstat.c                     |    2 +-
 4 files changed, 21 insertions(+), 21 deletions(-)

diff -puN Documentation/vm/page_owner.txt~mm-page_owner-convert-page_owner_inited-to-static-key Documentation/vm/page_owner.txt
--- a/Documentation/vm/page_owner.txt~mm-page_owner-convert-page_owner_inited-to-static-key
+++ a/Documentation/vm/page_owner.txt
@@ -28,10 +28,11 @@ with page owner and page owner is disabl
 boot option, runtime overhead is marginal. If disabled in runtime, it
 doesn't require memory to store owner information, so there is no runtime
 memory overhead. And, page owner inserts just two unlikely branches into
-the page allocator hotpath and if it returns false then allocation is
-done like as the kernel without page owner. These two unlikely branches
-would not affect to allocation performance. Following is the kernel's
-code size change due to this facility.
+the page allocator hotpath and if not enabled, then allocation is done
+like as the kernel without page owner. These two unlikely branches should
+not affect to allocation performance, especially if the static keys jump
+label patching functionality is available. Following is the kernel's code
+size change due to this facility.
 
 - Without page owner
    text    data     bss     dec     hex filename
diff -puN include/linux/page_owner.h~mm-page_owner-convert-page_owner_inited-to-static-key include/linux/page_owner.h
--- a/include/linux/page_owner.h~mm-page_owner-convert-page_owner_inited-to-static-key
+++ a/include/linux/page_owner.h
@@ -1,8 +1,10 @@
 #ifndef __LINUX_PAGE_OWNER_H
 #define __LINUX_PAGE_OWNER_H
 
+#include <linux/jump_label.h>
+
 #ifdef CONFIG_PAGE_OWNER
-extern bool page_owner_inited;
+extern struct static_key_false page_owner_inited;
 extern struct page_ext_operations page_owner_ops;
 
 extern void __reset_page_owner(struct page *page, unsigned int order);
@@ -12,27 +14,23 @@ extern gfp_t __get_page_owner_gfp(struct
 
 static inline void reset_page_owner(struct page *page, unsigned int order)
 {
-	if (likely(!page_owner_inited))
-		return;
-
-	__reset_page_owner(page, order);
+	if (static_branch_unlikely(&page_owner_inited))
+		__reset_page_owner(page, order);
 }
 
 static inline void set_page_owner(struct page *page,
 			unsigned int order, gfp_t gfp_mask)
 {
-	if (likely(!page_owner_inited))
-		return;
-
-	__set_page_owner(page, order, gfp_mask);
+	if (static_branch_unlikely(&page_owner_inited))
+		__set_page_owner(page, order, gfp_mask);
 }
 
 static inline gfp_t get_page_owner_gfp(struct page *page)
 {
-	if (likely(!page_owner_inited))
+	if (static_branch_unlikely(&page_owner_inited))
+		return __get_page_owner_gfp(page);
+	else
 		return 0;
-
-	return __get_page_owner_gfp(page);
 }
 #else
 static inline void reset_page_owner(struct page *page, unsigned int order)
diff -puN mm/page_owner.c~mm-page_owner-convert-page_owner_inited-to-static-key mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-convert-page_owner_inited-to-static-key
+++ a/mm/page_owner.c
@@ -5,10 +5,11 @@
 #include <linux/bootmem.h>
 #include <linux/stacktrace.h>
 #include <linux/page_owner.h>
+#include <linux/jump_label.h>
 #include "internal.h"
 
 static bool page_owner_disabled = true;
-bool page_owner_inited __read_mostly;
+DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
 static void init_early_allocated_pages(void);
 
@@ -37,7 +38,7 @@ static void init_page_owner(void)
 	if (page_owner_disabled)
 		return;
 
-	page_owner_inited = true;
+	static_branch_enable(&page_owner_inited);
 	init_early_allocated_pages();
 }
 
@@ -157,7 +158,7 @@ read_page_owner(struct file *file, char
 	struct page *page;
 	struct page_ext *page_ext;
 
-	if (!page_owner_inited)
+	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
 
 	page = NULL;
@@ -305,7 +306,7 @@ static int __init pageowner_init(void)
 {
 	struct dentry *dentry;
 
-	if (!page_owner_inited) {
+	if (!static_branch_unlikely(&page_owner_inited)) {
 		pr_info("page_owner is disabled\n");
 		return 0;
 	}
diff -puN mm/vmstat.c~mm-page_owner-convert-page_owner_inited-to-static-key mm/vmstat.c
--- a/mm/vmstat.c~mm-page_owner-convert-page_owner_inited-to-static-key
+++ a/mm/vmstat.c
@@ -1117,7 +1117,7 @@ static void pagetypeinfo_showmixedcount(
 #ifdef CONFIG_PAGE_OWNER
 	int mtype;
 
-	if (!page_owner_inited)
+	if (!static_branch_unlikely(&page_owner_inited))
 		return;
 
 	drain_all_pages(NULL);
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

