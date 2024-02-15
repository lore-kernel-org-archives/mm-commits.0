Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D78F141995
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 23:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708040051; cv=none; b=txXrlIa5tVsJU/5HbomUevkgRJBMwatjVrMSpeOAvIMG3mNAlK4O0hVblwe93wKX5K/cvKEu5sGXzfpJIICF8DjkQspwClPuw1TZitpK2SbNjBbQhwaNqaboRVAHmoNLP0JlQGrXW6r4/syxbWVj8wuQC2VjBwTLMvzZmWZjcEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708040051; c=relaxed/simple;
	bh=GnLPwH/A/E4bgWSH3c2DWxuewhD2Wo5+L/fHr0hmVE8=;
	h=Date:To:From:Subject:Message-Id; b=jbRkgCyANc/7wQkkGc7Mc4AtJBWFFSA1dhUVQhGZCQoqimgCOfBNb+GyFuECLUjjGhuvNs8NloR7hmo96snAPyhBpB79lmiPJqQ1v0ITCKK73Z9dhIOvS6vT7e9eb8EohaDEjoFC4V67lebiRDO4M+fWdey0QKzJlDwVh8WMSo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hIQTpYaZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hIQTpYaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D501AC433C7;
	Thu, 15 Feb 2024 23:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708040050;
	bh=GnLPwH/A/E4bgWSH3c2DWxuewhD2Wo5+L/fHr0hmVE8=;
	h=Date:To:From:Subject:From;
	b=hIQTpYaZ3VYjhJVn/L1rhwRbO5dils5EAJ464JRuO/g4SOgXmjENdQbXGvfovvRug
	 MOzbcBBV8icwA7XQY/Dg2ysDmucgRo3N5gHmDT4B0gi9Zcd5QprxeNs2YpvSBZccX1
	 CKNYjjqKHF8C3ZC52izEcDByks5PwQsNICRe/jE8=
Date: Thu, 15 Feb 2024 15:34:10 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-maintain-own-list-of-stack_records-structs.patch added to mm-unstable branch
Message-Id: <20240215233410.D501AC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,page_owner: maintain own list of stack_records structs
has been added to the -mm mm-unstable branch.  Its filename is
     mmpage_owner-maintain-own-list-of-stack_records-structs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmpage_owner-maintain-own-list-of-stack_records-structs.patch

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
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
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

lib-stackdepot-fix-first-entry-having-a-0-handle.patch
lib-stackdepot-move-stack_record-struct-definition-into-the-header.patch
mmpage_owner-maintain-own-list-of-stack_records-structs.patch
mmpage_owner-implement-the-tracking-of-the-stacks-count.patch
mmpage_owner-display-all-stacks-and-their-count.patch
mmpage_owner-filter-out-stacks-by-a-threshold.patch
mmpage_owner-update-documentation-regarding-page_owner_stacks.patch

