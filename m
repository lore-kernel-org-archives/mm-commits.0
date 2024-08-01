Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4A514AA9
	for <mm-commits@vger.kernel.org>; Thu,  1 Aug 2024 19:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722541917; cv=none; b=iaMQVQ2lSJqQY0AzD5fTnIiY3Tj8DdL85ZEBjdccAvh3pSpdvNHeWRsYtsHIH2xqZebpr2j5mYeZeTcDzlCPZ+msN0IADtqqSfoFJ3jLGUuYIHLamsMkyDq3ZmPoiA8iblFZphzvAyjcYA+VgQtV0+mFiN+cZWF2Wr8QxjuF2JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722541917; c=relaxed/simple;
	bh=NbO3ZK7uvL6yFNe5TcLtKdTpAfJjbqgZp3HI7WrCw+Y=;
	h=Date:To:From:Subject:Message-Id; b=ujq7L1sdJrIm7xVVBesYrubtQBq9oMRO/SYzMzHHSaiVsoAQMRUuRInYZPSJLFafFjmuwaz+Uhzl3QoVa0xCVIA5fNBYNDZf0id+WJI6T0lL5vJFGu4tq7zas9yD0uL31Brmyc6rJYIT7d5FlzzU3MdWUwvBxSclN2YvaD7bzAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cNMB/JIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cNMB/JIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CFB0C32786;
	Thu,  1 Aug 2024 19:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722541916;
	bh=NbO3ZK7uvL6yFNe5TcLtKdTpAfJjbqgZp3HI7WrCw+Y=;
	h=Date:To:From:Subject:From;
	b=cNMB/JIRGAlMH67j4vBsnUFaHAaeuY/VvEsBZkV8Iz7NsC5L3gFZ0VFGVamD5WcLQ
	 tkuB+ZtdEU7F+SeHvmgXRW4nRNBpj2zmG1lQLFOkqFAwxfeau07aXwlhzhuCnNTZJ1
	 2VSjZMlzV/3jLdJiC2JBSusKv9h7CgQdhjRAOmUQ=
Date: Thu, 01 Aug 2024 12:51:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,gshan@redhat.com,david@redhat.com,baohua@kernel.org,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20240801195156.7CFB0C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix
Date: Wed, 31 Jul 2024 16:56:37 +0800

remove comment, per Barry

Link: https://lkml.kernel.org/r/c55d7ef7-78aa-4ed6-b897-c3e03a3f3ab7@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/shmem.c~mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix
+++ a/mm/shmem.c
@@ -1629,10 +1629,6 @@ unsigned long shmem_allowable_huge_order
 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
 	unsigned long vm_flags = vma->vm_flags;
-	/*
-	 * Check all the (large) orders below MAX_PAGECACHE_ORDER + 1 that
-	 * are enabled for this vma.
-	 */
 	unsigned long orders = THP_ORDERS_ALL_FILE_DEFAULT;
 	loff_t i_size;
 	int order;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem.patch
mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix.patch
mm-shmem-fix-incorrect-aligned-index-when-checking-conflicts.patch
mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch
mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch
mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch

