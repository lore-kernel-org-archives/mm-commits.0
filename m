Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24632EEC8
	for <mm-commits@vger.kernel.org>; Sat, 24 Aug 2024 01:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724464710; cv=none; b=ugCS8OegxvZzXNLkOHfC7UkjSj3yCPPQUKS7h9pX8puP8yJT4kzi7PgP/n6CNVyv+wtgqFKCdJ647L3hlxFk3RZzPDJEU8dr1r5+roo73jYqBLbxPUiK6JCmz9yVGBzNKFEinzedP9pPf/M+k6o/fwcrGIx7dcr3zD8oBRuBlXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724464710; c=relaxed/simple;
	bh=qgCmpC3zjalCNblpP+56NJX6fBUs4HI0C0g4zpwBcS4=;
	h=Date:To:From:Subject:Message-Id; b=kXt6SWoE7o+n8qjfQ4Mcxd6z5yvW7D2b16ArCA/FJlk9Xukr78O/AkmrwNUCC0YsEzHzqA0/qMJeAUZ+JetK2KNcNqZB2hQ4Xsk4JilB8o50DLGvihAOl/JlVj1r/0SRlTRApGEjGPu9GhTJePBW9hZ9eOVC9k5txzkTUMhQ6ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jZS/Mk3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jZS/Mk3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9D4BC32786;
	Sat, 24 Aug 2024 01:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724464710;
	bh=qgCmpC3zjalCNblpP+56NJX6fBUs4HI0C0g4zpwBcS4=;
	h=Date:To:From:Subject:From;
	b=jZS/Mk3EWK+QCJdZxdaGOlsTpnYbaAIm5tD+u2PG+v3LNznjVbC20oqmI8Cs8YD54
	 ujpDTHXCpIdq+j6upxeTKTKFgkYPbmWG8/WhLjui5r59pWJKQVl5CrjHhIbut8MnVd
	 0rbDUx096vN9vDnDEjymPXuLF1vUqb/BJyy4w8Z4=
Date: Fri, 23 Aug 2024 18:58:28 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,surenb@google.com,spasswolf@web.de,sidhartha.kumar@oracle.com,paul@paul-moore.com,paulmck@kernel.org,olsajiri@gmail.com,lstoakes@gmail.com,lorenzo.stoakes@oracle.com,kees@kernel.org,Liam.Howlett@Oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct.patch added to mm-unstable branch
Message-Id: <20240824015829.D9D4BC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: track start and end for munmap in vma_munmap_struct
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>
Subject: mm/vma: track start and end for munmap in vma_munmap_struct
Date: Thu, 22 Aug 2024 15:25:34 -0400

Set the start and end address for munmap when the prev and next are
gathered.  This is needed to avoid incorrect addresses being used during
the vms_complete_munmap_vmas() function if the prev/next vma are expanded.

Add a new helper vms_complete_pte_clear(), which is needed later and will
avoid growing the argument list to unmap_region() beyond the 9 it already
has.

Link: https://lkml.kernel.org/r/20240822192543.3359552-13-Liam.Howlett@oracle.com
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Bert Karwatzki <spasswolf@web.de>
Cc: Jiri Olsa <olsajiri@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |   32 +++++++++++++++++++++++++-------
 mm/vma.h |    4 ++++
 2 files changed, 29 insertions(+), 7 deletions(-)

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
@@ -746,6 +760,8 @@ int vms_gather_munmap_vmas(struct vma_mu
 			goto start_split_failed;
 	}
 	vms->prev = vma_prev(vms->vmi);
+	if (vms->prev)
+		vms->unmap_start = vms->prev->vm_end;
 
 	/*
 	 * Detach a range of VMAs from the mm. Using next as a temp variable as
@@ -810,6 +826,8 @@ int vms_gather_munmap_vmas(struct vma_mu
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
@@ -108,6 +110,8 @@ static inline void init_vma_munmap(struc
 	vms->vma_count = 0;
 	vms->nr_pages = vms->locked_vm = vms->nr_accounted = 0;
 	vms->exec_vm = vms->stack_vm = vms->data_vm = 0;
+	vms->unmap_start = FIRST_USER_ADDRESS;
+	vms->unmap_end = USER_PGTABLES_CEILING;
 }
 
 int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
_

Patches currently in -mm which might be from Liam.Howlett@Oracle.com are

maple_tree-remove-rcu_read_lock-from-mt_validate.patch
mm-vma-correctly-position-vma_iterator-in-__split_vma.patch
mm-vma-introduce-abort_munmap_vmas.patch
mm-vma-introduce-vmi_complete_munmap_vmas.patch
mm-vma-extract-the-gathering-of-vmas-from-do_vmi_align_munmap.patch
mm-vma-introduce-vma_munmap_struct-for-use-in-munmap-operations.patch
mm-vma-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas.patch
mm-vma-change-munmap-to-use-vma_munmap_struct-for-accounting-and-surrounding-vmas-fix.patch
mm-vma-extract-validate_mm-from-vma_complete.patch
mm-vma-inline-munmap-operation-in-mmap_region.patch
mm-vma-expand-mmap_region-munmap-call.patch
mm-vma-support-vma-==-null-in-init_vma_munmap.patch
mm-mmap-reposition-vma-iterator-in-mmap_region.patch
mm-vma-track-start-and-end-for-munmap-in-vma_munmap_struct.patch
mm-clean-up-unmap_region-argument-list.patch
mm-mmap-avoid-zeroing-vma-tree-in-mmap_region.patch
mm-change-failure-of-map_fixed-to-restoring-the-gap-on-failure.patch
mm-mmap-use-phys_pfn-in-mmap_region.patch
mm-mmap-use-vms-accounted-pages-in-mmap_region.patch
ipc-shm-mm-drop-do_vma_munmap.patch
mm-move-may_expand_vm-check-in-mmap_region.patch
mm-vma-drop-incorrect-comment-from-vms_gather_munmap_vmas.patch
mm-vmah-optimise-vma_munmap_struct.patch

