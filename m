Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0AA6266581
	for <mm-commits@vger.kernel.org>; Wed,  5 Aug 2026 01:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785892457; cv=none; b=I5THsBlSqIS3/idzeD9gUCt/GmBzbqv+1TwFn85oyu7mlm7c8TXhSL671l5Wc+aRJX/XOxU8aD+YYCTP8zssWblCMun4lZZ1Xmvsc0niIxgcCvSXmqP+0RNCXIx7fdeKRAxFqbQjgfOLz4NC1nPh6zSPl+19BFLuug41a7iipnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785892457; c=relaxed/simple;
	bh=bxN82NwC2Jjm/eRJGpp11OHtoElDMUMxIgr3QXJucZA=;
	h=Date:To:From:Subject:Message-Id; b=hrNq+owD8rXgIuUiefjebckrxm1IjowRYfQFMfQeu1jlo8Yy2w8lhO8RSFnIzdU0VvrRUnZwGP5dyF/xnWiVa0vhmFTNIIA4LZYlDN9m1pFyL5zPE6N+RfQeFqR19ugtQNuPYKSaV0giLR4AcLOYQHBFXumea1vms6W28fv55nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J6C6GqsF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J6C6GqsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4282D1F000E9;
	Wed,  5 Aug 2026 01:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785892455;
	bh=1PzOuy16bWUqJN4Y+KVRrLyvBEkj+3ZcYfEbUYx3948=;
	h=Date:To:From:Subject;
	b=J6C6GqsFKFq68wVszjikYl1D1KOvKER1yO7+tpXwix30UPhKZBzYLn4lDzPKVkISc
	 bq2WWZPGhFVPxXkOFaN+IbTiLaGidXMLMBlaK9IMz4OmasL9Ds0z1cBeJ8BZgJcQkK
	 xcpt5ZRHT9JtmY8G1yKcc6yo8tTg28mcDu0eftI0=
Date: Tue, 04 Aug 2026 18:14:14 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tzimmermann@suse.de,sj@kernel.org,pfalcato@suse.de,m.szyprowski@samsung.com,ljs@kernel.org,liam@infradead.org,kai.huang@intel.com,gourry@gourry.net,david@kernel.org,ackerleytng@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vma-add-and-use-vma__pgoff-fix.patch removed from -mm tree
Message-Id: <20260805011415.4282D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vma-add-and-use-vma__pgoff-fix
has been removed from the -mm tree.  Its filename was
     mm-vma-add-and-use-vma__pgoff-fix.patch

This patch was dropped because it was folded into mm-vma-add-and-use-vma__pgoff.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vma-add-and-use-vma__pgoff-fix
Date: Fri Jul 17 08:03:43 PM PDT 2026

use linear_page_delta() in __split_vma(), per Vlastimal & Lorenzo

Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vma.c~mm-vma-add-and-use-vma__pgoff-fix
+++ a/mm/vma.c
@@ -556,7 +556,7 @@ __split_vma(struct vma_iterator *vmi, st
 
 	if (new_below) {
 		vma->vm_start = addr;
-		vma_add_pgoff(vma, (addr - new->vm_start) >> PAGE_SHIFT);
+		vma_add_pgoff(vma, linear_page_delta(new, addr));
 	} else {
 		vma->vm_end = addr;
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hmm-make-config_hmm_mirror-select-config_mmu_notifier.patch
mm-vma-add-and-use-vma__pgoff.patch
alloc_tag-add-ioctl-to-proc-allocinfo-fix.patch
mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

