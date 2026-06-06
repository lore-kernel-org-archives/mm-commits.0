Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8B717A300
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 00:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780706383; cv=none; b=R1Qb9xS5e/onLHPr3d39QlXCDfi1jjNH6PRwXbvGz7N//UdqH0oKC/HREA0VUm6+5SgF4wV8GciFVKjiCQ9G+hhe0ku7wPYVEWZMrUWP4uPgulwZUR0Iiv0D01slLpJRRbCrcEyrWMAvSH1Te5oc7aHn47ivh+iC5sDrj9eRBlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780706383; c=relaxed/simple;
	bh=mJhYzBpLBI4wW+2+UTfK+iHE+7WH3u3Xl+U/TIjplXM=;
	h=Date:To:From:Subject:Message-Id; b=bSa9WQGNcjCmTnaVZE60p51Kh2Pl9Wq0hvjEehTAAD5oumC+SSjtyA5Th9f3X1rQcqvVL5AyfVkWjV3ZmQhTgoy6khSDEyFCJcI/oQaZfD5QD2ejLzqXF882MOf9hY0EnnKht6XK1cDHML05y0rpjdARM16nJzYwPr/bUaBX4qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hRceAOTT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hRceAOTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B89C1F00893;
	Sat,  6 Jun 2026 00:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780706381;
	bh=wpOuzfXFP24t5AWtEo7ESkpn5Wdo8VaZc3KVAo+z3xA=;
	h=Date:To:From:Subject;
	b=hRceAOTTioTT2z7jUi34b05AKOUGuU4vrFQtWOzqbRWv3mYf37nZIVOeK1UQsIt51
	 DiBOMOYn0KAOAPFmtFRhxX1h32qCK8ottoabEZ3uJ1BAYWqdNigcd+QUSLUojmVISA
	 +OG4Ulm6xS2Mm7SQMZCM0KdVrSgETt9YRA7pbGOk=
Date: Fri, 05 Jun 2026 17:39:40 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-require-collapse_huge_page-to-enter-exit-with-the-lock-dropped.patch added to mm-unstable branch
Message-Id: <20260606003941.2B89C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: require collapse_huge_page to enter/exit with the lock dropped
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-require-collapse_huge_page-to-enter-exit-with-the-lock-dropped.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-require-collapse_huge_page-to-enter-exit-with-the-lock-dropped.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Nico Pache <npache@redhat.com>
Subject: mm/khugepaged: require collapse_huge_page to enter/exit with the lock dropped
Date: Fri, 5 Jun 2026 10:14:12 -0600

Currently the collapse_huge_page function requires the mmap_read_lock to
enter with it held, and exit with it dropped.  This function moves the
unlock into its parent caller, and changes this semantic to requiring it
to enter/exit with it always unlocked.

In future patches, we need this expectation, as for in mTHP collapse, we
may have already dropped the lock, and do not want to conditionally check
for this by passing through the lock_dropped variable.

No functional change is expected as one of the first things the
collapse_huge_page function does is drop this lock before allocating the
hugepage.

Link: https://lore.kernel.org/20260605161422.213817-6-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
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
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
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
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-require-collapse_huge_page-to-enter-exit-with-the-lock-dropped
+++ a/mm/khugepaged.c
@@ -1222,6 +1222,12 @@ static enum scan_result alloc_charge_fol
 	return SCAN_SUCCEED;
 }
 
+/*
+ * collapse_huge_page expects the mmap_lock to be unlocked before entering and
+ * will always return with the lock unlocked, to avoid holding the mmap_lock
+ * while allocating a THP, as that could trigger direct reclaim/compaction.
+ * Note that the VMA must be rechecked after grabbing the mmap_lock again.
+ */
 static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
 		int referenced, int unmapped, struct collapse_control *cc)
 {
@@ -1237,14 +1243,6 @@ static enum scan_result collapse_huge_pa
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
-	/*
-	 * Before allocating the hugepage, release the mmap_lock read lock.
-	 * The allocation can take potentially a long time if it involves
-	 * sync compaction, and we do not need to hold the mmap_lock during
-	 * that. We will recheck the vma after taking it again in write mode.
-	 */
-	mmap_read_unlock(mm);
-
 	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
 	if (result != SCAN_SUCCEED)
 		goto out_nolock;
@@ -1554,6 +1552,8 @@ static enum scan_result collapse_scan_pm
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
 	if (result == SCAN_SUCCEED) {
+		/* collapse_huge_page expects the lock to be dropped before calling */
+		mmap_read_unlock(mm);
 		result = collapse_huge_page(mm, start_addr, referenced,
 					    unmapped, cc);
 		/* collapse_huge_page will return with the mmap_lock released */
_

Patches currently in -mm which might be from npache@redhat.com are

mm-khugepaged-generalize-hugepage_vma_revalidate-for-mthp-support.patch
mm-khugepaged-rework-max_ptes_-handling-with-helper-functions.patch
mm-khugepaged-generalize-__collapse_huge_page_-for-mthp-support.patch
mm-khugepaged-require-collapse_huge_page-to-enter-exit-with-the-lock-dropped.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse.patch
mm-khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
mm-khugepaged-add-per-order-mthp-collapse-failure-statistics.patch
mm-khugepaged-improve-tracepoints-for-mthp-orders.patch
mm-khugepaged-introduce-collapse_possible_orders-helper-functions.patch
mm-khugepaged-introduce-mthp-collapse-support.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

