Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158A038332F
	for <mm-commits@vger.kernel.org>; Fri, 22 May 2026 20:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779481577; cv=none; b=PObchjG7M5l7YBdLXcCXmjoM7zfmnMQ3oBP7aOTwLDSJnVCT+gSnsv1RfkmuplT2K/ZwuRUPZkEVuKq/vcggKeC+OmDtNocjAjzdJrtAheRONi5juWc+83MZdIlHaITbnUpU2c8tCLtCULL1Ja7xiR+ReQuZoc/ZlUvK5UR2Atw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779481577; c=relaxed/simple;
	bh=2IQXb80Kta1XtMTb27PBN6mePt75N2C/w6qrS3OM44s=;
	h=Date:To:From:Subject:Message-Id; b=CWRsGkLQJpHQRMcnw/K850jAjynI2y/sC7gdBCu8gNRu3Q25Zz9hew5GljhNhrrsTTTBpU+tZXzo09TVoynU4nszVojlZdZjQl6GSU/PtyRAKSXQnFHpHiOPWOidBhqN1Bm6lX2Il9P6hQkTXiFslpf/lbN7Ig5vtattaQy8BXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dtOKLrbF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dtOKLrbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBE51F00A3D;
	Fri, 22 May 2026 20:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779481575;
	bh=QxYOthcETRtKEnJb9KPR/DdoeYS943EOdf5NL7fVT7A=;
	h=Date:To:From:Subject;
	b=dtOKLrbFKqPH1h6rouik7limUGJpFqu7GnsgM51P/SKpTRXm+GycCPVekFQjnVRYl
	 a9lERLbK2Njc51FYHJPVg0w/9AsoMi9IglVgH2kH7slrjg6qD8MqbqmXhIyTuvyy2h
	 i4F0CznlTd88CVGnwI+mByLvvyk7LgypvACqVlhc=
Date: Fri, 22 May 2026 13:26:15 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-require-collapse_huge_page-to-enter-exit-with-the-lock-dropped.patch removed from -mm tree
Message-Id: <20260522202615.CBBE51F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: require collapse_huge_page to enter/exit with the lock dropped
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-require-collapse_huge_page-to-enter-exit-with-the-lock-dropped.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm/khugepaged: require collapse_huge_page to enter/exit with the lock dropped
Date: Mon, 11 May 2026 12:58:05 -0600

Currently the collapse_huge_page function requires the mmap_read_lock to
enter with it held, and exit with it dropped.  This function moves the
unlock into its parent caller, and changes this semantic to requiring it
to enter/exit with it always unlocked.

In future patches, we need this expectation, as for in mTHP collapse, we
may have already have dropped the lock, and do not want to conditionally
check for this by passing through the lock_dropped variable.

No functional change is expected as one of the first things the
collapse_huge_page function does is drop this lock before allocating the
hugepage.

Link: https://lore.kernel.org/20260511185817.686831-6-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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
Cc: Lorenzo Stoakes <ljs@kernel.org>
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
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-require-collapse_huge_page-to-enter-exit-with-the-lock-dropped
+++ a/mm/khugepaged.c
@@ -1199,6 +1199,14 @@ static enum scan_result alloc_charge_fol
 	return SCAN_SUCCEED;
 }
 
+/*
+ * collapse_huge_page expects the mmap_read_lock to be dropped before
+ * entering this function. The function will also always return with the lock
+ * dropped. The function starts by allocation a folio, which can potentially
+ * take a long time if it involves sync compaction, and we do not need to hold
+ * the mmap_lock during that. We must recheck the vma after taking it again in
+ * write mode.
+ */
 static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
 		int referenced, int unmapped, struct collapse_control *cc)
 {
@@ -1214,14 +1222,6 @@ static enum scan_result collapse_huge_pa
 
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
@@ -1526,6 +1526,8 @@ static enum scan_result collapse_scan_pm
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

a.patch
mm-khugepaged-generalize-collapse_huge_page-for-mthp-collapse.patch
mm-khugepaged-skip-collapsing-mthp-to-smaller-orders.patch
mm-khugepaged-add-per-order-mthp-collapse-failure-statistics.patch
mm-khugepaged-improve-tracepoints-for-mthp-orders.patch
mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch
mm-khugepaged-introduce-mthp-collapse-support.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

