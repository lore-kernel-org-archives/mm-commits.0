Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AEE155A2F
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 00:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730854727; cv=none; b=T7Mweb95+7U5HM6mhiTjjg75fgRw+q6preIbIDq7+Cy9Dlw7qVp+J5k5ZR+z9POshGiqvhQpYj1tHLAb6bgDxxx+xdfNWALsnkeb8Z/r0ZMqLhMD0s5hkkd9+UQWrM4ZlZIy6YrP07zt7LTCrk8BU8Tux2cSPm4ABWMcTZpm8kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730854727; c=relaxed/simple;
	bh=jNOcuY+8nGl+HIWWKYqxVshndjlaV3PRqGlpl8wLLZw=;
	h=Date:To:From:Subject:Message-Id; b=qVRmhLdFhoHlSkETcU0zynpsvIMU8TUa5trHaAw7I02TB2L/ePbsyk+sH/s8Cyhiej2bwlrcgb+Kkbv2ZAh6RnfQMhJ4mJ8dSxxBZYOPm3OoOd+iOOPMSnhGEnjxr/8EoMXirTCkxT+3OtQqWs7jFS7nYU3kMI/bCUUa45lZHVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Hdog60Xv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Hdog60Xv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD6BC4CECF;
	Wed,  6 Nov 2024 00:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730854727;
	bh=jNOcuY+8nGl+HIWWKYqxVshndjlaV3PRqGlpl8wLLZw=;
	h=Date:To:From:Subject:From;
	b=Hdog60Xvn48j8h13kj0e2vnlb7UeJQt8aBqj5BteOfIh48B860V5qJ4TQ4LzdZw4e
	 VYEHyTz2aWUaKaOV7W+/WJSGb5u7mdrsmY4PZjTvG6AyKgvGGszYLLhPolzqpFmsN7
	 fXGAZ5gJylp8wP7GkzKQdmvug5yS/fRlNLVBq3uc=
Date: Tue, 05 Nov 2024 16:58:46 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vishal.moola@gmail.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,muchun.song@linux.dev,hughd@google.com,david@redhat.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filemap-filemap_fault_recheck_pte_none-use-pte_offset_map_ro_nolock.patch removed from -mm tree
Message-Id: <20241106005847.7BD6BC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: filemap: filemap_fault_recheck_pte_none() use pte_offset_map_ro_nolock()
has been removed from the -mm tree.  Its filename was
     mm-filemap-filemap_fault_recheck_pte_none-use-pte_offset_map_ro_nolock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: filemap: filemap_fault_recheck_pte_none() use pte_offset_map_ro_nolock()
Date: Thu, 26 Sep 2024 14:46:16 +0800

In filemap_fault_recheck_pte_none(), we just do pte_none() check, so
convert it to using pte_offset_map_ro_nolock().

Link: https://lkml.kernel.org/r/9f7cbbaa772385ced1b8931b67a8b9d246c9b82d.1727332572.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-filemap-filemap_fault_recheck_pte_none-use-pte_offset_map_ro_nolock
+++ a/mm/filemap.c
@@ -3258,8 +3258,8 @@ static vm_fault_t filemap_fault_recheck_
 	if (!(vmf->flags & FAULT_FLAG_ORIG_PTE_VALID))
 		return 0;
 
-	ptep = pte_offset_map_nolock(vma->vm_mm, vmf->pmd, vmf->address,
-				     &vmf->ptl);
+	ptep = pte_offset_map_ro_nolock(vma->vm_mm, vmf->pmd, vmf->address,
+					&vmf->ptl);
 	if (unlikely(!ptep))
 		return VM_FAULT_NOPAGE;
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


