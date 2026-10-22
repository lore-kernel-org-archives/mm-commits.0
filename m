Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792686808;
	b=l19GEpJ5D5ZKLTk84gmatBUZ20k5yV4E6yDZnJNopJVy/1AAU3QZP2tUJEWbP3srbI5S
	 Y1BpUU/ce2Y6AfkrSwQrElkA6JtfMogZJcOZH6iPMl+MrrviFKE+dXi6ujtGvIWXzcxnA
	 o0EhG1GlRyT5AGv0wjpkzPSUbIefaTVqa6KxrE7cWEcCh084p7xaG8vFee1liUJMJAoa/
	 zPIrqGdZPdsmIow6sz6Yd6EB6/MeY5bhdt8NB7hGZoAyLZyUnEAw/EbnEVjFRIOkMhkl9
	 SeDjMYeNQmdfb2FMPsaSmLAHwEAIYzAGvhOvo2clUYueZfgU35oLy6qLj5Y/J8pQ4Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792686808;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=yAsSi9Wknvz1SeSD/E/A/GK208m2509d3LDk7ItBXds=;
	b=b3w2nu2KQz5L+sqDecG+uEQ9lL5E5y89dI/55T9ATwLFcOJlOgLpnIDueVETf1c8OfA4
	 Q2LxwPqmUd+/onyurZa+TNgAx6Ja+JETQTSKdo+4PsJaZXL0ZcU4D0I6xcEo7i6ZbBqT8
	 g49VUrFgCgPrhmYIi/h7bbYL7Z6GtuGjmA/0JHU+QkziOqm7pRsuEAzl5C5GuAFvCObOc
	 v6kkjlyGrzL8QcWqpYVfDlBk855zZ5OY+NTONwXvsjaeL7t7qWJtDI3cZxs/AeF9yy5q8
	 1aTq+yjF6DCtM9Oa0FjE5cCAHxyBp17v757hKgOivNam/C5F/qpmh6kTz+YaaZ449YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PcUU3R4l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499D9606A31D;
	Thu, 22 Oct 2026 16:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PcUU3R4l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16531F01825;
	Thu, 22 Oct 2026 16:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792686807;
	bh=yAsSi9Wknvz1SeSD/E/A/GK208m2509d3LDk7ItBXds=;
	h=Date:To:From:Subject;
	b=PcUU3R4ljoJdUJyA2eX1QabsYz8bempiMA1mxJ6HkpAjSwCpGYf5IB3WZL8ZFkuwt
	 yiCcag1PBG/owHBThwbwtzd/NxyVqFguR2IV8KHentNiYleZa+apK4C6ussEBMTtpC
	 qul5/9CFSfvOXWSquaZZYUqJcbNaZoIkLxgVywHY=
Date: Thu, 22 Oct 2026 09:33:27 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,azpijr@gmail.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-fix-mremap-move-length-truncation.patch added to mm-unstable branch
Message-Id: <20261022163327.C16531F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb: fix mremap move length truncation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-fix-mremap-move-length-truncation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-fix-mremap-move-length-truncation.patch

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
From: Li Zhe <lizhe.67@bytedance.com>
Subject: mm/hugetlb: fix mremap move length truncation
Date: Thu, 22 Oct 2026 11:45:41 +0800

Patch series "mm/hugetlb: fix mremap bugs", v3.

This series fixes a few hugetlb mremap bugs.

Patch 1 fixes the return type of move_hugetlb_page_tables(), so large
hugetlb moves cannot be truncated when reported back to the generic
mremap code.

Patch 2 disables hugetlb PMD sharing for UFFD missing mode, so
UFFDIO_POISON markers cannot become visible through shared PMD page
tables.

Patch 3 fixes the recursive i_mmap_rwsem deadlock in the hugetlb mremap
path by avoiding the destination PMD sharing allocation path while the
mapping lock is already held for write.


This patch (of 3):

move_hugetlb_page_tables() returns the number of bytes moved, but
its return type is int while the generic move_page_tables() path uses
unsigned long lengths.

A hugetlb mremap() move length above INT_MAX can therefore be
misreported to copy_vma_and_data(). The out-of-range conversion to int
is implementation-defined; on common 64-bit builds, for example, a
4 GiB move can be reported as zero, making the caller treat the move as
a failure and use the wrong length for rollback.

Return unsigned long from move_hugetlb_page_tables(), matching
move_page_tables() and preserving the full byte count.

Link: https://lore.kernel.org/20261022034543.51226-1-lizhe.67@bytedance.com
Link: https://lore.kernel.org/20261022034543.51226-2-lizhe.67@bytedance.com
Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Cc: <stable@vger.kernel.org>
---

 include/linux/hugetlb.h |   15 ++++++---------
 mm/hugetlb.c            |    7 +++----
 2 files changed, 9 insertions(+), 13 deletions(-)

--- a/include/linux/hugetlb.h~mm-hugetlb-fix-mremap-move-length-truncation
+++ a/include/linux/hugetlb.h
@@ -121,10 +121,9 @@ void hugepage_put_subpool(struct hugepag
 
 void hugetlb_dup_vma_private(struct vm_area_struct *vma);
 void clear_vma_resv_huge_pages(struct vm_area_struct *vma);
-int move_hugetlb_page_tables(struct vm_area_struct *vma,
-			     struct vm_area_struct *new_vma,
-			     unsigned long old_addr, unsigned long new_addr,
-			     unsigned long len);
+unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
+		struct vm_area_struct *new_vma, unsigned long old_addr,
+		unsigned long new_addr, unsigned long len);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *,
 			    struct vm_area_struct *, struct vm_area_struct *);
 void unmap_hugepage_range(struct vm_area_struct *,
@@ -338,11 +337,9 @@ static inline int copy_hugetlb_page_rang
 	return 0;
 }
 
-static inline int move_hugetlb_page_tables(struct vm_area_struct *vma,
-					   struct vm_area_struct *new_vma,
-					   unsigned long old_addr,
-					   unsigned long new_addr,
-					   unsigned long len)
+static inline unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
+		struct vm_area_struct *new_vma, unsigned long old_addr,
+		unsigned long new_addr, unsigned long len)
 {
 	BUG();
 	return 0;
--- a/mm/hugetlb.c~mm-hugetlb-fix-mremap-move-length-truncation
+++ a/mm/hugetlb.c
@@ -5206,10 +5206,9 @@ static void move_huge_pte(struct vm_area
 	spin_unlock(dst_ptl);
 }
 
-int move_hugetlb_page_tables(struct vm_area_struct *vma,
-			     struct vm_area_struct *new_vma,
-			     unsigned long old_addr, unsigned long new_addr,
-			     unsigned long len)
+unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
+		struct vm_area_struct *new_vma, unsigned long old_addr,
+		unsigned long new_addr, unsigned long len)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping = vma->vm_file->f_mapping;
_

Patches currently in -mm which might be from lizhe.67@bytedance.com are

mm-hugetlb-fix-overbroad-mmu-notifiers-for-unshared-pmds.patch
mm-hugetlb-fix-mremap-move-length-truncation.patch
mm-hugetlb-fix-mremap-deadlock-when-pmd-sharing-is-possible.patch

