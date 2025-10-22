Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1399F2798FA;
	Wed, 22 Oct 2025 21:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761167326; cv=none; b=fkZtVvORGLz+4ewSHJmqugZDiYZRDpVz2ioOc2C4cKeT00EcAQmcjAwV7jNPkpUtMv9YbKNp3e4QsgixDqQ7axB3cWISgaX88MbUwwpI8CuL/H9QJVnCHVRv9aPFHjFJT5xVllJ4tT5Z0PEcbTcp/BcAguoBWYFm39T97lCIuOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761167326; c=relaxed/simple;
	bh=LBZlHTAmUcH5qGRwAKkOhbKaIS4ykbI4GGpZ3ZcHMA0=;
	h=Date:To:From:Subject:Message-Id; b=XA3sVjPUgC1+Hm2gv5l+N9atLeqFPbDRtXUZnCYMJaTM5pkh4sCa1g+Qw2seea3dkJcTx+sDS1SQV0A4r26GndsGmLB26X6c84qunZfBEFWaBEwnNVaygxkD4nBgEZcCL2e0U9K/gEkbFmLTWLJPEAzSgz5MFfqmKYqPwIYPqNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kt3KnQRj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kt3KnQRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D4AC4CEE7;
	Wed, 22 Oct 2025 21:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761167325;
	bh=LBZlHTAmUcH5qGRwAKkOhbKaIS4ykbI4GGpZ3ZcHMA0=;
	h=Date:To:From:Subject:From;
	b=kt3KnQRjBRAaQo2V+qoEhY6Tj3Dp0WnE4S7dJfPpTXXPa7xcSjYRMR9pCP3+A6XpE
	 R3dnU99XnimWimXz0jOP0Ttyh2aBw95hE98bS8qR71Af45cfj9oYBjf6fs7l+VFn1P
	 rx1aDYDvn0yd5kxsjmYx3sEOPMeWtw5DCVCVLvoo=
Date: Wed, 22 Oct 2025 14:08:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,hughd@google.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-thp-allocation-and-fallback-loop.patch added to mm-hotfixes-unstable branch
Message-Id: <20251022210845.65D4AC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/shmem: fix THP allocation and fallback loop
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-fix-thp-allocation-and-fallback-loop.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-thp-allocation-and-fallback-loop.patch

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
Subject: mm/shmem: fix THP allocation and fallback loop
Date: Wed, 22 Oct 2025 18:57:19 +0800

The order check and fallback loop is updating the index value on every
loop, this will cause the index to be aligned by a larger value while the
loop shrinks the order.

This may result in inserting and returning a folio of the wrong index and
cause data corruption with some userspace workloads [1].

Link: https://lkml.kernel.org/r/20251022105719.18321-1-ryncsn@gmail.com
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

 mm/shmem.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-thp-allocation-and-fallback-loop
+++ a/mm/shmem.c
@@ -1895,10 +1895,11 @@ static struct folio *shmem_alloc_and_add
 		order = highest_order(suitable_orders);
 		while (suitable_orders) {
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
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-shmem-fix-thp-allocation-and-fallback-loop.patch

