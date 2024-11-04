Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E01290F
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730695837; cv=none; b=Xk0yvNtWl+hUwYm9TYql0JKdcuawNBLu9nWTgrkGO2Vun6R/h8YJhf6ZKp+meIJZq8qh6Lqn+hk72RX6O9mNDMpk7OmgwJvFJ9pKJ21rgu21l6C/jj7gjasy1/FA/LTQpXTJV1ryvE5NZF+2Rb3gA+iTAUvsr9qsguMYZ7SDuq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730695837; c=relaxed/simple;
	bh=jMnWVOAgGC8gDZVwQGQFYdOwoJhI7jbrNwIYrJXsOi8=;
	h=Date:To:From:Subject:Message-Id; b=AU9rQvyVE6qINuhb7KsPj+xvuDyScKDiRay9BL+KUCS0GxXgYVbA0qdukM8U0nVV+h5Xl130Wcg6gMKfCpWT9q9qbUcqci5Xd0LHbTgF1V32UIPC8llSndm4hSB2AHXp3DSAkbOG8ucMU33WFP2z0XGzuBxXsEgdWtFecoqnelc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bITjHHsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bITjHHsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61FC1C4CECE;
	Mon,  4 Nov 2024 04:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730695837;
	bh=jMnWVOAgGC8gDZVwQGQFYdOwoJhI7jbrNwIYrJXsOi8=;
	h=Date:To:From:Subject:From;
	b=bITjHHsdVIP5ySl9GpmqtdPtOd+c+U1cgp2AYSRyh+yw5GM3fKx4UEwe5AIHJBm8c
	 TLx4k+OTCKdaNgjjDX6bXT+FOr2Dto2ZTGYPJhhtr0i+12eDoScZChwMIQptWKRfRq
	 8Z1EVH+Ocz0xoBXOXhb2/qj+YP1TTlQTe154Wc+E=
Date: Sun, 03 Nov 2024 20:50:36 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,lkp@intel.com,donettom@linux.ibm.com,david@redhat.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch removed from -mm tree
Message-Id: <20241104045037.61FC1C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix
has been removed from the -mm tree.  Its filename was
     mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix.patch

This patch was dropped because it was folded into mm-consolidate-common-checks-in-hugetlb_get_unmapped_area.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix
Date: Tue Oct  8 11:25:48 AM PDT 2024

arch/mips/include/asm/hugetlb.h: remove now-unused local

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410081210.uNLbf3Jk-lkp@intel.com/
Cc: David Hildenbrand <david@redhat.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/mips/include/asm/hugetlb.h |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/mips/include/asm/hugetlb.h~mm-consolidate-common-checks-in-hugetlb_get_unmapped_area-fix
+++ a/arch/mips/include/asm/hugetlb.h
@@ -17,7 +17,6 @@ static inline int prepare_hugepage_range
 					 unsigned long len)
 {
 	unsigned long task_size = STACK_TOP;
-	struct hstate *h = hstate_file(file);
 
 	if (len > task_size)
 		return -ENOMEM;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix.patch
mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix.patch
mm-consolidate-common-checks-in-hugetlb_get_unmapped_area.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
mm-kasan-kmsan-copy_from-to_kernel_nofault-fix.patch
alloc_tag-load-module-tags-into-separate-contiguous-memory-fix-fix.patch
tools-mm-free-the-allocated-memory-fix.patch
memcg-v1-no-need-for-memcg-locking-for-mglru-fix.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch
memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch
bootmem-stop-using-page-index-fix.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
maple_tree-add-a-test-checking-storing-null-fix.patch
fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch

