Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B744468D
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jq54/hrQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C7CC433C8;
	Mon, 11 Dec 2023 00:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256117;
	bh=FB8mIBvsGL3q5Lg7a4YFKKYVjqpZg3hC36NxhaDYDHk=;
	h=Date:To:From:Subject:From;
	b=jq54/hrQVLz3z/BkD272tiPpryB68X7w77xCxW091Obt1b6XNjovYzwMjRlmJpS6a
	 puuv9a843jldlA3gbjj5hpxiCA4rT55HlWPhhk+nl0/ZNEXL4W0kZOK3g+7j5lIHbZ
	 c0OM2Tt7pbT6Z/lM0SaHK7gMIbSxQVozwmQUrze4=
Date: Sun, 10 Dec 2023 16:55:16 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,hca@linux.ibm.com,gerald.schaefer@linux.ibm.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] pgtable-fix-s390-ptdesc-field-comments.patch removed from -mm tree
Message-Id: <20231211005517.62C7CC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: pgtable: fix s390 ptdesc field comments
has been removed from the -mm tree.  Its filename was
     pgtable-fix-s390-ptdesc-field-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: pgtable: fix s390 ptdesc field comments
Date: Tue, 21 Nov 2023 20:43:49 +0100

Patch series "minor ptdesc updates", v3.


This patch (of 2):

Since commit d08d4e7cd6bf ("s390/mm: use full 4KB page for 2KB PTE") there
is no fragmented page tracking on s390.  Fix the corresponding comments.

Link: https://lkml.kernel.org/r/cover.1700594815.git.agordeev@linux.ibm.com
Link: https://lkml.kernel.org/r/2eead241f3a45bed26c7911cf66bded1e35670b8.1700594815.git.agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/mm_types.h~pgtable-fix-s390-ptdesc-field-comments
+++ a/include/linux/mm_types.h
@@ -401,11 +401,11 @@ FOLIO_MATCH(compound_head, _head_2a);
  * @pmd_huge_pte:     Protected by ptdesc->ptl, used for THPs.
  * @__page_mapping:   Aliases with page->mapping. Unused for page tables.
  * @pt_mm:            Used for x86 pgds.
- * @pt_frag_refcount: For fragmented page table tracking. Powerpc and s390 only.
+ * @pt_frag_refcount: For fragmented page table tracking. Powerpc only.
  * @_pt_pad_2:        Padding to ensure proper alignment.
  * @ptl:              Lock for the page table.
  * @__page_type:      Same as page->page_type. Unused for page tables.
- * @_refcount:        Same as page refcount. Used for s390 page tables.
+ * @_refcount:        Same as page refcount.
  * @pt_memcg_data:    Memcg data. Tracked for page tables here.
  *
  * This struct overlays struct page for now. Do not modify without a good
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are


