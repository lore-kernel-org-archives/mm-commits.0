Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02D3255E43
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744911; cv=none; b=RzSkOKaBDjbvvljYQlZv7s0EHEgZvtzaFJcuNhltXN1WSmDUhfbJWNeuXBgld4OHUrjhq3DxoUZxMD/iXsRIN987D0SU5uC2mek0D6TvDXhZGr69mnGzMyGo0nvIYRMTjX8PMRUMx2V3QgW+FY16kT+Ok80XKYi7LjmUl/Mi3jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744911; c=relaxed/simple;
	bh=/ja4deF+Ok60gReBTf6BELb9XSg8emOi3GP3fY0ZIqU=;
	h=Date:To:From:Subject:Message-Id; b=Bw/GVhGEMuO4E2bw3Yi6fzMd7VZAfAwVqhMa+dHwExwtaCFNbJ5hnYaUVc//bMgZ6+6JkCU4hWZIFRyBMoVsu6puxT4ixv2QyOSZ8TjKXwsuSnQ3aT45Kgd/2ZExihnwwKkObY8k7QT7iiE23klIfy9HBupXKoM6LpB2NpTXVhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gJXW33ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gJXW33ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817FCC4CEF7;
	Sun, 29 Mar 2026 00:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744911;
	bh=/ja4deF+Ok60gReBTf6BELb9XSg8emOi3GP3fY0ZIqU=;
	h=Date:To:From:Subject:From;
	b=gJXW33otKUTWFbgjy98MuUrFm3XO0qKHPuQTz1MDdZvtAvBC5TOQl+DKJ0l0hBzHf
	 +T7TLmULUTH+b6kNtxhtvUtdZiV4hgj6gPJiu9DD3tqS6oIvw/MoFiNw9S3rGcrhKb
	 Y1PqR5+ZDuu3HSXxzMxP/Uy6tJrM46Bdi1kmmWrg=
Date: Sat, 28 Mar 2026 17:41:51 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ying.huang@linux.alibaba.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,vbabka@suse.cz,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shivankg@amd.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,richard.weiyang@gmail.com,rdunlap@infradead.org,raquini@redhat.com,rakie.kim@sk.com,pfalcato@suse.de,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,ljs@kernel.org,liam.howlett@oracle.com,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,jack@suse.cz,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-unify-khugepaged-and-madv_collapse-with-collapse_single_pmd.patch removed from -mm tree
Message-Id: <20260329004151.817FCC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: unify khugepaged and madv_collapse with collapse_single_pmd()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-unify-khugepaged-and-madv_collapse-with-collapse_single_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm/khugepaged: unify khugepaged and madv_collapse with collapse_single_pmd()
Date: Wed, 25 Mar 2026 05:40:22 -0600

The khugepaged daemon and madvise_collapse have two different
implementations that do almost the same thing.  Create collapse_single_pmd
to increase code reuse and create an entry point to these two users.

Refactor madvise_collapse and collapse_scan_mm_slot to use the new
collapse_single_pmd function.  To help reduce confusion around the
mmap_locked variable, we rename mmap_locked to lock_dropped in the
collapse_scan_mm_slot() function, and remove the redundant mmap_locked in
madvise_collapse(); this further unifies the code readiblity.  the
SCAN_PTE_MAPPED_HUGEPAGE enum is no longer reachable in the
madvise_collapse() function, so we drop it from the list of "continuing"
enums.

This introduces a minor behavioral change that is most likely an
undiscovered bug.  The current implementation of khugepaged tests
collapse_test_exit_or_disable() before calling collapse_pte_mapped_thp,
but we weren't doing it in the madvise_collapse case.  By unifying these
two callers madvise_collapse now also performs this check.  We also modify
the return value to be SCAN_ANY_PROCESS which properly indicates that this
process is no longer valid to operate on.

By moving the madvise_collapse writeback-retry logic into the helper
function we can also avoid having to revalidate the VMA.

We guard the khugepaged_pages_collapsed variable to ensure its only
incremented for khugepaged.

As requested we also convert a VM_BUG_ON to a VM_WARN_ON.

Link: https://lkml.kernel.org/r/20260325114022.444081-6-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shivank Garg <shivankg@amd.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Takashi Iwai (SUSE) <tiwai@suse.de>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |  144 +++++++++++++++++++++++-----------------------
 1 file changed, 73 insertions(+), 71 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-unify-khugepaged-and-madv_collapse-with-collapse_single_pmd
+++ a/mm/khugepaged.c
@@ -1250,7 +1250,7 @@ out_nolock:
 
 static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		struct vm_area_struct *vma, unsigned long start_addr,
-		bool *mmap_locked, struct collapse_control *cc)
+		bool *lock_dropped, struct collapse_control *cc)
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
@@ -1425,7 +1425,7 @@ out_unmap:
 		result = collapse_huge_page(mm, start_addr, referenced,
 					    unmapped, cc);
 		/* collapse_huge_page will return with the mmap_lock released */
-		*mmap_locked = false;
+		*lock_dropped = true;
 	}
 out:
 	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
@@ -2417,6 +2417,67 @@ static enum scan_result collapse_scan_fi
 	return result;
 }
 
+/*
+ * Try to collapse a single PMD starting at a PMD aligned addr, and return
+ * the results.
+ */
+static enum scan_result collapse_single_pmd(unsigned long addr,
+		struct vm_area_struct *vma, bool *lock_dropped,
+		struct collapse_control *cc)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	bool triggered_wb = false;
+	enum scan_result result;
+	struct file *file;
+	pgoff_t pgoff;
+
+	mmap_assert_locked(mm);
+
+	if (vma_is_anonymous(vma)) {
+		result = collapse_scan_pmd(mm, vma, addr, lock_dropped, cc);
+		goto end;
+	}
+
+	file = get_file(vma->vm_file);
+	pgoff = linear_page_index(vma, addr);
+
+	mmap_read_unlock(mm);
+	*lock_dropped = true;
+retry:
+	result = collapse_scan_file(mm, addr, file, pgoff, cc);
+
+	/*
+	 * For MADV_COLLAPSE, when encountering dirty pages, try to writeback,
+	 * then retry the collapse one time.
+	 */
+	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
+	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
+		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
+		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
+
+		filemap_write_and_wait_range(file->f_mapping, lstart, lend);
+		triggered_wb = true;
+		goto retry;
+	}
+	fput(file);
+
+	if (result == SCAN_PTE_MAPPED_HUGEPAGE) {
+		mmap_read_lock(mm);
+		if (collapse_test_exit_or_disable(mm))
+			result = SCAN_ANY_PROCESS;
+		else
+			result = try_collapse_pte_mapped_thp(mm, addr,
+							     !cc->is_khugepaged);
+		if (result == SCAN_PMD_MAPPED)
+			result = SCAN_SUCCEED;
+		mmap_read_unlock(mm);
+	}
+end:
+	if (cc->is_khugepaged && result == SCAN_SUCCEED)
+		++khugepaged_pages_collapsed;
+	return result;
+}
+
 static void collapse_scan_mm_slot(unsigned int progress_max,
 		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
@@ -2478,46 +2539,21 @@ static void collapse_scan_mm_slot(unsign
 		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
 
 		while (khugepaged_scan.address < hend) {
-			bool mmap_locked = true;
+			bool lock_dropped = false;
 
 			cond_resched();
 			if (unlikely(collapse_test_exit_or_disable(mm)))
 				goto breakouterloop;
 
-			VM_BUG_ON(khugepaged_scan.address < hstart ||
+			VM_WARN_ON_ONCE(khugepaged_scan.address < hstart ||
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
 				  hend);
-			if (!vma_is_anonymous(vma)) {
-				struct file *file = get_file(vma->vm_file);
-				pgoff_t pgoff = linear_page_index(vma,
-						khugepaged_scan.address);
-
-				mmap_read_unlock(mm);
-				mmap_locked = false;
-				*result = collapse_scan_file(mm,
-					khugepaged_scan.address, file, pgoff, cc);
-				fput(file);
-				if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
-					mmap_read_lock(mm);
-					if (collapse_test_exit_or_disable(mm))
-						goto breakouterloop;
-					*result = try_collapse_pte_mapped_thp(mm,
-						khugepaged_scan.address, false);
-					if (*result == SCAN_PMD_MAPPED)
-						*result = SCAN_SUCCEED;
-					mmap_read_unlock(mm);
-				}
-			} else {
-				*result = collapse_scan_pmd(mm, vma,
-					khugepaged_scan.address, &mmap_locked, cc);
-			}
-
-			if (*result == SCAN_SUCCEED)
-				++khugepaged_pages_collapsed;
 
+			*result = collapse_single_pmd(khugepaged_scan.address,
+						      vma, &lock_dropped, cc);
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			if (!mmap_locked)
+			if (lock_dropped)
 				/*
 				 * We released mmap_lock so break loop.  Note
 				 * that we drop mmap_lock before all hugepage
@@ -2792,7 +2828,6 @@ int madvise_collapse(struct vm_area_stru
 	unsigned long hstart, hend, addr;
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
-	bool mmap_locked = true;
 
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
@@ -2814,13 +2849,11 @@ int madvise_collapse(struct vm_area_stru
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
-		bool triggered_wb = false;
 
-retry:
-		if (!mmap_locked) {
+		if (*lock_dropped) {
 			cond_resched();
 			mmap_read_lock(mm);
-			mmap_locked = true;
+			*lock_dropped = false;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
 							 cc);
 			if (result  != SCAN_SUCCEED) {
@@ -2830,45 +2863,14 @@ retry:
 
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
-		mmap_assert_locked(mm);
-		if (!vma_is_anonymous(vma)) {
-			struct file *file = get_file(vma->vm_file);
-			pgoff_t pgoff = linear_page_index(vma, addr);
-
-			mmap_read_unlock(mm);
-			mmap_locked = false;
-			*lock_dropped = true;
-			result = collapse_scan_file(mm, addr, file, pgoff, cc);
-
-			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
-			    mapping_can_writeback(file->f_mapping)) {
-				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
-				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
-
-				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
-				triggered_wb = true;
-				fput(file);
-				goto retry;
-			}
-			fput(file);
-		} else {
-			result = collapse_scan_pmd(mm, vma, addr, &mmap_locked, cc);
-		}
-		if (!mmap_locked)
-			*lock_dropped = true;
 
-handle_result:
+		result = collapse_single_pmd(addr, vma, lock_dropped, cc);
+
 		switch (result) {
 		case SCAN_SUCCEED:
 		case SCAN_PMD_MAPPED:
 			++thps;
 			break;
-		case SCAN_PTE_MAPPED_HUGEPAGE:
-			BUG_ON(mmap_locked);
-			mmap_read_lock(mm);
-			result = try_collapse_pte_mapped_thp(mm, addr, true);
-			mmap_read_unlock(mm);
-			goto handle_result;
 		/* Whitelisted set of results where continuing OK */
 		case SCAN_NO_PTE_TABLE:
 		case SCAN_PTE_NON_PRESENT:
@@ -2891,7 +2893,7 @@ handle_result:
 
 out_maybelock:
 	/* Caller expects us to hold mmap_lock on return */
-	if (!mmap_locked)
+	if (*lock_dropped)
 		mmap_read_lock(mm);
 out_nolock:
 	mmap_assert_locked(mm);
_

Patches currently in -mm which might be from npache@redhat.com are


