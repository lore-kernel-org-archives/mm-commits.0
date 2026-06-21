Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F92F2D5432
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782066765; cv=none; b=KBcNcwo54aTq2z7HZ6jjsUs0rZ5bX9dhNCdsR4s6znqP6K6jjLi/2nTjOkZjOeUIgc7GQ3E/UtQVpADN9NcemU2CMhJQ8X6crg0ZBTa0Yf3CLX5avJ0ouZsPsx4wV2irqjv46LFUalrE/JIQIFkE1OACj9MG8gJ7HeKlh5N9BPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782066765; c=relaxed/simple;
	bh=89dHUKXQ2RAr2hm8xsWZINi+RRFn6RQXj8DvOVt0AyU=;
	h=Date:To:From:Subject:Message-Id; b=a24mc/o+1fmaTQWQDmIv/fudiaUFolwMxNqhgtBKg1+ewsZz0/10WPCCTtOqNQaRbrANaP8y/zriXq2H/IlV+acytMEcUlD5S5o6CNQdgsa/Qhy85LPohtFlNe3eMbgkxthKmYOQs7IKB0iG/TjeRgC7CbIqj7wAyBVdCkNWWtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TL/bRokc reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TL/bRokc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35131F000E9;
	Sun, 21 Jun 2026 18:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782066763;
	bh=gXOTCmIPED5N2hmZD9nV8mlmnaE8STZPMhiHCtugtBU=;
	h=Date:To:From:Subject;
	b=TL/bRokcIZwtcG1FOcZbGhXOqvLZBFMV2N1rZW8Wr4eqF1ENiqLBoKQMRquxI2XgV
	 O1sNnQsECr21Hw8J0MFOxwpW6MVBuxryZAIuNVftds/fPN9KjcK+SF1t/jKo4ouURU
	 oJGxeI9SAorpCFIIoDg1S8hfHSmzPUD3TEcq+vWk=
Date: Sun, 21 Jun 2026 11:32:43 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ying.huang@linux.alibaba.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,vbabka@suse.cz,usama.arif@linux.dev,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shivankg@amd.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,richard.weiyang@gmail.com,rdunlap@infradead.org,raquini@redhat.com,rakie.kim@sk.com,pfalcato@suse.de,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,jack@suse.cz,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,bagasdotme@gmail.co
 m,apopple@nvidia.com,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-introduce-collapse_possible_orders-helper-functions.patch removed from -mm tree
Message-Id: <20260621183243.D35131F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: introduce collapse_possible_orders helper functions
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-introduce-collapse_possible_orders-helper-functions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: mm/khugepaged: introduce collapse_possible_orders helper functions
Date: Fri, 5 Jun 2026 10:14:17 -0600

Add collapse_possible_orders() to generalize THP order eligibility.  The
function determines which THP orders are permitted based on collapse
context (khugepaged vs madv_collapse).  We also add collapse_possible() as
a thin wrapper around collapse_possible_orders() that returns a bool
rather than the whole bitmap.

This consolidates collapse configuration logic and provides a clean
interface for future mTHP collapse support where the orders may be
different.

Link: https://lore.kernel.org/20260605161422.213817-11-npache@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
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
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-introduce-collapse_possible_orders-helper-functions
+++ a/mm/khugepaged.c
@@ -554,12 +554,30 @@ void __khugepaged_enter(struct mm_struct
 		wake_up_interruptible(&khugepaged_wait);
 }
 
+/*
+ * Check what orders are possible based on the vma and collapse type.
+ * This is used to determine if mTHP collapse is a viable option.
+ */
+static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type tva_flags)
+{
+	const unsigned long orders = BIT(HPAGE_PMD_ORDER);
+
+	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
+}
+
+static bool collapse_possible(struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type tva_flags)
+{
+	return collapse_possible_orders(vma, vm_flags, tva_flags);
+}
+
 void khugepaged_enter_vma(struct vm_area_struct *vma,
 			  vm_flags_t vm_flags)
 {
 	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
 	    hugepage_pmd_enabled()) {
-		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
+		if (collapse_possible(vma, vm_flags, TVA_KHUGEPAGED))
 			__khugepaged_enter(vma->vm_mm);
 	}
 }
@@ -2705,7 +2723,7 @@ static void collapse_scan_mm_slot(unsign
 			cc->progress++;
 			break;
 		}
-		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
+		if (!collapse_possible(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
 			cc->progress++;
 			continue;
 		}
@@ -3015,7 +3033,7 @@ int madvise_collapse(struct vm_area_stru
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
 
-	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
+	if (!collapse_possible(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
 		return -EINVAL;
 
 	cc = kmalloc_obj(*cc);
_

Patches currently in -mm which might be from npache@redhat.com are


