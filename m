Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A055478D
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 23:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774652699; cv=none; b=H2cFpN5KMjCA1nqiXZC04qb5EWXqW1/f306So/miUUB0LZum42MI6i84O+/ktqyydl3Xe7vUhcN9QDOY9sxAxm3FIx/IuuSkiNQGAQ4gaaLdRQP85s4WPSF+uNjRcFPG6Ns1HBNVmdrvsCR3+L2Hr+dGjE2xZsWEwAdbF5nKkO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774652699; c=relaxed/simple;
	bh=YJUWXKo7rr17J6uLZ16yYEtt2diBctbAOWInXwMVd3k=;
	h=Date:To:From:Subject:Message-Id; b=AaqjrEJMqNNEGlk31JdVCnL73irZ2kDFR+AIKy2IDyaJQ+zanxsxIpfcLAEkJccOtrCJ66aa6GgN9xnFglLBXndpT55EETw1eb8Mgc7Pk4HE2ND+NLRg0X2/def4h9oh0gsIm2Xh/TmtSjuwLEx2U/Q9BPFVhdhEElxFD+3PeUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EJDRlBc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EJDRlBc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC706C19423;
	Fri, 27 Mar 2026 23:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774652698;
	bh=YJUWXKo7rr17J6uLZ16yYEtt2diBctbAOWInXwMVd3k=;
	h=Date:To:From:Subject:From;
	b=EJDRlBc/+Q8qIHInAWtbnE7YyWIBLhtJGZBvhRx+aG2LqRK8vZKNWvly4EvbibHO3
	 o3/ie+yWYE2ZKRWNUVwCWwOmTmScMfebuO6YqCDk/ct5rOyVIibsXbQtBTsI58j0lq
	 4EmcazqEcI0FjS+t47b+6vUeWNx99QFQs90Hzjbc=
Date: Fri, 27 Mar 2026 16:04:58 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-use-vma_start_write_killable-in-collapse_huge_page.patch removed from -mm tree
Message-Id: <20260327230458.AC706C19423@smtp.kernel.org>
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
Date: Thu, 26 Mar 2026 01:08:33 -0700

Replace vma_start_write() with vma_start_write_killable(), improving
reaction time to the kill signal.  Replace vma_start_write() in
collapse_huge_page().

Link: https://lkml.kernel.org/r/20260326080836.695207-4-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
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
@@ -1166,7 +1166,10 @@ static enum scan_result collapse_huge_pa
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

a.patch
mm-vma-use-vma_start_write_killable-in-vma-operations.patch
mm-use-vma_start_write_killable-in-process_vma_walk_lock.patch
kvm-ppc-use-vma_start_write_killable-in-kvmppc_memslot_page_merge.patch
mm-vmscan-prevent-mglru-reclaim-from-pinning-address-space.patch

