Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B65A27BF7C;
	Tue, 21 Oct 2025 21:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761081439; cv=none; b=oB/6JPmpHZ0UnGulCZ9/0tl+s5CI2mHmH1W6rGbmaee9EZAfcZevKxocw5MRGQyShmndSnLoGos1K6cxc94cfiqxpwwk7p0YvTxSVKuTTyfErGIzmd9OVE7oGH2OtgPt3LFcCQnzvI3ZxX/cM0Dhifv72u8w6yYkhOCbisxVbNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761081439; c=relaxed/simple;
	bh=Is8OEJ6yaeGMKzX6wgy8g+v6FK3EgTrTNTk8+DFwGxU=;
	h=Date:To:From:Subject:Message-Id; b=CyK1rT1Ob9+oFz+u1dsf5CpC0qZdQzvSrUzYytwZhXdgk//u6OFDO2PksAdNj3JpSV3syFng3YrRQzuSQ6GPJtXZvIRN64AgPHjaGUfDk3IJc4beluu6JK1nNZYCy0RGw4SyxbEnHNDSsj4xILrn6QYSMdusaMd+0ayd4/3FR+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iyW6QSN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iyW6QSN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF31C4CEF1;
	Tue, 21 Oct 2025 21:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761081438;
	bh=Is8OEJ6yaeGMKzX6wgy8g+v6FK3EgTrTNTk8+DFwGxU=;
	h=Date:To:From:Subject:From;
	b=iyW6QSN22+0ZVRlk7zhLVFEm7OBz2N78HMW1rJM+3sFskecmeT4+HhXuqfK581r+F
	 2f2uocFkt4wQVJ75OfN4dv+uXGZUmYrHmfGqXRLaQRjgOzCnKGa85nRD60lX6XPw4/
	 fnmnE7aUR4w2rVHZ4YBiq6KbDlRseuGW5XXcKIfo=
Date: Tue, 21 Oct 2025 14:17:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-thp-allocation-size-check-and-fallback.patch added to mm-hotfixes-unstable branch
Message-Id: <20251021211718.BEF31C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: fix THP allocation size check and fallback
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-fix-thp-allocation-size-check-and-fallback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-thp-allocation-size-check-and-fallback.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Kairui Song <kasong@tencent.com>
Subject: mm/shmem: fix THP allocation size check and fallback
Date: Wed, 22 Oct 2025 03:04:36 +0800

There are some problems with the code implementations of THP fallback. 
suitable_orders could be zero, and calling highest_order on a zero value
returns an overflowed size.  And the order check loop is updating the
index value on every loop which may cause the index to be aligned by a
larger value while the loop shrinks the order.  And it forgot to try order
0 after the final loop.

This is usually fine because shmem_add_to_page_cache ensures the shmem
mapping is still sane, but it might cause many potential issues like
allocating random folios into the random position in the map or return
-ENOMEM by accident.  This triggered some strange userspace errors [1],
and shouldn't have happened in the first place.

Link: https://lkml.kernel.org/r/20251021190436.81682-1-ryncsn@gmail.com
Link: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/ [1]
Fixes: e7a2ab7b3bb5d ("mm: shmem: add mTHP support for anonymous shmem")
Signed-off-by: Kairui Song <kasong@tencent.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-thp-allocation-size-check-and-fallback
+++ a/mm/shmem.c
@@ -1824,6 +1824,9 @@ static unsigned long shmem_suitable_orde
 	unsigned long pages;
 	int order;
 
+	if (!orders)
+		return 0;
+
 	if (vma) {
 		orders = thp_vma_suitable_orders(vma, vmf->address, orders);
 		if (!orders)
@@ -1888,27 +1891,28 @@ static struct folio *shmem_alloc_and_add
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		orders = 0;
 
-	if (orders > 0) {
-		suitable_orders = shmem_suitable_orders(inode, vmf,
-							mapping, index, orders);
+	suitable_orders = shmem_suitable_orders(inode, vmf,
+						mapping, index, orders);
 
+	if (suitable_orders) {
 		order = highest_order(suitable_orders);
-		while (suitable_orders) {
+		do {
 			pages = 1UL << order;
-			index = round_down(index, pages);
-			folio = shmem_alloc_folio(gfp, order, info, index);
-			if (folio)
+			folio = shmem_alloc_folio(gfp, order, info, round_down(index, pages));
+			if (folio) {
+				index = round_down(index, pages);
 				goto allocated;
+			}
 
 			if (pages == HPAGE_PMD_NR)
 				count_vm_event(THP_FILE_FALLBACK);
 			count_mthp_stat(order, MTHP_STAT_SHMEM_FALLBACK);
 			order = next_order(&suitable_orders, order);
-		}
-	} else {
-		pages = 1;
-		folio = shmem_alloc_folio(gfp, 0, info, index);
+		} while (suitable_orders);
 	}
+
+	pages = 1;
+	folio = shmem_alloc_folio(gfp, 0, info, index);
 	if (!folio)
 		return ERR_PTR(-ENOMEM);
 
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-fix-thp-allocation-size-check-and-fallback.patch

