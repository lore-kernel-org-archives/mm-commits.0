Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9AD1C1F15
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836936; cv=none; b=AVp4wM8ne3YJlU13nTM1S02sTniFE4XCq/po8CeFyUpfUEk2GflvmfSpPm7XMFMIIMEDbO+QsBr+gn8zsM97dolkXO3oKAmOiiR78cfFOiMhKIQ+PjkY28QvYCoe4s9oFtt6y3HRzoEOLh0hORAKSyE+JdCXKO7pl0DC3n1vOTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836936; c=relaxed/simple;
	bh=r4FrSI60oGRMfhccMZaCbMs6Q/XmaSQe2qjn59Tcbcs=;
	h=Date:To:From:Subject:Message-Id; b=u3nNgbw7UbazVY0YxtJU35mIJNSsUd5TWQ4G4lsWdzRLxWlViG73WhPifeyXu36LavbWbuQVqDWBNnnJJua6RBkzZDqFjcYK/gvzpA7ZUYfutorT3wZWb5YPiOxirCXt/89W+cBz+XIRzRZ1iks/J/eHUogRRP+LuW7NROwY7j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pj94WLNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pj94WLNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A00C4CEDF;
	Tue, 14 Jan 2025 06:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836936;
	bh=r4FrSI60oGRMfhccMZaCbMs6Q/XmaSQe2qjn59Tcbcs=;
	h=Date:To:From:Subject:From;
	b=pj94WLNVILr646FcvV9Ap7DgmEMF4Yv5E12riIMJf3aY4OMELXyHYoeTuwpNxdS7L
	 LDO2HxZnbBKHtM3t5DFq1VQBRgsykO+FcwLOOWG/1whvDfpErMO3V3/pzzDRPZy269
	 gmVL3ASaHW9K2i3U54qohOGxdFAgVScTqLE8xjBU=
Date: Mon, 13 Jan 2025 22:42:15 -0800
To: mm-commits@vger.kernel.org,tongtiangen@huawei.com,ryan.roberts@arm.com,peterx@redhat.com,pasha.tatashin@soleen.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,jgg@ziepe.ca,jannh@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pgtable-make-ptep_clear-non-atomic.patch removed from -mm tree
Message-Id: <20250114064216.10A00C4CEDF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pgtable: make ptep_clear() non-atomic
has been removed from the -mm tree.  Its filename was
     mm-pgtable-make-ptep_clear-non-atomic.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: make ptep_clear() non-atomic
Date: Fri, 22 Nov 2024 15:36:52 +0800

In the generic ptep_get_and_clear() implementation, it is just a simple
combination of ptep_get() and pte_clear(). But for some architectures
(such as x86 and arm64, etc), the hardware will modify the A/D bits of the
page table entry, so the ptep_get_and_clear() needs to be overwritten
and implemented as an atomic operation to avoid contention, which has a
performance cost.

The commit d283d422c6c4 ("x86: mm: add x86_64 support for page table
check") adds the ptep_clear() on the x86, and makes it call
ptep_get_and_clear() when CONFIG_PAGE_TABLE_CHECK is enabled. The page
table check feature does not actually care about the A/D bits, so only
ptep_get() + pte_clear() should be called. But considering that the page
table check is a debug option, this should not have much of an impact.

But then the commit de8c8e52836d ("mm: page_table_check: add hooks to
public helpers") changed ptep_clear() to unconditionally call
ptep_get_and_clear(), so that the CONFIG_PAGE_TABLE_CHECK check can be
put into the page table check stubs (in include/linux/page_table_check.h).
This also cause performance loss to the kernel without
CONFIG_PAGE_TABLE_CHECK enabled, which doesn't make sense.

Currently ptep_clear() is only used in debug code and in khugepaged
collapse paths, which are fairly expensive. So the cost of an extra atomic
RMW operation does not matter. But this may be used for other paths in the
future. After all, for the present pte entry, we need to call ptep_clear()
instead of pte_clear() to ensure that PAGE_TABLE_CHECK works properly.

So to be more precise, just calling ptep_get() and pte_clear() in the
ptep_clear().

Link: https://lkml.kernel.org/r/20241122073652.54030-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Jann Horn <jannh@google.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Tong Tiangen <tongtiangen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pgtable.h |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/include/linux/pgtable.h~mm-pgtable-make-ptep_clear-non-atomic
+++ a/include/linux/pgtable.h
@@ -533,7 +533,14 @@ static inline void clear_young_dirty_pte
 static inline void ptep_clear(struct mm_struct *mm, unsigned long addr,
 			      pte_t *ptep)
 {
-	ptep_get_and_clear(mm, addr, ptep);
+	pte_t pte = ptep_get(ptep);
+
+	pte_clear(mm, addr, ptep);
+	/*
+	 * No need for ptep_get_and_clear(): page table check doesn't care about
+	 * any bits that could have been set by HW concurrently.
+	 */
+	page_table_check_pte_clear(mm, pte);
 }
 
 #ifdef CONFIG_GUP_GET_PXX_LOW_HIGH
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


