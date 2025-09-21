Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3692BE02D
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758489921; cv=none; b=CkuFzLV6EEXhkQN7e6DEaBTVh72gQifI/AmeqJ//SrfZ55+sn+1OZ/MjGXOU5EFgzKzWHvu27nEa+ZGzabASfPo8omBYwi7z9YVdr7+6TXmCVKUcvGZSE1oWwTOOrXpOZN7nONegQQaiBJunn0Q7fcIOFtlncHpBbQiYk5KRrso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758489921; c=relaxed/simple;
	bh=Fss6dZABeV9m7MD66p+0k9i7sCFnOEoGzczagXFSF/M=;
	h=Date:To:From:Subject:Message-Id; b=N874cG/nwuTuPfa4m0pc41dxcR5FItTKi6LhSp0qg5y1GaJBOnz4ZJUb/EjiAiOX9kaaKpbit8XG8ub4WJ882KZfDdB0QWz9Ns19zdFW1e2DGba0uM2Eo2+pJIG0wMBPb8pTVUU9ou+ENqIuOR57KCF+JEffczS20ZTfjCe78YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g5rfnRTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g5rfnRTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BE1C4CEE7;
	Sun, 21 Sep 2025 21:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758489921;
	bh=Fss6dZABeV9m7MD66p+0k9i7sCFnOEoGzczagXFSF/M=;
	h=Date:To:From:Subject:From;
	b=g5rfnRTKK9Gh+rcTu2RokKq6APeoVO/h3tYGZHbVj5RX9t0VX8LbVWNR/jsS5weE/
	 VEK4//X9xHUUQIjEpoyTNRDkj80MD5QmDYB4Ix9Dld7vykU5BmAeBjGAzR7Ujha7bK
	 yWkTXn6ylN+M7wfySaOl6OjTn1X0XKrvPPrzlGqk=
Date: Sun, 21 Sep 2025 14:25:21 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,lorenzo.stoakes@oracle.com,lkp@intel.com,kas@kernel.org,david@redhat.com,baohua@kernel.org,anshuman.khandual@arm.com,p.raghav@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] huge_memory-return-einval-in-folio-split-functions-when-thp-is-disabled.patch removed from -mm tree
Message-Id: <20250921212521.94BE1C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: huge_memory: return -EINVAL in folio split functions when THP is disabled
has been removed from the -mm tree.  Its filename was
     huge_memory-return-einval-in-folio-split-functions-when-thp-is-disabled.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pankaj Raghav <p.raghav@samsung.com>
Subject: huge_memory: return -EINVAL in folio split functions when THP is disabled
Date: Fri, 5 Sep 2025 17:00:12 +0200

split_huge_page_to_list_[to_order](), split_huge_page() and
try_folio_split() return 0 on success and error codes on failure.

When THP is disabled, these functions return 0 indicating success even
though an error code should be returned as it is not possible to split a
folio when THP is disabled.

Make all these functions return -EINVAL to indicate failure instead of 0. 
As large folios depend on CONFIG_THP, issue warning as this function
should not be called without a large folio.

Link: https://lkml.kernel.org/r/20250905150012.93714-1-kernel@pankajraghav.com
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202509051753.riCeG7LC-lkp@intel.com/
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/include/linux/huge_mm.h~huge_memory-return-einval-in-folio-split-functions-when-thp-is-disabled
+++ a/include/linux/huge_mm.h
@@ -588,22 +588,26 @@ static inline int
 split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order)
 {
-	return 0;
+	VM_WARN_ON_ONCE_PAGE(1, page);
+	return -EINVAL;
 }
 static inline int split_huge_page(struct page *page)
 {
-	return 0;
+	VM_WARN_ON_ONCE_PAGE(1, page);
+	return -EINVAL;
 }
 
 static inline int split_folio_to_list(struct folio *folio, struct list_head *list)
 {
-	return 0;
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
 }
 
 static inline int try_folio_split(struct folio *folio, struct page *page,
 		struct list_head *list)
 {
-	return 0;
+	VM_WARN_ON_ONCE_FOLIO(1, folio);
+	return -EINVAL;
 }
 
 static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
_

Patches currently in -mm which might be from p.raghav@samsung.com are


