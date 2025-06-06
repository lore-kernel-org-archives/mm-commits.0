Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC80A1FAA;
	Fri,  6 Jun 2025 05:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749186181; cv=none; b=pzg0tV47epLBlx8wY6OicNLfmSdUGEytOcu6dCymaxfrOgAUGxPpDU3z0T0Id+a3oABOmc0HN8ns6ayP0fh7yh/H9Grrc3GVmDNLxczqMHlmGbkKW2x6FNEEXTcyLgFBc1a1rl6TNLziz73VQ5cyTfPyoCbm/amRE7g5QLJHSj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749186181; c=relaxed/simple;
	bh=TSQM2LCImr7/8SrWrLVIjZhOTYz/9xkaJZP5l6y/Pho=;
	h=Date:To:From:Subject:Message-Id; b=STdBl0hVT6z55WrCtDdtxoFcK3NMfI5IhUhY0o2VSlHHEMOgIfF+CobgQ8M2G/SLh0A52b14RKSQe9fCRelTHqhk6ULFlO3oOx8hjZoUCM493GvFycBjd/CBoVOgX684azkYKj1O7NHeaPiWy+gQCRtGdVLKKglfy5MJsJEjHlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XJgorIAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XJgorIAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF497C4CEEB;
	Fri,  6 Jun 2025 05:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749186180;
	bh=TSQM2LCImr7/8SrWrLVIjZhOTYz/9xkaJZP5l6y/Pho=;
	h=Date:To:From:Subject:From;
	b=XJgorIAdFGjzh90l/ETiZxof+RtCIjJt6uj4k8+aPhes8rWS4NN/+rwBDDY5ZTP4K
	 eLZiDkEb76yaVRaQCUWypl8XT1SqJxhCncDf6WqD/K/3z3jXUe1vTSk1odG8dUEUz+
	 vP6S+In8LhVS8Sq07g3X1Gl731Cn/BYxhhirGCYc=
Date: Thu, 05 Jun 2025 22:03:00 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-huge_pmd_unshare-vs-gup-fast-race.patch removed from -mm tree
Message-Id: <20250606050300.AF497C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-huge_pmd_unshare-vs-gup-fast-race.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race
Date: Tue, 27 May 2025 23:23:54 +0200

huge_pmd_unshare() drops a reference on a page table that may have
previously been shared across processes, potentially turning it into a
normal page table used in another process in which unrelated VMAs can
afterwards be installed.

If this happens in the middle of a concurrent gup_fast(), gup_fast() could
end up walking the page tables of another process.  While I don't see any
way in which that immediately leads to kernel memory corruption, it is
really weird and unexpected.

Fix it with an explicit broadcast IPI through tlb_remove_table_sync_one(),
just like we do in khugepaged when removing page tables for a THP
collapse.

Link: https://lkml.kernel.org/r/20250528-hugetlb-fixes-splitrace-v2-2-1329349bad1a@google.com
Link: https://lkml.kernel.org/r/20250527-hugetlb-fixes-splitrace-v1-2-f4136f5ec58a@google.com
Fixes: 39dde65c9940 ("[PATCH] shared page table for hugetlb page")
Signed-off-by: Jann Horn <jannh@google.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-fix-huge_pmd_unshare-vs-gup-fast-race
+++ a/mm/hugetlb.c
@@ -7629,6 +7629,13 @@ int huge_pmd_unshare(struct mm_struct *m
 		return 0;
 
 	pud_clear(pud);
+	/*
+	 * Once our caller drops the rmap lock, some other process might be
+	 * using this page table as a normal, non-hugetlb page table.
+	 * Wait for pending gup_fast() in other threads to finish before letting
+	 * that happen.
+	 */
+	tlb_remove_table_sync_one();
 	ptdesc_pmd_pts_dec(virt_to_ptdesc(ptep));
 	mm_dec_nr_pmds(mm);
 	return 1;
_

Patches currently in -mm which might be from jannh@google.com are

hugetlb-block-hugetlb-file-creation-if-hugetlb-is-not-set-up.patch

