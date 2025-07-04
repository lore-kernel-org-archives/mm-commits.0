Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5D0BE65
	for <mm-commits@vger.kernel.org>; Fri,  4 Jul 2025 00:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751590768; cv=none; b=b3roa3WOXRpckE4LhOrrRfsoCDGPUDnAnhmvcPcnJvw6T6u2uaWJOC+ZuGGjbKRgGKwreB/UUq6Tmt4R3jeTSD6jgq87zxvbbiwF3HycXu7IRk1pKkBospyQFm9tLMCfPIVyByvR/udUT1lqsVpNsfD1byAm+GFxU9DxxMxLvJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751590768; c=relaxed/simple;
	bh=he9OPp9NTebsGF1yz8+ahfA1FB8NBKAzFjOk8ZklVKo=;
	h=Date:To:From:Subject:Message-Id; b=Qt/gm8oJ+whPnfSao6GaaCdTMhnRJ+63Erva6r/sw8s2/HqzVepBTUTyVbCNZHcd9cP+DiVnouTUZb+QI1LwOfzujmrSJvhWrXQK0wxSqWK4SK6gxxok11LjQa6uhxfy6ZEVGOTHgJmwIDPHLpBFNv7uc/zOBe/jhtSioRINWy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yo5vAsf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yo5vAsf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED2AC4CEE3;
	Fri,  4 Jul 2025 00:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1751590768;
	bh=he9OPp9NTebsGF1yz8+ahfA1FB8NBKAzFjOk8ZklVKo=;
	h=Date:To:From:Subject:From;
	b=yo5vAsf9Yt6W3lq20NXCqAnZFABvxfUdZyszhFyfRWiLwPs5syNdrkUN8LKwh5l44
	 rGGmi15Be97z6DA0y0/Ldktb9HzCcWGlLElhGU1z53TGEeCmheoTOSNLLAHuXPpcfG
	 +/fUEKP3ozqsXU3S4WMgtcDk9mLy7nNwc7Pkf0BA=
Date: Thu, 03 Jul 2025 17:59:27 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,ryan.roberts@arm.com,rostedt@goodmis.org,rientjes@google.com,rdunlap@infradead.org,raquini@redhat.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,cl@gentwo.org,catalin.marinas@arm.com,baohua@kernel.org,bagasdotme@gmail.com,anshuman.khandual@arm.com,aarcange@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch added to mm-new branch
Message-Id: <20250704005927.DED2AC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: khugepaged: allow khugepaged to check all anonymous mTHP orders
has been added to the -mm mm-new branch.  Its filename is
     khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: khugepaged: allow khugepaged to check all anonymous mTHP orders
Date: Tue, 1 Jul 2025 23:57:37 -0600

We have now allowed mTHP collapse, but thp_vma_allowable_order() still
only checks if the PMD-sized mTHP is allowed to collapse.  This prevents
scanning and collapsing of 64K mTHP when only 64K mTHP is enabled.  Thus,
we should modify the checks to allow all large orders of anonymous mTHP.

Link: https://lkml.kernel.org/r/20250702055742.102808-11-npache@redhat.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
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
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/khugepaged.c~khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders
+++ a/mm/khugepaged.c
@@ -491,8 +491,11 @@ void khugepaged_enter_vma(struct vm_area
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
@@ -2612,6 +2615,8 @@ static unsigned int khugepaged_scan_mm_s
 
 	vma_iter_init(&vmi, mm, khugepaged_scan.address);
 	for_each_vma(vmi, vma) {
+		unsigned long orders = vma_is_anonymous(vma) ?
+					THP_ORDERS_ALL_ANON : BIT(PMD_ORDER);
 		unsigned long hstart, hend;
 
 		cond_resched();
@@ -2619,8 +2624,8 @@ static unsigned int khugepaged_scan_mm_s
 			progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags,
-					TVA_ENFORCE_SYSFS, PMD_ORDER)) {
+		if (!thp_vma_allowable_orders(vma, vma->vm_flags,
+			TVA_ENFORCE_SYSFS, orders)) {
 skip:
 			progress++;
 			continue;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-fix-the-inaccurate-memory-statistics-issue-for-users.patch
selftests-khugepaged-fix-the-shmem-collapse-failure.patch
selftests-mm-add-shmem-collapse-as-a-default-test-item.patch
mm-huge_memory-fix-the-check-for-allowed-huge-orders-in-shmem.patch
khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch
khugepaged-kick-khugepaged-for-enabling-none-pmd-sized-mthps.patch

