Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC97212548
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343108; cv=none; b=rsscxk/9lY3Aljqg6UQlrVyu8xXHCkDCAjksYEZTXZV123KATV8887koFCfeWhWyC8D/ZOMSO0J5CQaeQhYMBjyazfRaQaeU7F2TykT3b7plDrwkH5h/gs8dHPKgSXJXNgyYoMjBvZwbWCHPbpujlk2t66rjNU2sxzuxS7e1xPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343108; c=relaxed/simple;
	bh=UT/90H6i0KpV7kL4d4NGNqFNmTNWPWMhwQiRX7IQGIg=;
	h=Date:To:From:Subject:Message-Id; b=cLF5o8xSWg8ZhHpC/x/aK266BtpNgQGKB5Gg+C+CxI8+0vDvnnwOCJgz4YJzNybE8RDzEfR2LbTmtWtZ7RNPSV3225Ornr7yN0G0NGkuyyPHiqckH7tcYZOLXpWNEWZF5kwX64ziCmoDI+8qv55L475nf/IiblPpGqZiN8G193o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i48QwT8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i48QwT8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6384EC4CEF5;
	Mon, 17 Nov 2025 01:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343108;
	bh=UT/90H6i0KpV7kL4d4NGNqFNmTNWPWMhwQiRX7IQGIg=;
	h=Date:To:From:Subject:From;
	b=i48QwT8+TjEpG2YAYr6Q+pKitIZYqbT1exPRUDxPLk/QFM+mMvVp8/6DE8syiCjq+
	 i3SNoYhR0MO8yjyaRQLQ92j8d87gwyRLsssQgJCUuArgVSdqNyyZXOtcNJ6/+PkKn3
	 6mjz1jqUL4EZ3eXsfjOry1Yq/M0V0AlD0DAk4FBs=
Date: Sun, 16 Nov 2025 17:31:47 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,osalvador@suse.de,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,mfo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-add-struct-stack_print_ctxflags.patch removed from -mm tree
Message-Id: <20251117013148.6384EC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: add struct stack_print_ctx.flags
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-struct-stack_print_ctxflags.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mauricio Faria de Oliveira <mfo@igalia.com>
Subject: mm/page_owner: add struct stack_print_ctx.flags
Date: Wed, 1 Oct 2025 14:56:08 -0300

Add the flags field to stack_print_ctx, and define two flags for current
behavior (printing stack traces and their number of base pages).

The plumbing of flags is debugfs_create_file(data) -> inode.i_private ->
page_owner_stack_open() -> stack_print_ctx.flags -> stack_print().

No behavior change intended.

Link: https://lkml.kernel.org/r/20251001175611.575861-3-mfo@igalia.com
Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-add-struct-stack_print_ctxflags
+++ a/mm/page_owner.c
@@ -45,8 +45,12 @@ static struct stack failure_stack;
 static struct stack *stack_list;
 static DEFINE_SPINLOCK(stack_list_lock);
 
+#define STACK_PRINT_FLAG_STACK		0x1
+#define STACK_PRINT_FLAG_PAGES		0x2
+
 struct stack_print_ctx {
 	struct stack *stack;
+	u8 flags;
 };
 
 static bool page_owner_enabled __initdata;
@@ -904,20 +908,24 @@ static int stack_print(struct seq_file *
 	unsigned long *entries;
 	unsigned long nr_entries;
 	struct stack_record *stack_record = stack->stack_record;
+	struct stack_print_ctx *ctx = m->private;
 
 	if (!stack->stack_record)
 		return 0;
 
-	nr_entries = stack_record->size;
-	entries = stack_record->entries;
 	nr_base_pages = refcount_read(&stack_record->count) - 1;
 
 	if (nr_base_pages < 1 || nr_base_pages < page_owner_pages_threshold)
 		return 0;
 
-	for (i = 0; i < nr_entries; i++)
-		seq_printf(m, " %pS\n", (void *)entries[i]);
-	seq_printf(m, "nr_base_pages: %d\n\n", nr_base_pages);
+	if (ctx->flags & STACK_PRINT_FLAG_STACK) {
+		nr_entries = stack_record->size;
+		entries = stack_record->entries;
+		for (i = 0; i < nr_entries; i++)
+			seq_printf(m, " %pS\n", (void *)entries[i]);
+	}
+	if (ctx->flags & STACK_PRINT_FLAG_PAGES)
+		seq_printf(m, "nr_base_pages: %d\n\n", nr_base_pages);
 
 	return 0;
 }
@@ -938,6 +946,13 @@ static int page_owner_stack_open(struct
 	int ret = seq_open_private(file, &page_owner_stack_op,
 				   sizeof(struct stack_print_ctx));
 
+	if (!ret) {
+		struct seq_file *m = file->private_data;
+		struct stack_print_ctx *ctx = m->private;
+
+		ctx->flags = (uintptr_t) inode->i_private;
+	}
+
 	return ret;
 }
 
@@ -976,7 +991,9 @@ static int __init pageowner_init(void)
 	debugfs_create_file("page_owner", 0400, NULL, NULL,
 			    &proc_page_owner_operations);
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
-	debugfs_create_file("show_stacks", 0400, dir, NULL,
+	debugfs_create_file("show_stacks", 0400, dir,
+			    (void *)(STACK_PRINT_FLAG_STACK |
+				     STACK_PRINT_FLAG_PAGES),
 			    &page_owner_stack_operations);
 	debugfs_create_file("count_threshold", 0600, dir, NULL,
 			    &proc_page_owner_threshold);
_

Patches currently in -mm which might be from mfo@igalia.com are


