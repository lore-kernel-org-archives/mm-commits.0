Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794887784;
	b=5Ls76aEfhuKzOCy3jmafiFhNlEZTzk6JbkHg5pk/qsZYJ7VWibdM2C6xR/2Zo1tq7cIM
	 Um5HG4LTzz/VowWH5R1HZOlREZLPwL6/aooYEuN2kI5bChd6GiIsnnx78txxOSPOBp47q
	 WbKw5haPBNNZJ+aTaMMSYdBYnMmQ9oIwUiRfPopNkk4smWHVT7R9VxH1kQ2niz7GZYCJ7
	 DpdNQHo7cVGsJwgMIXgh0gsX7HBeEvOfWb1ESq9Q2X7rj7lpipyw4SuCPd9jAVgjib3nl
	 Iue/t/yYhFTRW+JWQ6y16E8g8+rWLnoBK+LPxKuNQyO2gzXAaQ5Dcxl+YRZ+0PPo5FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794887784;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=mXGYkSQpOpzW3aLoErSj+CA5UkhxjDzkZbEbV3yRe4k=;
	b=TcixFHG/6zYxgYepm1VTBOP5pMh2ITJMu+pr1TosuQr2/iYi2vj81TQg1qQRm5v92OIw
	 fU9bSNW9BWpauJF23Xz3PJoAuXGpTXLvNzTo3sO88CKBWHIZAD4GQ44BkgiUqrgFxQHWr
	 Gu7NHf2L26BcgOshNh7qj4gnGtVJB2eJhedDjxABd2Iuo5BoWXt+TTItjD404/lDnH/2s
	 ihKEcLKKr/jn5LUVIg9yzj4wZsGjjGzRnb/DC/dQN6Nv/DS+hCABBK1yWUauXX7sKIsca
	 mOlI2o/9hHw8FAag0SQi6aCVLQ66ywpOUMvlP340Ixq/adHtpUrCAX85osavF9fmaJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PphvekQg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A479606A32A;
	Tue, 17 Nov 2026 03:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=PphvekQg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358CE1F000C4;
	Tue, 17 Nov 2026 03:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794887784;
	bh=mXGYkSQpOpzW3aLoErSj+CA5UkhxjDzkZbEbV3yRe4k=;
	h=Date:To:From:Subject;
	b=PphvekQgMNV709DObKtDCB8oCsrt6569vKWIcFkQLH2I+boX3NNkPI++QWuftU8rX
	 0B/UOv9EuM9JxJYvuGAIDZx/wrZ6e3SBdGuyB9EjSniuvCzSZdJR4Yh5aA8lU+da6i
	 lSvDTQ4egFAJnN6s7vq+YkcQMz/sAQFagtnco0iI=
Date: Mon, 16 Nov 2026 19:56:23 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,rppt@kernel.org,
	osalvador@suse.de,osalvador@kernel.org,nao.horiguchi@gmail.com,
	ljs@kernel.org,linmiaohe@huawei.com,joao.m.martins@oracle.com,
	jiaqiyan@google.com,david@kernel.org,azpijr@gmail.com,
	songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-fix-deadlock-during-pmd-split.patch added to mm-new branch
Message-Id: <20261117035624.358CE1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/hugetlb_vmemmap: fix deadlock during PMD split
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb_vmemmap-fix-deadlock-during-pmd-split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-fix-deadlock-during-pmd-split.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/hugetlb_vmemmap: fix deadlock during PMD split
Date: Sat, 14 Nov 2026 19:25:23 +0800

vmemmap_remap_range() currently walks vmemmap page tables under
init_mm.mmap_lock. If the walk reaches a leaf PMD, vmemmap_split_pmd()
allocates a PTE table with GFP_KERNEL and can enter direct reclaim:

hugetlb_vmemmap_optimize_folio()
  vmemmap_remap_range()
    mmap_read_lock(&init_mm)  <-- outer read lock
    ...
      vmemmap_split_pmd()
        pte_alloc_one_kernel(&init_mm)  /* GFP_KERNEL */
          <direct reclaim>
            ttm_pool_shrinker_scan()
              ...
                change_page_attr_set_clr()
                  mmap_read_lock(&init_mm)  <-- self-deadlock

Since commit d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on
attribute changes to avoid UAF"), reclaim through TTM can enter CPA,
which also takes init_mm.mmap_lock. If a writer is pending, the nested
read blocks behind it while the outer read cannot be released, causing a
self-deadlock.

HVO walks vmemmap ranges whose intermediate page tables remain present.
vmemmap_split_pmd() revalidates the PMD under init_mm.page_table_lock
before installing the PTE table. Use the lockless page-table walker so the
allocation no longer runs under init_mm.mmap_lock.

Link: https://lore.kernel.org/20261114112523.75208-4-songmuchun@bytedance.com
Fixes: d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on attribute changes to avoid UAF")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/sashiko-outbox-206969@kernel.org/
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Joao Martins <joao.m.martins@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: <stable@vger.kernel.org>

 mm/hugetlb_vmemmap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-fix-deadlock-during-pmd-split
+++ a/mm/hugetlb_vmemmap.c
@@ -161,10 +161,8 @@ static int vmemmap_remap_range(unsigned
 
 	VM_BUG_ON(!PAGE_ALIGNED(start | end));
 
-	mmap_read_lock(&init_mm);
-	ret = walk_kernel_page_table_range(start, end, &vmemmap_remap_ops,
-				    NULL, walk);
-	mmap_read_unlock(&init_mm);
+	ret = walk_kernel_page_table_range_lockless(start, end, &vmemmap_remap_ops,
+						    NULL, walk);
 	if (ret)
 		return ret;
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

powerpc-mm-make-vmemmap_populate_compound_pages-static.patch
powerpc-mm-drop-powerpc-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-vmemmap_can_optimize.patch
mm-sparse-vmemmap-drop-pgmap-from-vmemmap-population-apis.patch
mm-hugetlb_vmemmap-fix-hwpoison-state-races-during-optimization.patch
mm-hugetlb_vmemmap-fix-pmd-split-tlb-flush-race.patch
mm-hugetlb_vmemmap-fix-deadlock-during-pmd-split.patch

