Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A653CF963
	for <mm-commits@vger.kernel.org>; Mon, 20 Jul 2026 22:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784587268; cv=none; b=dHAFzx1MZmkHvO/nyTn9z8MBYPby7wt80xtSXzKzW2h2LnADb2vJDbbqDyfRqX+p6GA/TQdbTJKEfwlNzn0rp3e9/EWYrYtAy+ruWpxTU0V1IJ5Lb4TxoblZIJFwO/UarPa3z8YIIj4junHePKlP46HkgBYcxDqjyXWptnN05BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784587268; c=relaxed/simple;
	bh=DaFO7Pz+nMgwYJPrMBanrdrI/Zh2E9c1J8k5LtshSpc=;
	h=Date:To:From:Subject:Message-Id; b=czhxJKWqWarOTBfz+M4mq579LpSnKIZe12QiNSSga7erlMMNZu78bI6kXhGVmZ1YS/nX/XGZdrFr8SKdHALBioau9jtT76kvYovjCdaQLEwen9w7o35/lrDx7GVO9LVKMR8HFD7JByLXuph2h0ZPVI68WYJKoLik1bcC6A7KDHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dBIszui6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dBIszui6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89451F000E9;
	Mon, 20 Jul 2026 22:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784587266;
	bh=QQiKSrwvsF33vYLD3h6Mw50ZhhAJH7rKL6Ss9JPMD7Y=;
	h=Date:To:From:Subject;
	b=dBIszui6DlN7Ul1sPaNxEYbTH831vQLqT550G9G0A7gjqqbkVCZDi/qlWk+4d0UH5
	 ugmKsvACl8Cbol73wv9qEFiN2pz83xUmiNGX+3TXlwLPu+j4gwbW74ajohIvwCHMLP
	 97PFFJblex7X/uwnw9LXoe95+E7T+u7tWAZIgocM=
Date: Mon, 20 Jul 2026 15:41:06 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mincore-remove-special-handling-for-vm_pfnmap-fix.patch added to mm-unstable branch
Message-Id: <20260720224106.B89451F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mincore: fixup for remove special handling for VM_PFNMAP
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mincore-remove-special-handling-for-vm_pfnmap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mincore-remove-special-handling-for-vm_pfnmap-fix.patch

This patch will later appear in the mm-unstable branch at
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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mincore: fixup for remove special handling for VM_PFNMAP
Date: Mon, 20 Jul 2026 20:41:51 +0800

Address David's comments
- rename mincore_pud_range to mincore_pud_entry
- change int nr to const unsigned long
- remove a local vec variable

Link: https://lore.kernel.org/20260720124151.1483820-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/mincore.c~mm-mincore-remove-special-handling-for-vm_pfnmap-fix
+++ a/mm/mincore.c
@@ -160,16 +160,15 @@ static int mincore_unmapped_range(unsign
 	return 0;
 }
 
-static int mincore_pud_range(pud_t *pudp, unsigned long addr, unsigned long end,
+static int mincore_pud_entry(pud_t *pudp, unsigned long addr, unsigned long end,
 		struct mm_walk *walk)
 {
 	if (pud_is_huge(pudp_get(pudp))) {
-		int nr = (end - addr) >> PAGE_SHIFT;
-		unsigned char *vec = walk->private;
+		const unsigned long nr = (end - addr) >> PAGE_SHIFT;
 
-		memset(vec, 1, nr);
-		walk->action = ACTION_CONTINUE;
+		memset(walk->private, 1, nr);
 		walk->private += nr;
+		walk->action = ACTION_CONTINUE;
 	}
 
 	return 0;
@@ -247,7 +246,7 @@ static inline bool can_do_mincore(struct
 }
 
 static const struct mm_walk_ops mincore_walk_ops = {
-	.pud_entry		= mincore_pud_range,
+	.pud_entry		= mincore_pud_entry,
 	.pmd_entry		= mincore_pte_range,
 	.pte_hole		= mincore_unmapped_range,
 	.hugetlb_entry		= mincore_hugetlb,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-migrate_device-fix-pte_pfn-pte_dirty-called-on-non-present-pte.patch
mm-remove-pagetranscompound.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore.patch
mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup.patch
mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range.patch
mm-migrate_device-use-walk_page_range_vma-in-migrate_vma_collect.patch
mm-introduce-pud_is_huge-helper.patch
mm-mincore-remove-special-handling-for-vm_pfnmap.patch
mm-mincore-remove-special-handling-for-vm_pfnmap-fix.patch
mm-mincore-replace-__get_free_page-with-kmalloc.patch
mm-mincore-remove-xa_is_value-in-mincore_swap.patch
mm-mincore-improve-mincore_hugetlb.patch
mm-mincore-improve-mincore_hugetlb-fix.patch
mm-mincore-refactor-mincore_page.patch

