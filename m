Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666F42045B1
	for <mm-commits@vger.kernel.org>; Thu, 19 Jun 2025 23:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750374127; cv=none; b=u2ykMFGh42icIqskyv0kDy60YBHJK+58A2G70NNY7BIhxhkdli46ZCKD0RI1d0YD163nlp0hWXaDNIBVBxd+UjrFijzZRlA0SEYOKKDQXAh1jxb4teXycoEy4mVi9+3I/ojWy2+yBRWyRLmpbSF7S9Sd6+PD/ssgMztl687Zamo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750374127; c=relaxed/simple;
	bh=6cU/PUdZj5wGkwbT+xRqhuYqFIA4PI/E4mku9ILgb1o=;
	h=Date:To:From:Subject:Message-Id; b=tYK6hgOyXkKFqKiDoLTfUN9NoFj+3xpmB5+UorbH1uvjSH0g/ALjEj/Srzf3lVAPCxjbSBQ2RLl7w1nMjphe+HjIUwVvLYJBVZtFXFcgyOZJlHnIFhmZLhHMNdVQrobJnwzK4dc8ulchaUxq0BOxqqkxRtHNoiEU+Vjg9Yg8Fus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F0fj25If; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F0fj25If"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEC5C4CEEA;
	Thu, 19 Jun 2025 23:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750374127;
	bh=6cU/PUdZj5wGkwbT+xRqhuYqFIA4PI/E4mku9ILgb1o=;
	h=Date:To:From:Subject:From;
	b=F0fj25IfW38WSFkaGM+vH3Q09j7NXK69MgYt9a+gbrqodiBi/QCiFnHqArSkpyNgh
	 HvZss2AsrBgEEMIaLy0BLtw5j9OoPAKZ4QJ/bzOLizVTDld8uWs1JmN8qSJHtBzC2b
	 aXEbab7l2RlH0x+mHn+6qR9BJDLdJHSspHcyW4F4=
Date: Thu, 19 Jun 2025 16:02:06 -0700
To: mm-commits@vger.kernel.org,zhang.lyra@gmail.com,willy@infradead.org,will@kernel.org,m.szyprowski@samsung.com,lorenzo.stoakes@oracle.com,john@groves.net,jhubbard@nvidia.com,jgg@nvidia.com,hch@lst.de,gerald.schaefer@linux.ibm.com,debug@rivosinc.com,david@redhat.com,dan.j.williams@intel.com,bjorn@rivosinc.com,bjorn@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filter-zone-device-pages-returned-from-folio_walk_start.patch added to mm-new branch
Message-Id: <20250619230207.2AEC5C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: filter zone device pages returned from folio_walk_start()
has been added to the -mm mm-new branch.  Its filename is
     mm-filter-zone-device-pages-returned-from-folio_walk_start.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filter-zone-device-pages-returned-from-folio_walk_start.patch

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
From: Alistair Popple <apopple@nvidia.com>
Subject: mm: filter zone device pages returned from folio_walk_start()
Date: Thu, 19 Jun 2025 18:57:54 +1000

Previously dax pages were skipped by the pagewalk code as pud_special() or
vm_normal_page{_pmd}() would be false for DAX pages.  Now that dax pages
are refcounted normally that is no longer the case, so the pagewalk code
will start returning them.

Most callers already explicitly filter for DAX or zone device pages so
don't need updating.  However some don't, so add checks to those callers.

Link: https://lkml.kernel.org/r/4ecb7b357fc5b435588024770b88bbb695c30090.1750323463.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Björn Töpel <bjorn@kernel.org>
Cc: Björn Töpel <bjorn@rivosinc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Deepak Gupta <debug@rivosinc.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Inki Dae <m.szyprowski@samsung.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Groves <john@groves.net>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/events/uprobes.c~mm-filter-zone-device-pages-returned-from-folio_walk_start
+++ a/kernel/events/uprobes.c
@@ -539,7 +539,7 @@ retry:
 	}
 
 	ret = 0;
-	if (unlikely(!folio_test_anon(folio))) {
+	if (unlikely(!folio_test_anon(folio) || folio_is_zone_device(folio))) {
 		VM_WARN_ON_ONCE(is_register);
 		folio_put(folio);
 		goto out;
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-convert-pxd_devmap-checks-to-vma_is_dax.patch
mm-filter-zone-device-pages-returned-from-folio_walk_start.patch
mm-remove-remaining-uses-of-pfn_dev.patch
mm-convert-vmf_insert_mixed-from-using-pte_devmap-to-pte_special.patch
mm-gup-remove-pxx_devmap-usage-from-get_user_pages.patch
mm-huge_memory-remove-pxd_devmap-usage-from-insert_pxd_pfn.patch
mm-remove-redundant-pxd_devmap-calls.patch
mm-khugepaged-remove-redundant-pmd_devmap-check.patch
powerpc-remove-checks-for-devmap-pages-and-pmds-puds.patch
fs-dax-remove-fs_dax_limited-config-option.patch
mm-remove-devmap-related-functions-and-page-table-bits.patch
mm-remove-pfn_dev-pfn_map-pfn_special-pfn_sg_chain-and-pfn_sg_last.patch
mm-remove-callers-of-pfn_t-functionality.patch
mm-memremap-remove-unused-devmap_managed_key.patch

