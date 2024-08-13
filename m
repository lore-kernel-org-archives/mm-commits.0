Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF541A76D4
	for <mm-commits@vger.kernel.org>; Tue, 13 Aug 2024 22:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723588901; cv=none; b=WjXmKVy7WaYkYloBpXURgYPR5/ylrS9zFtoAWJQDuL5pRn2bMNgAv1cnyx2uOKnIcO0gBXFqZLkeJU3l9uhKaXy8M5LEnFXZnazMxn0stxhkmzZmSEL2eogAnBoY+DYuRl93XRrfA8cbV+lp2yY7ljzAZeZNRCU5tLT0RjzBbqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723588901; c=relaxed/simple;
	bh=igHJy8LukRzkFP0y+WzN7eqeYV0in4zA0EQH7Xb7ZbU=;
	h=Date:To:From:Subject:Message-Id; b=QWQWhKmMRR9RRAawdblzLoKLyjFxJTsa4a2w0Uf0j6j2QoW3dvcK7SWbq5AQq+IUAgvexYkjSN4qQvAeiYJnvRytDxz+DCPF0ESldjpaMMtsxlHdw/7azvt6HKov1tOVj3otNV/qo8uT4qjoVHU4uk2RXnmsqIUMof9hXKuQ91I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qwAX/b+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qwAX/b+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE0EC32782;
	Tue, 13 Aug 2024 22:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723588900;
	bh=igHJy8LukRzkFP0y+WzN7eqeYV0in4zA0EQH7Xb7ZbU=;
	h=Date:To:From:Subject:From;
	b=qwAX/b+qsvDotX0xckOySs6pK2Vf1PX2wSEkqQy3J9QkU2s61w79QejCw85g4R0px
	 DD7mH5RUEDaBsIA1ZsxE3Z1R9lEfit6nvgkYwPDVToLi3x5GXkd6drVeghGsNWCc3g
	 wi14DvlIhOlX0lRd9TSkngItALx+UVFoHcEucP6M=
Date: Tue, 13 Aug 2024 15:41:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch added to mm-unstable branch
Message-Id: <20240813224140.4FE0EC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: drop folio reference count using 'nr_pages' in shmem_delete_from_page_cache()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm: shmem: drop folio reference count using 'nr_pages' in shmem_delete_from_page_cache()
Date: Mon, 12 Aug 2024 15:42:08 +0800

To support large folio swapin/swapout for shmem in the following patches,
drop the folio's reference count by the number of pages contained in the
folio when a shmem folio is deleted from shmem pagecache after adding into
swap cache.

Link: https://lkml.kernel.org/r/b371eadb27f42fc51261c51008fbb9a334985b4c.1723434324.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache
+++ a/mm/shmem.c
@@ -851,7 +851,7 @@ static void shmem_delete_from_page_cache
 	__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
 	__lruvec_stat_mod_folio(folio, NR_SHMEM, -nr);
 	xa_unlock_irq(&mapping->i_pages);
-	folio_put(folio);
+	folio_put_refs(folio, nr);
 	BUG_ON(error);
 }
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch
mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch
mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch
mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch
mm-shmem-support-large-folio-swap-out.patch

