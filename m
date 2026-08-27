Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB5437AA79;
	Thu, 27 Aug 2026 20:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787861308; cv=none; b=CDZD/OaOwTB9FYWnpRHa0YoWj4uPfeF9RbeV3fU+mQuG3wRlxTr1nx50kma7P/+I86/zxoT/jOk+CqH8c1ndouFH2y8bXPcRR/LCK+3MzLpCs8NEWxttoupOpsJ0mGk0rc17ZiDNo4oCmitVAbXQ0EqO2qqSRSN+CA6pe003KSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787861308; c=relaxed/simple;
	bh=0mxKeRpUAuMJu9ff7WObv+KkLhWZ5PlXVSlu264/w1o=;
	h=Date:To:From:Subject:Message-Id; b=EjkHz1P2Gu22o38fmWJBQaoIHZf7ako34+KaLONp4wIrgXIebpx2KQ5oEup5L9chdrM3HJcuSGK18pPc3p73EJkNI1h7FH3dvPLJBj7fLFXfkTt1H1HyYLTreQf8ttSw9rJFk07cNZ4zZPkr8tdV33/Am6xa2jpHT5031S0Yoz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bMiKL/Ho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bMiKL/Ho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B7E1F00A3A;
	Thu, 27 Aug 2026 20:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787861306;
	bh=egb2AaRHbiRh5EjxkxlL7LBxGGiOS7TtKTQJfJ2jAgg=;
	h=Date:To:From:Subject;
	b=bMiKL/HoKt1mRzC/4brCQyWOPxlOXcqIfadPPPaXqy6SFkm6kkqch8bmOCrqOv+CM
	 8FKAX8Ds5BY8fnXFSA0o2ZxaHe+nogeruCQxoU+I48r14cDmhJn2gux5Py/D6a6qir
	 sXBcgPFDavDbCEOWGlYQmIlDc+aozNHU4w9OYitk=
Date: Thu, 27 Aug 2026 13:08:25 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,hughd@google.com,dev.jain@arm.com,david@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-incorrect-vm_flags-usage-when-checking-allowable-orders-for-tmpfs.patch removed from -mm tree
Message-Id: <20260827200826.32B7E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix incorrect vm_flags usage when checking allowable orders for tmpfs
has been removed from the -mm tree.  Its filename was
     mm-fix-incorrect-vm_flags-usage-when-checking-allowable-orders-for-tmpfs.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: fix incorrect vm_flags usage when checking allowable orders for tmpfs
Date: Tue, 18 Aug 2026 10:47:26 +0800

Lance reported that when nothing else causes the mm to be considered for
khugepaged collapse, an MADV_HUGEPAGE-advised tmpfs VMA alone does not
trigger scanning.

After commit 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled()
into shmem_allowable_huge_orders()"), the shmem/tmpfs allowable order
check reads vma->flags directly.  However, when MADV_HUGEPAGE is handled,
khugepaged_enter_vma() is called before the VMA's flags have been updated,
so the check uses stale flags and incorrectly rejects the VMA for
collapse.  As a result, khugepaged does not collapse the tmpfs file into
PMD order in time.

Fix this by calling khugepaged_enter_vma() with the new VMA flags in
madvise_update_vma().  Meanwhile we can remove the khugepaged_enter_vma()
in hugepage_madvise().

Link: https://lore.kernel.org/7d5b5eb27be798f89d563b06254c947ff53db0b2.1787020910.git.baolin.wang@linux.alibaba.com
Fixes: 6beeab870e70 ("mm: shmem: move shmem_huge_global_enabled() into shmem_allowable_huge_orders()")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reported-by: Lance Yang <lance.yang@linux.dev>
Closes: https://lore.kernel.org/all/20260815181632.21453-1-lance.yang@linux.dev/
Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    6 ------
 mm/madvise.c    |    8 ++++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/mm/khugepaged.c~mm-fix-incorrect-vm_flags-usage-when-checking-allowable-orders-for-tmpfs
+++ a/mm/khugepaged.c
@@ -454,12 +454,6 @@ int hugepage_madvise(struct vm_area_stru
 	case MADV_HUGEPAGE:
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
-		/*
-		 * If the vma become good for khugepaged to scan,
-		 * register it here without waiting a page fault that
-		 * may not happen any time soon.
-		 */
-		khugepaged_enter_vma(vma, *vm_flags);
 		break;
 	case MADV_NOHUGEPAGE:
 		*vm_flags &= ~VM_HUGEPAGE;
--- a/mm/madvise.c~mm-fix-incorrect-vm_flags-usage-when-checking-allowable-orders-for-tmpfs
+++ a/mm/madvise.c
@@ -178,6 +178,14 @@ static int madvise_update_vma(vm_flags_t
 	/* vm_flags is protected by the mmap_lock held in write mode. */
 	vma_start_write(vma);
 	vma->flags = new_vma_flags;
+	/*
+	 * If the vma become good for khugepaged to scan,
+	 * register it here without waiting a page fault that
+	 * may not happen any time soon.
+	 */
+	if (vma_flags_test(&new_vma_flags, VMA_HUGEPAGE_BIT))
+		khugepaged_enter_vma(vma, vma_flags_to_legacy(new_vma_flags));
+
 	if (set_new_anon_name)
 		return replace_anon_vma_name(vma, anon_name);
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


