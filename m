Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3D614AA9
	for <mm-commits@vger.kernel.org>; Thu,  1 Aug 2024 19:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722541918; cv=none; b=fHgTnDkoguVaEYxf2NA7/VLgt8U9TXeZZzNqSCniSo0bLawgUeIuUVQSbpflc9aSwfF1bnfIvnYpAboWfSpWTYkS9N5czKlXKpNDVOuXY6seniaeyfLaUJ48K8vV1BbuX5jL1p5IooOL2i3fjnbDLzb2zZ9cD5RL8M0ukUpH8C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722541918; c=relaxed/simple;
	bh=EdUFjtpw/vp6v7ipIDcDk+K9Oy++WqqzeCXOR0HZLq0=;
	h=Date:To:From:Subject:Message-Id; b=oTffbgPKTX7F/TDhKFi1rZKeJiWw7hDB7YcsRp2UCqiBFtVOBjC5ZTNu7iDSeCk67BK/+SPK9177otUbAj72oWchWtf4oJVX3qsT8FOZyh2SI+dM8lG2KCtVt+4SKWU1QeTvH+U1Drk5ldUd9ziwovVNYG3sFxPA49FJ70Ympwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CRbQAKMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CRbQAKMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4C6C32786;
	Thu,  1 Aug 2024 19:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722541917;
	bh=EdUFjtpw/vp6v7ipIDcDk+K9Oy++WqqzeCXOR0HZLq0=;
	h=Date:To:From:Subject:From;
	b=CRbQAKMatVBdndORCcSjKsX8226UTjh90KBWKvv6WFRHePWcrMH1wJb1hcHyhcI5i
	 JG0w6qEDAp6gVGA+L5IKAInVi8guCnAP7rkOHPo4DqslGFttD8iacKE9BqzMjdGwWG
	 tyi6KiqyNO1rvYoUvLy9PfGWtovBDpeEK3gHhO8c=
Date: Thu, 01 Aug 2024 12:51:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,gshan@redhat.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,21cnbao@gmail.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix-2.patch added to mm-hotfixes-unstable branch
Message-Id: <20240801195157.AE4C6C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix-2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix-2.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix-2
Date: Wed, 31 Jul 2024 17:59:23 +0800

remove local `orders'

Link: https://lkml.kernel.org/r/87769ae8-b6c6-4454-925d-1864364af9c8@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix-2
+++ a/mm/shmem.c
@@ -1629,7 +1629,6 @@ unsigned long shmem_allowable_huge_order
 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
 	unsigned long vm_flags = vma->vm_flags;
-	unsigned long orders = THP_ORDERS_ALL_FILE_DEFAULT;
 	loff_t i_size;
 	int order;
 
@@ -1674,7 +1673,7 @@ unsigned long shmem_allowable_huge_order
 	if (global_huge)
 		mask |= READ_ONCE(huge_shmem_orders_inherit);
 
-	return orders & mask;
+	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
 }
 
 static unsigned long shmem_suitable_orders(struct inode *inode, struct vm_fault *vmf,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix-2.patch
mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch

