Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3686B86337
	for <mm-commits@vger.kernel.org>; Thu,  5 Jun 2025 06:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749103536; cv=none; b=kNclSJlKKhgypM5jhKZ6tDnGLWNEuf5NL8Nt9QFBrH2zRqymaKaSm//IUL2X6wC7JvdgWtqrT5P29ktfY9h8PlQV+lndUbboXy6P+ZUl11LjULdfz4odpkWTL8dxBa9wixRU/9ckuHzFH1zUIpkIF/LtNCMWgLKDWoWMWa5qmXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749103536; c=relaxed/simple;
	bh=iqOZwUe75K/fo0Ralz52fACSYkJI3UkeGHz+lqNeLjo=;
	h=Date:To:From:Subject:Message-Id; b=cIjLHyA3SHzfoqkDbMMQWB3yM9ng3Yw3zZ5vNLfV/+hrfkbDFgCeh1+fzyqYMEbqSbskAl5JHd0UuzsxXuwBsajk2Ni1ruWr5H40RsiLYbVOiEAPHttbnu9s2IFt5Yq6n63RAX33lhUPWBs4y1v8URbaqqz9uIjnASsFl/FyNU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hSBdGROX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hSBdGROX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B686C4CEE7;
	Thu,  5 Jun 2025 06:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749103535;
	bh=iqOZwUe75K/fo0Ralz52fACSYkJI3UkeGHz+lqNeLjo=;
	h=Date:To:From:Subject:From;
	b=hSBdGROX3dSNC2Ylu4qBjvFASp5fUtxORT1SOBqK45N3QGGYfaqlTGAT1su155z4B
	 06tRJDLyalGVrQyEOV4BkDSEKVYYv871zCRSuLV12+TrjtPWz/ixTulstGDCWUG7rY
	 2tbDi1M+OoQNazkKChu5VFHcBbdPJLEkS5MUiiDs=
Date: Wed, 04 Jun 2025 23:05:34 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,ryan.roberts@arm.com,rostedt@goodmis.org,rientjes@google.com,rdunlap@infradead.org,raquini@redhat.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,cl@gentwo.org,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,aarcange@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch removed from -mm tree
Message-Id: <20250605060535.3B686C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: khugepaged: allow khugepaged to check all anonymous mTHP orders
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: khugepaged: allow khugepaged to check all anonymous mTHP orders
Date: Wed, 28 May 2025 20:31:46 +0800

We have now allowed mTHP collapse, but thp_vma_allowable_order() still
only checks if the PMD-sized mTHP is allowed to collapse.  This prevents
scanning and collapsing of 64K mTHP when only 64K mTHP is enabled.  Thus,
we should modify the checks to allow all large orders of anonymous mTHP.

Link: https://lkml.kernel.org/r/ac9ed6d71b439611f9c94b3506a8ce975d4636e9.1748435162.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter (Ampere) <cl@gentwo.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Rafael Aquini <raquini@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Reported-by:Takashi Iwai <tiwai@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders
+++ a/mm/khugepaged.c
@@ -474,8 +474,11 @@ void khugepaged_enter_vma(struct vm_area
 {
 	if (!test_bit(MMF_VM_HUGEPAGE, &vma->vm_mm->flags) &&
 	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_ENFORCE_SYSFS,
-					    PMD_ORDER))
+		unsigned long orders = vma_is_anonymous(vma) ?
+					THP_ORDERS_ALL_ANON : BIT(PMD_ORDER);
+
+		if (thp_vma_allowable_orders(vma, vm_flags, TVA_ENFORCE_SYSFS,
+					    orders))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -2399,6 +2402,8 @@ static unsigned int khugepaged_scan_mm_s
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
 	for_each_vma(vmi, vma) {
+		unsigned long orders = vma_is_anonymous(vma) ?
+					THP_ORDERS_ALL_ANON : BIT(PMD_ORDER);
 		unsigned long hstart, hend;
 
 		cond_resched();
@@ -2406,8 +2411,8 @@ static unsigned int khugepaged_scan_mm_s
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags,
-					TVA_ENFORCE_SYSFS, PMD_ORDER)) {
+		if (!thp_vma_allowable_orders(vma, vma->vm_flags,
+					TVA_ENFORCE_SYSFS, orders)) {
 skip:
 			progress++;
 			continue;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-khugepaged-kick-khugepaged-for-enabling-none-pmd-sized-mthps.patch
mm-fix-the-inaccurate-memory-statistics-issue-for-users.patch

