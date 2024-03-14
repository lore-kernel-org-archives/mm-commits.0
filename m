Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F091874BE8
	for <mm-commits@vger.kernel.org>; Thu, 14 Mar 2024 18:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710439309; cv=none; b=jwWZQK1sOBbRQPL0HxioYTpXoALDaWufVjVxS5CGDyCNlrljxUCyGV65XlsyhX0fP64B4y07Ne8euBcfS1Y6db6tgDVmpUMQ/a15s95BwiokW36yKenSSe1H7HQVJLwzD+BUy7q5TcpQaKHa9JwzJ2ArJJy/BWq2RGuv4wxC0+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710439309; c=relaxed/simple;
	bh=Vfbh55KFBnzuHbdt+c5cVZ9mG9mXxQl2LJZDHLJNTd4=;
	h=Date:To:From:Subject:Message-Id; b=uniVEZfz3SinPkeqfrwasi6DHNFawujGbVqKNVyHA+CoPdCDXY99WP5jqCyofhlnpxkphP+f1Lgs7JJHhH2zukTDQGeMg0xSldTLBxO8yYKhyzjvsE9B6D70YFkgV/k68BoOz39Kb4Z568VgbzWsAyDny3yQRYzIKM+L9mMyYr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=P9LRrAPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="P9LRrAPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63205C433C7;
	Thu, 14 Mar 2024 18:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710439308;
	bh=Vfbh55KFBnzuHbdt+c5cVZ9mG9mXxQl2LJZDHLJNTd4=;
	h=Date:To:From:Subject:From;
	b=P9LRrAPVFmpL6JTG6j3ycmA5mNC5lkR/MRJocACJDbjMKJyu8okw2ivJF+bJTw2z0
	 IUzw6k7I0Qdn57NGHWAxoH35Sr3JNj/qKz7/P2X5iEpuYQQGmbnTA7OXbEfq2ANzCr
	 Nj51bD/jhLK84I/AlWh9rrE8OxFHx6MrgTHbqgxc=
Date: Thu, 14 Mar 2024 11:01:47 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-fix-refcount-imbalance.patch added to mm-stable branch
Message-Id: <20240314180148.63205C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,page_owner: fix refcount imbalance
has been added to the -mm mm-stable branch.  Its filename is
     mmpage_owner-fix-refcount-imbalance.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmpage_owner-fix-refcount-imbalance.patch

This patch will later appear in the mm-stable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_owner: fix refcount imbalance
Date: Thu, 14 Mar 2024 15:47:53 +0100

Current code does not contemplate scenarios were an allocation and free
operation on the same pages do not handle it in the same amount at once.

To give an example, page_alloc_exact(), where we will allocate a page of
enough order to stafisfy the size request, but we will free the remainings
right away.

In the above example, we will increment the stack_record refcount only
once, but we will decrease it the same number of times as number of unused
pages we have to free.  This will lead to a warning because of refcount
imbalance.

Fix this by recording the number of base pages every stack_record holds,
and only let the last decrementing of refcount succeed if the number of
base pages equals 0, which means we freed all the pages.

As a bonus, show the aggregate of stack_count + base_pages as this gives a
much better picture of the memory usage.

Link: https://lkml.kernel.org/r/20240314144753.16276-1-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Fixes: 217b2119b9e2 ("mm,page_owner: implement the tracking of the stacks count")
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |    3 +
 mm/page_owner.c            |   57 ++++++++++++++++++++++++++++-------
 2 files changed, 50 insertions(+), 10 deletions(-)

--- a/include/linux/stackdepot.h~mmpage_owner-fix-refcount-imbalance
+++ a/include/linux/stackdepot.h
@@ -57,6 +57,9 @@ struct stack_record {
 	u32 size;			/* Number of stored frames */
 	union handle_parts handle;	/* Constant after initialization */
 	refcount_t count;
+#ifdef CONFIG_PAGE_OWNER
+	unsigned long nr_base_pages;
+#endif
 	union {
 		unsigned long entries[CONFIG_STACKDEPOT_MAX_FRAMES];	/* Frames */
 		struct {
--- a/mm/page_owner.c~mmpage_owner-fix-refcount-imbalance
+++ a/mm/page_owner.c
@@ -107,10 +107,14 @@ static __init void init_page_owner(void)
 	/* Initialize dummy and failure stacks and link them to stack_list */
 	dummy_stack.stack_record = __stack_depot_get_stack_record(dummy_handle);
 	failure_stack.stack_record = __stack_depot_get_stack_record(failure_handle);
-	if (dummy_stack.stack_record)
+	if (dummy_stack.stack_record) {
+		dummy_stack.stack_record->nr_base_pages = 0;
 		refcount_set(&dummy_stack.stack_record->count, 1);
-	if (failure_stack.stack_record)
+	}
+	if (failure_stack.stack_record) {
+		failure_stack.stack_record->nr_base_pages = 0;
 		refcount_set(&failure_stack.stack_record->count, 1);
+	}
 	dummy_stack.next = &failure_stack;
 	stack_list = &dummy_stack;
 }
@@ -183,9 +187,11 @@ static void add_stack_record_to_list(str
 	spin_unlock_irqrestore(&stack_list_lock, flags);
 }
 
-static void inc_stack_record_count(depot_stack_handle_t handle, gfp_t gfp_mask)
+static void inc_stack_record_count(depot_stack_handle_t handle, gfp_t gfp_mask,
+				   unsigned long nr_base_pages)
 {
 	struct stack_record *stack_record = __stack_depot_get_stack_record(handle);
+	unsigned long curr_nr_pages;
 
 	if (!stack_record)
 		return;
@@ -200,19 +206,47 @@ static void inc_stack_record_count(depot
 	if (refcount_read(&stack_record->count) == REFCOUNT_SATURATED) {
 		int old = REFCOUNT_SATURATED;
 
-		if (atomic_try_cmpxchg_relaxed(&stack_record->count.refs, &old, 1))
+		if (atomic_try_cmpxchg_relaxed(&stack_record->count.refs, &old, 1)) {
 			/* Add the new stack_record to our list */
 			add_stack_record_to_list(stack_record, gfp_mask);
+			smp_store_release(&stack_record->nr_base_pages,
+					  nr_base_pages);
+			goto inc;
+		}
 	}
+
+	curr_nr_pages = smp_load_acquire(&stack_record->nr_base_pages);
+	smp_store_release(&stack_record->nr_base_pages,
+			  curr_nr_pages + nr_base_pages);
+inc:
 	refcount_inc(&stack_record->count);
 }
 
-static void dec_stack_record_count(depot_stack_handle_t handle)
+static void dec_stack_record_count(depot_stack_handle_t handle,
+				   unsigned long nr_base_pages)
 {
 	struct stack_record *stack_record = __stack_depot_get_stack_record(handle);
+	unsigned long curr_nr_pages;
+
+	if (!stack_record)
+		return;
+
+	curr_nr_pages = smp_load_acquire(&stack_record->nr_base_pages);
+	smp_store_release(&stack_record->nr_base_pages,
+			  curr_nr_pages - nr_base_pages);
+	curr_nr_pages = smp_load_acquire(&stack_record->nr_base_pages);
+
+	/*
+	 * If this stack_record is going to reach a refcount == 1, which means
+	 * free, only do it if all the base pages it allocated were freed.
+	 * E.g: scenarios like THP splitting, or alloc_pages_exact() can have
+	 * an alloc/free operation with different amount of pages
+	 */
+	if (refcount_read(&stack_record->count) == 2 &&
+	    curr_nr_pages)
+		return;
 
-	if (stack_record)
-		refcount_dec(&stack_record->count);
+	refcount_dec(&stack_record->count);
 }
 
 void __reset_page_owner(struct page *page, unsigned short order)
@@ -250,7 +284,7 @@ void __reset_page_owner(struct page *pag
 		 * the machinery is not ready yet, we cannot decrement
 		 * their refcount either.
 		 */
-		dec_stack_record_count(alloc_handle);
+		dec_stack_record_count(alloc_handle, 1UL << order);
 }
 
 static inline void __set_page_owner_handle(struct page_ext *page_ext,
@@ -292,7 +326,7 @@ noinline void __set_page_owner(struct pa
 		return;
 	__set_page_owner_handle(page_ext, handle, order, gfp_mask);
 	page_ext_put(page_ext);
-	inc_stack_record_count(handle, gfp_mask);
+	inc_stack_record_count(handle, gfp_mask, 1UL << order);
 }
 
 void __set_page_owner_migrate_reason(struct page *page, int reason)
@@ -856,6 +890,7 @@ static int stack_print(struct seq_file *
 	struct stack *stack = v;
 	unsigned long *entries;
 	unsigned long nr_entries;
+	unsigned long nr_base_pages;
 	struct stack_record *stack_record = stack->stack_record;
 
 	if (!stack->stack_record)
@@ -863,6 +898,7 @@ static int stack_print(struct seq_file *
 
 	nr_entries = stack_record->size;
 	entries = stack_record->entries;
+	nr_base_pages = stack_record->nr_base_pages;
 	stack_count = refcount_read(&stack_record->count) - 1;
 
 	if (stack_count < 1 || stack_count < page_owner_stack_threshold)
@@ -870,7 +906,8 @@ static int stack_print(struct seq_file *
 
 	for (i = 0; i < nr_entries; i++)
 		seq_printf(m, " %pS\n", (void *)entries[i]);
-	seq_printf(m, "stack_count: %d\n\n", stack_count);
+	seq_printf(m, "stack_count: %d curr_nr_base_pages: %lu\n\n",
+		   stack_count, nr_base_pages);
 
 	return 0;
 }
_

Patches currently in -mm which might be from osalvador@suse.de are

mmpage_owner-fix-refcount-imbalance.patch

