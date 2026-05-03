Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC352C2346
	for <mm-commits@vger.kernel.org>; Sun,  3 May 2026 13:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777815063; cv=none; b=kfhpGDMXCtS8tXd7hsB4pXGKm+GF5UYhv+fiUNKB+gxGxBjAyAD2Glw5mW2yzYvEbbQeuJ+I840N6W2qCZ4td5is4oHb76NGZ38b1UN6cdEWp1qr+sQOQQKDcwTEus8lnmQhsQ0xifjz2v0ysVmITX56cO/9k3xV0bUlOKLkzIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777815063; c=relaxed/simple;
	bh=v8yUc+s20Z0cNTKbQLehF+iYQpGBbHPEgT1/CmNIU4A=;
	h=Date:To:From:Subject:Message-Id; b=Z/QWsv04LSAXWN4Ls3tiMwahMJt3eNhbma62CHLbOBX1T0b+xXPkJTYah6o2XGoQMzGOi29Ezs8TmgBq0Y61relVvzT9teaKfxVSZNZk8zMFuNaG5iH553DvEdCZQU3LtB1r/ZAGEdQEuWGhBEalG2uTHTE56+LYWpZgyGz5Ugw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a44IeObe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a44IeObe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A08DC2BCB4;
	Sun,  3 May 2026 13:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777815063;
	bh=v8yUc+s20Z0cNTKbQLehF+iYQpGBbHPEgT1/CmNIU4A=;
	h=Date:To:From:Subject:From;
	b=a44IeObeykC++GlStIDdvrJkx5WVSngfK+r2pWgkO8jME9vVUGV1ph5TPxAAuERwi
	 hzGgECHhdGoykfVqVXyxsCGo0mNCj9JKHfu34Kxk5JmbWHaLHx6XAIzNnCBw4M/Fd5
	 PWvA1xplNp9YUR1byqGTRQbVZ9FesCwhpZq6qLxk=
Date: Sun, 03 May 2026 06:31:00 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ying.huang@linux.alibaba.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,vbabka@suse.cz,usama.arif@linux.dev,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shivankg@amd.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,richard.weiyang@gmail.com,rdunlap@infradead.org,raquini@redhat.com,rakie.kim@sk.com,pfalcato@suse.de,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,jack@suse.cz,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,byungchul@sk.com,baohua@kernel.org,bagasdotme@gmail.com,apopple@nvidia.com,anshuman.khandual@arm.com,aarcange@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-run-khugepaged-for-all-orders.patch added to mm-new branch
Message-Id: <20260503133102.6A08DC2BCB4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: run khugepaged for all orders
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-run-khugepaged-for-all-orders.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-run-khugepaged-for-all-orders.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/khugepaged: run khugepaged for all orders
Date: Sun, 19 Apr 2026 12:57:49 -0600

If any order (m)THP is enabled we should allow running khugepaged to
attempt scanning and collapsing mTHPs.  In order for khugepaged to operate
when only mTHP sizes are specified in sysfs, we must modify the predicate
function that determines whether it ought to run to do so.

This function is currently called hugepage_pmd_enabled(), this patch
renames it to hugepage_enabled() and updates the logic to check to
determine whether any valid orders may exist which would justify
khugepaged running.

We must also update collapse_allowable_orders() to check all orders if the
vma is anonymous and the collapse is khugepaged.

After this patch khugepaged mTHP collapse is fully enabled.

Link: https://lore.kernel.org/20260419185750.260784-13-npache@redhat.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
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
Cc: Liam Howlett <liam@infradead.org>
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
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-run-khugepaged-for-all-orders
+++ a/mm/khugepaged.c
@@ -524,23 +524,23 @@ static inline int collapse_test_exit_or_
 		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
 }
 
-static bool hugepage_pmd_enabled(void)
+static bool hugepage_enabled(void)
 {
 	/*
 	 * We cover the anon, shmem and the file-backed case here; file-backed
 	 * hugepages, when configured in, are determined by the global control.
-	 * Anon pmd-sized hugepages are determined by the pmd-size control.
+	 * Anon hugepages are determined by its per-size mTHP control.
 	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
 	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
 	 */
 	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
 	    hugepage_global_enabled())
 		return true;
-	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
+	if (READ_ONCE(huge_anon_orders_always))
 		return true;
-	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
+	if (READ_ONCE(huge_anon_orders_madvise))
 		return true;
-	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
+	if (READ_ONCE(huge_anon_orders_inherit) &&
 	    hugepage_global_enabled())
 		return true;
 	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
@@ -581,7 +581,13 @@ void __khugepaged_enter(struct mm_struct
 static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
 		enum tva_type tva_flags)
 {
-	unsigned long orders = BIT(HPAGE_PMD_ORDER);
+	unsigned long orders;
+
+	/* If khugepaged is scanning an anonymous vma, allow mTHP collapse */
+	if ((tva_flags & TVA_KHUGEPAGED) && vma_is_anonymous(vma))
+		orders = THP_ORDERS_ALL_ANON;
+	else
+		orders = BIT(HPAGE_PMD_ORDER);
 
 	return thp_vma_allowable_orders(vma, vma->vm_flags, tva_flags, orders);
 }
@@ -589,7 +595,7 @@ static unsigned long collapse_allowable_
 void khugepaged_enter_vma(struct vm_area_struct *vma)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
-	    hugepage_pmd_enabled()) {
+	    hugepage_enabled()) {
 		if (collapse_allowable_orders(vma, TVA_KHUGEPAGED))
 			__khugepaged_enter(vma->vm_mm);
 	}
@@ -2936,7 +2942,7 @@ breakouterloop_mmap_lock:
 
 static int khugepaged_has_work(void)
 {
-	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
+	return !list_empty(&khugepaged_scan.mm_head) && hugepage_enabled();
 }
 
 static int khugepaged_wait_event(void)
@@ -3009,7 +3015,7 @@ static void khugepaged_wait_work(void)
 		return;
 	}
 
-	if (hugepage_pmd_enabled())
+	if (hugepage_enabled())
 		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
 }
 
@@ -3040,7 +3046,7 @@ void set_recommended_min_free_kbytes(voi
 	int nr_zones = 0;
 	unsigned long recommended_min;
 
-	if (!hugepage_pmd_enabled()) {
+	if (!hugepage_enabled()) {
 		calculate_min_free_kbytes();
 		goto update_wmarks;
 	}
@@ -3090,7 +3096,7 @@ int start_stop_khugepaged(void)
 	int err = 0;
 
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled()) {
+	if (hugepage_enabled()) {
 		if (!khugepaged_thread)
 			khugepaged_thread = kthread_run(khugepaged, NULL,
 							"khugepaged");
@@ -3116,7 +3122,7 @@ fail:
 void khugepaged_min_free_kbytes_update(void)
 {
 	mutex_lock(&khugepaged_mutex);
-	if (hugepage_pmd_enabled() && khugepaged_thread)
+	if (hugepage_enabled() && khugepaged_thread)
 		set_recommended_min_free_kbytes();
 	mutex_unlock(&khugepaged_mutex);
 }
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

revert-tmpfs-dont-enable-large-folios-if-not-supported.patch
mm-khugepaged-run-khugepaged-for-all-orders.patch

