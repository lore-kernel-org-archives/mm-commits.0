From: akpm@linux-foundation.org
Subject: + mm-page_owner-use-stackdepot-to-store-stacktrace.patch added to -mm tree
Date: Thu, 02 Jun 2016 12:49:35 -0700
Message-ID: <57508dcf.V7c8gEeLhQEpEjaa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50436 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbcFBTtg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jun 2016 15:49:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, glider@google.com, hughd@google.com, mgorman@techsingularity.net, mhocko@kernel.org, minchan@kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: use stackdepot to store stacktrace
has been added to the -mm tree.  Its filename is
     mm-page_owner-use-stackdepot-to-store-stacktrace.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-use-stackdepot-to-store-stacktrace.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-use-stackdepot-to-store-stacktrace.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_owner: use stackdepot to store stacktrace

Currently, we store each page's allocation stacktrace on corresponding
page_ext structure and it requires a lot of memory.  This causes the
problem that memory tight system doesn't work well if page_owner is
enabled.  Moreover, even with this large memory consumption, we cannot get
full stacktrace because we allocate memory at boot time and just maintain
8 stacktrace slots to balance memory consumption.  We could increase it to
more but it would make system unusable or change system behaviour.

To solve the problem, this patch uses stackdepot to store stacktrace.  It
obviously provides memory saving but there is a drawback that stackdepot
could fail.

stackdepot allocates memory at runtime so it could fail if system has not
enough memory.  But, most of allocation stack are generated at very early
time and there are much memory at this time.  So, failure would not happen
easily.  And, one failure means that we miss just one page's allocation
stacktrace so it would not be a big problem.  In this patch, when memory
allocation failure happens, we store special stracktrace handle to the
page that is failed to save stacktrace.  With it, user can guess memory
usage properly even if failure happens.

Memory saving looks as following. (4GB memory system with page_owner)

static allocation:
92274688 bytes -> 25165824 bytes

dynamic allocation after kernel build:
0 bytes -> 327680 bytes

total:
92274688 bytes -> 25493504 bytes

72% reduction in total.

Note that implementation looks complex than someone would imagine because
there is recursion issue.  stackdepot uses page allocator and page_owner
is called at page allocation.  Using stackdepot in page_owner could
re-call page allcator and then page_owner.  That is a recursion.  To
detect and avoid it, whenever we obtain stacktrace, recursion is checked
and page_owner is set to dummy information if found.  Dummy information
means that this page is allocated for page_owner feature itself (such as
stackdepot) and it's understandable behavior for user.

Link: http://lkml.kernel.org/r/1464230275-25791-6-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |    4 -
 lib/Kconfig.debug        |    1 
 mm/page_owner.c          |  138 +++++++++++++++++++++++++++++++------
 3 files changed, 122 insertions(+), 21 deletions(-)

diff -puN include/linux/page_ext.h~mm-page_owner-use-stackdepot-to-store-stacktrace include/linux/page_ext.h
--- a/include/linux/page_ext.h~mm-page_owner-use-stackdepot-to-store-stacktrace
+++ a/include/linux/page_ext.h
@@ -3,6 +3,7 @@
 
 #include <linux/types.h>
 #include <linux/stacktrace.h>
+#include <linux/stackdepot.h>
 
 struct pglist_data;
 struct page_ext_operations {
@@ -44,9 +45,8 @@ struct page_ext {
 #ifdef CONFIG_PAGE_OWNER
 	unsigned int order;
 	gfp_t gfp_mask;
-	unsigned int nr_entries;
 	int last_migrate_reason;
-	unsigned long trace_entries[8];
+	depot_stack_handle_t handle;
 #endif
 };
 
diff -puN lib/Kconfig.debug~mm-page_owner-use-stackdepot-to-store-stacktrace lib/Kconfig.debug
--- a/lib/Kconfig.debug~mm-page_owner-use-stackdepot-to-store-stacktrace
+++ a/lib/Kconfig.debug
@@ -244,6 +244,7 @@ config PAGE_OWNER
 	depends on DEBUG_KERNEL && STACKTRACE_SUPPORT
 	select DEBUG_FS
 	select STACKTRACE
+	select STACKDEPOT
 	select PAGE_EXTENSION
 	help
 	  This keeps track of what call chain is the owner of a page, may
diff -puN mm/page_owner.c~mm-page_owner-use-stackdepot-to-store-stacktrace mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-use-stackdepot-to-store-stacktrace
+++ a/mm/page_owner.c
@@ -7,11 +7,18 @@
 #include <linux/page_owner.h>
 #include <linux/jump_label.h>
 #include <linux/migrate.h>
+#include <linux/stackdepot.h>
+
 #include "internal.h"
 
+#define PAGE_OWNER_STACK_DEPTH (16)
+
 static bool page_owner_disabled = true;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
+static depot_stack_handle_t dummy_handle;
+static depot_stack_handle_t failure_handle;
+
 static void init_early_allocated_pages(void);
 
 static int early_page_owner_param(char *buf)
@@ -34,11 +41,41 @@ static bool need_page_owner(void)
 	return true;
 }
 
+static noinline void register_dummy_stack(void)
+{
+	unsigned long entries[4];
+	struct stack_trace dummy;
+
+	dummy.nr_entries = 0;
+	dummy.max_entries = ARRAY_SIZE(entries);
+	dummy.entries = &entries[0];
+	dummy.skip = 0;
+
+	save_stack_trace(&dummy);
+	dummy_handle = depot_save_stack(&dummy, GFP_KERNEL);
+}
+
+static noinline void register_failure_stack(void)
+{
+	unsigned long entries[4];
+	struct stack_trace failure;
+
+	failure.nr_entries = 0;
+	failure.max_entries = ARRAY_SIZE(entries);
+	failure.entries = &entries[0];
+	failure.skip = 0;
+
+	save_stack_trace(&failure);
+	failure_handle = depot_save_stack(&failure, GFP_KERNEL);
+}
+
 static void init_page_owner(void)
 {
 	if (page_owner_disabled)
 		return;
 
+	register_dummy_stack();
+	register_failure_stack();
 	static_branch_enable(&page_owner_inited);
 	init_early_allocated_pages();
 }
@@ -61,25 +98,66 @@ void __reset_page_owner(struct page *pag
 	}
 }
 
-void __set_page_owner(struct page *page, unsigned int order, gfp_t gfp_mask)
+static inline bool check_recursive_alloc(struct stack_trace *trace,
+					unsigned long ip)
 {
-	struct page_ext *page_ext = lookup_page_ext(page);
+	int i, count;
+
+	if (!trace->nr_entries)
+		return false;
+
+	for (i = 0, count = 0; i < trace->nr_entries; i++) {
+		if (trace->entries[i] == ip && ++count == 2)
+			return true;
+	}
 
+	return false;
+}
+
+static noinline depot_stack_handle_t save_stack(gfp_t flags)
+{
+	unsigned long entries[PAGE_OWNER_STACK_DEPTH];
 	struct stack_trace trace = {
 		.nr_entries = 0,
-		.max_entries = ARRAY_SIZE(page_ext->trace_entries),
-		.entries = &page_ext->trace_entries[0],
-		.skip = 3,
+		.entries = entries,
+		.max_entries = PAGE_OWNER_STACK_DEPTH,
+		.skip = 0
 	};
+	depot_stack_handle_t handle;
+
+	save_stack_trace(&trace);
+	if (trace.nr_entries != 0 &&
+	    trace.entries[trace.nr_entries-1] == ULONG_MAX)
+		trace.nr_entries--;
+
+	/*
+	 * We need to check recursion here because our request to stackdepot
+	 * could trigger memory allocation to save new entry. New memory
+	 * allocation would reach here and call depot_save_stack() again
+	 * if we don't catch it. There is still not enough memory in stackdepot
+	 * so it would try to allocate memory again and loop forever.
+	 */
+	if (check_recursive_alloc(&trace, _RET_IP_))
+		return dummy_handle;
+
+	handle = depot_save_stack(&trace, flags);
+	if (!handle)
+		handle = failure_handle;
+
+	return handle;
+}
+
+noinline void __set_page_owner(struct page *page, unsigned int order,
+					gfp_t gfp_mask)
+{
+	struct page_ext *page_ext = lookup_page_ext(page);
 
 	if (unlikely(!page_ext))
 		return;
 
-	save_stack_trace(&trace);
-
+	page_ext->handle = save_stack(gfp_mask);
 	page_ext->order = order;
 	page_ext->gfp_mask = gfp_mask;
-	page_ext->nr_entries = trace.nr_entries;
 	page_ext->last_migrate_reason = -1;
 
 	__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
@@ -111,7 +189,6 @@ void __copy_page_owner(struct page *oldp
 {
 	struct page_ext *old_ext = lookup_page_ext(oldpage);
 	struct page_ext *new_ext = lookup_page_ext(newpage);
-	int i;
 
 	if (unlikely(!old_ext || !new_ext))
 		return;
@@ -119,10 +196,7 @@ void __copy_page_owner(struct page *oldp
 	new_ext->order = old_ext->order;
 	new_ext->gfp_mask = old_ext->gfp_mask;
 	new_ext->last_migrate_reason = old_ext->last_migrate_reason;
-	new_ext->nr_entries = old_ext->nr_entries;
-
-	for (i = 0; i < ARRAY_SIZE(new_ext->trace_entries); i++)
-		new_ext->trace_entries[i] = old_ext->trace_entries[i];
+	new_ext->handle = old_ext->handle;
 
 	/*
 	 * We don't clear the bit on the oldpage as it's going to be freed
@@ -138,14 +212,18 @@ void __copy_page_owner(struct page *oldp
 
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
-		struct page *page, struct page_ext *page_ext)
+		struct page *page, struct page_ext *page_ext,
+		depot_stack_handle_t handle)
 {
 	int ret;
 	int pageblock_mt, page_mt;
 	char *kbuf;
+	unsigned long entries[PAGE_OWNER_STACK_DEPTH];
 	struct stack_trace trace = {
-		.nr_entries = page_ext->nr_entries,
-		.entries = &page_ext->trace_entries[0],
+		.nr_entries = 0,
+		.entries = entries,
+		.max_entries = PAGE_OWNER_STACK_DEPTH,
+		.skip = 0
 	};
 
 	kbuf = kmalloc(count, GFP_KERNEL);
@@ -174,6 +252,7 @@ print_page_owner(char __user *buf, size_
 	if (ret >= count)
 		goto err;
 
+	depot_fetch_stack(handle, &trace);
 	ret += snprint_stack_trace(kbuf + ret, count - ret, &trace, 0);
 	if (ret >= count)
 		goto err;
@@ -204,10 +283,14 @@ err:
 void __dump_page_owner(struct page *page)
 {
 	struct page_ext *page_ext = lookup_page_ext(page);
+	unsigned long entries[PAGE_OWNER_STACK_DEPTH];
 	struct stack_trace trace = {
-		.nr_entries = page_ext->nr_entries,
-		.entries = &page_ext->trace_entries[0],
+		.nr_entries = 0,
+		.entries = entries,
+		.max_entries = PAGE_OWNER_STACK_DEPTH,
+		.skip = 0
 	};
+	depot_stack_handle_t handle;
 	gfp_t gfp_mask = page_ext->gfp_mask;
 	int mt = gfpflags_to_migratetype(gfp_mask);
 
@@ -221,6 +304,13 @@ void __dump_page_owner(struct page *page
 		return;
 	}
 
+	handle = READ_ONCE(page_ext->handle);
+	if (!handle) {
+		pr_alert("page_owner info is not active (free page?)\n");
+		return;
+	}
+
+	depot_fetch_stack(handle, &trace);
 	pr_alert("page allocated via order %u, migratetype %s, gfp_mask %#x(%pGg)\n",
 		 page_ext->order, migratetype_names[mt], gfp_mask, &gfp_mask);
 	print_stack_trace(&trace, 0);
@@ -236,6 +326,7 @@ read_page_owner(struct file *file, char
 	unsigned long pfn;
 	struct page *page;
 	struct page_ext *page_ext;
+	depot_stack_handle_t handle;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -284,10 +375,19 @@ read_page_owner(struct file *file, char
 		if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags))
 			continue;
 
+		/*
+		 * Access to page_ext->handle isn't synchronous so we should
+		 * be careful to access it.
+		 */
+		handle = READ_ONCE(page_ext->handle);
+		if (!handle)
+			continue;
+
 		/* Record the next PFN to read in the file offset */
 		*ppos = (pfn - min_low_pfn) + 1;
 
-		return print_page_owner(buf, count, pfn, page, page_ext);
+		return print_page_owner(buf, count, pfn, page,
+				page_ext, handle);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-compaction-split-freepages-without-holding-the-zone-lock.patch
mm-page_owner-initialize-page-owner-without-holding-the-zone-lock.patch
mm-page_owner-copy-last_migrate_reason-in-copy_page_owner.patch
mm-page_owner-introduce-split_page_owner-and-replace-manual-handling.patch
tools-vm-page_owner-increase-temporary-buffer-size.patch
mm-page_owner-use-stackdepot-to-store-stacktrace.patch
mm-page_alloc-introduce-post-allocation-processing-on-page-allocator.patch

