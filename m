From: akpm@linux-foundation.org
Subject: +
 mm-page_owner-dont-define-fields-on-struct-page_ext-by-hard-coding.patch
 added to -mm tree
Date: Tue, 16 Aug 2016 13:40:07 -0700
Message-ID: <57b37a27.nUgKQSOhaABuaBxd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37775 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbcHPUkI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 16 Aug 2016 16:40:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, mhocko@kernel.org, minchan@kernel.org, sergey.senozhatsky@gmail.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: don't define fields on struct page_ext by hard-coding
has been added to the -mm tree.  Its filename is
     mm-page_owner-dont-define-fields-on-struct-page_ext-by-hard-coding.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_owner-dont-define-fields-on-struct-page_ext-by-hard-coding.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_owner-dont-define-fields-on-struct-page_ext-by-hard-coding.patch

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
Subject: mm/page_owner: don't define fields on struct page_ext by hard-coding

There is a memory waste problem if we define field on struct page_ext by
hard-coding.  Entry size of struct page_ext includes the size of those
fields even if it is disabled at runtime.  Now, extra memory request at
runtime is possible so page_owner don't need to define it's own fields by
hard-coding.

This patch removes hard-coded define and uses extra memory for storing
page_owner information in page_owner.  Most of code are just mechanical
changes.

Link: http://lkml.kernel.org/r/1471315879-32294-7-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |    6 --
 mm/page_owner.c          |   83 +++++++++++++++++++++++++------------
 2 files changed, 58 insertions(+), 31 deletions(-)

diff -puN include/linux/page_ext.h~mm-page_owner-dont-define-fields-on-struct-page_ext-by-hard-coding include/linux/page_ext.h
--- a/include/linux/page_ext.h~mm-page_owner-dont-define-fields-on-struct-page_ext-by-hard-coding
+++ a/include/linux/page_ext.h
@@ -44,12 +44,6 @@ enum page_ext_flags {
  */
 struct page_ext {
 	unsigned long flags;
-#ifdef CONFIG_PAGE_OWNER
-	unsigned int order;
-	gfp_t gfp_mask;
-	int last_migrate_reason;
-	depot_stack_handle_t handle;
-#endif
 };
 
 extern void pgdat_page_ext_init(struct pglist_data *pgdat);
diff -puN mm/page_owner.c~mm-page_owner-dont-define-fields-on-struct-page_ext-by-hard-coding mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-dont-define-fields-on-struct-page_ext-by-hard-coding
+++ a/mm/page_owner.c
@@ -18,6 +18,13 @@
  */
 #define PAGE_OWNER_STACK_DEPTH (16)
 
+struct page_owner {
+	unsigned int order;
+	gfp_t gfp_mask;
+	int last_migrate_reason;
+	depot_stack_handle_t handle;
+};
+
 static bool page_owner_disabled = true;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
@@ -86,10 +93,16 @@ static void init_page_owner(void)
 }
 
 struct page_ext_operations page_owner_ops = {
+	.size = sizeof(struct page_owner),
 	.need = need_page_owner,
 	.init = init_page_owner,
 };
 
+static inline struct page_owner *get_page_owner(struct page_ext *page_ext)
+{
+	return (void *)page_ext + page_owner_ops.offset;
+}
+
 void __reset_page_owner(struct page *page, unsigned int order)
 {
 	int i;
@@ -156,14 +169,16 @@ noinline void __set_page_owner(struct pa
 					gfp_t gfp_mask)
 {
 	struct page_ext *page_ext = lookup_page_ext(page);
+	struct page_owner *page_owner;
 
 	if (unlikely(!page_ext))
 		return;
 
-	page_ext->handle = save_stack(gfp_mask);
-	page_ext->order = order;
-	page_ext->gfp_mask = gfp_mask;
-	page_ext->last_migrate_reason = -1;
+	page_owner = get_page_owner(page_ext);
+	page_owner->handle = save_stack(gfp_mask);
+	page_owner->order = order;
+	page_owner->gfp_mask = gfp_mask;
+	page_owner->last_migrate_reason = -1;
 
 	__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
 }
@@ -171,21 +186,26 @@ noinline void __set_page_owner(struct pa
 void __set_page_owner_migrate_reason(struct page *page, int reason)
 {
 	struct page_ext *page_ext = lookup_page_ext(page);
+	struct page_owner *page_owner;
+
 	if (unlikely(!page_ext))
 		return;
 
-	page_ext->last_migrate_reason = reason;
+	page_owner = get_page_owner(page_ext);
+	page_owner->last_migrate_reason = reason;
 }
 
 void __split_page_owner(struct page *page, unsigned int order)
 {
 	int i;
 	struct page_ext *page_ext = lookup_page_ext(page);
+	struct page_owner *page_owner;
 
 	if (unlikely(!page_ext))
 		return;
 
-	page_ext->order = 0;
+	page_owner = get_page_owner(page_ext);
+	page_owner->order = 0;
 	for (i = 1; i < (1 << order); i++)
 		__copy_page_owner(page, page + i);
 }
@@ -194,14 +214,18 @@ void __copy_page_owner(struct page *oldp
 {
 	struct page_ext *old_ext = lookup_page_ext(oldpage);
 	struct page_ext *new_ext = lookup_page_ext(newpage);
+	struct page_owner *old_page_owner, *new_page_owner;
 
 	if (unlikely(!old_ext || !new_ext))
 		return;
 
-	new_ext->order = old_ext->order;
-	new_ext->gfp_mask = old_ext->gfp_mask;
-	new_ext->last_migrate_reason = old_ext->last_migrate_reason;
-	new_ext->handle = old_ext->handle;
+	old_page_owner = get_page_owner(old_ext);
+	new_page_owner = get_page_owner(new_ext);
+	new_page_owner->order = old_page_owner->order;
+	new_page_owner->gfp_mask = old_page_owner->gfp_mask;
+	new_page_owner->last_migrate_reason =
+		old_page_owner->last_migrate_reason;
+	new_page_owner->handle = old_page_owner->handle;
 
 	/*
 	 * We don't clear the bit on the oldpage as it's going to be freed
@@ -221,6 +245,7 @@ static void pagetypeinfo_showmixedcount_
 {
 	struct page *page;
 	struct page_ext *page_ext;
+	struct page_owner *page_owner;
 	unsigned long pfn = zone->zone_start_pfn, block_end_pfn;
 	unsigned long end_pfn = pfn + zone->spanned_pages;
 	unsigned long count[MIGRATE_TYPES] = { 0, };
@@ -271,7 +296,9 @@ static void pagetypeinfo_showmixedcount_
 			if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags))
 				continue;
 
-			page_mt = gfpflags_to_migratetype(page_ext->gfp_mask);
+			page_owner = get_page_owner(page_ext);
+			page_mt = gfpflags_to_migratetype(
+					page_owner->gfp_mask);
 			if (pageblock_mt != page_mt) {
 				if (is_migrate_cma(pageblock_mt))
 					count[MIGRATE_MOVABLE]++;
@@ -281,7 +308,7 @@ static void pagetypeinfo_showmixedcount_
 				pfn = block_end_pfn;
 				break;
 			}
-			pfn += (1UL << page_ext->order) - 1;
+			pfn += (1UL << page_owner->order) - 1;
 		}
 	}
 
@@ -293,7 +320,7 @@ static void pagetypeinfo_showmixedcount_
 }
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
-		struct page *page, struct page_ext *page_ext,
+		struct page *page, struct page_owner *page_owner,
 		depot_stack_handle_t handle)
 {
 	int ret;
@@ -313,15 +340,15 @@ print_page_owner(char __user *buf, size_
 
 	ret = snprintf(kbuf, count,
 			"Page allocated via order %u, mask %#x(%pGg)\n",
-			page_ext->order, page_ext->gfp_mask,
-			&page_ext->gfp_mask);
+			page_owner->order, page_owner->gfp_mask,
+			&page_owner->gfp_mask);
 
 	if (ret >= count)
 		goto err;
 
 	/* Print information relevant to grouping pages by mobility */
 	pageblock_mt = get_pageblock_migratetype(page);
-	page_mt  = gfpflags_to_migratetype(page_ext->gfp_mask);
+	page_mt  = gfpflags_to_migratetype(page_owner->gfp_mask);
 	ret += snprintf(kbuf + ret, count - ret,
 			"PFN %lu type %s Block %lu type %s Flags %#lx(%pGp)\n",
 			pfn,
@@ -338,10 +365,10 @@ print_page_owner(char __user *buf, size_
 	if (ret >= count)
 		goto err;
 
-	if (page_ext->last_migrate_reason != -1) {
+	if (page_owner->last_migrate_reason != -1) {
 		ret += snprintf(kbuf + ret, count - ret,
 			"Page has been migrated, last migrate reason: %s\n",
-			migrate_reason_names[page_ext->last_migrate_reason]);
+			migrate_reason_names[page_owner->last_migrate_reason]);
 		if (ret >= count)
 			goto err;
 	}
@@ -364,6 +391,7 @@ err:
 void __dump_page_owner(struct page *page)
 {
 	struct page_ext *page_ext = lookup_page_ext(page);
+	struct page_owner *page_owner;
 	unsigned long entries[PAGE_OWNER_STACK_DEPTH];
 	struct stack_trace trace = {
 		.nr_entries = 0,
@@ -379,7 +407,9 @@ void __dump_page_owner(struct page *page
 		pr_alert("There is not page extension available.\n");
 		return;
 	}
-	gfp_mask = page_ext->gfp_mask;
+
+	page_owner = get_page_owner(page_ext);
+	gfp_mask = page_owner->gfp_mask;
 	mt = gfpflags_to_migratetype(gfp_mask);
 
 	if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags)) {
@@ -387,7 +417,7 @@ void __dump_page_owner(struct page *page
 		return;
 	}
 
-	handle = READ_ONCE(page_ext->handle);
+	handle = READ_ONCE(page_owner->handle);
 	if (!handle) {
 		pr_alert("page_owner info is not active (free page?)\n");
 		return;
@@ -395,12 +425,12 @@ void __dump_page_owner(struct page *page
 
 	depot_fetch_stack(handle, &trace);
 	pr_alert("page allocated via order %u, migratetype %s, gfp_mask %#x(%pGg)\n",
-		 page_ext->order, migratetype_names[mt], gfp_mask, &gfp_mask);
+		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask);
 	print_stack_trace(&trace, 0);
 
-	if (page_ext->last_migrate_reason != -1)
+	if (page_owner->last_migrate_reason != -1)
 		pr_alert("page has been migrated, last migrate reason: %s\n",
-			migrate_reason_names[page_ext->last_migrate_reason]);
+			migrate_reason_names[page_owner->last_migrate_reason]);
 }
 
 static ssize_t
@@ -409,6 +439,7 @@ read_page_owner(struct file *file, char
 	unsigned long pfn;
 	struct page *page;
 	struct page_ext *page_ext;
+	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
 
 	if (!static_branch_unlikely(&page_owner_inited))
@@ -458,11 +489,13 @@ read_page_owner(struct file *file, char
 		if (!test_bit(PAGE_EXT_OWNER, &page_ext->flags))
 			continue;
 
+		page_owner = get_page_owner(page_ext);
+
 		/*
 		 * Access to page_ext->handle isn't synchronous so we should
 		 * be careful to access it.
 		 */
-		handle = READ_ONCE(page_ext->handle);
+		handle = READ_ONCE(page_owner->handle);
 		if (!handle)
 			continue;
 
@@ -470,7 +503,7 @@ read_page_owner(struct file *file, char
 		*ppos = (pfn - min_low_pfn) + 1;
 
 		return print_page_owner(buf, count, pfn, page,
-				page_ext, handle);
+				page_owner, handle);
 	}
 
 	return 0;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-debug_pagealloc-clean-up-guard-page-handling-code.patch
mm-debug_pagealloc-dont-allocate-page_ext-if-we-dont-use-guard-page.patch
mm-page_owner-move-page_owner-specific-function-to-page_ownerc.patch
mm-page_ext-rename-offset-to-index.patch
mm-page_ext-support-extra-space-allocation-by-page_ext-user.patch
mm-page_owner-dont-define-fields-on-struct-page_ext-by-hard-coding.patch

