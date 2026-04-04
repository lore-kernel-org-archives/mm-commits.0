Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9487260D
	for <mm-commits@vger.kernel.org>; Sat,  4 Apr 2026 00:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775263587; cv=none; b=hJl374g4HNCA8bmSI17txs3m/UUspbo3QZJMN7/+U/yF4O7TOBJiZDrhTlswFcE3CpE0rd5PyV56KAp/Ld+m2Gu4V9MF8idomuvgoH0GKILLs9EFS/xxTaH2XsFB/rdWuQXU6tcWF9C0O3wnK7v0kKHtfhpQj6UiBNF/34uhZiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775263587; c=relaxed/simple;
	bh=2iG9Z8KXvZ7p+c6sjkAAhR24Gx0NyCsEBWT/ILpBA4w=;
	h=Date:To:From:Subject:Message-Id; b=nY/PXcyEne5zSR2XoFvfWWN14ADo1dvzWTkMDeVr3x4sDh7P97zzQhoETnx0cEfG1aTHdFbksB0x5rxS3iO0MqDlwq1EBeqOOn922SfVyt/ogGn3CaMbaAkBzKjZtWhknVZB9CK3ksyBReC8S1lCUOo+8rnicxy4SkGH8GBvJSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xceRwMzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xceRwMzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67645C4CEF7;
	Sat,  4 Apr 2026 00:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775263586;
	bh=2iG9Z8KXvZ7p+c6sjkAAhR24Gx0NyCsEBWT/ILpBA4w=;
	h=Date:To:From:Subject:From;
	b=xceRwMzJQznTliPVd4nzbELKiSyd2lrfcHBORggLaNQ4tU/L5EkAwoCcqc9Z8db2h
	 wMVL/kVQuYE7r2Uz42Q7BCm8hkKmf++sQRe/9VxdhE+bYWle8727DSpuWjJShy2VlA
	 KNvzVxuXtb+WdrMtfk7O6Wi03q4gyH4e34+qXbgA=
Date: Fri, 03 Apr 2026 17:46:25 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ying.huang@linux.alibaba.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,vbabka@suse.cz,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shivankg@amd.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,richard.weiyang@gmail.com,rdunlap@infradead.org,raquini@redhat.com,rakie.kim@sk.com,pfalcato@suse.de,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,mathieu.desnoyers@efficios.com,liam.howlett@oracle.com,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,jack@suse.cz,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,anshuman.khandual@arm.com,aarcange@redhat.com,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-fix-issue-with-tracking-lock.patch removed from -mm tree
Message-Id: <20260404004626.67645C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: fix issue with tracking lock
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-issue-with-tracking-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

maintainers-update-mglru-entry-to-reflect-current-status.patch
tools-testing-selftests-add-merge-test-for-partial-msealed-range.patch

