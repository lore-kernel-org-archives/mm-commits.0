Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4884138C433
	for <mm-commits@vger.kernel.org>; Mon, 25 May 2026 19:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779736247; cv=none; b=lrMnFUmVID0Rbkf0MjHDY9dwdXeUh4N/SCbI9lf0H1toBG0Ra0QoXEswf5jRw28odaB0L1z1HKTHtojfrm5643dq2s+/ygkIFzLsKzcw5tU37EIRDjusEKEFXvHs3rKztuPPS6q7mjJvMiOv8pXp+vIbbBRkIINzPPMuFCXtygo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779736247; c=relaxed/simple;
	bh=Rz0IjHHOSbPO1Bf/GFui/ITaBvSbBb+dVhotGk1iyd8=;
	h=Date:To:From:Subject:Message-Id; b=AEMdimk53xZw0r/KTez72lx//r+ZNY9OwIApGaYFStKWTdu8aikcHrBppThdOcgaNblHKi9c/aRqvP9wh+Xr2q96Gh2jrEwlOFuqHqD7y3uB2SKPttapyTK23+2AL6pwu0KL/dhPvhYxfwaS/RpFLoxzKzQTeBfrkK3UQgUImJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=fail (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d3UAnpA1 reason="signature verification failed"; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d3UAnpA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00EC71F000E9;
	Mon, 25 May 2026 19:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779736246;
	bh=izOsAX2WBGdHdPvJZBCYFa27ngrwkm3g3vZTHn9Rj4I=;
	h=Date:To:From:Subject;
	b=d3UAnpA1owi+RikZ5JqFsw1pEaIFgmsxmMfOeh61cRr4/463IuqvX6ySCtMm7qZ9I
	 TG2IzRzHIfIK/1WXoD4X2Kgfly8u5eYVXAbyoaujfkZF5W5eXp7QsDJ+e9AQLUDvnf
	 /PojzU2LwX4E3SAfKrDcIWYycjnq0ZenXCjMgGsk=
Date: Mon, 25 May 2026 12:10:45 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ying.huang@linux.alibaba.com,yang@os.amperecomputing.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,vbabka@suse.cz,usama.arif@linux.dev,usamaarif642@gmail.com,tiwai@suse.de,thomas.hellstrom@linux.intel.com,surenb@google.com,sunnanyong@huawei.com,shivankg@amd.com,ryan.roberts@arm.com,rppt@kernel.org,rostedt@goodmis.org,rientjes@google.com,richard.weiyang@gmail.com,rdunlap@infradead.org,raquini@redhat.com,rakie.kim@sk.com,pfalcato@suse.de,peterx@redhat.com,mhocko@suse.com,mhiramat@kernel.org,matthew.brost@intel.com,mathieu.desnoyers@efficios.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,jack@suse.cz,jackmanb@google.com,hughd@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,catalin.marinas@arm.com,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,bagasdotme@gmail.co
 m,apopple@nvidia.com,anshuman.khandual@arm.com,aarcange@redhat.com,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-khugepaged-introduce-mthp-collapse-support-fix.patch added to mm-unstable branch
Message-Id: <20260525191046.00EC71F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fix potential use-after-free of vma in mthp_collapse()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-khugepaged-introduce-mthp-collapse-support-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-khugepaged-introduce-mthp-collapse-support-fix.patch

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

Author: Nico Pache <npache@redhat.com>
Subject: fix potential use-after-free of vma in mthp_collapse()
Date: Mon May 25 07:38:59 2026 -0600

Between V17 and v18, one reviewer (Wei) brought up that we are not doing
the uffd-armed check until deep in the collapse operation.  While not
functionally incorrect, it can lead to unnecessary work.

We optimized this by passing the vma variable to mthp_collapse() and using
the collapse_max_ptes_none() function to check the state of uffd-armed
preventing the wasted work later in the collapse.

mthp_collapse() is called after mmap_read_unlock(), so the vma pointer can
become stale.  Remove the vma parameter and pass NULL to
collapse_max_ptes_none() instead.

Link: https://lore.kernel.org/2b2cda8c-358a-4a5c-989c-ae42593ef2ea@redhat.com
Signed-off-by: Nico Pache <npache@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>
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

 mm/khugepaged.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-introduce-mthp-collapse-support-fix
+++ a/mm/khugepaged.c
@@ -1502,9 +1502,9 @@ static unsigned int collapse_mthp_count_
  * If a collapse is permitted, we attempt to collapse the PTE range into a
  * mTHP.
  */
-static int mthp_collapse(struct mm_struct *mm, struct vm_area_struct *vma,
-		unsigned long address, int referenced, int unmapped,
-		struct collapse_control *cc, unsigned long enabled_orders)
+static int mthp_collapse(struct mm_struct *mm, unsigned long address,
+		int referenced, int unmapped, struct collapse_control *cc,
+		unsigned long enabled_orders)
 {
 	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
 	int collapsed = 0, stack_size = 0;
@@ -1524,7 +1524,7 @@ static int mthp_collapse(struct mm_struc
 		if (!test_bit(order, &enabled_orders))
 			goto next_order;
 
-		max_ptes_none = collapse_max_ptes_none(cc, vma, order);
+		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
 
 		nr_occupied_ptes = collapse_mthp_count_present(cc, offset,
 							       nr_ptes);
@@ -1749,7 +1749,7 @@ out_unmap:
 	if (result == SCAN_SUCCEED) {
 		/* collapse_huge_page expects the lock to be dropped before calling */
 		mmap_read_unlock(mm);
-		nr_collapsed = mthp_collapse(mm, vma, start_addr, referenced,
+		nr_collapsed = mthp_collapse(mm, start_addr, referenced,
 					     unmapped, cc, enabled_orders);
 		/* mmap_lock was released above, set lock_dropped */
 		*lock_dropped = true;
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
mm-khugepaged-introduce-collapse_allowable_orders-helper-function.patch
mm-khugepaged-introduce-mthp-collapse-support.patch
mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

