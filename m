Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A421E1DE9
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343133; cv=none; b=CrSDVgGPWZXXnKsMjndaCs4VYz11Pok9fH6sqmrlXURaivA5RFM82fmKhwo2aIfTcGY/Yhkh/kiNeJZ1bAfZ4VU8C2z4DZTVL+FPeJ0TrAnFteJlD8/jPpQw6kUADc41vnVr99tO6pt2m82VBRWsxfCNDv42PyJip8tmNmbosFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343133; c=relaxed/simple;
	bh=wzFT4MA9MvUsJ9sAMMu4X7A36LTwEyI0o6vxrpuu9j4=;
	h=Date:To:From:Subject:Message-Id; b=X8lobEy+lmHydxbssMkM1oCU8+Zg0Qk4eeHLtgb5SehO3dyDDsIcXNybLpwRUunGlLKGoLutLn6NvbT9KmF87bUYfvNkIVrbtVaJXF7KbX1DAD7pRiq6e4P5L88ixEy0fgRZ21H7VUaW9AM62uoCTnjS73y3pcy+VUSs2AxoSOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VWz4ICSj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VWz4ICSj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6D6C113D0;
	Mon, 17 Nov 2025 01:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343133;
	bh=wzFT4MA9MvUsJ9sAMMu4X7A36LTwEyI0o6vxrpuu9j4=;
	h=Date:To:From:Subject:From;
	b=VWz4ICSjzR2VH2I2pTRvS9X3jHIVznQfn7fLoEGhlVs2qZZepdsnnrcdu0PI/xSqK
	 WIQNYwjh5pUyVIjrN8YIPrfjZa7NjkhTYhsGg7cXeSCQpYdNFvUG2RFbs7u3kA7gKw
	 eh+a/tL6HbV39EzY4/L/hXOPzEJ9xXZOqO/oUFsQ=
Date: Sun, 16 Nov 2025 17:32:13 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sidhartha.kumar@oracle.com,ryan.roberts@arm.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch removed from -mm tree
Message-Id: <20251117013213.AD6D6C113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: mprotect: always skip dma pinned folio in prot_numa_skip()
has been removed from the -mm tree.  Its filename was
     mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mprotect: always skip dma pinned folio in prot_numa_skip()
Date: Thu, 23 Oct 2025 19:37:34 +0800

Patch series "mm: some optimizations for prot numa", v5.


This patch (of 4):

If the folio (even not CoW folio) is dma pinned, it can't be migrated due
to the elevated reference count.  So always skip a pinned folio to avoid
wasting cycles when folios are migrated.

Link: https://lkml.kernel.org/r/20251023113737.3572790-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20251023113737.3572790-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/mprotect.c~mm-mprotect-always-skip-dma-pinned-folio-in-prot_numa_skip
+++ a/mm/mprotect.c
@@ -136,9 +136,12 @@ static bool prot_numa_skip(struct vm_are
 	if (folio_is_zone_device(folio) || folio_test_ksm(folio))
 		goto skip;
 
-	/* Also skip shared copy-on-write pages */
-	if (is_cow_mapping(vma->vm_flags) &&
-	    (folio_maybe_dma_pinned(folio) || folio_maybe_mapped_shared(folio)))
+	/* Also skip shared copy-on-write folios */
+	if (is_cow_mapping(vma->vm_flags) && folio_maybe_mapped_shared(folio))
+		goto skip;
+
+	/* Folios are pinned and can't be migrated */
+	if (folio_maybe_dma_pinned(folio))
 		goto skip;
 
 	/*
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-kill-mm_wr_locked-from-unmap_vmas-and-unmap_single_vma.patch

