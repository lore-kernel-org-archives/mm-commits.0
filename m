Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3019369D64
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622938; cv=none; b=s1oIy6MGXhExhSwQWyE3X+iOKaZcaCaaGYu1b2IxqomPVnxDXKzlE+YDwqXbdb9UAmf2mDn0TZs+PWuNyt9XNMLey3FKxb9G77my77BsyuzRDlJcS5RqJK9tX3eJOaz7lQ6ZLjsf4ikz99YmvgB7A1J6vajb1Ko/l3QNc536kLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622938; c=relaxed/simple;
	bh=HU5ctBdVF6fA/rnt3fVZTqWcwn+qOnUjumDFGNLZ7es=;
	h=Date:To:From:Subject:Message-Id; b=HlJgquMyaTaTGeq1AvW1CxAfDGd152eaU8Gx3AJA3GL77aXsPZ4KstjXe0JEp0/xjbd2k95F9J9Xu21etsSWtJQMW/SOmb2sZ3tfB4YDkav3A2bUci40bXCeGExY0voLb2+Qc7vE/qmHDiVqtkk8z8YF8T66t+jp2JOBrpjSCwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IgX9qw9a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IgX9qw9a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539011F000E9;
	Tue, 25 Aug 2026 01:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622937;
	bh=Dm+GF3Yg79Nsx0sN5+oRpreP2bFKjiKUJjcGmCcEttk=;
	h=Date:To:From:Subject;
	b=IgX9qw9aAxONQWnNZZCmAWKpK+zlqSF/3WA1hAZKnIfZb3clrlJ+5FQKcDAebNnP/
	 /R84bguZqWCsMb2+qofNyWSJOuX0Rm3x38drgouGFfC0djWH2E89JyzYFrNeV2FTip
	 +xhYqML1Ubc9l0I1zp/MhkS3uMXYgVQxb4whomkM=
Date: Mon, 24 Aug 2026 18:55:36 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,corbet@lwn.net,baolin.wang@linux.alibaba.com,baohua@kernel.org,nico.pache@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch removed from -mm tree
Message-Id: <20260825015537.539011F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: unmap pte before releasing vma write lock
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-unmap-pte-before-releasing-vma-write-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Subject: mm/khugepaged: unmap pte before releasing vma write lock
Date: Tue, 11 Aug 2026 06:48:38 -0600

We are currently dropping the anon_vma write lock before unmapping the
PTE.  Although this is safe, due to us still holding the mmap_write_lock,
its safer and less confusing to switch the order of these two operations.

Link: https://lore.kernel.org/20260811-khugepaged_pte_refactor-v4-6-ddac39d61c4a@linux.dev
Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-unmap-pte-before-releasing-vma-write-lock
+++ a/mm/khugepaged.c
@@ -1463,10 +1463,10 @@ static enum scan_result collapse_huge_pa
 
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


