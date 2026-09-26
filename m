Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAEC33970F;
	Sat, 26 Sep 2026 20:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790456140; cv=none; b=ASRmVlTc8lMHiYCoeDRksd9XpyZWXZl2H7ns7A8vCiABScelKMP6zqK3ue5aapBttRhjl3fuJoBrQ6hGb8xshP7M6VJDjkwzmOTAYt8NRLO/NwWYAVjuI1PNysjjQAqPNfM8jZiYXXZ3zIJPX9QpD4xo6I9QqqkIysMNV/HMdQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790456140; c=relaxed/simple;
	bh=Tz1nPuroqrKbAh3mzfvADVvwOIk0EblK+f1yaLrlV1A=;
	h=Date:To:From:Subject:Message-Id; b=djkrW++IxFkIrg0B0yF8f99R8+uWZOun4M3uaK8VRcx6PmxWthVDJYTWgKo/D8NxkphWZAKbh7MKsjXi6Eb6hBZtNH4lD8GlE2V4HBlwyTbnEHx3SxQ2tupPeOgYkKBfp6pxmqGJ0tx7vLKhGn/u6AoC0CVR2VkaohD+z/vv9nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cVZvVfZ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cVZvVfZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730531F00893;
	Sat, 26 Sep 2026 20:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790456138;
	bh=M7spHMnRUU7fBvhMkCBcTSKPcu9ishhGisS82sD0/OM=;
	h=Date:To:From:Subject;
	b=cVZvVfZ7qDt9PBC/5ozKaL0lPXfUVyl/L01wfNNZoADK9EAyLzXd9+y8gUCEqoFD7
	 yl28sP46KhrUJQfJV3DDtS6DCqL49MzdfqIHU96tI9SPGx7Gp4bNDao+DnOhRtaGtf
	 D3UP/ZPEX/2Aru7M+qS7GLcpPxcC/RrX63VCHYRk=
Date: Sat, 26 Sep 2026 13:55:38 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,stable@vger.kernel.org,ryan.roberts@arm.com,qi.zheng@linux.dev,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,hughd@google.com,dev.jain@arm.com,david@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-ignore-sysfs-configs-for-shmem-forced-collapse.patch removed from -mm tree
Message-Id: <20260926205538.730531F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: ignore sysfs configs for shmem forced collapse
has been removed from the -mm tree.  Its filename was
     mm-shmem-ignore-sysfs-configs-for-shmem-forced-collapse.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: ignore sysfs configs for shmem forced collapse
Date: Mon, 14 Sep 2026 10:12:41 +0800

According to Documentation/mm/transhuge.rst, MADV_COLLAPSE is expected to
ignore any THP or mTHP interface settings.

However, after commit 26c7d8413aaf ("mm: thp: support "THPeligible"
semantics for mTHP with anonymous shmem"), performing MADV_COLLAPSE on
shmem will depend on /sys/.../hugepages-2048kB/shmem_enabled being set to
"inherit" (although that is the default), which can cause MADV_COLLAPSE to
fail unexpectedly.

This could cause a userspace-visible performance regression.

Fix this by returning the result of shmem_huge_global_enabled() directly
when MADV_COLLAPSE is requested, allowing PMD-order collapse while
ignoring shmem THP/mTHP settings.

Link: https://lore.kernel.org/063f655b4d6c4234f3aa27ed6ecab10283ecb880.1789351825.git.baolin.wang@linux.alibaba.com
Fixes: 26c7d8413aaf ("mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Closes: https://lore.kernel.org/all/20260908125105.1510704-7-kirill@shutemov.name/
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
---

 mm/shmem.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-ignore-sysfs-configs-for-shmem-forced-collapse
+++ a/mm/shmem.c
@@ -1847,8 +1847,11 @@ unsigned long shmem_allowable_huge_order
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
 						  shmem_huge_force, vma, vm_flags);
-	/* Tmpfs huge pages allocation */
-	if (!vma || !vma_is_anon_shmem(vma))
+	/*
+	 * Tmpfs huge pages allocation or forced collapse ignores
+	 * sysfs configs.
+	 */
+	if (!vma || !vma_is_anon_shmem(vma) || shmem_huge_force)
 		return global_orders;
 
 	/*
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-mglru-clear-the-reference-counter-for-rejected-folios.patch

