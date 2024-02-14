Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6400F134740
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 18:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707935559; cv=none; b=mv0v7aAxJ+ElxLlfBPtaE2qQE8SVmbntEkVlbo5nngC6Bk1i+423oYiG4e85bB2KyFr4c08YalYxoDzATdIEjecB4SJYzm+2WDc+YvDVED2XrkeXiFwJwthny813LdDzR6eQEzMrRSKn0o6XXWuUdzBUZjiOslsqvyyAg58jJtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707935559; c=relaxed/simple;
	bh=4KoXj7rsN00p0x8KYmB/Z6mcrJ1bcgVbEQfnXzUiyy4=;
	h=Date:To:From:Subject:Message-Id; b=pZMyrue2PXPc3ptAr37WkWRJoNWlbXUPgUKCsvSz+5ad13xvJrhkPro2VcWnQfvVYi9qkKpync1KaOIKKj0elqeyzO4725ztG4dH8f2K3cybCMkNPjq6atZ4d4LI/T9tZaVQFi6+z5+9Jd0sJYTTlXduX1jdtjezEQdxaklSoyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uceqtEp9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uceqtEp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2CABC433F1;
	Wed, 14 Feb 2024 18:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707935558;
	bh=4KoXj7rsN00p0x8KYmB/Z6mcrJ1bcgVbEQfnXzUiyy4=;
	h=Date:To:From:Subject:From;
	b=uceqtEp9Rc3GLKqai5L5TCbNdahrmrLIXLzbhc+NtjXZF+IauyBDxRaAuYMjNeW2G
	 SNYjs37NYR4LqnbXilzZPx8F9UqVAhg6toKMjOwzjBpMr47/1diFZfh1K9aLlCvvFY
	 b11VX491DjtYC9+Ju82AjxLTQlJly6RDw4ZupJjM=
Date: Wed, 14 Feb 2024 10:32:38 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,mhocko@suse.com,glider@google.com,elver@google.com,andreyknvl@gmail.com,osalvador@suse.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmpage_owner-display-all-stacks-and-their-count.patch added to mm-unstable branch
Message-Id: <20240214183238.C2CABC433F1@smtp.kernel.org>
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
Date: Wed, 14 Feb 2024 18:01:55 +0100

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

Link: https://lkml.kernel.org/r/20240214170157.17530-6-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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
+	int i;
+	struct stack *stack = v;
+	unsigned long *entries;
+	unsigned long nr_entries;
+	struct stack_record *stack_record = stack->stack_record;
+
+	nr_entries = stack_record->size;
+	entries = stack_record->entries;
+
+	if (!nr_entries || nr_entries < 0 ||
+	    refcount_read(&stack_record->count) < 2)
+		return 0;
+
+	for (i = 0; i < nr_entries; i++)
+		seq_printf(m, " %pS\n", (void *)entries[i]);
+	seq_printf(m, "stack_count: %d\n\n", refcount_read(&stack_record->count));
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

lib-stackdepot-fix-first-entry-having-a-0-handle.patch
lib-stackdepot-move-stack_record-struct-definition-into-the-header.patch
mmpage_owner-maintain-own-list-of-stack_records-structs.patch
mmpage_owner-implement-the-tracking-of-the-stacks-count.patch
mmpage_owner-display-all-stacks-and-their-count.patch
mmpage_owner-filter-out-stacks-by-a-threshold.patch
mmpage_owner-update-documentation-regarding-page_owner_stacks.patch

