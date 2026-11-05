Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894091;
	b=m/GNYX+VMY0jzMS7lZnWGCgd+WzKJGbiTD+PMRS0Hhb5UdZ/iXySmCTeqXc2SMXWt0JQ
	 g4/JlEFXLfOm8jRGjAqcgLGNaoqFZeQR2BGXndD8eg1qqkTVXkc18YZmXuWCYUWLAkDHW
	 U6Zyz3F6Ns3LUzGHsv90VPc4ePppeGfE9QIYOJyFzZFZtuZQovBzyCxbQ/O1rU2R73wuq
	 vYf+od07ejtzv4GspBhJ7i0i2BXULoYgPr+t9MhiPqfEylXpSRLgve0ao4X7iK3QIWtm0
	 BXsI4ZWY2ivAdmVZxD4yPlO1IfOq1WFvEePLMx9n+/BjtPN91c3UihUl7FEK+ULwj1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894091;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=BMfzGjK1M8KPOc0N/SSy4QRKsqgSi84hxYac8JkGTJw=;
	b=rlBGtxh/1wxGqo1UZWNsKB6hEAmfCa7bhrgb7u/EkeCsXRwiilE1h/8RvE4QIbxmVdbQ
	 zih5GGEZRQt7vBmvCN4tu2xPHR/oSDZA6JWsglzDPNDL2EAljRjdhXV0vWmwQH3WgGwEM
	 I2Sshs0n7w6c19sY7I40Iw/uBu6i7iXXIIH0xgwKPUoRnbgeDuw9reNEFz8SuP94I8Je8
	 ekfDT+mrKe172QR7MazLCWbsF32fwNUJCSLOxX0A1mKB6MWhjUf4bCE4ZTnlKHcqaVWR8
	 qKpunzQN6vn0Er5R3xEIXM5AZXvytWnP7BuVTzclnvz28Q3KU9f6ljoD3Zym7N6ZPPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="UGJ9t/f0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D06606CF9E
	for <mm-commits@vger.kernel.org>; Thu,  5 Nov 2026 15:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=UGJ9t/f0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FD41F00A02;
	Thu,  5 Nov 2026 15:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793894090;
	bh=BMfzGjK1M8KPOc0N/SSy4QRKsqgSi84hxYac8JkGTJw=;
	h=Date:To:From:Subject;
	b=UGJ9t/f0lKFFMgdOZRorqSnQIXLJwhYdbq3L1zZNq08AlfNLxyDkzHBNEuphwHK+h
	 q6u1Pc09JDN5RZVQxVDth+zOD534VKEX1o/gWunNXxB4kl+Y76iaDvy59ut1bFndcl
	 9amggHTuMKpUBKQXyBXGPnDTNgALlgwkBC8hOEtg=
Date: Thu, 05 Nov 2026 07:54:50 -0800
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-remove-thp_size-and-thp_order.patch removed from -mm tree
Message-Id: <20261105155450.83FD41F00A02@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: remove thp_size() and thp_order()
has been removed from the -mm tree.  Its filename was
     mm-remove-thp_size-and-thp_order.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove thp_size() and thp_order()
Date: Mon, 02 Nov 2026 17:54:13 -0500

The last callers of thp_size() have been converted to folio_size(), and
thp_order()'s only remaining user was thp_size() itself, so remove
both.

Link: https://lore.kernel.org/20261102-page-wrappers-v1-8-e7280bdb31f6@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
---

 include/linux/mm.h |   21 ---------------------
 1 file changed, 21 deletions(-)

--- a/include/linux/mm.h~mm-remove-thp_size-and-thp_order
+++ a/include/linux/mm.h
@@ -2146,27 +2146,6 @@ static inline unsigned int page_shift(st
 	return PAGE_SHIFT + compound_order(page);
 }
 
-/**
- * thp_order - Order of a transparent huge page.
- * @page: Head page of a transparent huge page.
- */
-static inline unsigned int thp_order(struct page *page)
-{
-	VM_BUG_ON_PGFLAGS(PageTail(page), page);
-	return compound_order(page);
-}
-
-/**
- * thp_size - Size of a transparent huge page.
- * @page: Head page of a transparent huge page.
- *
- * Return: Number of bytes in this page.
- */
-static inline unsigned long thp_size(struct page *page)
-{
-	return PAGE_SIZE << thp_order(page);
-}
-
 #ifdef CONFIG_MMU
 /*
  * Do pte_mkwrite, but only if the vma says VM_WRITE.  We do this when
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-remove-mod_memcg_page_state.patch
mm-memcontrol-remove-page_memcg_check.patch
mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry.patch

