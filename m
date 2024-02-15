Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48B714534A
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 23:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708040052; cv=none; b=saV20092xWlHkUYXl8U4ozRLVzuHJZsrFgc2ViDG80UXPctdAEUF9p32iGdNUKHRYp7BP2wF2NinI+BDdkR75IZniTdMYm3lgfnZEMNfrrVcvI6fbbgrVGf2kducmCIyXAwjmSkHxFgXl1Abc5dtYmQp4QTJ0PFhw6EFqNsipcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708040052; c=relaxed/simple;
	bh=R1WjClXccqRnpuiTncAftSN+A2eZ3WZLolwAo208mU4=;
	h=Date:To:From:Subject:Message-Id; b=adkKmMxSqkiU1d4L5bJWrk5RZa7jERQkRt4WdrzmhTczG2Gw+NcBBN4zwZfQZHmWVuM+EObWIAR/DUEC9r+zAVYTJQprlq78ApI4GN1hrypAOkEvwfqr4QtOvTE/WQZHVq887U8uSXqoYDJ1/OatvkNTDmCjcjqnU+TjvxhskXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LEvZ8Zfb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LEvZ8Zfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409ADC433C7;
	Thu, 15 Feb 2024 23:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708040052;
	bh=R1WjClXccqRnpuiTncAftSN+A2eZ3WZLolwAo208mU4=;
	h=Date:To:From:Subject:From;
	b=LEvZ8ZfbzOXXH0iYKTAREbhV0DnzildKGgWDtjAhrRfkoMwDZK/EXT4aydznTqpR0
	 nJWl0jWqF2GE7wYf+GvQS/hLbKNuW8NjwgQ+/2h6Ft0XGFDHAitL4Xt7GU5fY8crVL
	 RPp9TStEcb3hUVZfI6CRQtYywVVqhodWc5rszLgs=
Date: Thu, 15 Feb 2024 15:34:11 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-implement-the-tracking-of-the-stacks-count.patch added to mm-unstable branch
Message-Id: <20240215233412.409ADC433C7@smtp.kernel.org>
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
Date: Thu, 15 Feb 2024 22:59:04 +0100

Implement {inc,dec}_stack_record_count() which increments or decrements on
respective allocation and free operations, via __reset_page_owner() (free
operation) and __set_page_owner() (alloc operation).

Newly allocated stack_record structs will be added to the list stack_list
via add_stack_record_to_list().  Modifications on the list are protected
via a spinlock with irqs disabled, since this code can also be reached
from IRQ context.

Link: https://lkml.kernel.org/r/20240215215907.20121-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Marco Elver <elver@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   73 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

--- a/mm/page_owner.c~mmpage_owner-implement-the-tracking-of-the-stacks-count
+++ a/mm/page_owner.c
@@ -43,6 +43,7 @@ struct stack {
 static struct stack dummy_stack;
 static struct stack failure_stack;
 static struct stack *stack_list;
+static DEFINE_SPINLOCK(stack_list_lock);
 
 static bool page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
@@ -150,11 +151,68 @@ static noinline depot_stack_handle_t sav
 	return handle;
 }
 
+static void add_stack_record_to_list(struct stack_record *stack_record,
+				     gfp_t gfp_mask)
+{
+	unsigned long flags;
+	struct stack *stack;
+
+	/* Filter gfp_mask the same way stackdepot does, for consistency */
+	gfp_mask &= ~GFP_ZONEMASK;
+	gfp_mask &= (GFP_ATOMIC | GFP_KERNEL);
+	gfp_mask |= __GFP_NOWARN;
+
+	stack = kmalloc(sizeof(*stack), gfp_mask);
+	if (!stack)
+		return;
+
+	stack->stack_record = stack_record;
+	stack->next = NULL;
+
+	spin_lock_irqsave(&stack_list_lock, flags);
+	stack->next = stack_list;
+	stack_list = stack;
+	spin_unlock_irqrestore(&stack_list_lock, flags);
+}
+
+static void inc_stack_record_count(depot_stack_handle_t handle, gfp_t gfp_mask)
+{
+	struct stack_record *stack_record = __stack_depot_get_stack_record(handle);
+
+	if (!stack_record)
+		return;
+
+	/*
+	 * New stack_record's that do not use STACK_DEPOT_FLAG_GET start
+	 * with REFCOUNT_SATURATED to catch spurious increments of their
+	 * refcount.
+	 * Since we do not use STACK_DEPOT_FLAG_GET API, let us
+	 * set a refcount of 1 ourselves.
+	 */
+	if (refcount_read(&stack_record->count) == REFCOUNT_SATURATED) {
+		int old = REFCOUNT_SATURATED;
+
+		if (atomic_try_cmpxchg_relaxed(&stack_record->count.refs, &old, 1))
+			/* Add the new stack_record to our list */
+			add_stack_record_to_list(stack_record, gfp_mask);
+	}
+	refcount_inc(&stack_record->count);
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
 void __reset_page_owner(struct page *page, unsigned short order)
 {
 	int i;
 	struct page_ext *page_ext;
 	depot_stack_handle_t handle;
+	depot_stack_handle_t alloc_handle;
 	struct page_owner *page_owner;
 	u64 free_ts_nsec = local_clock();
 
@@ -162,17 +220,29 @@ void __reset_page_owner(struct page *pag
 	if (unlikely(!page_ext))
 		return;
 
+	page_owner = get_page_owner(page_ext);
+	alloc_handle = page_owner->handle;
+
 	handle = save_stack(GFP_NOWAIT | __GFP_NOWARN);
 	for (i = 0; i < (1 << order); i++) {
 		__clear_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
-		page_owner = get_page_owner(page_ext);
 		page_owner->free_handle = handle;
 		page_owner->free_ts_nsec = free_ts_nsec;
 		page_owner->free_pid = current->pid;
 		page_owner->free_tgid = current->tgid;
 		page_ext = page_ext_next(page_ext);
+		page_owner = get_page_owner(page_ext);
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
@@ -214,6 +284,7 @@ noinline void __set_page_owner(struct pa
 		return;
 	__set_page_owner_handle(page_ext, handle, order, gfp_mask);
 	page_ext_put(page_ext);
+	inc_stack_record_count(handle, gfp_mask);
 }
 
 void __set_page_owner_migrate_reason(struct page *page, int reason)
_

Patches currently in -mm which might be from osalvador@suse.de are

lib-stackdepot-fix-first-entry-having-a-0-handle.patch
lib-stackdepot-move-stack_record-struct-definition-into-the-header.patch
mmpage_owner-maintain-own-list-of-stack_records-structs.patch
mmpage_owner-implement-the-tracking-of-the-stacks-count.patch
mmpage_owner-display-all-stacks-and-their-count.patch
mmpage_owner-filter-out-stacks-by-a-threshold.patch
mmpage_owner-update-documentation-regarding-page_owner_stacks.patch

