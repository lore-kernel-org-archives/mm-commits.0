Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED331E376C
	for <mm-commits@vger.kernel.org>; Sat,  6 Jun 2026 00:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780705097; cv=none; b=cs01wNEIAkRA6F4Jl3gKMSCcwB5YDuxOtp8RbQqu3m1UUPjgk2syaprCrtUbaDV1aKxUL0fvlvQ19o621VHhvyKqa9fn24Tr8VNXSXJ/ORl4kl4MDgtSjGMNTI0SoUa2WghTT9nr11RzF3TputmD+ug3w7EbWVSTVplZaU/vBW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780705097; c=relaxed/simple;
	bh=O5FoNYqVzMqBxIDuTGXDaPloWAYrfsh1PP+qVt2bOGU=;
	h=Date:To:From:Subject:Message-Id; b=PD7MEpEmxzOxF7y/mfxULUbB1fzFfoFp6YMOFl2TY2bAyn5ceFw3BoVYJ6xD3C+SK3nXQ+TGpX1R4kIvU7MYM+8YrgW+bC8QiVONXIWsia60zo6pbQXTy4sUklN5D97DhQ9e+O49hZL9lIuO1HzsqV4zYsrEXeW7cSYRJlKERuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=picWzqZv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="picWzqZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A531F00898;
	Sat,  6 Jun 2026 00:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780705095;
	bh=LUaRh5mj2kudOByT4r3/rfog2TPaaeRoJtu9iwHVO9A=;
	h=Date:To:From:Subject;
	b=picWzqZvmeyYRmEUj8uKO02QslyItcEYBk3sVghBbAqyHXVvqQyZ8fL22fD8UXwE0
	 2hLbbBCIottbiOG5AsxfSz+d/Zx7i6HIo3pdRyji6RaueUgofzzYZKJTuKUjqhHMTo
	 tprK1gS6Sd1zx6/vHpG3i2C30yGrTSq7n7MNfeuA=
Date: Fri, 05 Jun 2026 17:18:15 -0700
To: mm-commits@vger.kernel.org,npache@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-introduce-mthp-collapse-support-fix.patch removed from -mm tree
Message-Id: <20260606001815.C3A531F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fix potential use-after-free of vma in mthp_collapse()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-introduce-mthp-collapse-support-fix.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Nico Pache <npache@redhat.com>
Subject: fix potential use-after-free of vma in mthp_collapse()
Date:Mon May 25 07:38:59 2026 -0600

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
@@ -1516,9 +1516,9 @@ static unsigned int collapse_mthp_count_
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
@@ -1538,7 +1538,7 @@ static int mthp_collapse(struct mm_struc
 		if (!test_bit(order, &enabled_orders))
 			goto next_order;
 
-		max_ptes_none = collapse_max_ptes_none(cc, vma, order);
+		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
 
 		nr_occupied_ptes = collapse_mthp_count_present(cc, offset,
 							       nr_ptes);
@@ -1763,7 +1763,7 @@ out_unmap:
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

mm-khugepaged-avoid-unnecessary-mthp-collapse-attempts.patch
documentation-mm-update-the-admin-guide-for-mthp-collapse.patch

