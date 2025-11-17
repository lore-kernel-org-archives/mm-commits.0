Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8A91FF7C5
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343124; cv=none; b=elZjUP43rJSs7TVeP8zwyLfFzRD1PnCW5HoVy0cbkmdxcZgQs++4wEXPA8MumMJHfJx4YNwuvasxb9FqsIkyGZYESTanrbG4kwOYZHk21H2tkbWC0VEdRn0WOEnXaJQ3G1+MmL+vEvQiSZx+H0XCCsItKAZMPsYnZIFrN29qhFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343124; c=relaxed/simple;
	bh=ltwEp0DUf8fDpBHjUQdD6NajXH8uZk2zBEf49Jk1tbk=;
	h=Date:To:From:Subject:Message-Id; b=SPyBt7J6Q2RzM6qt25ikXV/1ruCs0NaxRx4YIVZrpEFwC4y//PYBTt9kRF+0fzid0xcUsN/n7zakkjUI59iio/vKY5BDOFyEbvUE/dTeNZnUvE2EeggE8YyniMcIJ7sRXFG51oh2Umj/ssy+VSnUJqGPXJCF3wEzKjpxmur7gLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GGe77e/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GGe77e/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1616C116D0;
	Mon, 17 Nov 2025 01:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343124;
	bh=ltwEp0DUf8fDpBHjUQdD6NajXH8uZk2zBEf49Jk1tbk=;
	h=Date:To:From:Subject:From;
	b=GGe77e/P4C6jKvlA0sFaDxfJx4UF9a+M0CEtNZrCmQyithOvGnPcC3M8QvKJkitL/
	 IAcbrzwJoh24fKmHHiUH0vFlN2cp8a/b2Y9QIV4OJjdVc6Qdll2RjYq8b602RsQqov
	 HFUXXrDFAASXVZVAUEejfwc/cYzYQVYgDx9+26EQ=
Date: Sun, 16 Nov 2025 17:32:04 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,liuye@kylinos.cn,jackmanb@google.com,hannes@cmpxchg.org,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_owner-rename-proc-prefixed-variables-for-clarity.patch removed from -mm tree
Message-Id: <20251117013204.A1616C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_owner: rename proc-prefixed variables for clarity
has been removed from the -mm tree.  Its filename was
     mm-page_owner-rename-proc-prefixed-variables-for-clarity.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Song Hu <husong@kylinos.cn>
Subject: mm/page_owner: rename proc-prefixed variables for clarity
Date: Tue, 30 Sep 2025 17:21:51 +0800

`proc_page_owner_operations` and related variables were renamed to
`page_owner_fops` to better reflect their association with `debugfs`
rather than `/proc`.  This improves code clarity and aligns with kernel
naming conventions.

Link: https://lkml.kernel.org/r/20250930092153.843109-1-husong@kylinos.cn
Signed-off-by: Song Hu <husong@kylinos.cn>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Ye Liu <liuye@kylinos.cn>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-rename-proc-prefixed-variables-for-clarity
+++ a/mm/page_owner.c
@@ -860,7 +860,7 @@ static void init_early_allocated_pages(v
 		init_zones_in_node(pgdat);
 }
 
-static const struct file_operations proc_page_owner_operations = {
+static const struct file_operations page_owner_fops = {
 	.read		= read_page_owner,
 	.llseek		= lseek_page_owner,
 };
@@ -961,7 +961,7 @@ static int page_owner_stack_open(struct
 	return ret;
 }
 
-static const struct file_operations page_owner_stack_operations = {
+static const struct file_operations page_owner_stack_fops = {
 	.open		= page_owner_stack_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
@@ -980,7 +980,7 @@ static int page_owner_threshold_set(void
 	return 0;
 }
 
-DEFINE_SIMPLE_ATTRIBUTE(proc_page_owner_threshold, &page_owner_threshold_get,
+DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
 			&page_owner_threshold_set, "%llu");
 
 
@@ -993,24 +993,22 @@ static int __init pageowner_init(void)
 		return 0;
 	}
 
-	debugfs_create_file("page_owner", 0400, NULL, NULL,
-			    &proc_page_owner_operations);
+	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_STACK |
 				     STACK_PRINT_FLAG_PAGES),
-			    &page_owner_stack_operations);
+			     &page_owner_stack_fops);
 	debugfs_create_file("show_handles", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_HANDLE |
 				     STACK_PRINT_FLAG_PAGES),
-			    &page_owner_stack_operations);
+			    &page_owner_stack_fops);
 	debugfs_create_file("show_stacks_handles", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_STACK |
 				     STACK_PRINT_FLAG_HANDLE),
-			    &page_owner_stack_operations);
+			    &page_owner_stack_fops);
 	debugfs_create_file("count_threshold", 0600, dir, NULL,
-			    &proc_page_owner_threshold);
-
+			    &page_owner_threshold_fops);
 	return 0;
 }
 late_initcall(pageowner_init)
_

Patches currently in -mm which might be from husong@kylinos.cn are


