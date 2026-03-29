Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C9910F2
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744816; cv=none; b=d6Rlmm8iR95LBy9LB9ugInmi6b5POK1ahvpHW06fQTx4tM+m7mBBbcA9fr1CMC1m3HHjEmLlRhOIcilZwBTO+VeledzrzrlhReaWW/Ssmj50Lmjn9TkG4EW8cnQnBEDqIwZgwdq49j1uJCAZfANEeKtxLbWfLkxf0TNUcr4MECs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744816; c=relaxed/simple;
	bh=ie1vF86rwDi3tRRlVMKD8Atu2BOKcYrI0MVOggmFbd0=;
	h=Date:To:From:Subject:Message-Id; b=dAp00pxeRgznMsYipKPjt/H8gK5CHwC5T/Pr/RjoEFPo1yDWViOLqEmTpc/WnU+tTHrROyX0a0IahECClzbnfufZ9vfWD0Z6aqSzVJ//7sTjm3s4la70IHK4+iMKiWzBUNvGU8bKO3JD6rf+D0+5HgOqY5VG/SloJCOjxFwio2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2G9oG0vr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2G9oG0vr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5509C4CEF7;
	Sun, 29 Mar 2026 00:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744816;
	bh=ie1vF86rwDi3tRRlVMKD8Atu2BOKcYrI0MVOggmFbd0=;
	h=Date:To:From:Subject:From;
	b=2G9oG0vr8wcev68Rsysbs73sMcXTZFF6osbqjhRqWg0gv3x+9pgKmj5qisJ5oUP/h
	 PPfsZRPI8+T4meAnoxmnYd+WsSjxco++EU8urOaKxOaT+hNEegpM2I+d3KhdYh1dyo
	 sAEsQt6X3x0tWYb1T+VwoBrg9XzgBs4GKGPZAwHQ=
Date: Sat, 28 Mar 2026 17:40:15 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,richard.weiyang@gmail.com,rakie.kim@sk.com,npache@redhat.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-document-folio_get-requirement-before-frozen-pmd-split.patch removed from -mm tree
Message-Id: <20260329004015.E5509C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: document folio_get requirement before frozen PMD split
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-document-folio_get-requirement-before-frozen-pmd-split.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/migrate_device: document folio_get requirement before frozen PMD split
Date: Mon, 9 Mar 2026 14:25:02 -0700

split_huge_pmd_address() with freeze=true splits a PMD migration entry
into PTE migration entries, consuming one folio reference in the process. 
The folio_get() before it provides this reference.

Add a comment explaining this relationship.  The expected folio refcount
at the start of migrate_vma_split_unmapped_folio() is 1.

Link: https://lkml.kernel.org/r/20260309212502.3922825-1-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/migrate_device.c~mm-migrate_device-document-folio_get-requirement-before-frozen-pmd-split
+++ a/mm/migrate_device.c
@@ -914,6 +914,10 @@ static int migrate_vma_split_unmapped_fo
 	unsigned long flags;
 	int ret = 0;
 
+	/*
+	 * take a reference, since split_huge_pmd_address() with freeze = true
+	 * drops a reference at the end.
+	 */
 	folio_get(folio);
 	split_huge_pmd_address(migrate->vma, addr, true);
 	ret = folio_split_unmapped(folio, 0);
_

Patches currently in -mm which might be from usama.arif@linux.dev are


