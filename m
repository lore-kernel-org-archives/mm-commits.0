Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751CD34BA3C
	for <mm-commits@vger.kernel.org>; Thu,  9 Oct 2025 02:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759977188; cv=none; b=Z0OcrAR3EzGMmkhutOCGJNCz3+Q6gjiFrPafOWekMPxLsVpZDQALFuLn92114SZ+Zgz918TfptuRpfXVoazghNDH3iPHJknO2PYj4iNaTqdA/1ASwkslP88Pp+tS59FB58ob2JVTVKZSC0lb29HQ0FcVAsRJy07tSjBAJB1IIhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759977188; c=relaxed/simple;
	bh=i7n1um+pvs3K/Kt0mGnTScMZmGtkTC7apMmYCtIvcEY=;
	h=Date:To:From:Subject:Message-Id; b=FHdYFMvIIyvyB8Jbtzz5JRiysvjfEUXs8YfjP7rEJBjuu6vHGKZOd200Zv9LFJX/5l3p6vBezfdUFFULfpAj+2Ad0XvLeOweAHPg7QdLW7xaHtkVIfFLsoE2ES7CGPbq+aETMhUSkMwmVBLoxBz8eXdKMukSybtGdRBovyCvh2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VY64K7cp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VY64K7cp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF213C4CEF5;
	Thu,  9 Oct 2025 02:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759977187;
	bh=i7n1um+pvs3K/Kt0mGnTScMZmGtkTC7apMmYCtIvcEY=;
	h=Date:To:From:Subject:From;
	b=VY64K7cpgoTlbLwsdQSj/vlQxM2b3OPmHX2vwafkQmp3ZKfA/uw5NIDVp1JHV9SQV
	 t3q0ea0sFcBWVzmfmM5OC46aFFeDIg/HtP+HcL3LxQ8Yo961zQlkwIvGH3jdde3Q8U
	 I7hkGu39+f/U8JKnvFIPmoLd4y2IbHXTF1eb/pTY=
Date: Wed, 08 Oct 2025 19:33:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,osalvador@suse.de,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,mfo@igalia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-struct-stack_print_ctxflags.patch added to mm-new branch
Message-Id: <20251009023306.DF213C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: add struct stack_print_ctx.flags
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-add-struct-stack_print_ctxflags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-struct-stack_print_ctxflags.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
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
@@ -901,20 +905,24 @@ static int stack_print(struct seq_file *
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
@@ -935,6 +943,13 @@ static int page_owner_stack_open(struct
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
 
@@ -973,7 +988,9 @@ static int __init pageowner_init(void)
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

mm-page_owner-introduce-struct-stack_print_ctx.patch
mm-page_owner-add-struct-stack_print_ctxflags.patch
mm-page_owner-add-debugfs-file-show_handles.patch
mm-page_owner-add-debugfs-file-show_stacks_handles.patch
mm-page_owner-update-documentation-with-show_handles-and-show_stacks_handles.patch

