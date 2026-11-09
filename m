Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246351;
	b=ZbJv1nIhxqbbMlb61qwdgI+iA7/FjGJULnqtGqyYpRiByXyb8VMgQSB7z9M6XC/h+NrY
	 wcm4E4fxMi5QR00iLkbwi100948UClYsLK9wBrFH6YiYeXikR4/BxC5xsDOSIC/E5uv+1
	 Trnn6R+fbXAx+nFK2z1B8PgFKQlCU94oG5gcSkO3C4lRTUzOEgkiJHKbISREmU84bpzt7
	 PT7hwnXzPrI16lJfP55pUsfsIAWQ9wDP1HY0gAJNQnM0hkqX2YBCu4s2VK/VwQpdgV2IN
	 S5ijG55FRqn3tVDTkILtaBSOrGymcsxT90BumlJCDZTXwaEYOL69XYfkqgbUZEjOTyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246351;
	h=Received:DKIM-Signature:Date:To:Cc:From:Subject:Message-Id;
	bh=eQ+loYI/zlz5gIIIYuPGoZEvZYztGsVVaRLbNdOaUdE=;
	b=xLM1EMrhebJkT48//Tyxw7ni2MPAIwDgncqpN4+YKnv9xurdfYwlDRlvAvUF+0lvie/u
	 SXDcaqexMEbWfZT/RozYRcKihsLsWXnEp3hK2xGQF3JzrftMwFstkz27O9Hdc/IoSpuR9
	 jnqr6NEc51cONQgEVOzQOHPOz7ZM/jWygnzzRbb81VT++iT6cY2O4jKTO4GLdG9/tUgJS
	 8t5vTKT8Jf+CeWMoAx+oO/8oBb3WXMf3RI2c3E4W/DoPmTh9Dau0UZQoIMGgnqIOwNB1k
	 UWnFD5rP1L/LnMVX4pE9tbTnlTrgQCTHE9UsElHBNHvx+8Kqtur2gPepV9jVglLi0mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=G9vdq8gy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE61606A31C
	for <mm-commits@vger.kernel.org>; Mon,  9 Nov 2026 17:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=G9vdq8gy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A9D1F0089F;
	Mon,  9 Nov 2026 17:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794246350;
	bh=eQ+loYI/zlz5gIIIYuPGoZEvZYztGsVVaRLbNdOaUdE=;
	h=Date:To:Cc:From:Subject;
	b=G9vdq8gy+67QEsedHdp+H93kgnm/A8jFtsZm6oirR+6AwXy5WJ3tOKkqJ+/LrljjQ
	 cBG+yEgy5xyKokk2hGcCi+eLVR5j5gVf8yw25nhOotTsMcjBMssQbdq+r9mkJ0TzjG
	 ndit8ZiRebkyazooL/Ew0XqlSBpVS6sCWXcwWhks=
Date: Mon, 09 Nov 2026 09:45:49 -0800
To: mm-commits@vger.kernel.org, ljs@kernel.org, akpm@linux-foundation.org
Cc: David Hildenbrand <david@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t.patch removed from -mm tree
Message-Id: <20261109174550.57A9D1F0089F@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/filemap: convert fault and readahead logic to use vma_flags_t
has been removed from the -mm tree.  Its filename was
     mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/filemap: convert fault and readahead logic to use vma_flags_t
Date: Thu, 05 Nov 2026 21:30:53 +0000

Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
file fault and mmap readahead logic.

No functional change intended.

Link: https://lore.kernel.org/20261105-late-2026-vma-flags-v1-2-0d3cd15ab75f@kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
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
Cc: Lance Yang <lance.yang@linux.dev>
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

 mm/filemap.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/mm/filemap.c~mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t
+++ a/mm/filemap.c
@@ -3352,13 +3352,14 @@ static struct file *do_sync_mmap_readahe
 	struct address_space *mapping = file->f_mapping;
 	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
 	struct file *fpin = NULL;
-	vm_flags_t vm_flags = vmf->vma->vm_flags;
+	struct vm_area_struct *vma = vmf->vma;
 	bool force_thp_readahead = false;
 	unsigned int thp_order = 0;
 	unsigned short mmap_miss;
 
 	/* Use the readahead code, even if readahead is disabled */
-	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    vma_test(vma, VMA_HUGEPAGE_BIT)) {
 		/*
 		 * Cap max THP order at 2MB: this is the common PMD-sized
 		 * hugepage size, and it avoids memory pressure from very
@@ -3378,20 +3379,21 @@ static struct file *do_sync_mmap_readahe
 		 * If we don't want any read-ahead, don't bother.
 		 * VM_EXEC case below is already intended for random access.
 		 */
-		if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
+		if (vma_test(vma, VMA_RAND_READ_BIT) &&
+		    !vma_test(vma, VMA_EXEC_BIT))
 			return fpin;
 
 		if (!ra->ra_pages)
 			return fpin;
 
-		if (vm_flags & VM_SEQ_READ) {
+		if (vma_test(vma, VMA_SEQ_READ_BIT)) {
 			fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 			page_cache_sync_ra(&ractl, ra->ra_pages);
 			return fpin;
 		}
 	}
 
-	if (!(vm_flags & (VM_SEQ_READ | VM_EXEC))) {
+	if (!vma_test_any(vma, VMA_SEQ_READ_BIT, VMA_EXEC_BIT)) {
 		/* Avoid banging the cache line if not needed */
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss < MMAP_LOTSAMISS * 10)
@@ -3415,7 +3417,7 @@ static struct file *do_sync_mmap_readahe
 		 * Fetch two folios so we get the chance to actually
 		 * readahead, unless we've been told not to.
 		 */
-		if (!(vm_flags & VM_RAND_READ))
+		if (!vma_test(vma, VMA_RAND_READ_BIT))
 			ra->size *= 2;
 		ra->async_size = folio_nr_pages;
 		ra->order = thp_order;
@@ -3423,7 +3425,7 @@ static struct file *do_sync_mmap_readahe
 		return fpin;
 	}
 
-	if (vm_flags & VM_EXEC) {
+	if (vma_test(vma, VMA_EXEC_BIT)) {
 		/*
 		 * Allow arch to request a preferred minimum folio order for
 		 * executable memory. This can often be beneficial to
@@ -3478,7 +3480,7 @@ static struct file *do_async_mmap_readah
 	unsigned short mmap_miss;
 
 	/* If we don't want any read-ahead, don't bother */
-	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
+	if (vma_test(vmf->vma, VMA_RAND_READ_BIT) || !ra->ra_pages)
 		return fpin;
 
 	/*
@@ -3492,7 +3494,7 @@ static struct file *do_async_mmap_readah
 	 * keep the counter symmetric.
 	 */
 	if (likely(!folio_test_locked(folio)) &&
-	    !(vmf->vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
+	    !vma_test_any(vmf->vma, VMA_SEQ_READ_BIT, VMA_EXEC_BIT)) {
 		mmap_miss = READ_ONCE(ra->mmap_miss);
 		if (mmap_miss)
 			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
@@ -3525,7 +3527,7 @@ static vm_fault_t filemap_fault_recheck_
 	 * scenarios. Recheck the PTE without PT lock firstly, thereby reducing
 	 * the number of times we hold PT lock.
 	 */
-	if (!(vma->vm_flags & VM_LOCKED))
+	if (!vma_test(vma, VMA_LOCKED_BIT))
 		return 0;
 
 	if (!(vmf->flags & FAULT_FLAG_ORIG_PTE_VALID))
@@ -4009,7 +4011,7 @@ vm_fault_t filemap_map_pages(struct vm_f
 		if ((map_ret & VM_FAULT_NOPAGE) &&
 		    !(vmf->flags & FAULT_FLAG_TRIED) &&
 		    !folio_test_workingset(folio) &&
-		    !(vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
+		    !vma_test_any(vma, VMA_SEQ_READ_BIT, VMA_EXEC_BIT)) {
 			unsigned short mmap_miss;
 
 			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-vma-read-anon_vma-carefully-in-validate_mm.patch
mm-rmap-convert-remaining-vma-flag-tests-to-use-vma_flags_t.patch
mm-migrate-convert-vma-flag-tests-to-use-vma_flags_t.patch
mm-convert-thp-vma-flag-tests-to-use-vma_flags_t.patch
mm-ksm-convert-vma-flag-tests-to-use-vma_flags_t.patch
mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t.patch
mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t.patch
fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t.patch
fs-coredump-convert-vma_dump_size-to-use-vma_flags_t.patch
uprobes-convert-vma-flag-tests-to-use-vma_flags_t.patch
perf-convert-vma-flag-tests-to-use-vma_flags_t.patch
security-convert-vma-flag-tests-to-use-vma_flags_t.patch

