Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795542969;
	b=B1TQsrAYiHFz7kKqh1rICSV6flzwVHmsxtqCUmM1t8hpP8zxOsP1GZhTNwL8ZFELNyLC
	 Z4SRxwvljopenHqi+0oQ6TPan92t0/5aeg8jaJJcn4CFj3CUCLGLT3oC3IAVR2difrpPH
	 tODSg1xKCgE3++mVmcAIDhgMx9yqH44mrZtMSkDfZeycnpyptfJ5T8WfydrtD1mLmPT1E
	 uF662Kf2IqNesfsr4VRwTh/ieVhqv8hXPq4WKIR5nkCyO3G4RgcCylcIcmntJSxJ4Gibx
	 3z753LG+3M0TIF4HoSrcE/Lzgm/55aMuWKo3Yv4cWFumIjxNF4e5Td4IM0fXAGd9oIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795542969;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=+1WvKEH/XXARdweXCf1jWHooeRYAyvF+ulJSMl0Rj3E=;
	b=Cn4B+7mQJYjpH/ul3MIfFcxb1ewQCgQh9mHY/YIB661D1Z3CVNgZaAROpfFp5qZqOQgw
	 zcY3MJYaWxFJFX5n9cNdbaNi32kPUNO/0RtaGuvHf94HC+eMte8yhBBcZQbz42f5wtWBP
	 Wl+OBc0KPSi/+nQecHF9Joka8o/PbfKms5YHHR58I9fnLzE6GiU7wgOwoZLJ1ntWS0sea
	 BJGXCCS5qysqh3eiz3hAOzN+rxbmoG229IKcKRgkmI5XFYNRQIk9dPporkMyhIsfzIfvP
	 jtbS261QpU+XP3MIkZ/EXHtAcBIc9jRlY70IYs9u3S6WMo9GUte01b3PUM0+UOZZ2gQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DkuG9p4u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A942F606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DkuG9p4u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40B3F1F000CA;
	Tue, 24 Nov 2026 17:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795542969;
	bh=+1WvKEH/XXARdweXCf1jWHooeRYAyvF+ulJSMl0Rj3E=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=DkuG9p4uYcuknAqK2uW1FRitnRkeu7tPpQlyjgignv0VrLuwm6dxPEYCvJcNbB4q8
	 x97rmWwYhlX7/tNN9vHpuY1jjd6CDyFqG1auTNZNAUxuPFEn4iUEO3KO65xuIn7Wit
	 sPERaF0tro8bbgXSO70OM34reIHbEtSBbzP9MAFk=
Date: Tue, 24 Nov 2026 09:56:08 -0800
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124-late-2026-vma-flags-v2-4-bf3fade93064@kernel.org>
References: <20261124-late-2026-vma-flags-v2-4-bf3fade93064@kernel.org>
Subject: + fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t.patch added to mm-new branch
Message-Id: <20261124175609.40B3F1F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fs/proc/task_mmu: convert VMA flag tests to use vma_flags_t
has been added to the -mm mm-new branch.  Its filename is
     fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t.patch

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
Subject: fs/proc/task_mmu: convert VMA flag tests to use vma_flags_t
Date: Tue, 24 Nov 2026 17:07:56 +0000

Replace use of the legacy vm_flags_t flags with vma_flags_t values where
VMA flags are tested directly in /proc/$pid/[s]maps, pagemap, clear_refs
and PROCMAP_QUERY.

In replacing vm_flags_clear() (which takes the VMA write lock) with
vma_clear_flags() (which does not) in clear_refs_write(), we explicitly
write lock the VMA. The mmap write lock is already held at this point.

Note that vm_flags_clear() asserts that the page tables support soft-dirty
when clearing VM_SOFTDIRTY, whereas vma_clear_flags() does not. No other
VMA flag is checked this way, so this assert is intentionally dropped.

The show_vma_header_prefix() and show_smap_vma_flags() output functions and
the thp_vma_allowable_orders() call continue to use legacy flags for the
time being.

No functional change intended.

Link: https://patch.msgid.link/20261124-late-2026-vma-flags-v2-4-bf3fade93064@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
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

 fs/proc/task_mmu.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t
+++ a/fs/proc/task_mmu.c
@@ -570,18 +570,18 @@ next_vma:
 
 	/* VMA permissions should satisfy query flags */
 	if (flags & PROCMAP_QUERY_VMA_FLAGS) {
-		u32 perm = 0;
+		vma_flags_t perm = EMPTY_VMA_FLAGS;
 
 		if (flags & PROCMAP_QUERY_VMA_READABLE)
-			perm |= VM_READ;
+			vma_flags_set(&perm, VMA_READ_BIT);
 		if (flags & PROCMAP_QUERY_VMA_WRITABLE)
-			perm |= VM_WRITE;
+			vma_flags_set(&perm, VMA_WRITE_BIT);
 		if (flags & PROCMAP_QUERY_VMA_EXECUTABLE)
-			perm |= VM_EXEC;
+			vma_flags_set(&perm, VMA_EXEC_BIT);
 		if (flags & PROCMAP_QUERY_VMA_SHARED)
-			perm |= VM_MAYSHARE;
+			vma_flags_set(&perm, VMA_MAYSHARE_BIT);
 
-		if ((vma->vm_flags & perm) != perm)
+		if (!vma_test_all_mask(vma, perm))
 			goto skip_vma;
 	}
 
@@ -648,13 +648,13 @@ static int do_procmap_query(struct mm_st
 	karg.vma_end = vma->vm_end;
 
 	karg.vma_flags = 0;
-	if (vma->vm_flags & VM_READ)
+	if (vma_test(vma, VMA_READ_BIT))
 		karg.vma_flags |= PROCMAP_QUERY_VMA_READABLE;
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_test(vma, VMA_WRITE_BIT))
 		karg.vma_flags |= PROCMAP_QUERY_VMA_WRITABLE;
-	if (vma->vm_flags & VM_EXEC)
+	if (vma_test(vma, VMA_EXEC_BIT))
 		karg.vma_flags |= PROCMAP_QUERY_VMA_EXECUTABLE;
-	if (vma->vm_flags & VM_MAYSHARE)
+	if (vma_test(vma, VMA_MAYSHARE_BIT))
 		karg.vma_flags |= PROCMAP_QUERY_VMA_SHARED;
 
 	karg.vma_page_size = vma_kernel_pagesize(vma);
@@ -971,7 +971,7 @@ static void smaps_pte_entry(pte_t *pte,
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = walk->vma;
-	bool locked = !!(vma->vm_flags & VM_LOCKED);
+	bool locked = vma_test(vma, VMA_LOCKED_BIT);
 	struct page *page = NULL;
 	bool present = false, young = false, dirty = false;
 	pte_t ptent = ptep_get(pte);
@@ -1018,7 +1018,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = walk->vma;
-	bool locked = !!(vma->vm_flags & VM_LOCKED);
+	bool locked = vma_test(vma, VMA_LOCKED_BIT);
 	struct page *page = NULL;
 	bool present = false;
 	struct folio *folio;
@@ -1732,7 +1732,7 @@ static int clear_refs_test_walk(unsigned
 	struct clear_refs_private *cp = walk->private;
 	struct vm_area_struct *vma = walk->vma;
 
-	if (vma->vm_flags & VM_PFNMAP)
+	if (vma_test(vma, VMA_PFNMAP_BIT))
 		return 1;
 
 	/*
@@ -1802,9 +1802,10 @@ static ssize_t clear_refs_write(struct f
 
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
 			for_each_vma(vmi, vma) {
-				if (!(vma->vm_flags & VM_SOFTDIRTY))
+				if (!vma_test(vma, VMA_SOFTDIRTY_BIT))
 					continue;
-				vm_flags_clear(vma, VM_SOFTDIRTY);
+				vma_start_write(vma);
+				vma_clear_flags(vma, VMA_SOFTDIRTY_BIT);
 				vma_set_page_prot(vma);
 			}
 
@@ -1908,7 +1909,7 @@ static int pagemap_pte_hole(unsigned lon
 			break;
 
 		/* Addresses in the VMA. */
-		if (vma->vm_flags & VM_SOFTDIRTY)
+		if (vma_test(vma, VMA_SOFTDIRTY_BIT))
 			pme = make_pme(0, PM_SOFT_DIRTY);
 		for (; addr < min(end, vma->vm_end); addr += PAGE_SIZE) {
 			err = add_to_pagemap(&pme, pm);
@@ -1980,7 +1981,7 @@ static pagemap_entry_t pte_to_pagemap_en
 	}
 
 out:
-	if (vma->vm_flags & VM_SOFTDIRTY)
+	if (vma_test(vma, VMA_SOFTDIRTY_BIT))
 		flags |= PM_SOFT_DIRTY;
 
 	return make_pme(frame, flags);
@@ -1998,7 +1999,7 @@ static int pagemap_pmd_range_thp(pmd_t *
 	struct folio *folio = NULL;
 	int err = 0;
 
-	if (vma->vm_flags & VM_SOFTDIRTY)
+	if (vma_test(vma, VMA_SOFTDIRTY_BIT))
 		flags |= PM_SOFT_DIRTY;
 
 	if (pmd_none(pmd))
@@ -2120,7 +2121,7 @@ static int pagemap_hugetlb_range(pte_t *
 	int err = 0;
 	pte_t pte;
 
-	if (vma->vm_flags & VM_SOFTDIRTY)
+	if (vma_test(vma, VMA_SOFTDIRTY_BIT))
 		flags |= PM_SOFT_DIRTY;
 
 	ptl = huge_pte_lock(hstate_vma(vma), walk->mm, ptep);
@@ -2629,13 +2630,13 @@ static int pagemap_scan_test_walk(unsign
 		 */
 	}
 
-	if (vma->vm_flags & VM_PFNMAP)
+	if (vma_test(vma, VMA_PFNMAP_BIT))
 		return 1;
 
 	if (wp_allowed)
 		vma_category |= PAGE_IS_WPALLOWED;
 
-	if (vma->vm_flags & VM_SOFTDIRTY)
+	if (vma_test(vma, VMA_SOFTDIRTY_BIT))
 		vma_category |= PAGE_IS_SOFT_DIRTY;
 
 	if (!pagemap_scan_is_interesting_vma(vma_category, p))
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

