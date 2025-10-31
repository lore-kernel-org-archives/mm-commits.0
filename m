Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16C83254B9
	for <mm-commits@vger.kernel.org>; Fri, 31 Oct 2025 21:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761947753; cv=none; b=ljVsWTocwywFjq5edNietuUQfga1V0N2QqVUrZYgfweQE55geAVdZbmnXPduA2BLNInr2OqBMsFJo0evkdfIiYX2Kcnz86XuOroYJ7xE3XKOOZ8uf2zBf6nHBViwxEVokdlhrmjXy4j3osjlo7pbGtasKmWf9dzGbHgzu5Wjxjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761947753; c=relaxed/simple;
	bh=MjViD6nBGndLs13+mFA/tyPOTVvlBu6uYNuchdMz518=;
	h=Date:To:From:Subject:Message-Id; b=CpxdoOX/NwfC/Fb3npzkMmUurxucmAe9acmxZa6rbjdW4W7Tz0Q23fjnt7nF3xikmmw9ZNj5SIW5ckLQRxmthpTdtODImW5nGKaqfnx/RXALMhRdPJfJv5IGtmg8By+89vCNg94sx9kCCdZWHpbCxSJNPrD7e2WTahCse2UCDr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uhsuu2mL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uhsuu2mL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944E7C116B1;
	Fri, 31 Oct 2025 21:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761947752;
	bh=MjViD6nBGndLs13+mFA/tyPOTVvlBu6uYNuchdMz518=;
	h=Date:To:From:Subject:From;
	b=uhsuu2mLNfAsesnLZU8H5KPzsGTgUD9dEvaIKJ3b3WJWpd0UO+KWbpJu9S+117rWg
	 OhN51zNDP5zeFER2ZY+a5Cblll2ZO+JoYIU5GIH0jtLvS9M6TASijbj8oUm/J5sxF7
	 n9d2+5fXVSrRdaEUZ/RtHjwBiPCHRUVPUkbVCDLI=
Date: Fri, 31 Oct 2025 14:55:51 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,mcgrof@kernel.org,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,kernel@pankajraghav.com,jane.chu@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-split_huge_page_to_order.patch added to mm-new branch
Message-Id: <20251031215552.944E7C116B1@smtp.kernel.org>
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
Date: Fri, 31 Oct 2025 12:19:59 -0400

Patch series "Optimize folio split in memory failure", v5.

This patchset optimizes folio split operations in memory failure code by
always splitting a folio to min_order_for_split() to minimize unusable
pages, even if min_order_for_split() is non zero and memory failure code
would take the failed path eventually for a successfully split folio. 

This means instead of making the entire original folio unusable memory
failure code would only make its after-split folio, which has order of
min_order_for_split() and contains HWPoison page, unusable.

For soft offline case, since the original folio is still accessible, no
split is performed if the folio cannot be split to order-0 to prevent
potential performance loss.

In addition, add split_huge_page_to_order() to improve code readability
and fix kernel-doc comment format for folio_split() and other related
functions.

Background
==========

This patchset is a follow-up of "[PATCH v3] mm/huge_memory: do not change
split_huge_page*() target order silently."[1] and [PATCH v4]
mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split to >0
order[2], since both are separated out as hotfixes.  It improves how
memory failure code handles large block size(LBS) folios with
min_order_for_split() > 0.  By splitting a large folio containing HW
poisoned pages to min_order_for_split(), the after-split folios without HW
poisoned pages could be freed for reuse.  To achieve this, folio split
code needs to set has_hwpoisoned on after-split folios containing HW
poisoned pages and it is done in the hotfix in [2].

This patchset includes:
1. A patch adds split_huge_page_to_order(),
2. Patch 2 and Patch 3 of "[PATCH v2 0/3] Do not change split folio target
   order"[3],


This patch (of 3):

When the caller does not supply a list to
split_huge_page_to_list_to_order(), use split_huge_page_to_order()
instead.

Link: https://lkml.kernel.org/r/20251031162001.670503-1-ziy@nvidia.com
Link: https://lkml.kernel.org/r/20251031162001.670503-2-ziy@nvidia.com
Link: https://lore.kernel.org/all/20251017013630.139907-1-ziy@nvidia.com/ [1]
Link: https://lore.kernel.org/all/20251023030521.473097-1-ziy@nvidia.com/ [2]
Link: https://lore.kernel.org/all/20251016033452.125479-1-ziy@nvidia.com/ [3]
Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
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
Cc: Yang Shi <shy828301@gmail.com>
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

