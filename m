Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246366;
	b=TQk1iyYk5oLCqRskk2kIyLuSbsiUyr7YdL85DtWY73bMAfllj1pOU0i1X/Laj4gbPItb
	 OuqBjtJjXNbl7QNeRD4ngwUCED5yZPwK99aJ8gfcTL3650ifuzomJvFIgRqIxICbngz7X
	 /8SObiQzXMhYNtkB4qY/kPxBW7g5nq+67hTchrCMKRDcdnFjC4fSQFnP2dnY8Q42SuQhX
	 P4ewv9WSA9qBBXQzqOh21XLYGjk3+ANfiUCw/84UiGmNiKXwTEes54RhYiVaxuIZZ7fUi
	 dcuDq6jlSZv+W5W3QpuFlQbDIi5zgGladMOWGccGK8LXbSyVJL9cScON0fi4TWsJgVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246366;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=8o5tR30/T7vqsadZA8mwm5ssfKc+Lm7RiXlDN4a7GZg=;
	b=f/AspKGmVxJ9fb3GgqCEpb69DAlA+04RmuSs2H+PvqcJ9Iudm0yr8eRtQdSrzoeiVgEy
	 AIeLxN9qymmAIyRK4WAVNohJZPHY5rMLNG+MtLdwB8To+e5gGBx0rVO4Ey3+UPgyNn0fg
	 xEUFlsIE+r65bg3WPEYC3udn/MjQ6IzuJ45GzBW2aBipBtXUCThgraStuyPjISRgI34Ol
	 PClW/qPNudotZO7rHi5iW9UzXjcJyv04+OXgsdIZS0+SFZNHAXBxZCUfPW08zspDV85xz
	 xgGCzKXgFgznkfTSnO9BM9p3U9Tq1MWjSUwjEG1yv/tdzSWNxRbJ+qyOn7e/w6tfl7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tYIL3edC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19C3606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 17:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tYIL3edC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AC8B1F0089F;
	Mon,  9 Nov 2026 17:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794246365;
	bh=8o5tR30/T7vqsadZA8mwm5ssfKc+Lm7RiXlDN4a7GZg=;
	h=Date:To:Cc:From:Subject;
	b=tYIL3edCEJ18FW56wJUf36OcQB8mL9CRsjlxvcOj7qPG1vjU6z7QIa8zlMrh2mHY7
	 tcTgNsVCHASrDkOa8n9WFPphtbkiacfpfW4wFtcEiEtkCRBGZqVhJjiqtg2cBCv14i
	 KZi3QpQloHfEPN3rh3HquC9hpUu/9lcsHQY8yjTM=
Date: Mon, 09 Nov 2026 09:46:04 -0800
To: mm-commits@vger.kernel.org, ljs@kernel.org, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t.patch removed from -mm tree
Message-Id: <20261109174605.3AC8B1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fs/proc/task_mmu: convert VMA flag tests to use vma_flags_t
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: fs/proc/task_mmu: convert VMA flag tests to use vma_flags_t
Date: Thu, 05 Nov 2026 21:31:00 +0000

Replace use of the legacy vm_flags_t flags with vma_flags_t values where
VMA flags are tested directly in /proc/$pid/[s]maps, pagemap, clear_refs
and PROCMAP_QUERY.

In replacing vm_flags_clear() (which takes the VMA write lock) with
vma_clear_flags() (which does not) in clear_refs_write(), we explicitly
write lock the VMA. The mmap write lock is already held at this point.

The show_vma_header_prefix() and show_smap_vma_flags() output functions and
the thp_vma_allowable_orders() call continue to use legacy flags for the
time being.

No functional change intended.

Link: https://lore.kernel.org/20261105-late-2026-vma-flags-v1-9-0d3cd15ab75f@kernel.org
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
---

 fs/proc/task_mmu.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t
+++ a/fs/proc/task_mmu.c
@@ -564,18 +564,18 @@ next_vma:
 
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
 
@@ -642,13 +642,13 @@ static int do_procmap_query(struct mm_st
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
@@ -965,7 +965,7 @@ static void smaps_pte_entry(pte_t *pte,
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = walk->vma;
-	bool locked = !!(vma->vm_flags & VM_LOCKED);
+	bool locked = vma_test(vma, VMA_LOCKED_BIT);
 	struct page *page = NULL;
 	bool present = false, young = false, dirty = false;
 	pte_t ptent = ptep_get(pte);
@@ -1012,7 +1012,7 @@ static void smaps_pmd_entry(pmd_t *pmd,
 {
 	struct mem_size_stats *mss = walk->private;
 	struct vm_area_struct *vma = walk->vma;
-	bool locked = !!(vma->vm_flags & VM_LOCKED);
+	bool locked = vma_test(vma, VMA_LOCKED_BIT);
 	struct page *page = NULL;
 	bool present = false;
 	struct folio *folio;
@@ -1723,7 +1723,7 @@ static int clear_refs_test_walk(unsigned
 	struct clear_refs_private *cp = walk->private;
 	struct vm_area_struct *vma = walk->vma;
 
-	if (vma->vm_flags & VM_PFNMAP)
+	if (vma_test(vma, VMA_PFNMAP_BIT))
 		return 1;
 
 	/*
@@ -1793,9 +1793,10 @@ static ssize_t clear_refs_write(struct f
 
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
 
@@ -1899,7 +1900,7 @@ static int pagemap_pte_hole(unsigned lon
 			break;
 
 		/* Addresses in the VMA. */
-		if (vma->vm_flags & VM_SOFTDIRTY)
+		if (vma_test(vma, VMA_SOFTDIRTY_BIT))
 			pme = make_pme(0, PM_SOFT_DIRTY);
 		for (; addr < min(end, vma->vm_end); addr += PAGE_SIZE) {
 			err = add_to_pagemap(&pme, pm);
@@ -1971,7 +1972,7 @@ static pagemap_entry_t pte_to_pagemap_en
 	}
 
 out:
-	if (vma->vm_flags & VM_SOFTDIRTY)
+	if (vma_test(vma, VMA_SOFTDIRTY_BIT))
 		flags |= PM_SOFT_DIRTY;
 
 	return make_pme(frame, flags);
@@ -1989,7 +1990,7 @@ static int pagemap_pmd_range_thp(pmd_t *
 	struct folio *folio = NULL;
 	int err = 0;
 
-	if (vma->vm_flags & VM_SOFTDIRTY)
+	if (vma_test(vma, VMA_SOFTDIRTY_BIT))
 		flags |= PM_SOFT_DIRTY;
 
 	if (pmd_none(pmd))
@@ -2111,7 +2112,7 @@ static int pagemap_hugetlb_range(pte_t *
 	int err = 0;
 	pte_t pte;
 
-	if (vma->vm_flags & VM_SOFTDIRTY)
+	if (vma_test(vma, VMA_SOFTDIRTY_BIT))
 		flags |= PM_SOFT_DIRTY;
 
 	ptl = huge_pte_lock(hstate_vma(vma), walk->mm, ptep);
@@ -2620,13 +2621,13 @@ static int pagemap_scan_test_walk(unsign
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

mm-vma-read-anon_vma-carefully-in-validate_mm.patch
fs-coredump-convert-vma_dump_size-to-use-vma_flags_t.patch
uprobes-convert-vma-flag-tests-to-use-vma_flags_t.patch
perf-convert-vma-flag-tests-to-use-vma_flags_t.patch
security-convert-vma-flag-tests-to-use-vma_flags_t.patch

