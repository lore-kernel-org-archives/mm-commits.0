Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795542957;
	b=xg5GtdbtEcZUKA6f2aTuqfKHMeKPwzW3CIlmh0KfBtqfr5naJ8PBVhcNZCWEoi2U4u0Z
	 T7+3reixqHkmaYqaNZcm8cwkELqC7Q5EK/xxvKNXIpvtP5QYiAq+QrDyMcfH/+D3qrGsq
	 IR1dBy4ekjufs2XyInAyZTEQ3q0lf1EEKNFy32nD7+IkJ20JLzFeW6VE8WzVnuRDanimh
	 ToPU9Ej2C53kQivsxPeZYpxA6rifvMXY5hbvuNI8U10vHgs1447lJxlMYIoqbTs7ytU9d
	 CsEM8WvPXy/cKk2vRvPaCD0OV+lKVoPq22j198GLqA3y6TZIGPzcyNTIzYItAs1i+rQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795542957;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=JHi4yRXB+aXcLplNQKlfsh1cVOVIQ274XE5Bu8XHh4k=;
	b=RnwfZBcOAtlwisOTAuz5g8wzpu0awJ7dkWiRKA+S6Hvv7no+rp9O0hg5k3X5sLY6zo7e
	 Atu6tJrXyI6ZoV4eMTlklZMVFDHucvhvg8M6Y4xstvXZZXOfh5rzBNOohgG7nmR5BkmoB
	 wakbv80JY+IoudJ6zuqY/oS8ET/9xbDwAwgMczeC2qDCB8ldtu4GR29wjeC6HYn02nXox
	 s6soCdC19ZPwWXn4AhCIiSVY/29Bh7rdmATnxvvboYbiHgnVD1dlYZH65T028bNpJVu8j
	 r5DvOmtyG5ynLtCKnfKMxPrHyFwtBCHgSc+2W75e2KzRITQb8gr/SyCCE1P4oL2kWRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DnooCa4U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9274606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DnooCa4U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665411F000C4;
	Tue, 24 Nov 2026 17:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795542956;
	bh=JHi4yRXB+aXcLplNQKlfsh1cVOVIQ274XE5Bu8XHh4k=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=DnooCa4U1ohQyJo12fYPJBumjuXo2mtcJV916qby0qIyOEvJ7EkE929OdtjjH8qsz
	 brNDlTYoboG+RiFNrCI3v6WaO1Av17J/YUWlgqKZNNlosmh7TsyjYIlTUNDCa7XnkA
	 bG9znyHbsPtuAuV2HqcNJrM0E1UcuQNnJJXQu5As=
Date: Tue, 24 Nov 2026 09:55:55 -0800
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-late-2026-vma-flags-v2-2-bf3fade93064@kernel.org>
References: <20261124-late-2026-vma-flags-v2-2-bf3fade93064@kernel.org>
Subject: + mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t.patch added to mm-new branch
Message-Id: <20261124175556.665411F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/madvise: convert madvise_vma_behavior() to use vma_flags_t
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/madvise: convert madvise_vma_behavior() to use vma_flags_t
Date: Tue, 24 Nov 2026 17:07:54 +0000

Replace use of the legacy vm_flags_t flags with vma_flags_t values
throughout the madvise logic.

In order to do so, update ksm_madvise() and hugepage_madvise() to take a
vma_flags_t pointer, and update their other callers in mremap and the
powerpc KVM ultravisor code accordingly.

In the latter case we replace vm_flags_reset() with vma_overwrite_flags().
The VMA is write locked at this point, so the atomic flags preserved by
vma_overwrite_flags() cannot differ from those copied, and the behaviour
is unchanged.

No functional change intended.

Link: https://patch.msgid.link/20261124-late-2026-vma-flags-v2-2-bf3fade93064@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <chleroy@kernel.org>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Shrikanth Hegde <sshegde@linux.ibm.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: SJ Park <sj@kernel.org>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Georgia Garcia <georgia.garcia@canonical.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Roberto Sassu <roberto.sassu@huawei.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Eric Snowberg <eric.snowberg@oracle.com>
Cc: Fan Wu <wufan@kernel.org>
Cc: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Ondrej Mosnáček <omosnacek@gmail.com>

 arch/powerpc/kvm/book3s_hv_uvmem.c |   10 ++---
 include/linux/huge_mm.h            |    4 +-
 include/linux/ksm.h                |    4 +-
 mm/khugepaged.c                    |   10 ++---
 mm/ksm.c                           |    8 ++--
 mm/madvise.c                       |   49 ++++++++++++++-------------
 mm/mremap.c                        |    2 -
 7 files changed, 45 insertions(+), 42 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_uvmem.c~mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t
+++ a/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -393,7 +393,7 @@ static int kvmppc_memslot_page_merge(str
 {
 	unsigned long gfn = memslot->base_gfn;
 	unsigned long end, start = gfn_to_hva(kvm, gfn);
-	vm_flags_t vm_flags;
+	vma_flags_t vma_flags;
 	int ret = 0;
 	struct vm_area_struct *vma;
 	int merge_flag = (merge) ? MADV_MERGEABLE : MADV_UNMERGEABLE;
@@ -411,15 +411,15 @@ static int kvmppc_memslot_page_merge(str
 			break;
 		}
 		vma_start_write(vma);
-		/* Copy vm_flags to avoid partial modifications in ksm_madvise */
-		vm_flags = vma->vm_flags;
+		/* Copy flags to avoid partial modifications in ksm_madvise */
+		vma_flags = vma->flags;
 		ret = ksm_madvise(vma, vma->vm_start, vma->vm_end,
-			  merge_flag, &vm_flags);
+				merge_flag, &vma_flags);
 		if (ret) {
 			ret = H_STATE;
 			break;
 		}
-		vm_flags_reset(vma, vm_flags);
+		vma_overwrite_flags(vma, vma_flags);
 		start = vma->vm_end;
 	} while (end > vma->vm_end);
 
--- a/include/linux/huge_mm.h~mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t
+++ a/include/linux/huge_mm.h
@@ -507,7 +507,7 @@ change_huge_pud(struct mmu_gather *tlb,
 			__split_huge_pud(__vma, __pud, __address);	\
 	}  while (0)
 
-int hugepage_madvise(struct vm_area_struct *vma, vm_flags_t *vm_flags,
+int hugepage_madvise(struct vm_area_struct *vma, vma_flags_t *vma_flags,
 		     int advice);
 int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		     unsigned long end, bool *lock_dropped);
@@ -709,7 +709,7 @@ static inline bool unmap_huge_pmd_locked
 	do { } while (0)
 
 static inline int hugepage_madvise(struct vm_area_struct *vma,
-				   vm_flags_t *vm_flags, int advice)
+		vma_flags_t *vma_flags, int advice)
 {
 	return -EINVAL;
 }
--- a/include/linux/ksm.h~mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t
+++ a/include/linux/ksm.h
@@ -16,7 +16,7 @@
 
 #ifdef CONFIG_KSM
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
-		unsigned long end, int advice, vm_flags_t *vm_flags);
+		unsigned long end, int advice, vma_flags_t *vma_flags);
 vma_flags_t ksm_vma_flags(struct mm_struct *mm, const struct file *file,
 			  vma_flags_t vma_flags);
 int ksm_enable_merge_any(struct mm_struct *mm);
@@ -139,7 +139,7 @@ static inline void collect_procs_ksm(con
 
 #ifdef CONFIG_MMU
 static inline int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
-		unsigned long end, int advice, vm_flags_t *vm_flags)
+		unsigned long end, int advice, vma_flags_t *vma_flags)
 {
 	return 0;
 }
--- a/mm/khugepaged.c~mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t
+++ a/mm/khugepaged.c
@@ -363,16 +363,16 @@ static unsigned int collapse_max_ptes_sw
 }
 
 int hugepage_madvise(struct vm_area_struct *vma,
-		     vm_flags_t *vm_flags, int advice)
+		     vma_flags_t *vma_flags, int advice)
 {
 	switch (advice) {
 	case MADV_HUGEPAGE:
-		*vm_flags &= ~VM_NOHUGEPAGE;
-		*vm_flags |= VM_HUGEPAGE;
+		vma_flags_clear(vma_flags, VMA_NOHUGEPAGE_BIT);
+		vma_flags_set(vma_flags, VMA_HUGEPAGE_BIT);
 		break;
 	case MADV_NOHUGEPAGE:
-		*vm_flags &= ~VM_HUGEPAGE;
-		*vm_flags |= VM_NOHUGEPAGE;
+		vma_flags_clear(vma_flags, VMA_HUGEPAGE_BIT);
+		vma_flags_set(vma_flags, VMA_NOHUGEPAGE_BIT);
 		/*
 		 * Setting VM_NOHUGEPAGE will prevent khugepaged from scanning
 		 * this vma even if we leave the mm registered in khugepaged if
--- a/mm/ksm.c~mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t
+++ a/mm/ksm.c
@@ -3022,7 +3022,7 @@ int ksm_disable(struct mm_struct *mm)
 }
 
 int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
-		unsigned long end, int advice, vm_flags_t *vm_flags)
+		unsigned long end, int advice, vma_flags_t *vma_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	int err;
@@ -3040,11 +3040,11 @@ int ksm_madvise(struct vm_area_struct *v
 				return err;
 		}
 
-		*vm_flags |= VM_MERGEABLE;
+		vma_flags_set(vma_flags, VMA_MERGEABLE_BIT);
 		break;
 
 	case MADV_UNMERGEABLE:
-		if (!(*vm_flags & VM_MERGEABLE))
+		if (!vma_flags_test(vma_flags, VMA_MERGEABLE_BIT))
 			return 0;		/* just ignore the advice */
 
 		if (vma_has_anon_rmap(vma)) {
@@ -3053,7 +3053,7 @@ int ksm_madvise(struct vm_area_struct *v
 				return err;
 		}
 
-		*vm_flags &= ~VM_MERGEABLE;
+		vma_flags_clear(vma_flags, VMA_MERGEABLE_BIT);
 		break;
 	}
 
--- a/mm/madvise.c~mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t
+++ a/mm/madvise.c
@@ -148,11 +148,10 @@ static int replace_anon_vma_name(struct
  * Update the vm_flags or anon_name on region of a vma, splitting it or merging
  * it as necessary. Must be called with mmap_lock held for writing.
  */
-static int madvise_update_vma(vm_flags_t new_flags,
+static int madvise_update_vma(vma_flags_t new_vma_flags,
 		struct madvise_behavior *madv_behavior)
 {
 	struct vm_area_struct *vma = madv_behavior->vma;
-	vma_flags_t new_vma_flags = legacy_to_vma_flags(new_flags);
 	struct madvise_behavior_range *range = &madv_behavior->range;
 	struct anon_vma_name *anon_name = madv_behavior->anon_name;
 	bool set_new_anon_name = madv_behavior->behavior == __MADV_SET_ANON_VMA_NAME;
@@ -627,7 +626,8 @@ static void madvise_cold_page_range(stru
 
 static inline bool can_madv_lru_vma(struct vm_area_struct *vma)
 {
-	return !(vma->vm_flags & (VM_LOCKED|VM_PFNMAP|VM_HUGETLB));
+	return !vma_test_any(vma, VMA_LOCKED_BIT, VMA_PFNMAP_BIT,
+			     VMA_HUGETLB_BIT);
 }
 
 static long madvise_cold(struct madvise_behavior *madv_behavior)
@@ -675,8 +675,8 @@ static long madvise_pageout(struct madvi
 	 * owner nor write capable of the file. We allow private file mappings
 	 * further to pageout dirty anon pages.
 	 */
-	if (!vma_is_anonymous(vma) && (!can_do_file_pageout(vma) &&
-				(vma->vm_flags & VM_MAYSHARE)))
+	if (!vma_is_anonymous(vma) && !can_do_file_pageout(vma) &&
+	    vma_test(vma, VMA_MAYSHARE_BIT))
 		return 0;
 
 	lru_add_drain();
@@ -923,12 +923,12 @@ bool madvise_dontneed_free_valid_vma(str
 	struct madvise_behavior_range *range = &madv_behavior->range;
 
 	if (!vma_is_hugetlb(vma)) {
-		unsigned int forbidden = VM_PFNMAP;
+		vma_flags_t forbidden = mk_vma_flags(VMA_PFNMAP_BIT);
 
 		if (behavior != MADV_DONTNEED_LOCKED)
-			forbidden |= VM_LOCKED;
+			vma_flags_set(&forbidden, VMA_LOCKED_BIT);
 
-		return !(vma->vm_flags & forbidden);
+		return !vma_test_any_mask(vma, forbidden);
 	}
 
 	if (behavior != MADV_DONTNEED && behavior != MADV_DONTNEED_LOCKED)
@@ -1063,7 +1063,7 @@ static long madvise_remove(struct madvis
 
 	mark_mmap_lock_dropped(madv_behavior);
 
-	if (vma->vm_flags & VM_LOCKED)
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		return -EINVAL;
 
 	f = vma->vm_file;
@@ -1377,7 +1377,7 @@ static bool can_madvise_modify(struct ma
 		return true;
 
 	/* If the user could write to the mapping anyway, then this is fine. */
-	if ((vma->vm_flags & VM_WRITE) &&
+	if (vma_test(vma, VMA_WRITE_BIT) &&
 	    arch_vma_access_permitted(vma, /* write= */ true,
 			/* execute= */ false, /* foreign= */ false))
 		return true;
@@ -1401,7 +1401,7 @@ static int madvise_vma_behavior(struct m
 {
 	int behavior = madv_behavior->behavior;
 	struct vm_area_struct *vma = madv_behavior->vma;
-	vm_flags_t new_flags = vma->vm_flags;
+	vma_flags_t new_flags = vma->flags;
 	struct madvise_behavior_range *range = &madv_behavior->range;
 	int error;
 
@@ -1432,44 +1432,47 @@ static int madvise_vma_behavior(struct m
 	/* The below behaviours update VMAs via madvise_update_vma(). */
 
 	case MADV_NORMAL:
-		new_flags = new_flags & ~VM_RAND_READ & ~VM_SEQ_READ;
+		vma_flags_clear(&new_flags, VMA_RAND_READ_BIT,
+				VMA_SEQ_READ_BIT);
 		break;
 	case MADV_SEQUENTIAL:
-		new_flags = (new_flags & ~VM_RAND_READ) | VM_SEQ_READ;
+		vma_flags_clear(&new_flags, VMA_RAND_READ_BIT);
+		vma_flags_set(&new_flags, VMA_SEQ_READ_BIT);
 		break;
 	case MADV_RANDOM:
-		new_flags = (new_flags & ~VM_SEQ_READ) | VM_RAND_READ;
+		vma_flags_clear(&new_flags, VMA_SEQ_READ_BIT);
+		vma_flags_set(&new_flags, VMA_RAND_READ_BIT);
 		break;
 	case MADV_DONTFORK:
-		new_flags |= VM_DONTCOPY;
+		vma_flags_set(&new_flags, VMA_DONTCOPY_BIT);
 		break;
 	case MADV_DOFORK:
 		if (!vma_is_mm_backed(vma) || vma_is_hugetlb(vma))
 			return -EINVAL;
-		new_flags &= ~VM_DONTCOPY;
+		vma_flags_clear(&new_flags, VMA_DONTCOPY_BIT);
 		break;
 	case MADV_WIPEONFORK:
 		/* MADV_WIPEONFORK is only supported on anonymous memory. */
-		if (vma->vm_file || new_flags & VM_SHARED)
+		if (vma->vm_file || vma_flags_test(&new_flags, VMA_SHARED_BIT))
 			return -EINVAL;
-		new_flags |= VM_WIPEONFORK;
+		vma_flags_set(&new_flags, VMA_WIPEONFORK_BIT);
 		break;
 	case MADV_KEEPONFORK:
-		if (new_flags & VM_DROPPABLE)
+		if (vma_flags_test_single_mask(&new_flags, VMA_DROPPABLE))
 			return -EINVAL;
-		new_flags &= ~VM_WIPEONFORK;
+		vma_flags_clear(&new_flags, VMA_WIPEONFORK_BIT);
 		break;
 	case MADV_DONTDUMP:
-		new_flags |= VM_DONTDUMP;
+		vma_flags_set(&new_flags, VMA_DONTDUMP_BIT);
 		break;
 	case MADV_DODUMP:
 		/* Only mm-backed memory can be meaningfully dumped. */
 		if (!vma_is_mm_backed(vma))
 			return -EINVAL;
 		/* Core mm may discard droppable memory at any time. */
-		if (new_flags & VM_DROPPABLE)
+		if (vma_flags_test_single_mask(&new_flags, VMA_DROPPABLE))
 			return -EINVAL;
-		new_flags &= ~VM_DONTDUMP;
+		vma_flags_clear(&new_flags, VMA_DONTDUMP_BIT);
 		break;
 	case MADV_MERGEABLE:
 	case MADV_UNMERGEABLE:
--- a/mm/mremap.c~mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t
+++ a/mm/mremap.c
@@ -1131,7 +1131,7 @@ static unsigned long prep_move_vma(struc
 	struct vm_area_struct *vma = vrm->vma;
 	unsigned long old_addr = vrm->addr;
 	unsigned long old_len = vrm->old_len;
-	vm_flags_t dummy = vma->vm_flags;
+	vma_flags_t dummy = vma->flags;
 	const bool split_before = vma->vm_start != old_addr;
 	const bool split_after = vma->vm_end != old_addr + old_len;
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-msync-return-enomem-if-page-aligned-length-overflows.patch
mm-vma-drop-mm-asynchronously-in-vma_start_read.patch
mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch
mm-madvise-zap-markers-from-guard-regions.patch
mm-mmap-free-gathered-pages-before-mmf_oom_skip.patch
percpu-fix-contig-hints-that-are-too-low.patch
percpu-search-the-whole-reserved-chunk.patch
mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t.patch
mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t.patch
mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t.patch
fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t.patch
fs-coredump-convert-vma_dump_size-to-use-vma_flags_t.patch
uprobes-convert-vma-flag-tests-to-use-vma_flags_t.patch
perf-convert-vma-flag-tests-to-use-vma_flags_t.patch
selinux-convert-vma-flag-tests-to-use-vma_flags_t.patch
apparmor-convert-vma-flag-tests-to-use-vma_flags_t.patch
ima-convert-vma-flag-tests-to-use-vma_flags_t.patch
ipe-convert-vma-flag-tests-to-use-vma_flags_t.patch

