Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F02B1EEA47
	for <mm-commits@vger.kernel.org>; Wed,  4 Jun 2025 22:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749075777; cv=none; b=W6pS96FH0Bs58q65U3M0izIDkfUIcWdAcpqqpzvO3nu0TEDlpL0DILH1OAPTa/xFdrGXekYmbYLya3V2vWVTtN6FBCUfQU9WW8+UE0aBaye+ynP66386PB93j6tgk/3ECiVr8uuYGVN3XdZSo8l0J4mo0WQkKSEIK5Y7+OLv1SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749075777; c=relaxed/simple;
	bh=fTtaqg8yZNvxcHPsa6VKt56VCe0b8bIO17po/1Kdr6A=;
	h=Date:To:From:Subject:Message-Id; b=LpKRAzKsm/MqiN+UlfsrEohDWtcqPwYtYHDeGVpLYbZuaIJqhUKYRcwdo6RTdxiys1gDitYX1q1/ujN7Nyj6j6vVEsc4htpS7ThCoz0Qoa3AmTx//4IGK8R5OtbLvQbSvII1cEDhksoc7XA9JhFuHgSrnnm84Hooh8P0z50OZfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=UYYIKSfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="UYYIKSfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0B4C4CEE4;
	Wed,  4 Jun 2025 22:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749075776;
	bh=fTtaqg8yZNvxcHPsa6VKt56VCe0b8bIO17po/1Kdr6A=;
	h=Date:To:From:Subject:From;
	b=UYYIKSfPT5yL6igfqwJvD0+jZFjAudCaI9hc2cCkz9rSobdomYOsyGSu/GrKfYFhi
	 pRwaqGcXBbe+uB4lBE9lHrh/AFWhKDaVfoVQgUMmPUS7O1P0JMvCLwsRuTPWsb0to3
	 Cvvqi39pZ3WB2T9VKl96059rTZYqXoCoSx2lugeQ=
Date: Wed, 04 Jun 2025 15:22:56 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,ryan.roberts@arm.com,rostedt@goodmis.org,rientjes@google.com,rdunlap@infradead.org,raquini@redhat.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,kirill.shutemov@linux.intel.com,jack@suse.cz,hannes@cmpxchg.org,dev.jain@arm.com,david@redhat.com,corbet@lwn.net,cl@gentwo.org,catalin.marinas@arm.com,baohua@kernel.org,anshuman.khandual@arm.com,aarcange@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch added to mm-new branch
Message-Id: <20250604222256.CB0B4C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: khugepaged: allow khugepaged to check all anonymous mTHP orders
has been added to the -mm mm-new branch.  Its filename is
     mm-khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch

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

mm-khugepaged-allow-khugepaged-to-check-all-anonymous-mthp-orders.patch
mm-khugepaged-kick-khugepaged-for-enabling-none-pmd-sized-mthps.patch
mm-fix-the-inaccurate-memory-statistics-issue-for-users.patch

