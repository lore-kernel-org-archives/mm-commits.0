Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FA1288AD
	for <mm-commits@vger.kernel.org>; Fri, 10 Oct 2025 01:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760061173; cv=none; b=GyRCOw5N/M6jGtI74WzvGIDVwZwenjaIV5plhNb0Z9PYXrD73wSyKaiWJLYkYmGZTEIuRQSrTxyfvXxHszBUuiOXIMbV6xilxJUHdyJveosc2Wl0vtAb9skehZUUsQY1rlTcU+EcwbzkO2j+mZ41eFYQNJcmms0mfwYlNwhpeMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760061173; c=relaxed/simple;
	bh=8iRerpRnM8AWpdZYm0l7W2rT+7EFhMRQO2lOuKy32Q8=;
	h=Date:To:From:Subject:Message-Id; b=hySnWGlhcWWkBafPtwZSM21n2KXTJ5HR8a2EDkvS2W5WtUcniOf5I2hqP8f6WHC/xvLk5abUwyWJBQswNmvKabST2KkGSBGXIVTEo5b0eDoTjc1ktyWS/ANkTDktqCBkVLWHumc11VOix5xju7m6lf/5Z/srfikRFNw+3Pn2i9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lTzI5nQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lTzI5nQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CADFC4CEE7;
	Fri, 10 Oct 2025 01:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760061172;
	bh=8iRerpRnM8AWpdZYm0l7W2rT+7EFhMRQO2lOuKy32Q8=;
	h=Date:To:From:Subject:From;
	b=lTzI5nQOCXM4nOPPvSv+4kYKs77Ntt33aTV6+OB1Nm5kjZZcuV4F4VUrzl2x7hx/X
	 fMlnDkFdxQhS6rwxFZbIfve1CdgDz/IGkqp1w0MFv7Zf9DronXOIIWXsaC7jgV8vib
	 KBjQpoBllYMSx2lpgCuXVs8ylXpWqb5/yH4rAZ9E=
Date: Thu, 09 Oct 2025 18:52:51 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,liuye@kylinos.cn,jackmanb@google.com,hannes@cmpxchg.org,husong@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-rename-proc-prefixed-variables-for-clarity.patch added to mm-new branch
Message-Id: <20251010015252.7CADFC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: rename proc-prefixed variables for clarity
has been added to the -mm mm-new branch.  Its filename is
     mm-page_owner-rename-proc-prefixed-variables-for-clarity.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-rename-proc-prefixed-variables-for-clarity.patch

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

mm-page_owner-rename-proc-prefixed-variables-for-clarity.patch
mm-page_owner-simplify-zone-iteration-logic-in-init_early_allocated_pages.patch

