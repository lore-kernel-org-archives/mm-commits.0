Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E61E1A2872
	for <mm-commits@vger.kernel.org>; Wed,  8 Jan 2025 06:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736317630; cv=none; b=Nl3hNNIru1ivZg+TSrlV1hu2Uq0RfuzqaDA3OACCvz3DxFR72tq7kGD2HlvMUcrr6LzF3VwW4VVCGTycQaLSGZklewd8vFITaktj5yTdBquaK7nmDE34B84u9GPzDA4FR8XSbl36awLFxVazZwBqKoXxRopI9xUeWzB4OhwZtZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736317630; c=relaxed/simple;
	bh=JdRkFqTX7NEWyCTd/IYpqRH92c/ZI6mcx1oYdAJycE8=;
	h=Date:To:From:Subject:Message-Id; b=LAep3fNIqyD75fhPu21gzdpMUbXZUWlAenUj9bXToc29LncReMDlIQch9NZKrgJzCROF61VZERIYDnQ9b+S76rKB8zNrmce9SafmEUfi2ZsPANYxqDtr1A3eZTX039Y2nn188U8sm2nT3tur19RDYmMkSIWdWmrwT0iMTbfmtRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rtaSg2gj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rtaSg2gj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F633C4CED0;
	Wed,  8 Jan 2025 06:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736317629;
	bh=JdRkFqTX7NEWyCTd/IYpqRH92c/ZI6mcx1oYdAJycE8=;
	h=Date:To:From:Subject:From;
	b=rtaSg2gju/zNLvb4qvXJ6ix0TN25PemRPdfLHU9x0C5+myGI7f0kac78gKVnJRZeq
	 2jcaCn/wOobeoR/Rr+QwrtMjVhIy9xpKXiBW18IBNMRx6lHf4zIKHJ0jGH3V269on4
	 stF9ty5RvKlAkxnt8lyRxv7CFperezkqVrD+UnGY=
Date: Tue, 07 Jan 2025 22:27:09 -0800
To: mm-commits@vger.kernel.org,david@redhat.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memremap-add-is_devdax_page-and-is_fsdax_page-helpers.patch added to mm-unstable branch
Message-Id: <20250108062709.8F633C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memremap: add is_devdax_page() and is_fsdax_page() helpers
has been added to the -mm mm-unstable branch.  Its filename is
     memremap-add-is_devdax_page-and-is_fsdax_page-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memremap-add-is_devdax_page-and-is_fsdax_page-helpers.patch

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
From: Alistair Popple <apopple@nvidia.com>
Subject: memremap: add is_devdax_page() and is_fsdax_page() helpers
Date: Tue, 7 Jan 2025 14:42:33 +1100

Add helpers to determine if a page or folio is a devdax or fsdax page or
folio.

Link: https://lkml.kernel.org/r/75b434c52f386c6078cd4fa7b92ed826d95d033f.1736221254.git-series.apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/include/linux/memremap.h~memremap-add-is_devdax_page-and-is_fsdax_page-helpers
+++ a/include/linux/memremap.h
@@ -187,6 +187,28 @@ static inline bool folio_is_device_coher
 	return is_device_coherent_page(&folio->page);
 }
 
+static inline bool is_fsdax_page(const struct page *page)
+{
+	return is_zone_device_page(page) &&
+		page_pgmap(page)->type == MEMORY_DEVICE_FS_DAX;
+}
+
+static inline bool folio_is_fsdax(const struct folio *folio)
+{
+	return is_fsdax_page(&folio->page);
+}
+
+static inline bool is_devdax_page(const struct page *page)
+{
+	return is_zone_device_page(page) &&
+		page_pgmap(page)->type == MEMORY_DEVICE_GENERIC;
+}
+
+static inline bool folio_is_devdax(const struct folio *folio)
+{
+	return is_devdax_page(&folio->page);
+}
+
 #ifdef CONFIG_ZONE_DEVICE
 void zone_device_page_init(struct page *page);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
_

Patches currently in -mm which might be from apopple@nvidia.com are

fuse-fix-dax-truncate-punch_hole-fault-path.patch
fs-dax-return-unmapped-busy-pages-from-dax_layout_busy_page_range.patch
fs-dax-dont-skip-locked-entries-when-scanning-entries.patch
fs-dax-refactor-wait-for-dax-idle-page.patch
fs-dax-create-a-common-implementation-to-break-dax-layouts.patch
fs-dax-always-remove-dax-page-cache-entries-when-breaking-layouts.patch
fs-dax-ensure-all-pages-are-idle-prior-to-filesystem-unmount.patch
fs-dax-remove-page_mapping_dax_shared-mapping-flag.patch
mm-gup-remove-redundant-check-for-pci-p2pdma-page.patch
mm-mm_init-move-p2pdma-page-refcount-initialisation-to-p2pdma.patch
mm-allow-compound-zone-device-pages.patch
mm-memory-enhance-insert_page_into_pte_locked-to-create-writable-mappings.patch
mm-memory-add-vmf_insert_page_mkwrite.patch
rmap-add-support-for-pud-sized-mappings-to-rmap.patch
huge_memory-add-vmf_insert_folio_pud.patch
huge_memory-add-vmf_insert_folio_pmd.patch
memremap-add-is_devdax_page-and-is_fsdax_page-helpers.patch
mm-gup-dont-allow-foll_longterm-pinning-of-fs-dax-pages.patch
proc-task_mmu-mark-devdax-and-fsdax-pages-as-always-unpinned.patch
mm-mlock-skip-zone_device-pmds-during-mlock.patch
fs-dax-properly-refcount-fs-dax-pages.patch
device-dax-properly-refcount-device-dax-pages-when-mapping.patch
mm-remove-pxx_devmap-callers.patch
mm-remove-devmap-related-functions-and-page-table-bits.patch
revert-riscv-mm-add-support-for-zone_device.patch

