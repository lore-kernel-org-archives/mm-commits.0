Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A671C2DC8
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736836375; cv=none; b=XJln/wsuA15y971vHnSWSqIbeaNzZ5bPHgUCl3PMsrcySc77JK3IIjgb9Qd4PT4eGlyXW2jimQXoiMCDxQkcSjPcCw/Si4k6VnIFtrBoYzHreq6gnvcTKu9ZqDJdsbG0nia9Iaxjns/utfK01LfjPJTnQc0hU4NSJfeJKFkcj4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736836375; c=relaxed/simple;
	bh=N9fQ7xYb1xQk+OnDhO7XTBhaKm/GRl2UEUhoMHq3Rrg=;
	h=Date:To:From:Subject:Message-Id; b=ADAXG0WXHQXTnhBWus0uzFJE116OmPafE1mwC9BkAvdXhLxrX4ex3WkMkwD5tjnrohzziKE+XJOgtsrhNYXujKsOgRVPYbIDQg8D/1CBbx9unOsZ7egLCRcR7/C7qErD3UUszpf69CpPetSLRow5OJpaLV6QaPA0AlKwkSHPkTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pxBi9FKL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pxBi9FKL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1734C4CEDD;
	Tue, 14 Jan 2025 06:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736836374;
	bh=N9fQ7xYb1xQk+OnDhO7XTBhaKm/GRl2UEUhoMHq3Rrg=;
	h=Date:To:From:Subject:From;
	b=pxBi9FKLWbf3mZMb1emKzRqlhCKfJf9eiJoTwj7sJGpjngssD9vPSPUiBmOJCnIlD
	 +fTWkWYEpchblOlTVIuravA9yQLYLpk8KKbSAmfAtBaMihwnvtDmI+mMrCzYKYJ/eB
	 2NUqWfqpvExch+h7F6/UXSr75HT5IXC8dpFrVJ3w=
Date: Mon, 13 Jan 2025 22:32:54 -0800
To: mm-commits@vger.kernel.org,ying.huang@linux.alibaba.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,kasong@tencent.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch removed from -mm tree
Message-Id: <20250114063254.B1734C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix.patch

This patch was dropped because it was folded into mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix
Date: Tue Jan  7 06:25:19 PM PST 2025

use IS_ENABLED(), tweak comment grammar 

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device-fix
+++ a/mm/shmem.c
@@ -1978,16 +1978,14 @@ static struct folio *shmem_swap_alloc_fo
 
 	/*
 	 * We have arrived here because our zones are constrained, so don't
-	 * limit chance of success by further cpuset and node constraints.
+	 * limit chance of success with further cpuset and node constraints.
 	 */
 	gfp &= ~GFP_CONSTRAINT_MASK;
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (order > 0) {
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && order > 0) {
 		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
 
 		gfp = limit_gfp_mask(huge_gfp, gfp);
 	}
-#endif
 
 	new = shmem_alloc_folio(gfp, order, info, index);
 	if (!new)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-damon-tests-vaddr-kunith-reduce-stack-consumption.patch
mm-huge_memoryc-rename-shadowed-local.patch
mm-shmem-skip-swapcache-for-swapin-of-synchronous-swap-device.patch
ksm-add-ksm-involvement-information-for-each-process-fix.patch
documentation-filesystems-procrst-fix-possessive-form-of-process.patch

