Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A8C80029
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lXyOv5WA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348ADC433C8;
	Tue, 12 Dec 2023 18:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407579;
	bh=Bs0/aWa9oUTkE60zj/Lj2xQnWlgQ+TbzoYgPSZMu5pI=;
	h=Date:To:From:Subject:From;
	b=lXyOv5WA2XheMbmJaoPoaCmp4m4WApOA+7idQk+e5sx3OZwarzPDrkChOpehmcJMv
	 uY/qCYqigJPzqYJk//zIqP2uMgXUBxcttdWlhpoL7j3N/D3MdYC6NIL8/J9/PhjSEC
	 uK5o60xYqNV+xsE+y6XGpaVAjkNwuT3JKFMjv+0Y=
Date: Tue, 12 Dec 2023 10:59:38 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,sidhartha.kumar@oracle.com,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-use-a-folio-in-validate_page_before_insert.patch removed from -mm tree
Message-Id: <20231212185939.348ADC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory: use a folio in validate_page_before_insert()
has been removed from the -mm tree.  Its filename was
     mm-memory-use-a-folio-in-validate_page_before_insert.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: use a folio in validate_page_before_insert()
Date: Sat, 18 Nov 2023 10:32:29 +0800

Use a folio in validate_page_before_insert() to save two compound_head()
calls.

Link: https://lkml.kernel.org/r/20231118023232.1409103-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-memory-use-a-folio-in-validate_page_before_insert
+++ a/mm/memory.c
@@ -1842,9 +1842,12 @@ pte_t *__get_locked_pte(struct mm_struct
 
 static int validate_page_before_insert(struct page *page)
 {
-	if (PageAnon(page) || PageSlab(page) || page_has_type(page))
+	struct folio *folio = page_folio(page);
+
+	if (folio_test_anon(folio) || folio_test_slab(folio) ||
+	    page_has_type(page))
 		return -EINVAL;
-	flush_dcache_page(page);
+	flush_dcache_folio(folio);
 	return 0;
 }
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-fix-vma-heap-bounds-checking.patch

