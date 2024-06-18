Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A700953E24
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 20:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718742749; cv=none; b=XAlz2IoSkhj+w/yzAx0T05MHu+zTVGn5KYEM55ljLLFcJuAsWrUQQROwhsDfLbOiWpXfK5mzimte0uCDGkSQhjEI23C5LqLaVYMxSbN7irzTyVcedSlULASYxUNz0MmvEsVarpnD3xtkfnEm3KJ3JCri0bnKs2IrT5W8/1TeDkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718742749; c=relaxed/simple;
	bh=CkL72ylkD3/VDBdGZqI0bRgA+PswuzdVaxk8CAXtdDU=;
	h=Date:To:From:Subject:Message-Id; b=mYER5lZD7bZ8q6+nklET1agClyAGj6tiCA/XzDoQFMR/lQHoEPCy5tip9Z8vrBCpGjXyahUGeCb1CYUsIfeDY3UnpNpOpb7cnYGc2o5sQGe67cRqD3b5Q7EfP6tW+dKIp8aCQOo66hjDv4H2TpPJX3vYIhzJ0DpFgq5TfbWgXTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YKoGU8uR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YKoGU8uR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78E88C3277B;
	Tue, 18 Jun 2024 20:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718742749;
	bh=CkL72ylkD3/VDBdGZqI0bRgA+PswuzdVaxk8CAXtdDU=;
	h=Date:To:From:Subject:From;
	b=YKoGU8uRSivZY6rz3KGoO4HmfD1TvE9DRECh7MqRVDqlDpC9yMf3MfU4VxwxXgn4Q
	 5mzlEIgW7qpF7meOZoLW+36+5U5ny6hue+ehAYZptpRh0BgNtyI/PNZ1+Y2IqCEPIb
	 Dkp1xqA3iM0RIEsRZKosJbrz7H0VdKjcWRHpPcFg=
Date: Tue, 18 Jun 2024 13:32:28 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch added to mm-unstable branch
Message-Id: <20240618203229.78E88C3277B@smtp.kernel.org>
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
Date: Tue, 18 Jun 2024 14:54:20 +0800

To support large folio swapin/swapout for shmem in the following patches,
drop the folio's reference count by the number of pages contained in the
folio when a shmem folio is deleted from shmem pagecache after adding into
swap cache.

Link: https://lkml.kernel.org/r/a11634487d3d3dfb4e69e07f5575de18a27ee67a.1718690645.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
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
@@ -831,7 +831,7 @@ static void shmem_delete_from_page_cache
 	__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
 	__lruvec_stat_mod_folio(folio, NR_SHMEM, -nr);
 	xa_unlock_irq(&mapping->i_pages);
-	folio_put(folio);
+	folio_put_refs(folio, nr);
 	BUG_ON(error);
 }
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix-fix.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-3.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch
mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate.patch
mm-vmscan-add-validation-before-spliting-shmem-large-folio.patch
mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-support-large-folio-swap-out.patch

