Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700AB78281
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 04:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725423564; cv=none; b=LEKD7/PUmZYGO6fO36k/QHdq1rGxT/P4ekQ/Z+rhExtmVu5fD3Yspe6iDFHxA9DLjW90Sous98BMXpkt+V/uI5knn2fQzFsL38eqIA1mhlf+0WI4z1icmH5OZMv6y7qpgc43lvS7I1bHSzL29Ket5ddXXgHflhbUsbj2gbkTecE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725423564; c=relaxed/simple;
	bh=CrjTnrUx9tiODUfMt29U3zPr2DbLix+bM3eDu6VYO9w=;
	h=Date:To:From:Subject:Message-Id; b=J9EM4xkTjsliCHQS+zEgFjAQZAaxcClx0TN5/tzstPrBgF8c0CjEH0/iMbWbp9HatnPOTZ9JzcIVK2Nuo/grxnwM06NSYlMiPEL/cvQo/CrE9ldxEV3tYpwmMYkdXKyp4St72EmYSrMrKkUx9aSxrbgn+y/mAn477UQpTGrELKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zC2KB0a+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zC2KB0a+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AE3C4CEC2;
	Wed,  4 Sep 2024 04:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725423564;
	bh=CrjTnrUx9tiODUfMt29U3zPr2DbLix+bM3eDu6VYO9w=;
	h=Date:To:From:Subject:From;
	b=zC2KB0a+XUS36u2pMGlK3DKKkJu2USNzDs9Nnx5hk5/YqsmXg0djIm7mjJpzjX3BD
	 kI7eoKvNiRUhHudTGWkKNMUaenslQdH9fDhLE9ErVTRns6OWdkGpO6233jmmG3DhPa
	 f7M6oQUZtY0whSPT/a1RdP3Wz3mKKiy/K9mJwlds=
Date: Tue, 03 Sep 2024 21:19:23 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,jeffxu@chromium.org,broonie@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct.patch removed from -mm tree
Message-Id: <20240904041924.47AE3C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/vma: track start and end for munmap in vma_munmap_struct
has been removed from the -mm tree.  Its filename was
     mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/vma: track start and end for munmap in vma_munmap_struct
Date: Fri, 30 Aug 2024 00:00:52 -0400

Set the start and end address for munmap when the prev and next are
gathered.  This is needed to avoid incorrect addresses being used during
the vms_complete_munmap_vmas() function if the prev/next vma are expanded.

Add a new helper vms_complete_pte_clear(), which is needed later and will
avoid growing the argument list to unmap_region() beyond the 9 it already
has.

Link: https://lkml.kernel.org/r/20240830040101.822209-13-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jeff Xu <jeffxu@chromium.org>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   32 +++++++++++++++++++++++++-------
 mm/vma.h |    6 ++++++
 2 files changed, 31 insertions(+), 7 deletions(-)

--- a/mm/vma.c~mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct
+++ a/mm/vma.c
@@ -646,6 +646,26 @@ again:
 		uprobe_mmap(vp->insert);
 }
 
+static void vms_complete_pte_clear(struct vma_munmap_struct *vms,
+		struct ma_state *mas_detach, bool mm_wr_locked)
+{
+	struct mmu_gather tlb;
+
+	/*
+	 * We can free page tables without write-locking mmap_lock because VMAs
+	 * were isolated before we downgraded mmap_lock.
+	 */
+	mas_set(mas_detach, 1);
+	lru_add_drain();
+	tlb_gather_mmu(&tlb, vms->mm);
+	update_hiwater_rss(vms->mm);
+	unmap_vmas(&tlb, mas_detach, vms->vma, vms->start, vms->end, vms->vma_count, mm_wr_locked);
+	mas_set(mas_detach, 1);
+	/* start and end may be different if there is no prev or next vma. */
+	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start, vms->unmap_end, mm_wr_locked);
+	tlb_finish_mmu(&tlb);
+}
+
 /*
  * vms_complete_munmap_vmas() - Finish the munmap() operation
  * @vms: The vma munmap struct
@@ -667,13 +687,7 @@ void vms_complete_munmap_vmas(struct vma
 	if (vms->unlock)
 		mmap_write_downgrade(mm);
 
-	/*
-	 * We can free page tables without write-locking mmap_lock because VMAs
-	 * were isolated before we downgraded mmap_lock.
-	 */
-	mas_set(mas_detach, 1);
-	unmap_region(mm, mas_detach, vms->vma, vms->prev, vms->next,
-		     vms->start, vms->end, vms->vma_count, !vms->unlock);
+	vms_complete_pte_clear(vms, mas_detach, !vms->unlock);
 	/* Update high watermark before we lower total_vm */
 	update_hiwater_vm(mm);
 	/* Stat accounting */
@@ -745,6 +759,8 @@ int vms_gather_munmap_vmas(struct vma_mu
 			goto start_split_failed;
 	}
 	vms->prev = vma_prev(vms->vmi);
+	if (vms->prev)
+		vms->unmap_start = vms->prev->vm_end;
 
 	/*
 	 * Detach a range of VMAs from the mm. Using next as a temp variable as
@@ -805,6 +821,8 @@ int vms_gather_munmap_vmas(struct vma_mu
 	}
 
 	vms->next = vma_next(vms->vmi);
+	if (vms->next)
+		vms->unmap_end = vms->next->vm_start;
 
 #if defined(CONFIG_DEBUG_VM_MAPLE_TREE)
 	/* Make sure no VMAs are about to be lost. */
--- a/mm/vma.h~mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct
+++ a/mm/vma.h
@@ -38,6 +38,8 @@ struct vma_munmap_struct {
 	struct list_head *uf;           /* Userfaultfd list_head */
 	unsigned long start;            /* Aligned start addr (inclusive) */
 	unsigned long end;              /* Aligned end addr (exclusive) */
+	unsigned long unmap_start;      /* Unmap PTE start */
+	unsigned long unmap_end;        /* Unmap PTE end */
 	int vma_count;                  /* Number of vmas that will be removed */
 	unsigned long nr_pages;         /* Number of pages being removed */
 	unsigned long locked_vm;        /* Number of locked pages */
@@ -78,6 +80,7 @@ int vma_expand(struct vma_iterator *vmi,
 int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       unsigned long start, unsigned long end, pgoff_t pgoff);
 
+#ifdef CONFIG_MMU
 /*
  * init_vma_munmap() - Initializer wrapper for vma_munmap_struct
  * @vms: The vma munmap struct
@@ -108,7 +111,10 @@ static inline void init_vma_munmap(struc
 	vms->vma_count = 0;
 	vms->nr_pages = vms->locked_vm = vms->nr_accounted = 0;
 	vms->exec_vm = vms->stack_vm = vms->data_vm = 0;
+	vms->unmap_start = FIRST_USER_ADDRESS;
+	vms->unmap_end = USER_PGTABLES_CEILING;
 }
+#endif
 
 int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 		struct ma_state *mas_detach);
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are


