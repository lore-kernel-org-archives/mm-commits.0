From: akpm@linux-foundation.org
Subject: [merged] mm-page_ext-remove-unnecessary-stack_trace-field.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 11:39:05 -0800
Message-ID: <54dd0159.0b1XMD0xbDfkkYgg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58567 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbbBLTjG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:39:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rogachevsergei@gmail.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner.c: remove unnecessary stack_trace field
has been removed from the -mm tree.  Its filename was
     mm-page_ext-remove-unnecessary-stack_trace-field.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergei Rogachev <rogachevsergei@gmail.com>
Subject: mm/page_owner.c: remove unnecessary stack_trace field

Page owner uses the page_ext structure to keep meta-information for every
page in the system.  The structure also contains a field of type 'struct
stack_trace', page owner uses this field during invocation of the function
save_stack_trace.  It is easy to notice that keeping a copy of this
structure for every page in the system is very inefficiently in terms of
memory.

The patch removes this unnecessary field of page_ext and forces page owner
to use a stack_trace structure allocated on the stack.

[akpm@linux-foundation.org: use struct initializers]
Signed-off-by: Sergei Rogachev <rogachevsergei@gmail.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_ext.h |    2 +-
 mm/page_owner.c          |   26 ++++++++++++++------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff -puN include/linux/page_ext.h~mm-page_ext-remove-unnecessary-stack_trace-field include/linux/page_ext.h
--- a/include/linux/page_ext.h~mm-page_ext-remove-unnecessary-stack_trace-field
+++ a/include/linux/page_ext.h
@@ -40,7 +40,7 @@ struct page_ext {
 #ifdef CONFIG_PAGE_OWNER
 	unsigned int order;
 	gfp_t gfp_mask;
-	struct stack_trace trace;
+	unsigned int nr_entries;
 	unsigned long trace_entries[8];
 #endif
 };
diff -puN mm/page_owner.c~mm-page_ext-remove-unnecessary-stack_trace-field mm/page_owner.c
--- a/mm/page_owner.c~mm-page_ext-remove-unnecessary-stack_trace-field
+++ a/mm/page_owner.c
@@ -59,20 +59,19 @@ void __reset_page_owner(struct page *pag
 
 void __set_page_owner(struct page *page, unsigned int order, gfp_t gfp_mask)
 {
-	struct page_ext *page_ext;
-	struct stack_trace *trace;
+	struct page_ext *page_ext = lookup_page_ext(page);
+	struct stack_trace trace = {
+		.nr_entries = 0,
+		.max_entries = ARRAY_SIZE(page_ext->trace_entries),
+		.entries = &page_ext->trace_entries[0],
+		.skip = 3,
+	};
 
-	page_ext = lookup_page_ext(page);
-
-	trace = &page_ext->trace;
-	trace->nr_entries = 0;
-	trace->max_entries = ARRAY_SIZE(page_ext->trace_entries);
-	trace->entries = &page_ext->trace_entries[0];
-	trace->skip = 3;
-	save_stack_trace(&page_ext->trace);
+	save_stack_trace(&trace);
 
 	page_ext->order = order;
 	page_ext->gfp_mask = gfp_mask;
+	page_ext->nr_entries = trace.nr_entries;
 
 	__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
 }
@@ -84,6 +83,10 @@ print_page_owner(char __user *buf, size_
 	int ret;
 	int pageblock_mt, page_mt;
 	char *kbuf;
+	struct stack_trace trace = {
+		.nr_entries = page_ext->nr_entries,
+		.entries = &page_ext->trace_entries[0],
+	};
 
 	kbuf = kmalloc(count, GFP_KERNEL);
 	if (!kbuf)
@@ -121,8 +124,7 @@ print_page_owner(char __user *buf, size_
 	if (ret >= count)
 		goto err;
 
-	ret += snprint_stack_trace(kbuf + ret, count - ret,
-					&page_ext->trace, 0);
+	ret += snprint_stack_trace(kbuf + ret, count - ret, &trace, 0);
 	if (ret >= count)
 		goto err;
 
_

Patches currently in -mm which might be from rogachevsergei@gmail.com are

origin.patch

