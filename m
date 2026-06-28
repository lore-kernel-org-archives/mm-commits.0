Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A17A1F872D
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 02:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782613900; cv=none; b=Fnv3XYlM9yyKyUMPVGrzztQowUbualp73wYfUc2CD1jmgmRGrlmrb0wmxLqG7xuvvjVjlDq0I87ZVAPkIOHG3to2g9rtGkTWPeN8sEw9bo9+emV8JcH3BwcGZLWHJzcFsCb+Yxhcq8ROXthc+PhUGqzmMVxJATQN+KVGzjMwR4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782613900; c=relaxed/simple;
	bh=LYOU1d0ObXAjg2/4SdjoJesiCQmT6w0O3Hw36WyEZIU=;
	h=Date:To:From:Subject:Message-Id; b=BTp5NR3egsF/CPsnKJexZ3dI/CgfPWoOg8mgzDvEwKsR13R5zCPeQhsA0aO2Fo9vQm8lboyul/8A1ru7/v+ppX2hmdcs/IeiHUzIDsEf2dcz4WmG8g9XiceFjdS2BdkKxaDe/CrtUVPwQ0FtxuByD7le8aw+c4nLK6chQzJyxYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ux/2cN2y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ux/2cN2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016F81F00A3A;
	Sun, 28 Jun 2026 02:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782613899;
	bh=54ar8OngMpU40GEdRirqDYk2eKncyoKCXR+Fc2T0qaQ=;
	h=Date:To:From:Subject;
	b=Ux/2cN2yQ79OyMHOVkswkmPG72qyDRu9LoIFK3EHBn7ik0YxC78XTh3bh2ZdXOiiZ
	 NOiD1xm2o867VHfkt1I6RivtXjEKKCIXU8Ao3U8bPowiAAhctwrP8w0hBPZ7tkuLd3
	 qiFUyJ5AoWvP18Jvo5551Yvm+4/YDRA3P9RxYuek=
Date: Sat, 27 Jun 2026 19:31:38 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch removed from -mm tree
Message-Id: <20260628023139.016F81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: drop redundant page_owner prefix from static symbols
has been removed from the -mm tree.  Its filename was
     mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: drop redundant page_owner prefix from static symbols
Date: Tue, 23 Jun 2026 14:52:31 +0800

All of these symbols are file-scoped (static) in page_owner.c, so the
page_owner_ prefix is pure noise.  Rename them to shorter, still-clear
names:

  page_owner_stack_op      -> stack_op
  page_owner_stack_open    -> stack_open
  page_owner_stack_fops    -> stack_fops
  page_owner_pages_threshold -> pages_threshold
  page_owner_threshold_get -> threshold_get
  page_owner_threshold_set -> threshold_set
  page_owner_threshold_fops -> threshold_fops

No functional change.

Link: https://lore.kernel.org/20260623065234.31866-7-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols
+++ a/mm/page_owner.c
@@ -901,7 +901,7 @@ static void *stack_next(struct seq_file
 	return stack;
 }
 
-static unsigned long page_owner_pages_threshold;
+static unsigned long pages_threshold;
 
 static int stack_print(struct seq_file *m, void *v)
 {
@@ -918,7 +918,7 @@ static int stack_print(struct seq_file *
 	nr_base_pages = refcount_read(&stack_record->count) - 1;
 
 	if (ctx->flags & STACK_PRINT_FLAG_PAGES &&
-	    (nr_base_pages < 1 || nr_base_pages < page_owner_pages_threshold))
+	    (nr_base_pages < 1 || nr_base_pages < pages_threshold))
 		return 0;
 
 	if (ctx->flags & STACK_PRINT_FLAG_STACK) {
@@ -940,16 +940,16 @@ static void stack_stop(struct seq_file *
 {
 }
 
-static const struct seq_operations page_owner_stack_op = {
+static const struct seq_operations stack_op = {
 	.start	= stack_start,
 	.next	= stack_next,
 	.stop	= stack_stop,
 	.show	= stack_print
 };
 
-static int page_owner_stack_open(struct inode *inode, struct file *file)
+static int stack_open(struct inode *inode, struct file *file)
 {
-	int ret = seq_open_private(file, &page_owner_stack_op,
+	int ret = seq_open_private(file, &stack_op,
 				   sizeof(struct stack_print_ctx));
 
 	if (!ret) {
@@ -962,28 +962,27 @@ static int page_owner_stack_open(struct
 	return ret;
 }
 
-static const struct file_operations page_owner_stack_fops = {
-	.open		= page_owner_stack_open,
+static const struct file_operations stack_fops = {
+	.open		= stack_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= seq_release_private,
 };
 
-static int page_owner_threshold_get(void *data, u64 *val)
+static int threshold_get(void *data, u64 *val)
 {
-	*val = READ_ONCE(page_owner_pages_threshold);
+	*val = READ_ONCE(pages_threshold);
 	return 0;
 }
 
-static int page_owner_threshold_set(void *data, u64 val)
+static int threshold_set(void *data, u64 val)
 {
-	WRITE_ONCE(page_owner_pages_threshold, val);
+	WRITE_ONCE(pages_threshold, val);
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
-			&page_owner_threshold_set, "%llu\n");
-
+DEFINE_SIMPLE_ATTRIBUTE(threshold_fops, &threshold_get,
+			&threshold_set, "%llu\n");
 
 static int __init pageowner_init(void)
 {
@@ -999,17 +998,17 @@ static int __init pageowner_init(void)
 	debugfs_create_file("show_stacks", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_STACK |
 				     STACK_PRINT_FLAG_PAGES),
-			     &page_owner_stack_fops);
+			     &stack_fops);
 	debugfs_create_file("show_handles", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_HANDLE |
 				     STACK_PRINT_FLAG_PAGES),
-			    &page_owner_stack_fops);
+			    &stack_fops);
 	debugfs_create_file("show_stacks_handles", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_STACK |
 				     STACK_PRINT_FLAG_HANDLE),
-			    &page_owner_stack_fops);
+			    &stack_fops);
 	debugfs_create_file("count_threshold", 0600, dir, NULL,
-			    &page_owner_threshold_fops);
+			    &threshold_fops);
 	return 0;
 }
 late_initcall(pageowner_init)
_

Patches currently in -mm which might be from ye.liu@linux.dev are

a.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

