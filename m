Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 347FE4F888
	for <mm-commits@vger.kernel.org>; Mon, 12 Feb 2024 23:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707780522; cv=none; b=nlUQr0Fg9DWT1gAdL/i0b43oyPVnW4O8BqIxkwxXDgD0JHPokfL3T2U0RBDBuiHhiPJw53ShfwH7yQEQMUk0AcQF2dDKgLikuCA/vh2OnqSQ6IdCWc2TKmul5vD1zWYS+Q07lDubAXFGL0JPauhrMj1CCLSMJvSbd2/Fjr4DuzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707780522; c=relaxed/simple;
	bh=1P9ykQ1FxVHufaRwCzbdEqEO+7F0DXHiY/3I8jD5/xs=;
	h=Date:To:From:Subject:Message-Id; b=kBzn8WORlGudJlkVsvH9eKkz0yLzMHU4QUWI1DITh+CIZ8i24mrkDcqQ/0CMrUeQAuJPndaJIqmbnwA5QZKM3Mk3cmxJBSWPz0TtI0zYgsGTixaZ9A/VjdFk/mQrvufIKLptiZ89GgURuJiteXk6V+82a5CXzW4IhUDsOv75lEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t57I0BUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t57I0BUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1202C433F1;
	Mon, 12 Feb 2024 23:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707780521;
	bh=1P9ykQ1FxVHufaRwCzbdEqEO+7F0DXHiY/3I8jD5/xs=;
	h=Date:To:From:Subject:From;
	b=t57I0BUCa7CUcHn+8tdQ7wxLjez8YRgCdxL/niWEtEJtea0LOdkV7ZBYkAeRz6Hll
	 MJA66wVKGHE2bpg9PZFJfhnvl/RFcq3wy0183hwJKhgMxF6Pa3xOMxmjpqHnEaK1YX
	 K/9jK9DlqQfRPXcbbdEvZPQ+I7QKcQYOSm7W2JsM=
Date: Mon, 12 Feb 2024 15:28:41 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-display-all-stacks-and-their-count.patch added to mm-unstable branch
Message-Id: <20240212232841.A1202C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,page_owner: display all stacks and their count
has been added to the -mm mm-unstable branch.  Its filename is
     mmpage_owner-display-all-stacks-and-their-count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmpage_owner-display-all-stacks-and-their-count.patch

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
Subject: mm,page_owner: display all stacks and their count
Date: Mon, 12 Feb 2024 23:30:27 +0100

This patch adds a new directory called 'page_owner_stacks' under
/sys/kernel/debug/, with a file called 'show_stacks' in it.  Reading from
that file will show all stacks that were added by page_owner followed by
their counting, giving us a clear overview of stack <-> count
relationship.

E.g:

  prep_new_page+0xa9/0x120
  get_page_from_freelist+0x801/0x2210
  __alloc_pages+0x18b/0x350
  alloc_pages_mpol+0x91/0x1f0
  folio_alloc+0x14/0x50
  filemap_alloc_folio+0xb2/0x100
  __filemap_get_folio+0x14a/0x490
  ext4_write_begin+0xbd/0x4b0 [ext4]
  generic_perform_write+0xc1/0x1e0
  ext4_buffered_write_iter+0x68/0xe0 [ext4]
  ext4_file_write_iter+0x70/0x740 [ext4]
  vfs_write+0x33d/0x420
  ksys_write+0xa5/0xe0
  do_syscall_64+0x80/0x160
  entry_SYSCALL_64_after_hwframe+0x6e/0x76
 stack_count: 4578

The seq stack_{start,next} functions will iterate through the list
stack_list in order to print all stacks.

Link: https://lkml.kernel.org/r/20240212223029.30769-4-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   99 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 98 insertions(+), 1 deletion(-)

--- a/mm/page_owner.c~mmpage_owner-display-all-stacks-and-their-count
+++ a/mm/page_owner.c
@@ -84,7 +84,12 @@ static void add_stack_record_to_list(str
 			stack_list = stack;
 		} else {
 			stack->next = stack_list;
-			stack_list = stack;
+			/* This pairs with smp_load_acquire() from function
+			 * stack_start(). This guarantees that stack_start()
+			 * will see an updated stack_list before starting to
+			 * traverse the list.
+			 */
+			smp_store_release(&stack_list, stack);
 		}
 		spin_unlock_irqrestore(&stack_list_lock, flags);
 	}
@@ -792,8 +797,97 @@ static const struct file_operations proc
 	.llseek		= lseek_page_owner,
 };
 
+static void *stack_start(struct seq_file *m, loff_t *ppos)
+{
+	struct stack *stack;
+
+	if (*ppos == -1UL)
+		return NULL;
+
+	if (!*ppos) {
+		/*
+		 * This pairs with smp_store_release() from function
+		 * add_stack_record_to_list(), so we get a consistent
+		 * value of stack_list.
+		 */
+		stack = smp_load_acquire(&stack_list);
+	} else {
+		stack = m->private;
+		stack = stack->next;
+	}
+
+	m->private = stack;
+
+	return stack;
+}
+
+static void *stack_next(struct seq_file *m, void *v, loff_t *ppos)
+{
+	struct stack *stack = v;
+
+	stack = stack->next;
+	*ppos = stack ? *ppos + 1 : -1UL;
+	m->private = stack;
+
+	return stack;
+}
+
+static int stack_print(struct seq_file *m, void *v)
+{
+	char *buf;
+	int ret = 0;
+	struct stack *stack = v;
+	struct stack_record *stack_record = stack->stack_record;
+
+	if (!stack_record->size || stack_record->size < 0 ||
+	    refcount_read(&stack_record->count) < 2)
+		return 0;
+
+	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+
+	ret += stack_trace_snprint(buf, PAGE_SIZE, stack_record->entries,
+				   stack_record->size, 0);
+	if (!ret)
+		goto out;
+
+	scnprintf(buf + ret, PAGE_SIZE - ret, "stack_count: %d\n\n",
+		  refcount_read(&stack_record->count));
+
+	seq_printf(m, buf);
+	seq_puts(m, "\n\n");
+out:
+	kfree(buf);
+
+	return 0;
+}
+
+static void stack_stop(struct seq_file *m, void *v)
+{
+}
+
+static const struct seq_operations page_owner_stack_op = {
+	.start	= stack_start,
+	.next	= stack_next,
+	.stop	= stack_stop,
+	.show	= stack_print
+};
+
+static int page_owner_stack_open(struct inode *inode, struct file *file)
+{
+	return seq_open_private(file, &page_owner_stack_op, 0);
+}
+
+static const struct file_operations page_owner_stack_operations = {
+	.open		= page_owner_stack_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static int __init pageowner_init(void)
 {
+	struct dentry *dir;
+
 	if (!static_branch_unlikely(&page_owner_inited)) {
 		pr_info("page_owner is disabled\n");
 		return 0;
@@ -801,6 +895,9 @@ static int __init pageowner_init(void)
 
 	debugfs_create_file("page_owner", 0400, NULL, NULL,
 			    &proc_page_owner_operations);
+	dir = debugfs_create_dir("page_owner_stacks", NULL);
+	debugfs_create_file("show_stacks", 0400, dir, NULL,
+			    &page_owner_stack_operations);
 
 	return 0;
 }
_

Patches currently in -mm which might be from osalvador@suse.de are

lib-stackdepot-move-stack_record-struct-definition-into-the-header.patch
mmpage_owner-implement-the-tracking-of-the-stacks-count.patch
mmpage_owner-display-all-stacks-and-their-count.patch
mmpage_owner-filter-out-stacks-by-a-threshold.patch
mmpage_owner-update-documentation-regarding-page_owner_stacks.patch

