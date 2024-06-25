Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C15513CFB9
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719291580; cv=none; b=FTUxwGvPv6Aft5st7rmh3Ot/kH3mUAbBlp1b9MC/YHcwITtF4hQaReEIWHrg3fFfpz4vpsbIRjO+9ORAL/OZZLWY+suVqAWG9JBJsorUGfVwriEraLPFE3jfjeZakIrV2RtHv2UChkGdYv0L+1SrzBcrDGUrRMoHvNsQbQ95eJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719291580; c=relaxed/simple;
	bh=uwcsnXacbHRqxUFhT8r3B0TTwKP92L0D1idsyWxtdWI=;
	h=Date:To:From:Subject:Message-Id; b=RZjOeGJxLaqQqiI7U784JORiHQkWAJIiu3N2I/vETnOXRq/mfjv/ICcIYRTXKFbkAidzKvlL5i/OKmK5+9djd/SeNu0abDUMMgy5mBUaDmHhQIKR9FlYNJQPSIOIcq1GhBNaz9z4j/oAZR9Mv+Rw15Rsw4IuwUXnBNvDOiWQinM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gls5dsjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gls5dsjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BEDC32782;
	Tue, 25 Jun 2024 04:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719291580;
	bh=uwcsnXacbHRqxUFhT8r3B0TTwKP92L0D1idsyWxtdWI=;
	h=Date:To:From:Subject:From;
	b=Gls5dsjKKFjKFy2B3tdDs4cPi2PE8Lt3B4rhtCNjBfFl63qom0YwfUygF8k+mFeWb
	 DOvvz9zQ20Gb6AGpfduXZJEwDbLp9JEG9b0xH/7ZXTlsCMDuQsH7GWX4RBR95F2uGJ
	 QD031Bl64G++jASewTmDN0/P6pLTFG6fSGGl+jbI=
Date: Mon, 24 Jun 2024 21:59:39 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lstoakes@gmail.com,Liam.Howlett@oracle.com,mjguzik@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-batch-unlink_file_vma-calls-in-free_pgd_range.patch removed from -mm tree
Message-Id: <20240625045940.70BEDC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: batch unlink_file_vma calls in free_pgd_range
has been removed from the -mm tree.  Its filename was
     mm-batch-unlink_file_vma-calls-in-free_pgd_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mateusz Guzik <mjguzik@gmail.com>
Subject: mm: batch unlink_file_vma calls in free_pgd_range
Date: Wed, 22 May 2024 01:43:21 +0200

Execs of dynamically linked binaries at 20-ish cores are bottlenecked on
the i_mmap_rwsem semaphore, while the biggest singular contributor is
free_pgd_range inducing the lock acquire back-to-back for all consecutive
mappings of a given file.

Tracing the count of said acquires while building the kernel shows:
[1, 2)     799579 |@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@|
[2, 3)          0 |                                                    |
[3, 4)       3009 |                                                    |
[4, 5)       3009 |                                                    |
[5, 6)     326442 |@@@@@@@@@@@@@@@@@@@@@                               |

So in particular there were 326442 opportunities to coalesce 5 acquires
into 1.

Doing so increases execs per second by 4% (~50k to ~52k) when running
the benchmark linked below.

The lock remains the main bottleneck, I have not looked at other spots
yet.

Bench can be found here:
http://apollo.backplane.com/DFlyMisc/doexec.c

$ cc -O2 -o shared-doexec doexec.c
$ ./shared-doexec $(nproc)

Note this particular test makes sure binaries are separate, but the
loader is shared.

Stats collected on the patched kernel (+ "noinline") with:
bpftrace -e 'kprobe:unlink_file_vma_batch_process
{ @ = lhist(((struct unlink_vma_file_batch *)arg0)->count, 0, 8, 1); }'

Link: https://lkml.kernel.org/r/20240521234321.359501-1-mjguzik@gmail.com
Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    9 +++++++++
 mm/memory.c   |   10 ++++++++--
 mm/mmap.c     |   41 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 58 insertions(+), 2 deletions(-)

--- a/mm/internal.h~mm-batch-unlink_file_vma-calls-in-free_pgd_range
+++ a/mm/internal.h
@@ -1535,4 +1535,13 @@ static inline void shrinker_debugfs_remo
 void workingset_update_node(struct xa_node *node);
 extern struct list_lru shadow_nodes;
 
+struct unlink_vma_file_batch {
+	int count;
+	struct vm_area_struct *vmas[8];
+};
+
+void unlink_file_vma_batch_init(struct unlink_vma_file_batch *);
+void unlink_file_vma_batch_add(struct unlink_vma_file_batch *, struct vm_area_struct *);
+void unlink_file_vma_batch_final(struct unlink_vma_file_batch *);
+
 #endif	/* __MM_INTERNAL_H */
--- a/mm/memory.c~mm-batch-unlink_file_vma-calls-in-free_pgd_range
+++ a/mm/memory.c
@@ -365,6 +365,8 @@ void free_pgtables(struct mmu_gather *tl
 		   struct vm_area_struct *vma, unsigned long floor,
 		   unsigned long ceiling, bool mm_wr_locked)
 {
+	struct unlink_vma_file_batch vb;
+
 	do {
 		unsigned long addr = vma->vm_start;
 		struct vm_area_struct *next;
@@ -384,12 +386,15 @@ void free_pgtables(struct mmu_gather *tl
 		if (mm_wr_locked)
 			vma_start_write(vma);
 		unlink_anon_vmas(vma);
-		unlink_file_vma(vma);
 
 		if (is_vm_hugetlb_page(vma)) {
+			unlink_file_vma(vma);
 			hugetlb_free_pgd_range(tlb, addr, vma->vm_end,
 				floor, next ? next->vm_start : ceiling);
 		} else {
+			unlink_file_vma_batch_init(&vb);
+			unlink_file_vma_batch_add(&vb, vma);
+
 			/*
 			 * Optimization: gather nearby vmas into one call down
 			 */
@@ -402,8 +407,9 @@ void free_pgtables(struct mmu_gather *tl
 				if (mm_wr_locked)
 					vma_start_write(vma);
 				unlink_anon_vmas(vma);
-				unlink_file_vma(vma);
+				unlink_file_vma_batch_add(&vb, vma);
 			}
+			unlink_file_vma_batch_final(&vb);
 			free_pgd_range(tlb, addr, vma->vm_end,
 				floor, next ? next->vm_start : ceiling);
 		}
--- a/mm/mmap.c~mm-batch-unlink_file_vma-calls-in-free_pgd_range
+++ a/mm/mmap.c
@@ -131,6 +131,47 @@ void unlink_file_vma(struct vm_area_stru
 	}
 }
 
+void unlink_file_vma_batch_init(struct unlink_vma_file_batch *vb)
+{
+	vb->count = 0;
+}
+
+static void unlink_file_vma_batch_process(struct unlink_vma_file_batch *vb)
+{
+	struct address_space *mapping;
+	int i;
+
+	mapping = vb->vmas[0]->vm_file->f_mapping;
+	i_mmap_lock_write(mapping);
+	for (i = 0; i < vb->count; i++) {
+		VM_WARN_ON_ONCE(vb->vmas[i]->vm_file->f_mapping != mapping);
+		__remove_shared_vm_struct(vb->vmas[i], mapping);
+	}
+	i_mmap_unlock_write(mapping);
+
+	unlink_file_vma_batch_init(vb);
+}
+
+void unlink_file_vma_batch_add(struct unlink_vma_file_batch *vb,
+			       struct vm_area_struct *vma)
+{
+	if (vma->vm_file == NULL)
+		return;
+
+	if ((vb->count > 0 && vb->vmas[0]->vm_file != vma->vm_file) ||
+	    vb->count == ARRAY_SIZE(vb->vmas))
+		unlink_file_vma_batch_process(vb);
+
+	vb->vmas[vb->count] = vma;
+	vb->count++;
+}
+
+void unlink_file_vma_batch_final(struct unlink_vma_file_batch *vb)
+{
+	if (vb->count > 0)
+		unlink_file_vma_batch_process(vb);
+}
+
 /*
  * Close a vm structure and free it.
  */
_

Patches currently in -mm which might be from mjguzik@gmail.com are

percpu_counter-add-a-cmpxchg-based-_add_batch-variant.patch

