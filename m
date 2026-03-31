Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEFC3876D5
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 18:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774981786; cv=none; b=JgpaWzQnfQaj+YB9srmx/7f8BuLMvnl+9iUiCK0De4dQOtEmFliiQpE+f5ibtukHDiEWPWO99dCPgvJQY8XrV6n6DD0vftEtWgHt+bKrcYg7flH4GZIBqhR5aFaQdkGavq6CYNby661HGP9FUDUL67S0WtOMUXsohyopSMHpIEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774981786; c=relaxed/simple;
	bh=1lrcwLzKzaOlFlRXQJwzpOG2J3FZj6zSF4u747ypw+s=;
	h=Date:To:From:Subject:Message-Id; b=mZyq92TRSemfvvOXT8Ej8EiRIfgu/Cn8nMAUP9pfl0V2uIHbm5+MppunYsYL+PbwyhzuYfT3nuyP/8aNWT0GdQeK4IXclBc/sL6Jqxn8Lg76TiHuK5ztyVdJ0EOsLU6vNtk6pGuikSzJ3uA1zqYYTI/oh0gkEPyHxd1YWRtFinU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=II5tUS2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="II5tUS2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9C5C19423;
	Tue, 31 Mar 2026 18:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774981786;
	bh=1lrcwLzKzaOlFlRXQJwzpOG2J3FZj6zSF4u747ypw+s=;
	h=Date:To:From:Subject:From;
	b=II5tUS2TSKDF7+uP1XT9PkcfdUdiLF0slw/tBRedtrzsLr89GbNKdjjG9Kt1q3O6r
	 BCQDsubwqsM18KFr8Bhheof88SIv+Z75MIiBbU6dplADKjTjVca2Ey/ZFatVU9ACT0
	 l6wZI7Dw/6F5yXXEqd5aZlkLH5icNfWP2/8yuLaY=
Date: Tue, 31 Mar 2026 11:29:45 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-use-vma_start_write_killable-in-collapse_huge_page.patch removed from -mm tree
Message-Id: <20260331182946.4E9C5C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: use vma_start_write_killable() in collapse_huge_page()
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-use-vma_start_write_killable-in-collapse_huge_page.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm/khugepaged: use vma_start_write_killable() in collapse_huge_page()
Date: Fri, 27 Mar 2026 13:54:54 -0700

Replace vma_start_write() with vma_start_write_killable(), improving
reaction time to the kill signal.  Replace vma_start_write() in
collapse_huge_page().

Link: https://lkml.kernel.org/r/20260327205457.604224-4-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-use-vma_start_write_killable-in-collapse_huge_page
+++ a/mm/khugepaged.c
@@ -1159,7 +1159,10 @@ static enum scan_result collapse_huge_pa
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma)) {
+		result = SCAN_FAIL;
+		goto out_up_write;
+	}
 	result = check_pmd_still_valid(mm, address, pmd);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
_

Patches currently in -mm which might be from surenb@google.com are

mm-vma-use-vma_start_write_killable-in-vma-operations.patch
mm-use-vma_start_write_killable-in-process_vma_walk_lock.patch
kvm-ppc-use-vma_start_write_killable-in-kvmppc_memslot_page_merge.patch
mm-vmscan-prevent-mglru-reclaim-from-pinning-address-space.patch

