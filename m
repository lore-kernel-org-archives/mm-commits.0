Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA10C80028
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JSk+gXS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84086C433C8;
	Tue, 12 Dec 2023 18:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407587;
	bh=VLUAPWioCO19rRkCPt4z3Rb9X11vu5eiS5o9NqFxXmQ=;
	h=Date:To:From:Subject:From;
	b=JSk+gXS22SVmyayKYESbCRk1xxq47p9epj7nvxy7/ycLhR4k5ADruJeqW1g91jt7W
	 QgftOiWgwdTgT6XBp4xAFp67fc1q2QyK7/WmjNo9vab6iUiOX3fINlZD9ooBFy1lCt
	 i59ZDd2JlvHJE3Mw2VLQLWd8eFQ9YP9fXfXDxBqY=
Date: Tue, 12 Dec 2023 10:59:46 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch removed from -mm tree
Message-Id: <20231212185947.84086C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: huge_memory: use more folio api in __split_huge_page_tail()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: huge_memory: use more folio api in __split_huge_page_tail()
Date: Fri, 10 Nov 2023 11:33:21 +0800

Use more folio APIs to save six compound_head() calls in
__split_huge_page_tail().

Link: https://lkml.kernel.org/r/20231110033324.2455523-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail
+++ a/mm/huge_memory.c
@@ -2509,13 +2509,13 @@ static void __split_huge_page_tail(struc
 	clear_compound_head(page_tail);
 
 	/* Finally unfreeze refcount. Additional reference from page cache. */
-	page_ref_unfreeze(page_tail, 1 + (!PageAnon(head) ||
-					  PageSwapCache(head)));
+	page_ref_unfreeze(page_tail, 1 + (!folio_test_anon(folio) ||
+					  folio_test_swapcache(folio)));
 
-	if (page_is_young(head))
-		set_page_young(page_tail);
-	if (page_is_idle(head))
-		set_page_idle(page_tail);
+	if (folio_test_young(folio))
+		folio_set_young(new_folio);
+	if (folio_test_idle(folio))
+		folio_set_idle(new_folio);
 
 	folio_xchg_last_cpupid(new_folio, folio_last_cpupid(folio));
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-fix-vma-heap-bounds-checking.patch

