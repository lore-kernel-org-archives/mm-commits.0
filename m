Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B89468D
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 00:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q6DbaAS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF71C433C8;
	Mon, 11 Dec 2023 00:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702256118;
	bh=3Tvm+ovhNX3Wj21J8PRu++TjhTRMdTtds2Zr0Cxm1LQ=;
	h=Date:To:From:Subject:From;
	b=q6DbaAS8rlAKTSJhtJ8APFG673fqlc/t6tKo/3/DLZ9d2Wsuns/xyo3JJL3kurr9z
	 Koxd2z1GKShTwn872ifrYrDuSR/Hu43Ab9vkJpx9rjonTN+lxxL2Qbnv4nHilQac09
	 UMt+QAGvIXfcnhjp/wPMv3IeGLli/Brq/MrvhTWg=
Date: Sun, 10 Dec 2023 16:55:17 -0800
To: mm-commits@vger.kernel.org,vishal.moola@gmail.com,hca@linux.ibm.com,gerald.schaefer@linux.ibm.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] pgtable-rename-ptdesc-_refcount-field-to-__page_refcount.patch removed from -mm tree
Message-Id: <20231211005518.5DF71C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: pgtable: rename ptdesc _refcount field to __page_refcount
has been removed from the -mm tree.  Its filename was
     pgtable-rename-ptdesc-_refcount-field-to-__page_refcount.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: pgtable: rename ptdesc _refcount field to __page_refcount
Date: Tue, 21 Nov 2023 20:43:50 +0100

Rename ptdesc _refcount field to __page_refcount similar to the other
unused page fields.

Link: https://lkml.kernel.org/r/982bdc652ba79a606c3d01c905766e7e076b3315.1700594815.git.agordeev@linux.ibm.com
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Suggested-by: Vishal Moola <vishal.moola@gmail.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mm_types.h~pgtable-rename-ptdesc-_refcount-field-to-__page_refcount
+++ a/include/linux/mm_types.h
@@ -405,7 +405,7 @@ FOLIO_MATCH(compound_head, _head_2a);
  * @_pt_pad_2:        Padding to ensure proper alignment.
  * @ptl:              Lock for the page table.
  * @__page_type:      Same as page->page_type. Unused for page tables.
- * @_refcount:        Same as page refcount.
+ * @__page_refcount:  Same as page refcount.
  * @pt_memcg_data:    Memcg data. Tracked for page tables here.
  *
  * This struct overlays struct page for now. Do not modify without a good
@@ -438,7 +438,7 @@ struct ptdesc {
 #endif
 	};
 	unsigned int __page_type;
-	atomic_t _refcount;
+	atomic_t __page_refcount;
 #ifdef CONFIG_MEMCG
 	unsigned long pt_memcg_data;
 #endif
@@ -452,7 +452,7 @@ TABLE_MATCH(compound_head, _pt_pad_1);
 TABLE_MATCH(mapping, __page_mapping);
 TABLE_MATCH(rcu_head, pt_rcu_head);
 TABLE_MATCH(page_type, __page_type);
-TABLE_MATCH(_refcount, _refcount);
+TABLE_MATCH(_refcount, __page_refcount);
 #ifdef CONFIG_MEMCG
 TABLE_MATCH(memcg_data, pt_memcg_data);
 #endif
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are


