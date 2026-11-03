Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793672126;
	b=LUoBvX4XbPJBvUoc06IgovIClWbISOskSkHvQs1IkUM/71bRY5eH32bkUPV1eTQ2FUZC
	 9tnhU8z+gTSm7gdUoHQ9BS4mxoi1vXj8Ga5EEsUo7KDc4sqtwk4xjS9qxlwbN9xcDh0ve
	 /G/Ddw25se/CwfPnwSvYGXt4MZwo2TGIlagV/1xH3pkBpeMijrFhwcDru9rxEuZzWFCWs
	 AG8AwHz7ykF17Km4RoTWFlosd4lCdy+ZI9HFx0zC15bV0fzO53FpOtshOxJO7mZNjUjSS
	 44Uw4rMxTA+90VDUnw0LVXhAQDugoFuVdOP4G5J3dAtrgQtKGUOUdh+JR/2Ef2Lsr8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793672126;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=rJhw/zUiXfhLQ6/b6e+y1WSCvnq39HT5qqKGj6KPX/k=;
	b=TW7J483gh02xezFWy4ZGkihcIZipjIYs+rqK+XXku4crhriVEKkUTxDVHPOFVWBtPIpM
	 cgADrj8CJ6QTEgsfnY7HJCgGvxLZx2f6tsbsm/judauG+/H7dHBDgaCnpog1HW6VbXliI
	 rXj/Uo85L5d3BpZxDmxuLZ/qOhSpCL06hpF2TW1JPi/bq62A2Ezx+JwSJOwWUEHyL0nHP
	 hni0LHQPwAwG+9dEkVYRDsqADHSqFDupmTtqeTqpXlNhFnGlsR74PVyJzmBjuLU4epNsD
	 BCWA+mSu9+xHR+VoOBsShRhc6L5BZckAGqrdTgAZW/cP13VKkpUf2XDfJAatmOsYWCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aHKGDZ4B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11CD606A32E;
	Tue,  3 Nov 2026 02:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=aHKGDZ4B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A88B1F00A1B;
	Tue,  3 Nov 2026 02:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793672125;
	bh=rJhw/zUiXfhLQ6/b6e+y1WSCvnq39HT5qqKGj6KPX/k=;
	h=Date:To:From:Subject;
	b=aHKGDZ4BzbTiuy3id1M/lSamXpWlwrzKEo6LZ4UJJhiOosYe2Czu8S9nq7JsAAzV2
	 CPw6R0B4rVEDbA48p8g0+YBrk8FNUJA3L9duZMf7LGlUBusLhVpE1C9XAa2oR7+U2x
	 inH+XUxTBGBIsGes14xVrDPzIiGKdioJRhK/ASyc=
Date: Mon, 02 Nov 2026 18:15:25 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,
	peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,
	azpijr@gmail.com,lizhe.67@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-mremap-move-length-truncation.patch removed from -mm tree
Message-Id: <20261103021525.6A88B1F00A1B@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/hugetlb: fix mremap move length truncation
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-mremap-move-length-truncation.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -5195,10 +5195,9 @@ static void move_huge_pte(struct vm_area
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


