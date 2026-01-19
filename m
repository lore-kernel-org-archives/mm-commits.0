Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AEC2727EE
	for <mm-commits@vger.kernel.org>; Mon, 19 Jan 2026 20:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854448; cv=none; b=bbyKUgpAElVk1hVqL77l8xt5K4D8Ffjcaoo8PMBOqdHEuXygwW77xnfMvYO+v0TKaKitvPLG70xcdJ4BSVF09nwhzs8DZGPJNO1iBJFkV7Up6D1v70wzTNaaFjjNQwjsuBt4MGAs8SGY3+LbYczBCWJkyDBwFcQePUi/TRrbz5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854448; c=relaxed/simple;
	bh=Iw0zU+aLY9Qh6T4y74UQ3x7zrwyhSzreCueeSWsBXHU=;
	h=Date:To:From:Subject:Message-Id; b=jhkls52xVbptxkTlqIz/xhiL5SwD3VkgV5K7BVY/geIb0Y8mn+L0KCDLTxAXNvk8Kx6C/Jsi3uOjbbjyobE3iOCleGa7hSv0XqiLXPm5TacUAfpjTl6K9GhasvQIpaEU6qeoQeJIwRMHX4kOIXeR8ri90IpInKjsXCdMPJPzhq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ClyqvW1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ClyqvW1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5DFC116C6;
	Mon, 19 Jan 2026 20:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768854447;
	bh=Iw0zU+aLY9Qh6T4y74UQ3x7zrwyhSzreCueeSWsBXHU=;
	h=Date:To:From:Subject:From;
	b=ClyqvW1SRvq9cSqXkvCdX9loo6ddLRWs6AqYB333G3rx+GyR+hbNO4Su2ZfoMerDY
	 a5jjLiHcHuDP6bDopSvNEWBIXv29sPMvQePXEr7WC26pnXekRCLBlS3tqL5JK68FqA
	 aE5+rXhOsWC4rPluDi4nZJ03mwu16yBZucxPcNmI=
Date: Mon, 19 Jan 2026 12:27:27 -0800
To: mm-commits@vger.kernel.org,suschako@amazon.de,riel@surriel.com,osalvador@suse.de,lorenzo.stoakes@oracle.com,loberman@redhat.com,liushixin2@huawei.com,lance.yang@linux.dev,harry.yoo@oracle.com,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather-fix.patch removed from -mm tree
Message-Id: <20260119202727.AA5DFC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather-fix.patch

This patch was dropped because it was folded into mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather.patch

------------------------------------------------------
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Subject: mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather-fix
Date: Thu, 25 Dec 2025 10:41:55 +0100

fix kerneldoc

Link: https://lkml.kernel.org/r/f223dd74-331c-412d-93fc-69e360a5006c@kernel.org
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Uschakow, Stanislav" <suschako@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_gather.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mmu_gather.c~mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather-fix
+++ a/mm/mmu_gather.c
@@ -462,8 +462,8 @@ void tlb_gather_mmu_fullmm(struct mmu_ga
 }
 
 /**
- * tlb_gather_mmu - initialize an mmu_gather structure for operating on a single
- *		    VMA
+ * tlb_gather_mmu_vma - initialize an mmu_gather structure for operating on a
+ *			single VMA
  * @tlb: the mmu_gather structure to initialize
  * @vma: the vm_area_struct
  *
_

Patches currently in -mm which might be from david@kernel.org are

mm-hugetlb-fix-hugetlb_pmd_shared.patch
mm-hugetlb-fix-two-comments-related-to-huge_pmd_unshare.patch
mm-rmap-fix-two-comments-related-to-huge_pmd_unshare.patch
mm-hugetlb-fix-excessive-ipi-broadcasts-when-unsharing-pmd-tables-using-mmu_gather.patch
vmw_balloon-adjust-balloon_deflate-when-deflating-while-migrating.patch
vmw_balloon-remove-vmballoon_compaction_init.patch
powerpc-pseries-cmm-remove-cmm_balloon_compaction_init.patch
mm-balloon_compaction-centralize-basic-page-migration-handling.patch
mm-balloon_compaction-centralize-adjust_managed_page_count-handling.patch
vmw_balloon-stop-using-the-balloon_dev_info-lock.patch
mm-balloon_compaction-use-a-device-independent-balloon-list-lock.patch
mm-balloon_compaction-remove-dependency-on-page-lock.patch
mm-balloon_compaction-make-balloon_mops-static.patch
mm-balloon_compaction-drop-fsh-include-from-balloon_compactionh.patch
drivers-virtio-virtio_balloon-stop-using-balloon_page_push-pop.patch
mm-balloon_compaction-remove-balloon_page_push-pop.patch
mm-balloon_compaction-fold-balloon_mapping_gfp_mask-into-balloon_page_alloc.patch
mm-balloon_compaction-move-internal-helpers-to-balloon_compactionc.patch
mm-balloon_compaction-assert-that-the-balloon_pages_lock-is-held.patch
mm-balloon_compaction-mark-remaining-functions-for-having-proper-kerneldoc.patch
mm-balloon_compaction-remove-extern-from-functions.patch
mm-vmscan-drop-inclusion-of-balloon_compactionh.patch
mm-rename-balloon_compactionch-to-balloonch.patch
mm-kconfig-make-balloon_compaction-depend-on-migration.patch
mm-rename-config_balloon_compaction-to-config_balloon_migration.patch
mm-rename-config_memory_balloon-config_balloon.patch
maintainers-move-memory-balloon-infrastructure-to-memory-management-balloon.patch
maintainers-move-memory-balloon-infrastructure-to-memory-management-balloon-fix.patch

