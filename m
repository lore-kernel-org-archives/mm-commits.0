Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E939737A831
	for <mm-commits@vger.kernel.org>; Tue, 11 Aug 2026 18:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786472174; cv=none; b=DCf1bKdZDdXFynnf1Xs37Fk0J4OL7oapgqz0T/1OFJEcVGiX4acuCL3XBzncrnruzokCdDTTvxXmL6418Mp3jlR4aO1Eb6FYk2V+2JJN3wcXmvMVXkgKqMKdy7w9fNYT89u+UVcYEMWua1rk4vrJmOPIk6anXX+TefioctrmRBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786472174; c=relaxed/simple;
	bh=nnLR7uiU8eCKKsLJYVqIRTLeWIfWssH6E81qSH6NIRk=;
	h=Date:To:From:Subject:Message-Id; b=FTXKhGqao8GAF5EmK2bxO8hHuexiTo8t0ZmlMF+fg9PsKhaOZ5Zj4AOyFNEhi5WPrppNyS7nhyp26W/tOPL29FXymIuaLfI/yBbm8d1p8H5VVdU9AR72FV7JesZg9kemUSjKDNebjUqScGO4ZGpU51jBY6tt2cetodTd7RSKacM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VxkNMyky; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VxkNMyky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2881F00A3A;
	Tue, 11 Aug 2026 18:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786472172;
	bh=UVGYvAty7+EMZv3pNHhI8D4EVnuICnvDUXtzjbnSZSo=;
	h=Date:To:From:Subject;
	b=VxkNMykyUxEz1ynzU+syzyNgR9PzQo78pJUtPvu11tRa1CKdD9S02+osg6GR0ma0o
	 jtYMuTQPLwqvKTe6oKPTMnxn8wHJCKhzU+1jtLFth3pgEu550mJUZQK8OMiSUtzvqA
	 mBqkfYukzNzGkYcHl8IMNDXzheKDmFxq1aTubK84=
Date: Tue, 11 Aug 2026 11:16:12 -0700
To: mm-commits@vger.kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch removed from -mm tree
Message-Id: <20260811181612.BC2881F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: unmap pte before releasing vma write lock
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Subject: mm/khugepaged: unmap pte before releasing vma write lock
Date: Tue, 04 Aug 2026 13:25:04 -0600

We are currently dropping the anon_vma write lock before unmapping the
PTE.  Although this is safe, due to us still holding the mmap_write_lock,
its safer and less confusing to switch the order of these two operations.

Link: https://lore.kernel.org/20260804-khugepaged_pte_refactor-v3-6-0364cad642a0@linux.dev
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-unmap-pte-before-releasing-vma-write-lock
+++ a/mm/khugepaged.c
@@ -1546,10 +1546,10 @@ static enum scan_result collapse_huge_pa
 
 	result = SCAN_SUCCEED;
 out_up_write:
-	if (anon_vma_locked)
-		anon_vma_unlock_write(vma->anon_vma);
 	if (pte)
 		pte_unmap(pte);
+	if (anon_vma_locked)
+		anon_vma_unlock_write(vma->anon_vma);
 	mmap_write_unlock(mm);
 out_nolock:
 	if (folio)
_

Patches currently in -mm which might be from nico.pache@linux.dev are

mm-documentation-clarify-where-the-mthp-stats-live.patch

