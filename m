Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632DB2500B1
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837191; cv=none; b=sSO1BgSt7jTU2GeztHDvKa6alwHSQCRXYzBQroMTl7P+kKrEu0XA8biECGekDvUF37jSPm4eU1fId5x9VcbpQtokLJ/MrGOnrUUUMW9p2InDiIO36VnDNtn8EFYSFjuGcpnQmX9Fi83tcJB4ccCCu0FxRRw2qCUoRSlTuj1m45M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837191; c=relaxed/simple;
	bh=ItxxTbcV2TL7T2En9SMlC2n668mgDhcLduWeFEGuBBw=;
	h=Date:To:From:Subject:Message-Id; b=QPGPv9Ct8frb5x21dmTfeAnG3NQFgHrim3+jeb0KuJba7PoB0/V/4uxY0lYH3as7/N9/OFs5eo2M2dIycghnlbNEgthjn4RRajsPbA5k/YfKv2dpbZJY9UDHo4gdCTs9xUvzJ+J3DV1o/R+RMjJElJ1m5SR+k0qziRSVS6q4UuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XNucE8iq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XNucE8iq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37C74C4CEDD;
	Tue, 14 Jan 2025 06:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837191;
	bh=ItxxTbcV2TL7T2En9SMlC2n668mgDhcLduWeFEGuBBw=;
	h=Date:To:From:Subject:From;
	b=XNucE8iqTJZHd68obw68DQhrnPlUYcRH/XPoijYWRN+nJvu9Og/JjBUC3JadduxQm
	 Y/AeQIoQPWHcegYCwMNGZdQ3PuvZtrHqzeFZJulS5VUy5XOdwuwZI50fuakYLHYttO
	 qGg51OuytMvX2XwkhB346CWP8xeUsS+EPsBFP7qY=
Date: Mon, 13 Jan 2025 22:46:30 -0800
To: mm-commits@vger.kernel.org,roman.gushchin@linux.dev,riel@surriel.com,osalvador@suse.de,nao.horiguchi@gmail.com,muchun.song@linux.dev,leitao@debian.org,ackerleytng@google.com,peterx@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-stop-using-avoid_reserve-flag-in-fork.patch removed from -mm tree
Message-Id: <20250114064631.37C74C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: stop using avoid_reserve flag in fork()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-stop-using-avoid_reserve-flag-in-fork.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: mm/hugetlb: stop using avoid_reserve flag in fork()
Date: Tue, 7 Jan 2025 15:39:57 -0500

When fork() and stumble on top of a dma-pinned hugetlb private page, CoW
must happen during fork() to guarantee dma coherency.

In this specific path, hugetlb pages need to be allocated for the child
process.  Stop using avoid_reserve=1 flag here: it's not required to be
used here, as dest_vma (which is destined to be a MAP_PRIVATE hugetlb vma)
will have no private vma resv map, and that will make sure it won't be
able to use a vma reservation later.

No functional change intended with this change.  Said that, it's still
wanted to do this, so as to reduce the usage of avoid_reserve to the only
one user, which is also why this flag was introduced initially in commit
04f2cbe35699 ("hugetlb: guarantee that COW faults for a process that
called mmap(MAP_PRIVATE) on hugetlbfs will succeed").  I don't see whoever
else should set it at all.

Further patch will clean up resv accounting based on this.

Link: https://lkml.kernel.org/r/20250107204002.2683356-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-stop-using-avoid_reserve-flag-in-fork
+++ a/mm/hugetlb.c
@@ -5373,7 +5373,7 @@ again:
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				/* Do not use reserve as it's private owned */
-				new_folio = alloc_hugetlb_folio(dst_vma, addr, 1);
+				new_folio = alloc_hugetlb_folio(dst_vma, addr, 0);
 				if (IS_ERR(new_folio)) {
 					folio_put(pte_folio);
 					ret = PTR_ERR(new_folio);
_

Patches currently in -mm which might be from peterx@redhat.com are


