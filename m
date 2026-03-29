Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E296D1DE4FB
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744753; cv=none; b=dqgwPiHS1MDnUe49o+oUrKr4TUi2nFrzp3SSbZfJ/7ZRqUMdlqnGdpDHks5e2/f3P+I+7dug/tWvQx1zzIvE8x6G8MuO9STX9MfadLNPXt2+54jmS+2SgWUwInCI2Cbe38eufF0KztmZsQob9ykcb3Dmalf/f+D5YeA9o99yLC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744753; c=relaxed/simple;
	bh=ZCMz7AJelyxx3wFOx7b3Z+uXZGkwR3si0qV+T9siBG0=;
	h=Date:To:From:Subject:Message-Id; b=D72Jxv1vIeiixF0g8KEXmspJscK4b6HGQt83T07PSH1jT6JuhkWQhViAUfXyg7OrkQEnS8M5Mzd8Z8BXrf4Y6WCh/IWHwHQB6SeeE08Y/MsrHx/DBm+LE4B8hTmmT0xo/tzjDu7DmONetWlDBQ3K1P/GvtSaT/7A6MV2A7iREXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MwtiUkY1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MwtiUkY1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830D3C4CEF7;
	Sun, 29 Mar 2026 00:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744752;
	bh=ZCMz7AJelyxx3wFOx7b3Z+uXZGkwR3si0qV+T9siBG0=;
	h=Date:To:From:Subject:From;
	b=MwtiUkY19wpXROfsQWtil8VeX/bocsYCaIetIyDKG8MGm7l3KXzsQS+4EQCXxHLjk
	 7HW+syimXe1a1215m5U6PpIchhWw3fXv/R2nKM++lSPbXJtZcgWSD+EI75jf6gEHX3
	 KyZ/R4iUk/vD/jRp250M1zrMMjrLEugteuAg+sS4=
Date: Sat, 28 Mar 2026 17:39:12 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vincenzo.frascino@arm.com,tursulin@ursulin.net,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rodrigo.vivi@intel.com,rientjes@google.com,pfalcato@suse.de,peterz@infradead.org,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,luto@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,joonas.lahtinen@linux.intel.com,jgg@ziepe.ca,jarkko@kernel.org,jannh@google.com,jani.nikula@linux.intel.com,imbrenda@linux.ibm.com,hsweeten@visionengravers.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,edumazet@google.com,dsahern@kernel.org,dimitri.sivanich@hpe.com,davem@davemloft.net,daniel@iogearbox.net,cmllamas@google.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,ast@kernel.org,arve@android.com,arnd@arndb.de,andrii@kernel.org,aliceryhl@google.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,abbotti@mev.co.uk,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-move-adjusting-of-address-range-to-unmap_vmas.patch removed from -mm tree
Message-Id: <20260329003912.830D3C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: move adjusting of address range to unmap_vmas()
has been removed from the -mm tree.  Its filename was
     mm-memory-move-adjusting-of-address-range-to-unmap_vmas.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/memory: move adjusting of address range to unmap_vmas()
Date: Fri, 27 Feb 2026 21:08:39 +0100

__zap_vma_range() has two callers, whereby zap_page_range_single_batched()
documents that the range must fit into the VMA range.

So move adjusting the range to unmap_vmas() where it is actually required
and add a safety check in __zap_vma_range() instead.  In unmap_vmas(),
we'd never expect to have empty ranges (otherwise, why have the vma in
there in the first place).

__zap_vma_range() will no longer be called with start == end, so cleanup
the function a bit.  While at it, simplify the overly long comment to its
core message.

We will no longer call uprobe_munmap() for start == end, which actually
seems to be the right thing to do.

Note that hugetlb_zap_begin()->...->adjust_range_if_pmd_sharing_possible()
cannot result in the range exceeding the vma range.

Link: https://lkml.kernel.org/r/20260227200848.114019-9-david@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Arve <arve@android.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Daniel Borkman <daniel@iogearbox.net>
Cc: Dave Airlie <airlied@gmail.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kacinski <kuba@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jann Horn <jannh@google.com>
Cc: Janosch Frank <frankja@linux.ibm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Namhyung kim <namhyung@kernel.org>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Tvrtko Ursulin <tursulin@ursulin.net>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   58 +++++++++++++++++++-------------------------------
 1 file changed, 23 insertions(+), 35 deletions(-)

--- a/mm/memory.c~mm-memory-move-adjusting-of-address-range-to-unmap_vmas
+++ a/mm/memory.c
@@ -2073,44 +2073,28 @@ static void unmap_page_range(struct mmu_
 	tlb_end_vma(tlb, vma);
 }
 
-
-static void __zap_vma_range(struct mmu_gather *tlb,
-		struct vm_area_struct *vma, unsigned long start_addr,
-		unsigned long end_addr, struct zap_details *details)
+static void __zap_vma_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end,
+		struct zap_details *details)
 {
-	unsigned long start = max(vma->vm_start, start_addr);
-	unsigned long end;
-
-	if (start >= vma->vm_end)
-		return;
-	end = min(vma->vm_end, end_addr);
-	if (end <= vma->vm_start)
-		return;
+	VM_WARN_ON_ONCE(start >= end || !range_in_vma(vma, start, end));
 
 	if (vma->vm_file)
 		uprobe_munmap(vma, start, end);
 
-	if (start != end) {
-		if (unlikely(is_vm_hugetlb_page(vma))) {
-			/*
-			 * It is undesirable to test vma->vm_file as it
-			 * should be non-null for valid hugetlb area.
-			 * However, vm_file will be NULL in the error
-			 * cleanup path of mmap_region. When
-			 * hugetlbfs ->mmap method fails,
-			 * mmap_region() nullifies vma->vm_file
-			 * before calling this function to clean up.
-			 * Since no pte has actually been setup, it is
-			 * safe to do nothing in this case.
-			 */
-			if (vma->vm_file) {
-				zap_flags_t zap_flags = details ?
-				    details->zap_flags : 0;
-				__unmap_hugepage_range(tlb, vma, start, end,
-							     NULL, zap_flags);
-			}
-		} else
-			unmap_page_range(tlb, vma, start, end, details);
+	if (unlikely(is_vm_hugetlb_page(vma))) {
+		zap_flags_t zap_flags = details ? details->zap_flags : 0;
+
+		/*
+		 * vm_file will be NULL when we fail early while instantiating
+		 * a new mapping. In this case, no pages were mapped yet and
+		 * there is nothing to do.
+		 */
+		if (!vma->vm_file)
+			return;
+		__unmap_hugepage_range(tlb, vma, start, end, NULL, zap_flags);
+	} else {
+		unmap_page_range(tlb, vma, start, end, details);
 	}
 }
 
@@ -2174,8 +2158,9 @@ void unmap_vmas(struct mmu_gather *tlb,
 				unmap->vma_start, unmap->vma_end);
 	mmu_notifier_invalidate_range_start(&range);
 	do {
-		unsigned long start = unmap->vma_start;
-		unsigned long end = unmap->vma_end;
+		unsigned long start = max(vma->vm_start, unmap->vma_start);
+		unsigned long end = min(vma->vm_end, unmap->vma_end);
+
 		hugetlb_zap_begin(vma, &start, &end);
 		__zap_vma_range(tlb, vma, start, end, &details);
 		hugetlb_zap_end(vma, &details);
@@ -2204,6 +2189,9 @@ void zap_page_range_single_batched(struc
 
 	VM_WARN_ON_ONCE(!tlb || tlb->mm != vma->vm_mm);
 
+	if (unlikely(!size))
+		return;
+
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				address, end);
 	hugetlb_zap_begin(vma, &range.start, &range.end);
_

Patches currently in -mm which might be from david@kernel.org are


