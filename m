Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01F94688
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739360; cv=none; b=Se5/+3+FZBL2SSGYm9dHQpeP0V760LnYIEHbWT8O/rEgE45bLCAC1DmMTB/YRpBksUW51lYxLejuvAZqMweoQwiL8Fo2uhcFnHORNtoxaSEq36tW9l2eZs90Pv0rtVCjSj1IHMVCRvr1iTynMaojYzrt8p8P3oM4a/p7+7ZbTDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739360; c=relaxed/simple;
	bh=+ngNMiBfCNDJfCM/rIavgtrPS8cwgV5t+prj4YAfoHs=;
	h=Date:To:From:Subject:Message-Id; b=J+V9KVZYKn0HFlKUAmZW0D7p2/AkRtBGZIj0C336KsxCsnK1Wguc/vhiLeWTdpi5tGtDWpiwLVEyFZtYpxCNTF7H9Ddh2ZQ3J96YZINLbXdxKBwNTpfcUspTGM8YylqqS74uSntM7gkAE4y3gHQ5DyiEDTL/979y+PvxZk7Loi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YJv8KEKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YJv8KEKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF426C433C7;
	Sat, 24 Feb 2024 01:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739359;
	bh=+ngNMiBfCNDJfCM/rIavgtrPS8cwgV5t+prj4YAfoHs=;
	h=Date:To:From:Subject:From;
	b=YJv8KEKAWSYr7sP/QmUCsGlIoTy7q8Z5T0bkF/qZh5GYtwTvJlQvoKo3A1PNgKwnj
	 0Q1j5K/5YA05ZIYFkjnVAXO07YTkpH/sg1y9fTu00ZOXUWgWuh4JphNwlAeq5x2eJf
	 NJxInFvGDsvWPlzmA6EgsJFTJqaNMH6ciB9rEiAI=
Date: Fri, 23 Feb 2024 17:49:19 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmpage_owner-maintain-own-list-of-stack_records-structs.patch removed from -mm tree
Message-Id: <20240224014919.AF426C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,page_owner: maintain own list of stack_records structs
has been removed from the -mm tree.  Its filename was
     mmpage_owner-maintain-own-list-of-stack_records-structs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_owner: maintain own list of stack_records structs
Date: Thu, 15 Feb 2024 22:59:03 +0100

page_owner needs to increment a stack_record refcount when a new
allocation occurs, and decrement it on a free operation.  In order to do
that, we need to have a way to get a stack_record from a handle. 
Implement __stack_depot_get_stack_record() which just does that, and make
it public so page_owner can use it.

Also, traversing all stackdepot buckets comes with its own complexity,
plus we would have to implement a way to mark only those stack_records
that were originated from page_owner, as those are the ones we are
interested in.  For that reason, page_owner maintains its own list of
stack_records, because traversing that list is faster than traversing all
buckets while keeping at the same time a low complexity.

For now, add to stack_list only the stack_records of dummy_handle and
failure_handle, and set their refcount of 1.

Further patches will add code to increment or decrement stack_records
count on allocation and free operation.

Link: https://lkml.kernel.org/r/20240215215907.20121-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Marco Elver <elver@google.com>
Acked-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/stackdepot.h |   11 +++++++++++
 lib/stackdepot.c           |    8 ++++++++
 mm/page_owner.c            |   15 +++++++++++++++
 3 files changed, 34 insertions(+)

--- a/include/linux/stackdepot.h~mmpage_owner-maintain-own-list-of-stack_records-structs
+++ a/include/linux/stackdepot.h
@@ -179,6 +179,17 @@ depot_stack_handle_t stack_depot_save(un
 				      unsigned int nr_entries, gfp_t gfp_flags);
 
 /**
+ * __stack_depot_get_stack_record - Get a pointer to a stack_record struct
+ *
+ * @handle: Stack depot handle
+ *
+ * This function is only for internal purposes.
+ *
+ * Return: Returns a pointer to a stack_record struct
+ */
+struct stack_record *__stack_depot_get_stack_record(depot_stack_handle_t handle);
+
+/**
  * stack_depot_fetch - Fetch a stack trace from stack depot
  *
  * @handle:	Stack depot handle returned from stack_depot_save()
--- a/lib/stackdepot.c~mmpage_owner-maintain-own-list-of-stack_records-structs
+++ a/lib/stackdepot.c
@@ -687,6 +687,14 @@ depot_stack_handle_t stack_depot_save(un
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
--- a/mm/page_owner.c~mmpage_owner-maintain-own-list-of-stack_records-structs
+++ a/mm/page_owner.c
@@ -36,6 +36,14 @@ struct page_owner {
 	pid_t free_tgid;
 };
 
+struct stack {
+	struct stack_record *stack_record;
+	struct stack *next;
+};
+static struct stack dummy_stack;
+static struct stack failure_stack;
+static struct stack *stack_list;
+
 static bool page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
@@ -95,6 +103,13 @@ static __init void init_page_owner(void)
 	register_early_stack();
 	static_branch_enable(&page_owner_inited);
 	init_early_allocated_pages();
+	/* Initialize dummy and failure stacks and link them to stack_list */
+	dummy_stack.stack_record = __stack_depot_get_stack_record(dummy_handle);
+	failure_stack.stack_record = __stack_depot_get_stack_record(failure_handle);
+	refcount_set(&dummy_stack.stack_record->count, 1);
+	refcount_set(&failure_stack.stack_record->count, 1);
+	dummy_stack.next = &failure_stack;
+	stack_list = &dummy_stack;
 }
 
 struct page_ext_operations page_owner_ops = {
_

Patches currently in -mm which might be from osalvador@suse.de are


