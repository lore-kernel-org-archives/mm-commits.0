Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205D225757
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957084; cv=none; b=dQcZ5zRKrQFi2Gy3CSn7wSz4l43vQCPd/0YXnN7wIJsdjM5DyVjVn8AwScnzpULpwIWt6hic87wogGHIX6EcEtfQw0R4PFHLnqLBe1Yu6owSEnqZT0yMNLzgc2v3A81GCD08h40XhYtO8s+3R1miY/dNvzVvidQYKQ5u/pkBzUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957084; c=relaxed/simple;
	bh=VCC6+HI3ffgKnoyxnJ7xVw8t7ZkRX9ZjhQmireeMrwE=;
	h=Date:To:From:Subject:Message-Id; b=WD5RvUeVljwTs72rWA4wJP9LxwkRKsl3S0uvRb8SEubFmKkn7dgJDMQaZIpk4U2j3Ty9fHYE6fqBSru7sW7VOGWs2NliBbAKL6n9j8sNaljjMHkCZqZhtNpxrl0EFJbT/Gx6wTTbK7e22gEt/MgpME2p/MHgUEBzyTES3ZasXbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iYxiGvbk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iYxiGvbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC44C113CC;
	Mon,  6 May 2024 00:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957084;
	bh=VCC6+HI3ffgKnoyxnJ7xVw8t7ZkRX9ZjhQmireeMrwE=;
	h=Date:To:From:Subject:From;
	b=iYxiGvbky00wBP50IFo9VWZTzWpJ1AyZZfbK9VGaxtq9nYn2r3Iol8cHe5vdUdf+C
	 2ayOvdxuBUC/UUxJX/0nGeA2o2zINqWb3x/nK+jPqZ46YSdarXty4Wsdcx4SK9zM+b
	 Su5IbzfpM2xYFoqXdEKdNsdZRkhwOWmM2He4kDCc=
Date: Sun, 05 May 2024 17:58:03 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,linmiaohe@huawei.com,jane.chu@oracle.com,dan.j.williams@intel.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch removed from -mm tree
Message-Id: <20240506005803.ECC44C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: remove fsdax_pgoff argument from __add_to_kill
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/memory-failure: remove fsdax_pgoff argument from __add_to_kill
Date: Fri, 12 Apr 2024 20:34:58 +0100

Patch series "Some cleanups for memory-failure", v3.

A lot of folio conversions, plus some other simplifications. 


This patch (of 11):

Unify the KSM and DAX codepaths by calculating the addr in
add_to_kill_fsdax() instead of telling __add_to_kill() to calculate it.

Link: https://lkml.kernel.org/r/20240412193510.2356957-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20240412193510.2356957-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-remove-fsdax_pgoff-argument-from-__add_to_kill
+++ a/mm/memory-failure.c
@@ -427,21 +427,13 @@ static unsigned long dev_pagemap_mapping
  * not much we can do.	We just print a message and ignore otherwise.
  */
 
-#define FSDAX_INVALID_PGOFF ULONG_MAX
-
 /*
  * Schedule a process for later kill.
  * Uses GFP_ATOMIC allocations to avoid potential recursions in the VM.
- *
- * Note: @fsdax_pgoff is used only when @p is a fsdax page and a
- * filesystem with a memory failure handler has claimed the
- * memory_failure event. In all other cases, page->index and
- * page->mapping are sufficient for mapping the page back to its
- * corresponding user virtual address.
  */
 static void __add_to_kill(struct task_struct *tsk, struct page *p,
 			  struct vm_area_struct *vma, struct list_head *to_kill,
-			  unsigned long ksm_addr, pgoff_t fsdax_pgoff)
+			  unsigned long addr)
 {
 	struct to_kill *tk;
 
@@ -451,12 +443,10 @@ static void __add_to_kill(struct task_st
 		return;
 	}
 
-	tk->addr = ksm_addr ? ksm_addr : page_address_in_vma(p, vma);
-	if (is_zone_device_page(p)) {
-		if (fsdax_pgoff != FSDAX_INVALID_PGOFF)
-			tk->addr = vma_address(vma, fsdax_pgoff, 1);
+	tk->addr = addr ? addr : page_address_in_vma(p, vma);
+	if (is_zone_device_page(p))
 		tk->size_shift = dev_pagemap_mapping_shift(vma, tk->addr);
-	} else
+	else
 		tk->size_shift = page_shift(compound_head(p));
 
 	/*
@@ -486,7 +476,7 @@ static void add_to_kill_anon_file(struct
 				  struct vm_area_struct *vma,
 				  struct list_head *to_kill)
 {
-	__add_to_kill(tsk, p, vma, to_kill, 0, FSDAX_INVALID_PGOFF);
+	__add_to_kill(tsk, p, vma, to_kill, 0);
 }
 
 #ifdef CONFIG_KSM
@@ -504,10 +494,10 @@ static bool task_in_to_kill_list(struct
 }
 void add_to_kill_ksm(struct task_struct *tsk, struct page *p,
 		     struct vm_area_struct *vma, struct list_head *to_kill,
-		     unsigned long ksm_addr)
+		     unsigned long addr)
 {
 	if (!task_in_to_kill_list(to_kill, tsk))
-		__add_to_kill(tsk, p, vma, to_kill, ksm_addr, FSDAX_INVALID_PGOFF);
+		__add_to_kill(tsk, p, vma, to_kill, addr);
 }
 #endif
 /*
@@ -681,7 +671,8 @@ static void add_to_kill_fsdax(struct tas
 			      struct vm_area_struct *vma,
 			      struct list_head *to_kill, pgoff_t pgoff)
 {
-	__add_to_kill(tsk, p, vma, to_kill, 0, pgoff);
+	unsigned long addr = vma_address(vma, pgoff, 1);
+	__add_to_kill(tsk, p, vma, to_kill, addr);
 }
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

