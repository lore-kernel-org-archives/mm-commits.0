Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2D04688
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739362; cv=none; b=FDU+ANg4UaZ2od8KbbzW601bw9rlK7Q0AB9ba8oNGVrmFK9tpKMM8w/xbWlgnn4fYWAHeJRhi+xFFdTZ66blGwGys9oC/e00j39riVwOaPTFT7P5lH2JSYQreGkIVWtglvsNv5XXyp39LSUC93YJWyLhxV3hBahRcvk2ON51uks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739362; c=relaxed/simple;
	bh=bf+f7ECQdQKDOvilIdiTU+yIl6Y2zyy24Hu3RzkWES8=;
	h=Date:To:From:Subject:Message-Id; b=kwsnFkiDbWn5RnI92kazfm/2NqnDcVSUu9QhAgV8bUAZMz526afUuR4MqztYlQW1Rt1YrUcP3GdqxnnV/CYfu2BUYBDyY07NCs332wPq20/q9Xe5zwFLbG/iAPYsZCA0W2erINDJSepdU5aI04QDjs7L2ScoClf1ziPHcwjCwtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d2ZSFgyW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d2ZSFgyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49306C433C7;
	Sat, 24 Feb 2024 01:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739362;
	bh=bf+f7ECQdQKDOvilIdiTU+yIl6Y2zyy24Hu3RzkWES8=;
	h=Date:To:From:Subject:From;
	b=d2ZSFgyWmwFzkyemoqXA6lfiLNWlpbhsY9+kwKWYpF5fuYjKxuHJeFaLO4/YGtyJI
	 3wDvT/JuJzCyCU4G4gYaujX/DY5Pesuud3B0yA+WpH+HA/Ge5Cp3zzPrihxr4E4lvE
	 bn0zRfuIgsIzP6arcjvSxv9mXWKCjeMDy22D1SjE=
Date: Fri, 23 Feb 2024 17:49:21 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mmpage_owner-display-all-stacks-and-their-count.patch removed from -mm tree
Message-Id: <20240224014922.49306C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,page_owner: display all stacks and their count
has been removed from the -mm tree.  Its filename was
     mmpage_owner-display-all-stacks-and-their-count.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,page_owner: display all stacks and their count
Date: Thu, 15 Feb 2024 22:59:05 +0100

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

Link: https://lkml.kernel.org/r/20240215215907.20121-6-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   93 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 92 insertions(+), 1 deletion(-)

--- a/mm/page_owner.c~mmpage_owner-display-all-stacks-and-their-count
+++ a/mm/page_owner.c
@@ -171,7 +171,13 @@ static void add_stack_record_to_list(str
 
 	spin_lock_irqsave(&stack_list_lock, flags);
 	stack->next = stack_list;
-	stack_list = stack;
+	/*
+	 * This pairs with smp_load_acquire() from function
+	 * stack_start(). This guarantees that stack_start()
+	 * will see an updated stack_list before starting to
+	 * traverse the list.
+	 */
+	smp_store_release(&stack_list, stack);
 	spin_unlock_irqrestore(&stack_list_lock, flags);
 }
 
@@ -805,8 +811,90 @@ static const struct file_operations proc
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
+	int i, stack_count;
+	struct stack *stack = v;
+	unsigned long *entries;
+	unsigned long nr_entries;
+	struct stack_record *stack_record = stack->stack_record;
+
+	nr_entries = stack_record->size;
+	entries = stack_record->entries;
+	stack_count = refcount_read(&stack_record->count) - 1;
+
+	if (!nr_entries || nr_entries < 0 || stack_count < 1)
+		return 0;
+
+	for (i = 0; i < nr_entries; i++)
+		seq_printf(m, " %pS\n", (void *)entries[i]);
+	seq_printf(m, "stack_count: %d\n\n", stack_count);
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
@@ -814,6 +902,9 @@ static int __init pageowner_init(void)
 
 	debugfs_create_file("page_owner", 0400, NULL, NULL,
 			    &proc_page_owner_operations);
+	dir = debugfs_create_dir("page_owner_stacks", NULL);
+	debugfs_create_file("show_stacks", 0400, dir, NULL,
+			    &page_owner_stack_operations);
 
 	return 0;
 }
_

Patches currently in -mm which might be from osalvador@suse.de are


