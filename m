Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A7D4F885
	for <mm-commits@vger.kernel.org>; Mon, 12 Feb 2024 23:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707780519; cv=none; b=fDi/wNMh4gokuEnIHRUbf2g57G7w9fQew2fO+f5nllUEWtZhA1Bw3N2baLBuwWh4zOuPW1TRSEY5OT9r/HnIrQWoPMNddsxUXqhnqMAKU+2YqF/sGhEzQDY9GDEKoA+hTA2fpklqhBYvGn04Y+E/+iCJktTpqTlx1C+e+EvV+Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707780519; c=relaxed/simple;
	bh=9xto64s1JB80dwzBjaVoqsEOhlFsqybGGNQroddyCFo=;
	h=Date:To:From:Subject:Message-Id; b=FCJDWWoIugHHUbeJjYboj+7MlFEDVruXsZ0h/90ddMPPEY1hXak0cLdTwu1ArIS/AVmUuQFc5l4L6TmZ7638v5IatohtoWisHMOg0R1MsAwyhExpfznfMY/llltg2RWh2Xum83LTRBmaWjPHyBJ79+bnMribjqicIOvfrUim35k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DsnmC8BU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DsnmC8BU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E1FC433F1;
	Mon, 12 Feb 2024 23:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707780519;
	bh=9xto64s1JB80dwzBjaVoqsEOhlFsqybGGNQroddyCFo=;
	h=Date:To:From:Subject:From;
	b=DsnmC8BU3waSzuarzqiT0mdtsh4E9R3VzbjaXX1dB2oxYdsaIAVe2yr59+shDDlVH
	 Rjx2lwNA0z6nch9kJXmwHsp9OOQBspJxerZYpEIYzZrihUOUAGdXUxeh0VZmBmRNn6
	 gQwQonbw6TzB0apQufK2AHohuID9hTi0/zMkkxx4=
Date: Mon, 12 Feb 2024 15:28:38 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-implement-the-tracking-of-the-stacks-count.patch added to mm-unstable branch
Message-Id: <20240212232839.21E1FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,page_owner: implement the tracking of the stacks count
has been added to the -mm mm-unstable branch.  Its filename is
     mmpage_owner-implement-the-tracking-of-the-stacks-count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmpage_owner-implement-the-tracking-of-the-stacks-count.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm,page_owner: implement the tracking of the stacks count
Date: Mon, 12 Feb 2024 23:30:26 +0100

page_owner needs to increment a stack_record refcount when a new
allocation occurs, and decrement it on a free operation.  In order to do
that, we need to have a way to get a stack_record from a handle.

Implement __stack_depot_get_stack_record() which just does that, and make
it public so page_owner can use it.

Also implement {inc,dec}_stack_record_count() which increments or
decrements on respective allocation and free operations, via
__reset_page_owner() (free operation) and __set_page_owner() (alloc
operation).

Traversing all stackdepot buckets comes with its own complexity, plus we
would have to implement a way to mark only those stack_records that were
originated from page_owner, as those are the ones we are interested in.

For that reason, page_owner maintains its own list of stack_records,
because traversing that list is faster than traversing all buckets while
keeping at the same time a low complexity.  inc_stack_record_count() is
responsible of adding new stack_records into the list stack_list.

Modifications on the list are protected via a spinlock with irqs disabled,
since this code can also be reached from IRQ context.

Link: https://lkml.kernel.org/r/20240212223029.30769-3-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |    9 ++++
 lib/stackdepot.c           |    8 +++
 mm/page_owner.c            |   73 +++++++++++++++++++++++++++++++++++
 3 files changed, 90 insertions(+)

--- a/include/linux/stackdepot.h~mmpage_owner-implement-the-tracking-of-the-stacks-count
+++ a/include/linux/stackdepot.h
@@ -176,6 +176,15 @@ depot_stack_handle_t stack_depot_save(un
 				      unsigned int nr_entries, gfp_t gfp_flags);
 
 /**
+ * __stack_depot_get_stack_record - Get a pointer to a stack_record struct
+ * This function is only for internal purposes.
+ * @handle: Stack depot handle
+ *
+ * Return: Returns a pointer to a stack_record struct
+ */
+struct stack_record *__stack_depot_get_stack_record(depot_stack_handle_t handle);
+
+/**
  * stack_depot_fetch - Fetch a stack trace from stack depot
  *
  * @handle:	Stack depot handle returned from stack_depot_save()
--- a/lib/stackdepot.c~mmpage_owner-implement-the-tracking-of-the-stacks-count
+++ a/lib/stackdepot.c
@@ -685,6 +685,14 @@ depot_stack_handle_t stack_depot_save(un
 }
 EXPORT_SYMBOL_GPL(stack_depot_save);
 
+struct stack_record *__stack_depot_get_stack_record(depot_stack_handle_t handle)
+{
+	if (!handle)
+		return NULL;
+
+	return depot_fetch_stack(handle);
+}
+
 unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 			       unsigned long **entries)
 {
--- a/mm/page_owner.c~mmpage_owner-implement-the-tracking-of-the-stacks-count
+++ a/mm/page_owner.c
@@ -36,6 +36,14 @@ struct page_owner {
 	pid_t free_tgid;
 };
 
+struct stack {
+	struct stack_record *stack_record;
+	struct stack *next;
+};
+
+static struct stack *stack_list;
+static DEFINE_SPINLOCK(stack_list_lock);
+
 static bool page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
@@ -61,6 +69,57 @@ static __init bool need_page_owner(void)
 	return page_owner_enabled;
 }
 
+static void add_stack_record_to_list(struct stack_record *stack_record)
+{
+	unsigned long flags;
+	struct stack *stack;
+
+	stack = kmalloc(sizeof(*stack), GFP_KERNEL);
+	if (stack) {
+		stack->stack_record = stack_record;
+		stack->next = NULL;
+
+		spin_lock_irqsave(&stack_list_lock, flags);
+		if (!stack_list) {
+			stack_list = stack;
+		} else {
+			stack->next = stack_list;
+			stack_list = stack;
+		}
+		spin_unlock_irqrestore(&stack_list_lock, flags);
+	}
+}
+
+static void inc_stack_record_count(depot_stack_handle_t handle)
+{
+	struct stack_record *stack_record = __stack_depot_get_stack_record(handle);
+
+	if (stack_record) {
+		/*
+		 * New stack_record's that do not use STACK_DEPOT_FLAG_GET start
+		 * with REFCOUNT_SATURATED to catch spurious increments of their
+		 * refcount.
+		 * Since we do not use STACK_DEPOT_FLAG_{GET,PUT} API, let us
+		 * set a refcount of 1 ourselves.
+		 */
+		if (refcount_read(&stack_record->count) == REFCOUNT_SATURATED) {
+			refcount_set(&stack_record->count, 1);
+
+			/* Add the new stack_record to our list */
+			add_stack_record_to_list(stack_record);
+		}
+		refcount_inc(&stack_record->count);
+	}
+}
+
+static void dec_stack_record_count(depot_stack_handle_t handle)
+{
+	struct stack_record *stack_record = __stack_depot_get_stack_record(handle);
+
+	if (stack_record)
+		refcount_dec(&stack_record->count);
+}
+
 static __always_inline depot_stack_handle_t create_dummy_stack(void)
 {
 	unsigned long entries[4];
@@ -140,6 +199,7 @@ void __reset_page_owner(struct page *pag
 	int i;
 	struct page_ext *page_ext;
 	depot_stack_handle_t handle;
+	depot_stack_handle_t alloc_handle;
 	struct page_owner *page_owner;
 	u64 free_ts_nsec = local_clock();
 
@@ -147,6 +207,9 @@ void __reset_page_owner(struct page *pag
 	if (unlikely(!page_ext))
 		return;
 
+	page_owner = get_page_owner(page_ext);
+	alloc_handle = page_owner->handle;
+
 	handle = save_stack(GFP_NOWAIT | __GFP_NOWARN);
 	for (i = 0; i < (1 << order); i++) {
 		__clear_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
@@ -158,6 +221,15 @@ void __reset_page_owner(struct page *pag
 		page_ext = page_ext_next(page_ext);
 	}
 	page_ext_put(page_ext);
+	if (alloc_handle != early_handle)
+		/*
+		 * early_handle is being set as a handle for all those
+		 * early allocated pages. See init_pages_in_zone().
+		 * Since their refcount is not being incremented because
+		 * the machinery is not ready yet, we cannot decrement
+		 * their refcount either.
+		 */
+		dec_stack_record_count(alloc_handle);
 }
 
 static inline void __set_page_owner_handle(struct page_ext *page_ext,
@@ -199,6 +271,7 @@ noinline void __set_page_owner(struct pa
 		return;
 	__set_page_owner_handle(page_ext, handle, order, gfp_mask);
 	page_ext_put(page_ext);
+	inc_stack_record_count(handle);
 }
 
 void __set_page_owner_migrate_reason(struct page *page, int reason)
_

Patches currently in -mm which might be from osalvador@suse.de are

lib-stackdepot-move-stack_record-struct-definition-into-the-header.patch
mmpage_owner-implement-the-tracking-of-the-stacks-count.patch
mmpage_owner-display-all-stacks-and-their-count.patch
mmpage_owner-filter-out-stacks-by-a-threshold.patch
mmpage_owner-update-documentation-regarding-page_owner_stacks.patch

