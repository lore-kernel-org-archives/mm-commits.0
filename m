Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246364;
	b=nea8JeAPy/t2xlqqBrh1psnwi/ASQgpzKURyYMpopgBmkOhNBhpHv3gt9WZgeTr0apun
	 HnohMvOkFCXN9cUKT9w4hmo/brK+WwSjYGKcJzD6sv7RkPPvorvZoMqozgbEwmW1O0bkN
	 eWGEa5Fdqg0qPRdqXNeTegBZEGcBshsANfeRlKxWFHYDRfjhNF4j1u+8ZP1MoeE2CzY4I
	 +3dOoNswSwqJbTzZ/I5AKgHoCk57AKjMbo/0SZcTPTbmzuj9zuKSh3Azlp3VYPm7rPvuY
	 4XJBDrnj3wS6aJE8QEdxBHr42clL8/Yt2tnereeEsfq/4VhXOMCykpOmgZDIxw443MA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246364;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=qVgv9dF5nmh63L8JGnaMV5cdZRr78iFwN4q51AcMSK8=;
	b=WKIs/vmUXSwLM42x6BCDcHg6qYkboDwR5Pq/x/tBCr80LgiLCGoYe6360Bmig+NeujK4
	 oF0fzDJWlFekxKJR28yiijgZVrzFYfUYvKUeeF23GFo55hKqLAs/8bt54OymZqzPJeyn6
	 sSrxagkPjIjw7/9eC1D4sK++4QPwWeQYFAnuiYb+QKTfP0nxGSIMw/+k+YudBCPoszeG1
	 x3pvKwSGv4shRwsW2NbGKlJimm6TnstpMN4113n/2ZI9XRoveLAQzOQOxf4Q+03sG+lVI
	 NDpvZ63FE+rwLIY0D2sEAuRm8LvS521dGIusRar+/ohR1THGQm6Wh23NWyUv89BUUfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Fp5KlBTB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FEE606A325
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 17:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Fp5KlBTB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C431F0089F;
	Mon,  9 Nov 2026 17:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794246363;
	bh=qVgv9dF5nmh63L8JGnaMV5cdZRr78iFwN4q51AcMSK8=;
	h=Date:To:Cc:From:Subject;
	b=Fp5KlBTBfN2ZM6mMYIQfPUHWFZrHgju54+RcU2sx9Cd/IpzWkYQWr2bjcFS5+D+b5
	 6LW5yG5jmyezX7e9i9qUJhi6SeooKGzFStR7fvTHNyholcn64FhL/Jgbud/RE419dy
	 4uWE3BfYc6J8cZ3AVjJPw9W/U4XKJPhDChY3jRwo=
Date: Mon, 09 Nov 2026 09:46:03 -0800
To: mm-commits@vger.kernel.org, ljs@kernel.org, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t.patch removed from -mm tree
Message-Id: <20261109174603.91C431F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: convert miscellaneous VMA flag tests to use vma_flags_t
has been removed from the -mm tree.  Its filename was
     mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm: convert miscellaneous VMA flag tests to use vma_flags_t
Date: Thu, 05 Nov 2026 21:30:59 +0000

Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
remaining straightforward VMA flag tests scattered throughout core mm, HMM
(and its test module), DAMON and the OOM reaper.

No functional change intended.

Link: https://lore.kernel.org/20261105-late-2026-vma-flags-v1-8-0d3cd15ab75f@kernel.org
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

 include/linux/mm_inline.h |    2 +-
 lib/test_hmm.c            |    4 ++--
 mm/damon/vaddr.c          |    2 +-
 mm/hmm.c                  |    6 +++---
 mm/internal.h             |    2 +-
 mm/mempolicy.c            |    4 ++--
 mm/mmap_lock.c            |    4 ++--
 mm/msync.c                |    4 ++--
 mm/oom_kill.c             |    4 ++--
 mm/pagewalk.c             |    2 +-
 mm/vma.h                  |    4 ++--
 11 files changed, 19 insertions(+), 19 deletions(-)

--- a/include/linux/mm_inline.h~mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t
+++ a/include/linux/mm_inline.h
@@ -657,7 +657,7 @@ static inline pte_marker copy_pte_marker
 
 static inline bool vma_has_recency(const struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))
+	if (vma_test_any(vma, VMA_SEQ_READ_BIT, VMA_RAND_READ_BIT))
 		return false;
 
 	if (vma->vm_file && (vma->vm_file->f_mode & FMODE_NOREUSE))
--- a/lib/test_hmm.c~mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t
+++ a/lib/test_hmm.c
@@ -1248,7 +1248,7 @@ static int dmirror_migrate_to_system(str
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
 		vma = vma_lookup(mm, addr);
-		if (!vma || !(vma->vm_flags & VM_READ)) {
+		if (!vma || !vma_test(vma, VMA_READ_BIT)) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -1320,7 +1320,7 @@ static int dmirror_migrate_to_device(str
 	mmap_read_lock(mm);
 	for (addr = start; addr < end; addr = next) {
 		vma = vma_lookup(mm, addr);
-		if (!vma || !(vma->vm_flags & VM_READ)) {
+		if (!vma || !vma_test(vma, VMA_READ_BIT)) {
 			ret = -EINVAL;
 			goto out;
 		}
--- a/mm/damon/vaddr.c~mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t
+++ a/mm/damon/vaddr.c
@@ -240,7 +240,7 @@ static void damon_va_walk_page_range(str
 		goto lock_mmap;
 	}
 
-	if (!(vma->vm_flags & VM_PFNMAP)) {
+	if (!vma_test(vma, VMA_PFNMAP_BIT)) {
 		ops->walk_lock = PGWALK_VMA_RDLOCK_VERIFY;
 		walk_page_range_vma(vma, start, end, ops, private);
 	}
--- a/mm/hmm.c~mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t
+++ a/mm/hmm.c
@@ -595,8 +595,8 @@ static int hmm_vma_walk_test(unsigned lo
 	struct hmm_range *range = hmm_vma_walk->range;
 	struct vm_area_struct *vma = walk->vma;
 
-	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
-	    vma->vm_flags & VM_READ)
+	if (!vma_test_any(vma, VMA_IO_BIT, VMA_PFNMAP_BIT) &&
+	    vma_test(vma, VMA_READ_BIT))
 		return 0;
 
 	/*
@@ -659,7 +659,7 @@ static int hmm_do_fault(struct mm_struct
 		return -EFAULT;
 
 	if (required_fault & HMM_NEED_WRITE_FAULT) {
-		if (!(vma->vm_flags & VM_WRITE))
+		if (!vma_test(vma, VMA_WRITE_BIT))
 			return -EPERM;
 		fault_flags |= FAULT_FLAG_WRITE;
 	}
--- a/mm/internal.h~mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t
+++ a/mm/internal.h
@@ -1248,7 +1248,7 @@ size_t splice_folio_into_pipe(struct pip
 
 static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_test(vma, VMA_SHARED_BIT))
 		return false;
 
 	return atomic_read(&vma->vm_mm->mm_users) == 1;
--- a/mm/mempolicy.c~mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t
+++ a/mm/mempolicy.c
@@ -2015,7 +2015,7 @@ SYSCALL_DEFINE5(get_mempolicy, int __use
 
 bool vma_migratable(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & (VM_IO | VM_PFNMAP))
+	if (vma_test_any(vma, VMA_IO_BIT, VMA_PFNMAP_BIT))
 		return false;
 
 	/*
@@ -2565,7 +2565,7 @@ struct folio *vma_alloc_folio_noprof(gfp
 	pgoff_t ilx;
 	struct folio *folio;
 
-	if (vma->vm_flags & VM_DROPPABLE)
+	if (vma_test_single_mask(vma, VMA_DROPPABLE))
 		gfp |= __GFP_NOWARN;
 
 	pol = get_vma_policy(vma, addr, order, &ilx);
--- a/mm/mmap_lock.c~mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t
+++ a/mm/mmap_lock.c
@@ -636,7 +636,7 @@ struct vm_area_struct *lock_mm_and_find_
 	 * Well, dang. We might still be successful, but only
 	 * if we can extend a vma to do so.
 	 */
-	if (!vma || !(vma->vm_flags & VM_GROWSDOWN)) {
+	if (!vma || !vma_test(vma, VMA_GROWSDOWN_BIT)) {
 		mmap_read_unlock(mm);
 		return NULL;
 	}
@@ -659,7 +659,7 @@ struct vm_area_struct *lock_mm_and_find_
 			goto fail;
 		if (vma->vm_start <= addr)
 			goto success;
-		if (!(vma->vm_flags & VM_GROWSDOWN))
+		if (!vma_test(vma, VMA_GROWSDOWN_BIT))
 			goto fail;
 	}
 
--- a/mm/msync.c~mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t
+++ a/mm/msync.c
@@ -81,7 +81,7 @@ SYSCALL_DEFINE3(msync, unsigned long, st
 		}
 		/* Here vma->vm_start <= start < vma->vm_end. */
 		if ((flags & MS_INVALIDATE) &&
-				(vma->vm_flags & VM_LOCKED)) {
+				vma_test(vma, VMA_LOCKED_BIT)) {
 			error = -EBUSY;
 			goto out_unlock;
 		}
@@ -90,7 +90,7 @@ SYSCALL_DEFINE3(msync, unsigned long, st
 		fend = fstart + (min(end, vma->vm_end) - start) - 1;
 		start = vma->vm_end;
 		if ((flags & MS_SYNC) && file &&
-				(vma->vm_flags & VM_SHARED)) {
+				vma_test(vma, VMA_SHARED_BIT)) {
 			get_file(file);
 			mmap_read_unlock(mm);
 			error = vfs_fsync_range(file, fstart, fend, 1);
--- a/mm/oom_kill.c~mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t
+++ a/mm/oom_kill.c
@@ -524,7 +524,7 @@ static bool __oom_reap_task_mm(struct mm
 	 * of the address space.
 	 */
 	mas_for_each_rev(&mas, vma, 0) {
-		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
+		if (vma_test_any(vma, VMA_HUGETLB_BIT, VMA_PFNMAP_BIT))
 			continue;
 
 		/*
@@ -537,7 +537,7 @@ static bool __oom_reap_task_mm(struct mm
 		 * we do not want to block exit_mmap by keeping mm ref
 		 * count elevated without a good reason.
 		 */
-		if (vma_is_anonymous(vma) || !(vma->vm_flags & VM_SHARED)) {
+		if (vma_is_anonymous(vma) || !vma_test(vma, VMA_SHARED_BIT)) {
 			if (zap_vma_for_reaping(vma))
 				ret = false;
 		}
--- a/mm/pagewalk.c~mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t
+++ a/mm/pagewalk.c
@@ -393,7 +393,7 @@ static int walk_page_test(unsigned long
 	 * define their ->pte_hole() callbacks, so let's delegate them to handle
 	 * vma(VM_PFNMAP).
 	 */
-	if (vma->vm_flags & VM_PFNMAP) {
+	if (vma_test(vma, VMA_PFNMAP_BIT)) {
 		int err = 1;
 		if (ops->pte_hole)
 			err = ops->pte_hole(start, end, -1, walk);
--- a/mm/vma.h~mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t
+++ a/mm/vma.h
@@ -597,9 +597,9 @@ static inline bool vma_wants_manual_pte_
 	 * private mappings, that's always the case when we have write
 	 * permissions as we properly have to handle COW.
 	 */
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_test(vma, VMA_SHARED_BIT))
 		return vma_wants_writenotify(vma, vma->vm_page_prot);
-	return !!(vma->vm_flags & VM_WRITE);
+	return vma_test(vma, VMA_WRITE_BIT);
 }
 
 #ifdef CONFIG_MMU
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-read-anon_vma-carefully-in-validate_mm.patch
fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t.patch
fs-coredump-convert-vma_dump_size-to-use-vma_flags_t.patch
uprobes-convert-vma-flag-tests-to-use-vma_flags_t.patch
perf-convert-vma-flag-tests-to-use-vma_flags_t.patch
security-convert-vma-flag-tests-to-use-vma_flags_t.patch

