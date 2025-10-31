Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4760F21257E
	for <mm-commits@vger.kernel.org>; Fri, 31 Oct 2025 03:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761882490; cv=none; b=jXS9AYRC29N5ZsFF1zNAkUBIAZAQLP32cDzptWznU3YpBeLEW/YLehKQfOzHjZUoHSOu8Y9Rw0zcMCFstvB5ocK/65+afqZLHCix9pRdGU8GHJSgFjsAAy6ha2C7+IXDekUMDA8XX43CWxel4GWpSYwhxGb/mK5cZhpzD5n2zhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761882490; c=relaxed/simple;
	bh=gEUWLn3Zr9W2Zgt92PIMdtMoOEuwzVI337FAtOjDuMg=;
	h=Date:To:From:Subject:Message-Id; b=B0M831ISrdQmO7I8/ztar6z7ze7wnUOfCjV/WJLnT9wFTOzm8V5DMm4jYSrkxzQoqUzNc2DArlhciE6JEqiXV9TEiT9ze9LpHjLxjwAkdkGnmnoHegxklHugrYpTEphk1LvlyPmCc7VsJK42zeV5NCpK02V0bEQi0ChsBm57ucM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=is7Bq/CZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="is7Bq/CZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91460C4CEE7;
	Fri, 31 Oct 2025 03:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761882489;
	bh=gEUWLn3Zr9W2Zgt92PIMdtMoOEuwzVI337FAtOjDuMg=;
	h=Date:To:From:Subject:From;
	b=is7Bq/CZB2KIy2keRsaY0RFiILLORpvzlp//L2dctNIEKzv0WKm1PJn4GKPwieQxJ
	 pjf0Z7cDl9YxkSUkNv/ahDP6AzyW7pLvTM27ZuF5cpQA/TUbNBPODj7SV+Yq+IwqWS
	 OfsE8La51D4u26ybkHvysKGY/6HImszuzFWC7Ox8=
Date: Thu, 30 Oct 2025 20:48:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,mcgrof@kernel.org,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,kernel@pankajraghav.com,jane.chu@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-split_huge_page_to_order.patch added to mm-new branch
Message-Id: <20251031034809.91460C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: add split_huge_page_to_order()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-add-split_huge_page_to_order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-split_huge_page_to_order.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: add split_huge_page_to_order()
Date: Wed, 29 Oct 2025 21:40:18 -0400

Patch series "Optimize folio split in memory failure", v4.


This patch (of 3):

When the caller does not supply a list to
split_huge_page_to_list_to_order(), use split_huge_page_to_order()
instead.

Link: https://lkml.kernel.org/r/20251030014020.475659-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20251030014020.475659-2-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Luis Chamberalin <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Pankaj Raghav <kernel@pankajraghav.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/include/linux/huge_mm.h~mm-huge_memory-add-split_huge_page_to_order
+++ a/include/linux/huge_mm.h
@@ -381,6 +381,10 @@ static inline int split_huge_page_to_lis
 {
 	return __split_huge_page_to_list_to_order(page, list, new_order, false);
 }
+static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
+{
+	return split_huge_page_to_list_to_order(page, NULL, new_order);
+}
 
 /*
  * try_folio_split_to_order - try to split a @folio at @page to @new_order using
@@ -400,8 +404,7 @@ static inline int try_folio_split_to_ord
 		struct page *page, unsigned int new_order)
 {
 	if (!non_uniform_split_supported(folio, new_order, /* warns= */ false))
-		return split_huge_page_to_list_to_order(&folio->page, NULL,
-				new_order);
+		return split_huge_page_to_order(&folio->page, new_order);
 	return folio_split(folio, new_order, page, NULL);
 }
 static inline int split_huge_page(struct page *page)
@@ -589,6 +592,11 @@ split_huge_page_to_list_to_order(struct
 {
 	VM_WARN_ON_ONCE_PAGE(1, page);
 	return -EINVAL;
+}
+static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
+{
+	VM_WARN_ON_ONCE_PAGE(1, page);
+	return -EINVAL;
 }
 static inline int split_huge_page(struct page *page)
 {
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-do-not-change-split_huge_page-target-order-silently.patch
mm-huge_memory-preserve-pg_has_hwpoisoned-if-a-folio-is-split-to-0-order.patch
mm-huge_memory-add-split_huge_page_to_order.patch
mm-memory-failure-improve-large-block-size-folio-handling.patch
mm-huge_memory-fix-kernel-doc-comments-for-folio_split-and-related.patch

