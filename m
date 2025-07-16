Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440432EF285
	for <mm-commits@vger.kernel.org>; Wed, 16 Jul 2025 22:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752706767; cv=none; b=BiRfb07f4X1CQLeVG0HUDSA0rKwYsoqAIk5YMKosZG6VghbW597vEl20aj62dQY4QHdBDzZqLwTMLHqzYfJBqX8bZutUAaxnD48HXs81XzDKgHM+iXwtvzHOkd5LycYP4eNdsv26N4NRaIpnnF2rB5RWNgqSRupmL01SnD1kxgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752706767; c=relaxed/simple;
	bh=+qSlPvgIwhJKgqMJ0UoWq1TaPcjdQtqgIP3cU8aQ2fs=;
	h=Date:To:From:Subject:Message-Id; b=Lp3pAHLBBS4gLlgIWhX5Y3f8L04MG4xwgGba6RB/1zz/fnqfMwL2pcojOYo+M4ZHm1AGnKnGKM6x89KGNNN/QfCBqScZSkJLq19u98WloRig/6owC81gqJamXdd9Yh6gOW4DM6Lwr1w9UQeoWKGdFvgUUxlm6o0Emw45uIyCptU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WB68HIcU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WB68HIcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1323C4CEE7;
	Wed, 16 Jul 2025 22:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752706766;
	bh=+qSlPvgIwhJKgqMJ0UoWq1TaPcjdQtqgIP3cU8aQ2fs=;
	h=Date:To:From:Subject:From;
	b=WB68HIcUdhjVcVjom3VARIYnJQJWm0S5YjkoxfMQnKuljPMMVK0IVq6/geBd+sShs
	 62QLvPYVPGnDS95/qQ6pls84L+g+Si/tCeTALH6pWLEkSumIPJOH8+EvW627tgYmEs
	 dvBuToyd3Mtu5gC5VM1AwBEDaC82VN4wnT4Hx6sw=
Date: Wed, 16 Jul 2025 15:59:26 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,davem@davemloft.net,christophe.leroy@csgroup.eu,arnd@arndb.de,anshuman.khandual@arm.com,andreas@gaisler.com,alexghiti@rivosinc.com,agordeev@linux.ibm.com,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-call-to-hugetlb_free_pgd_range.patch added to mm-new branch
Message-Id: <20250716225926.A1323C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: remove call to hugetlb_free_pgd_range()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-call-to-hugetlb_free_pgd_range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-call-to-hugetlb_free_pgd_range.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Anthony Yznaga <anthony.yznaga@oracle.com>
Subject: mm: remove call to hugetlb_free_pgd_range()
Date: Tue, 15 Jul 2025 18:26:10 -0700

With the removal of the last arch-specific implementation of
hugetlb_free_pgd_range(), hugetlb VMAs no longer need special handling
when freeing page tables.

Link: https://lkml.kernel.org/r/20250716012611.10369-3-anthony.yznaga@oracle.com
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Hildenbrand <david@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   42 ++++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

--- a/mm/memory.c~mm-remove-call-to-hugetlb_free_pgd_range
+++ a/mm/memory.c
@@ -379,32 +379,26 @@ void free_pgtables(struct mmu_gather *tl
 			vma_start_write(vma);
 		unlink_anon_vmas(vma);
 
-		if (is_vm_hugetlb_page(vma)) {
-			unlink_file_vma(vma);
-			hugetlb_free_pgd_range(tlb, addr, vma->vm_end,
-				floor, next ? next->vm_start : ceiling);
-		} else {
-			unlink_file_vma_batch_init(&vb);
-			unlink_file_vma_batch_add(&vb, vma);
+		unlink_file_vma_batch_init(&vb);
+		unlink_file_vma_batch_add(&vb, vma);
 
-			/*
-			 * Optimization: gather nearby vmas into one call down
-			 */
-			while (next && next->vm_start <= vma->vm_end + PMD_SIZE
-			       && !is_vm_hugetlb_page(next)) {
-				vma = next;
-				next = mas_find(mas, ceiling - 1);
-				if (unlikely(xa_is_zero(next)))
-					next = NULL;
-				if (mm_wr_locked)
-					vma_start_write(vma);
-				unlink_anon_vmas(vma);
-				unlink_file_vma_batch_add(&vb, vma);
-			}
-			unlink_file_vma_batch_final(&vb);
-			free_pgd_range(tlb, addr, vma->vm_end,
-				floor, next ? next->vm_start : ceiling);
+		/*
+		 * Optimization: gather nearby vmas into one call down
+		 */
+		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
+			vma = next;
+			next = mas_find(mas, ceiling - 1);
+			if (unlikely(xa_is_zero(next)))
+				next = NULL;
+			if (mm_wr_locked)
+				vma_start_write(vma);
+			unlink_anon_vmas(vma);
+			unlink_file_vma_batch_add(&vb, vma);
 		}
+		unlink_file_vma_batch_final(&vb);
+
+		free_pgd_range(tlb, addr, vma->vm_end,
+			floor, next ? next->vm_start : ceiling);
 		vma = next;
 	} while (vma);
 }
_

Patches currently in -mm which might be from anthony.yznaga@oracle.com are

sparc64-remove-hugetlb_free_pgd_range.patch
mm-remove-call-to-hugetlb_free_pgd_range.patch
mm-drop-hugetlb_free_pgd_range.patch

