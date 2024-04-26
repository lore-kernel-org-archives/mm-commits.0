Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBEB7EF06
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104078; cv=none; b=FuNCzG3V0aNO/LKIftZ8a/SnKX2oqS1p8YFwGsdBAEb8GxVcHi31548lBJfw/DS0ZAfh7Y6jGw8gqc/+qSKG9wLiXezymalVlniXs+cJTGCsbbKYTU43SbiC5kGhENr7i22YUQkZ+MUjj/cJC+bRiXLY0ydSu6jizGHY8kRlrBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104078; c=relaxed/simple;
	bh=CXPcBGSmKquaI7zUAwomNcKLgljwwXZr3P5HhCGD3EU=;
	h=Date:To:From:Subject:Message-Id; b=rCXkeI9lnuLFGZXa4ajCf1lYgMtjZ6WWSTwkmkvlfk5nEVFKKdlzPXKxsL1qBZ98U+05pqMxbKp/TC+lzGUpCiG9rhipZN78uK68mvWwVMNinpuiYgn0FZi5eWl0KVNfQSAdoEZwi24GuNl7K9aVKMBo+2bJPXAvizs3MxsKeL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Efm4QA//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Efm4QA//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA916C116B1;
	Fri, 26 Apr 2024 04:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104077;
	bh=CXPcBGSmKquaI7zUAwomNcKLgljwwXZr3P5HhCGD3EU=;
	h=Date:To:From:Subject:From;
	b=Efm4QA//B9e6KTLGCZR96K+5vn+3cdVPtEJMxghXPHKCK5mlODwbNdXx+Ru3NBt6O
	 G2aaIIG3Grks4k6gi1pzB+4GQYpRfUSuI/LEj9qNh6E2CKvRz4+OoKHrbBp9yntaJy
	 DnxHqtZHY18OIJ9Zh4YVZs4GVozHdRuYe0hd8vZM=
Date: Thu, 25 Apr 2024 21:01:17 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-__set_page_dirty_nobuffers.patch removed from -mm tree
Message-Id: <20240426040117.AA916C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove __set_page_dirty_nobuffers()
has been removed from the -mm tree.  Its filename was
     mm-remove-__set_page_dirty_nobuffers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: remove __set_page_dirty_nobuffers()
Date: Wed, 27 Mar 2024 22:30:08 +0800

There are no more callers of __set_page_dirty_nobuffers(), remove it.

Link: https://lkml.kernel.org/r/20240327143008.3739435-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 -
 mm/folio-compat.c       |    6 ------
 2 files changed, 7 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-__set_page_dirty_nobuffers
+++ a/include/linux/pagemap.h
@@ -1158,7 +1158,6 @@ static inline void folio_cancel_dirty(st
 bool folio_clear_dirty_for_io(struct folio *folio);
 bool clear_page_dirty_for_io(struct page *page);
 void folio_invalidate(struct folio *folio, size_t offset, size_t length);
-int __set_page_dirty_nobuffers(struct page *page);
 bool noop_dirty_folio(struct address_space *mapping, struct folio *folio);
 
 #ifdef CONFIG_MIGRATION
--- a/mm/folio-compat.c~mm-remove-__set_page_dirty_nobuffers
+++ a/mm/folio-compat.c
@@ -58,12 +58,6 @@ bool set_page_dirty(struct page *page)
 }
 EXPORT_SYMBOL(set_page_dirty);
 
-int __set_page_dirty_nobuffers(struct page *page)
-{
-	return filemap_dirty_folio(page_mapping(page), page_folio(page));
-}
-EXPORT_SYMBOL(__set_page_dirty_nobuffers);
-
 bool clear_page_dirty_for_io(struct page *page)
 {
 	return folio_clear_dirty_for_io(page_folio(page));
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

arm64-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
arm-mm-drop-vm_fault_badmap-vm_fault_badaccess.patch
mm-move-mm-counter-updating-out-of-set_pte_range.patch
mm-filemap-batch-mm-counter-updating-in-filemap_map_pages.patch
mm-swapfile-check-usable-swap-device-in-__folio_throttle_swaprate.patch
mm-memory-check-userfaultfd_wp-in-vmf_orig_pte_uffd_wp.patch

