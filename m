Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637F33E5EF9
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 21:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774992949; cv=none; b=WD8wKbeKn4p2qiozd2NenG4GEEGu9tptvjwom32OzfT+kuZ85H+k57JCqfe8eVobSbb+FrcGCU03d0WXmM7aEUpnRJnB4qA1f7jPYBZJ+14L4difKkSIP0R6YZmNVXRvsyEBDyZOGykhrxWI/XSp15lgdgX6WdckKtUzAgvAfH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774992949; c=relaxed/simple;
	bh=t72Bcdc0X/uHHjG/WOTIMeotjmrzr7Z0/gfsZUg/lnU=;
	h=Date:To:From:Subject:Message-Id; b=Pm77uRkwFLFYcGAwHEqZU9+scczM7zpeUmbXuoYLYVLdGpr77gOcb63h0pNMwR9rl7AOY1wHtiRg+1XPLNkMBCn1l1aGNMcDetcchfM5GsCFN85PMTg1FI8xEXOjURfOXoNcOOd3WePWLxWX0XFE454yV2yp+5xRxNHq4ugpNt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gr4c4nKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gr4c4nKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F10C19423;
	Tue, 31 Mar 2026 21:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774992949;
	bh=t72Bcdc0X/uHHjG/WOTIMeotjmrzr7Z0/gfsZUg/lnU=;
	h=Date:To:From:Subject:From;
	b=gr4c4nKRCI0BnaAqaxEBTYZQHPVP03wMtPsJghC6jbZrTfmcAgjynqA5lPC8R0IhD
	 0RCDS2utLhxQgcV/QuqNLmaMXgI6lVCyaORKk3Qi7H2B5oTWq+DRAryM/feS4y1XBB
	 kgfomkyu7JDyNJGvJMOodCAANVo5R7Pfy3yBv5ek=
Date: Tue, 31 Mar 2026 14:35:48 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ying.huang@linux.alibaba.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,vbabka@suse.cz,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shivankg@amd.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,richard.weiyang@gmail.com,rdunlap@infradead.org,raquini@redhat.com,rakie.kim@sk.com,pfalcato@suse.de,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,mathieu.desnoyers@efficios.com,liam.howlett@oracle.com,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,jack@suse.cz,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,aarcange@redhat.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-fix-issue-with-tracking-lock.patch added to mm-unstable branch
Message-Id: <20260331213548.D9F10C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/khugepaged: fix issue with tracking lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-fix-issue-with-tracking-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-fix-issue-with-tracking-lock.patch

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
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: mm/khugepaged: fix issue with tracking lock
Date: Tue, 31 Mar 2026 13:11:18 +0100

We are incorrectly treating lock_dropped to track both whether the lock is
currently held and whether or not the lock was ever dropped.

Update this change to account for this.

Link: https://lkml.kernel.org/r/7760c811-e100-4d40-9217-0813c28314be@lucifer.local
Fixes: 330f3758a3bc ("mm/khugepaged: unify khugepaged and madv_collapse with collapse_single_pmd()")
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
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

 mm/khugepaged.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-issue-with-tracking-lock
+++ a/mm/khugepaged.c
@@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_stru
 	unsigned long hstart, hend, addr;
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
+	bool mmap_unlocked = false;
 
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
@@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_stru
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
 
-		if (*lock_dropped) {
+		if (mmap_unlocked) {
 			cond_resched();
 			mmap_read_lock(mm);
-			*lock_dropped = false;
+			mmap_unlocked = false;
+			*lock_dropped = true;
 			result = hugepage_vma_revalidate(mm, addr, false, &vma,
 							 cc);
 			if (result  != SCAN_SUCCEED) {
@@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_stru
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
 
-		result = collapse_single_pmd(addr, vma, lock_dropped, cc);
+		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
 
 		switch (result) {
 		case SCAN_SUCCEED:
@@ -2893,8 +2895,10 @@ int madvise_collapse(struct vm_area_stru
 
 out_maybelock:
 	/* Caller expects us to hold mmap_lock on return */
-	if (*lock_dropped)
+	if (mmap_unlocked) {
+		*lock_dropped = true;
 		mmap_read_lock(mm);
+	}
 out_nolock:
 	mmap_assert_locked(mm);
 	mmdrop(mm);
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-khugepaged-fix-issue-with-tracking-lock.patch
maintainers-update-mglru-entry-to-reflect-current-status.patch
selftests-mm-add-merge-test-for-partial-msealed-range.patch

