Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EFC3D7D8B
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 23:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782950253; cv=none; b=MgqNbGmb1yohvjLv8x4mMlcPWTp2Pxp82sAxID9v36p8F736U+4Qh2xQDNj4B2tNjdUbKt2kNo80YHmjSxyb22aFeSLkSnKPiDMhCsFuBY6Dc8+T7OoU9xO+OkfHsUjlVkYRYSR/VByQWoC8DaGtECnZmv0vlHD/q+SWnon3MlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782950253; c=relaxed/simple;
	bh=tZymdZHPPAiEiUGOH43rPCEFRvz+wzqLmxB7iUf1oOE=;
	h=Date:To:From:Subject:Message-Id; b=BMKzBSj7ghnowg7+gwAHfXUZS/rNyyNypsWvBKoKkv/zceaMBVmLdQk/QWFA5NbQiLeDiPnqlRv8DpUjsOrmKhcLvSEwGTznZ6Sopq52Hn4lTOD897j/WFuzgvTijfaN08kLhTMRSd4QsPoxOhcTS2h2mTv0tx5Rxoqc7KnsWsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Yo53jUH8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Yo53jUH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560681F00A3D;
	Wed,  1 Jul 2026 23:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782950252;
	bh=p4Zf2/aJGkSDUXnQz2Fgd+mjs7HT9quvmxqGyDscclo=;
	h=Date:To:From:Subject;
	b=Yo53jUH8DiJh4U36l3uzEo7du5Nsby2znNLItXgkkhJYy7Ullwbt+IBh1uAWm98Uj
	 +YXQbaztJeSfAy04VY/Xtz/oLngXfvJdvq5wrOqij34SB1CSIbD9xehH8/XpEKr2+x
	 DZEgb3THwaib+nRPE0pnKwblYh1LffzXuSPprQgY=
Date: Wed, 01 Jul 2026 16:57:31 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch removed from -mm tree
Message-Id: <20260701235732.560681F00A3D@smtp.kernel.org>
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
Date: Wed, 1 Jul 2026 09:22:33 +0800

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

Link: https://lore.kernel.org/20260701012239.315262-8-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols
+++ a/mm/page_owner.c
@@ -894,7 +894,7 @@ static void *stack_next(struct seq_file
 	return stack;
 }
 
-static unsigned long page_owner_pages_threshold;
+static unsigned long pages_threshold;
 
 static int stack_print(struct seq_file *m, void *v)
 {
@@ -911,7 +911,7 @@ static int stack_print(struct seq_file *
 	nr_base_pages = refcount_read(&stack_record->count) - 1;
 
 	if (ctx->flags & STACK_PRINT_FLAG_PAGES &&
-	    (nr_base_pages < 1 || nr_base_pages < page_owner_pages_threshold))
+	    (nr_base_pages < 1 || nr_base_pages < pages_threshold))
 		return 0;
 
 	if (ctx->flags & STACK_PRINT_FLAG_STACK) {
@@ -933,16 +933,16 @@ static void stack_stop(struct seq_file *
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
@@ -955,28 +955,26 @@ static int page_owner_stack_open(struct
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
+DEFINE_SIMPLE_ATTRIBUTE(threshold_fops, &threshold_get, &threshold_set, "%llu\n");
 
 static int __init pageowner_init(void)
 {
@@ -992,17 +990,17 @@ static int __init pageowner_init(void)
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


