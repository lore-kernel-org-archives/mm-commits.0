Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FD02D9780
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 20:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764276460; cv=none; b=Bpt4Du4aagWqIGK4+hzHZP0r+g3JpzFO9IAEU8WEpuYpTkctgB4ibl9NbDpRg4zlleXGAdjCxOsGPMgs90zGlR5G5zzwSiQbGqJ+P5uzjRMLPvQDAU1LqLjxL2/TAqIobPFpTGz1dCUwBa6Mfy8wF1Y7gvbnNVOhpP3p/pU6OtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764276460; c=relaxed/simple;
	bh=ZWCYM3vTaMzT7dbfyOC2nwoOfJDN0WeJerTgdnCuPmI=;
	h=Date:To:From:Subject:Message-Id; b=mDRYTZmPE7CBXV5cW9pi0xIgK29AyCRjjtuW2ztOImsmwdStaUp0CX6lqIrQRYVmmhVp7KoypupXPVdnbpk14Bi8n1BrBVIzc/i92AKgrCiJNWAZTdv+FUJiYXNYFwwblpEGPfBqHhSW7KNyNfb6KvpcXm77Y7pZT3iSWQkml3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nGUXWRqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nGUXWRqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24878C4CEF8;
	Thu, 27 Nov 2025 20:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764276460;
	bh=ZWCYM3vTaMzT7dbfyOC2nwoOfJDN0WeJerTgdnCuPmI=;
	h=Date:To:From:Subject:From;
	b=nGUXWRqZksZrgAU9Qh96p/BCIK/NjEo4K5eOoyd95jwxzP4dXUZJyPivqmQhYbpre
	 YUVR7kcfkUV1drErLkatlX46wfRJaobfRQZ3Z5N8oWc2pXqEYjTULRRTKaMMnhgzv6
	 p9q5JFMtFY7dDgsBbfhvSzkzGOB2G/uV30t7+Fm4=
Date: Thu, 27 Nov 2025 12:47:39 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-fix-folio-split-stats-counting.patch added to mm-new branch
Message-Id: <20251127204740.24878C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: fix folio split stats counting
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-fix-folio-split-stats-counting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-fix-folio-split-stats-counting.patch

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
Subject: mm/huge_memory: fix folio split stats counting
Date: Wed, 26 Nov 2025 16:06:18 -0500

The "return <error code>" statements for error checks at the beginning of
__folio_split() skip necessary count_vm_event() and count_mthp_stat() at
the end of the function.  Fix these by replacing them with "ret = <error
code>; goto out;".

Link: https://lkml.kernel.org/r/20251126210618.1971206-5-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-folio-split-stats-counting
+++ a/mm/huge_memory.c
@@ -3942,16 +3942,20 @@ static int __folio_split(struct folio *f
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 
-	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
-		return -EINVAL;
+	if (folio != page_folio(split_at) || folio != page_folio(lock_at)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	if (new_order >= old_order)
-		return -EINVAL;
+	if (new_order >= old_order) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	ret = folio_check_splittable(folio, new_order, split_type);
 	if (ret) {
 		VM_WARN_ONCE(ret == -EINVAL, "Tried to split an unsplittable folio");
-		return ret;
+		goto out;
 	}
 
 	if (is_anon) {
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-change-folio_split_supported-to-folio_check_splittable.patch
mm-huge_memory-replace-can_split_folio-with-direct-refcount-calculation.patch
mm-huge_memory-make-min_order_for_split-always-return-an-order.patch
mm-huge_memory-fix-folio-split-stats-counting.patch

