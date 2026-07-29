Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30282390CA9
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298465; cv=none; b=oIaTd/VpcAleSMnhHOmt4wqmyvegofCBXQ7+D83kqeohMo3KMM8cL+dGs0uYEZVfmGEKVSXrcykU/adAcgf5vG0M8gFLlXjk287gONIOnrL4HTc/pPuC4UJeQCzOntwuco43lht7VKhqD3HlC2z4LkmcX4Uo6Flo4v7Ej/tsJtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298465; c=relaxed/simple;
	bh=SlZ8TeQvFwQ/hH1aFWe+wZHRf1cBZ0za05texb5lwPU=;
	h=Date:To:From:Subject:Message-Id; b=fqpaey4uP6b2ZN0OCz3hmPyYFXUScGS1LfJk54S3MnyAbCOC6g5Hy+lHOGfNntRMpg+HCXTIHMeEpaxCUNn2U361zf1ZDsO2/phUYO5eYi+jhGyXG1iFHg63ml4V/d+DAFp0ZmutcwYUcs2h53llsdMPPgZfWn6KFvwCVB5IZpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ggDRk28h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ggDRk28h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FEF1F000E9;
	Wed, 29 Jul 2026 04:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298464;
	bh=VZZIwuoFqK+B/BREwo8w92sb3fLWIbJgfrVZBC0euAQ=;
	h=Date:To:From:Subject;
	b=ggDRk28hp239VpZMWIh8hk/e//6mzkSTm/8l02Ljk5oZ/aDF9a4+fbbzbfvwIfYDH
	 CSrF/VPVUM3/amUptgRKHRMC216/oz7MrFmB6h8Xczpj+qQyM+2anKlYZXppd/ZwF7
	 cUkOd0jHCnPNWVA45MPWsKFe8x9eta+xho3rbqHk=
Date: Tue, 28 Jul 2026 21:14:23 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.arif@linux.dev,rppt@kernel.org,ritesh.list@gmail.com,osalvador@suse.de,osalvador@kernel.org,npiggin@gmail.com,mpe@ellerman.id.au,maddy@linux.ibm.com,ljs@kernel.org,liam@infradead.org,fvdl@google.com,david@kernel.org,aneesh.kumar@linux.ibm.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mm_init-defer-hugetlb-reservation-until-after-zone-initialization.patch removed from -mm tree
Message-Id: <20260729041424.06FEF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mm_init: defer hugetlb reservation until after zone initialization
has been removed from the -mm tree.  Its filename was
     mm-mm_init-defer-hugetlb-reservation-until-after-zone-initialization.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/mm_init: defer hugetlb reservation until after zone initialization
Date: Fri, 12 Jun 2026 11:58:53 +0800

hugetlb_cma_reserve() and hugetlb_bootmem_alloc() currently run before
free_area_init(), so HugeTLB reservation happens before zone state is
initialized.

Move the reservation step after free_area_init() so the relevant zone
information is available before HugeTLB reserves memory.  This is needed
for later hugetlb changes that validate boot-time HugeTLB reservations
against zone boundaries.

Link: https://lore.kernel.org/20260612035903.2468601-10-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Frank van der Linden <fvdl@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mm_init.c~mm-mm_init-defer-hugetlb-reservation-until-after-zone-initialization
+++ a/mm/mm_init.c
@@ -2683,11 +2683,11 @@ void __init mm_core_init_early(void)
 {
 	int nid;
 
+	free_area_init();
+
 	hugetlb_cma_reserve();
 	hugetlb_bootmem_alloc();
 
-	free_area_init();
-
 	sparse_init();
 	for_each_node_state(nid, N_MEMORY)
 		sparse_vmemmap_init_nid_late(nid);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

selftests-mm-remove-obsolete-hugetlb-vmemmap-test.patch

