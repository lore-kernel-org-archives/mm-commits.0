Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F571E7C1C
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160852; cv=none; b=iqexUYiBE6VuJO4inSnAUdGg5YxoI8Qk84176HyW+gbEpXEDlJvKKzdFv5OhfvR+1l+z+CIVx/2yrcRpzK1Tiamymm5mvUUFAxMVwWRw+8fXzVNEf7PN1BE5mbPE0MWkBXF/7S2k0xchB+PSTU41CHfsbqTte4moqWIioamgQf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160852; c=relaxed/simple;
	bh=G12sfUsVkqDZpXkNhWr4FoSwst2caAqTeLBKaQWNRRg=;
	h=Date:To:From:Subject:Message-Id; b=KiKM+N+ycp60huPKWNYq4b2YXeHzYGc5EqkoTilIqzlD7e5BMy446cbKNIXMbbbq+RrcjYPTHAcn5DgkAT1cSvc+bWRV/nUP1VbKEytLuN5hDXbsBJz4WG6FqqU7fbTFUb1MZ/Ucnpq6wc4wnoXbharQJIUjCoY6HiLaGO3v/NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NKq3dSGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NKq3dSGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08141C4CEEF;
	Sat,  2 Aug 2025 18:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160852;
	bh=G12sfUsVkqDZpXkNhWr4FoSwst2caAqTeLBKaQWNRRg=;
	h=Date:To:From:Subject:From;
	b=NKq3dSGjzxjfdzdAssYjobMyVOXeY9199L3AvVsmR2NWcih/QlSMVMoL5QVVTL++h
	 lnv60GXRSUWzfEyOVJZg6RLD1uySAMx7vFt8OXG7eRiSG+04sxQhz7uStkUkU2eANV
	 Has5CYiN/9Bk54iQ3bsH4zmDpy9I/fhaGqp5ct7M=
Date: Sat, 02 Aug 2025 11:54:11 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,thiago.bauermann@linaro.org,ryan.roberts@arm.com,rientjes@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,joern@logfs.org,hughd@google.com,dev.jain@arm.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,brahmajit.xyz@gmail.com,baolin.wang@linux.alibaba.com,avagin@gmail.com,andrii@kernel.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mincore-hold-ptl-in-mincore_hugetlb.patch removed from -mm tree
Message-Id: <20250802185412.08141C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mincore: hold PTL in mincore_hugetlb
has been removed from the -mm tree.  Its filename was
     mm-mincore-hold-ptl-in-mincore_hugetlb.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/mincore: hold PTL in mincore_hugetlb
Date: Thu, 24 Jul 2025 17:09:58 +0800

Hold PTL in mincore_hugetlb() to avoid operating on stale page, as
mincore_pte_range() have done.

Link: https://lkml.kernel.org/r/20250724090958.455887-4-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brahmajit Das <brahmajit.xyz@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/mincore.c~mm-mincore-hold-ptl-in-mincore_hugetlb
+++ a/mm/mincore.c
@@ -29,7 +29,9 @@ static int mincore_hugetlb(pte_t *pte, u
 #ifdef CONFIG_HUGETLB_PAGE
 	unsigned char present;
 	unsigned char *vec = walk->private;
+	spinlock_t *ptl;
 
+	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, pte);
 	/*
 	 * Hugepages under user process are always in RAM and never
 	 * swapped out, but theoretically it needs to be checked.
@@ -38,6 +40,7 @@ static int mincore_hugetlb(pte_t *pte, u
 	for (; addr != end; vec++, addr += PAGE_SIZE)
 		*vec = present;
 	walk->private = vec;
+	spin_unlock(ptl);
 #else
 	BUG();
 #endif
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch
mm-smaps-fix-race-between-smaps_hugetlb_range-and-migration.patch
fs-proc-task_mmu-hold-ptl-in-pagemap_hugetlb_range-and-gather_hugetlb_stats.patch

