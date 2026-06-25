Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F45E1F37D3
	for <mm-commits@vger.kernel.org>; Thu, 25 Jun 2026 00:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782346844; cv=none; b=Y8/yaVWt9yL6t+WvTQthit4Wajg2BdKvdeaIViKx/AOLkengtpg94jge5A1Ayzzyp/Wcs3YEMuV4yz31ITnv3qTipdplfg8O7Qld8ueYhkrXvC9NDgk+vMaRxJ3aSNC0AGSSZUGyvsb6gxPQXbUjJDe47FXWYcPPcprmBWzpS90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782346844; c=relaxed/simple;
	bh=agm4sxKY6ERIp7ikka3572N9SB7WB8NCc+ft3S04QfE=;
	h=Date:To:From:Subject:Message-Id; b=oisBtwGI/MNPMs4aTIgcTcN0EN9TWzwqlM29lxNBdyUq/XFidzfIs8s581kqj9VS2GZ+ALRv3+ghc7yJnoEpck+pTOmCJxV1qFtPKEeWCRDP6AkDgxjx7b2+m4lDJ2mKERP0b+bqUrgXAQUG+enJB5lqUny+Dv0pbz+EGpm2J1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YEcZBnaj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YEcZBnaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C921F000E9;
	Thu, 25 Jun 2026 00:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782346843;
	bh=4+juDoa4ENTIGZuE8Ie1HW4T+dUFXzimc7RpfETGUfI=;
	h=Date:To:From:Subject;
	b=YEcZBnajwmazNcapagAXdPokBlrzSznR3piSe0c1gIpD5sEgQ/GRB/fUkmqIDPV/b
	 sefZuHgQefPpFdR+EzgOUtetBMb3450lmkEJUIYDnHYL619a2D+U4MykiSiOx/v1Ea
	 Ek31PnFSHxNZE1SS/bLPCgjBYW1gx0ihAtKoY5/8=
Date: Wed, 24 Jun 2026 17:20:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch added to mm-hotfixes-unstable branch
Message-Id: <20260625002043.21C921F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: drop redundant page_owner prefix from static symbols
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch
mm-page_owner-use-migrate_reason_none-instead-of-1-for-last_migrate_reason.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch

