Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B00120D4E9
	for <mm-commits@vger.kernel.org>; Fri, 25 Jul 2025 02:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753409682; cv=none; b=QThjpVPYcHoopwFg9RNwXKuNuks+ssD0kqm0dHno5tNxfQiq3DPnGuTWhYtn+b4xrliFGjQz7/ey7zNGsfPLu2AqvD5mivmnfZZRu66vwrTzn7T67LJOJZB5VGfyOkI2+IPzjc/L4+wlKHDcMID6doWZpG1p4gVNu7KJi1UsuXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753409682; c=relaxed/simple;
	bh=U2sAPmel6vHX/OSR0ruD5bPeariviXmM4amSiB7h6IY=;
	h=Date:To:From:Subject:Message-Id; b=G63CVnbK/ol9naPGIVuWP7sYtA2k5UajaPD4L66ltmp8ZF4u2as5tY2Inq6qAt8eV0/OkDc0dRXiv2NFiZgcFH+aneuSsfIgyC3NDiBrK7enzWAx40hdink3KuBaD7RH+FjD+ZFJWMzg3DfNIWgO92IteVjUagGW4Gs3APVipy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=funhGMJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="funhGMJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E62C4CEED;
	Fri, 25 Jul 2025 02:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753409682;
	bh=U2sAPmel6vHX/OSR0ruD5bPeariviXmM4amSiB7h6IY=;
	h=Date:To:From:Subject:From;
	b=funhGMJyAyF1xIIlH/OvM4bSjXOzHZkVLJ+lUsuY9DqCcK9WluuVKG+IuKcHmCx1v
	 RyRzUHLeKPvD/KAemvYPWKMUP1rFy9J5CT/cPv8Tei5xHLCLN9kV3do47FOD2UVzh0
	 j/uBiT9qmUyA9IHJxTcH7qp8OoU/GSTfH9IFjPFc=
Date: Thu, 24 Jul 2025 19:14:41 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,davem@davemloft.net,christophe.leroy@csgroup.eu,arnd@arndb.de,anshuman.khandual@arm.com,andreas@gaisler.com,alexghiti@rivosinc.com,agordeev@linux.ibm.com,anthony.yznaga@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-call-to-hugetlb_free_pgd_range.patch removed from -mm tree
Message-Id: <20250725021441.E5E62C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: remove call to hugetlb_free_pgd_range()
has been removed from the -mm tree.  Its filename was
     mm-remove-call-to-hugetlb_free_pgd_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


