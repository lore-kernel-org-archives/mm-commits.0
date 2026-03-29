Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7716A1EB9E3
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744756; cv=none; b=naMg61cIDX+OovrPKlNH+sYzOqUVG8HMZWv/FVX77Iltmrl7ltvt8T988fFhmDtJFM7bqyR55ZleDQDmqD57Ua8Sz1KME7PG/TUkImLBAz4lNyehcNxPwkuChHObGoPCGI6esrGkT1BmaasK0GqgKBJAZmdFm2xCtoSAYD5eMoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744756; c=relaxed/simple;
	bh=I5bi0ch30vLy/K2dYlFdrweZlrhTGh752WzisIRQ8aA=;
	h=Date:To:From:Subject:Message-Id; b=c7bayTxJxchf0iu7tSwsItlHDC+avt3QklTdz9R1ONqDvX80S7r5THLnI+O2bti3lEpbogwrl3R1s9kaJCwdCJ2Ihkic5lxEJ6UUUhW3ifRZ2R/FJozrc95zyn1mpiR8GZS+7dgD4PBLWkwzaesNBc6sImhybRHoZ5SJOBGqNYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N7Npo2Tp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N7Npo2Tp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B397C4CEF7;
	Sun, 29 Mar 2026 00:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744756;
	bh=I5bi0ch30vLy/K2dYlFdrweZlrhTGh752WzisIRQ8aA=;
	h=Date:To:From:Subject:From;
	b=N7Npo2TpQPDoN0sc5QLjJNSzA7lqtT+ONP6WctsMrcglgcTGT8uL8gOou6hSHmXGd
	 ncdOcGQM1fvoaxqUxui9JznY3TSb8z+epAGWi3cGVwLhD6PY8ix+lZyASvzPi60eiL
	 9OO/qEOmIW/LKNyax8YtXx2hXJ3+sdabSjMBDwUI=
Date: Sat, 28 Mar 2026 17:39:15 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vincenzo.frascino@arm.com,tursulin@ursulin.net,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rodrigo.vivi@intel.com,rientjes@google.com,pfalcato@suse.de,peterz@infradead.org,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,luto@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,joonas.lahtinen@linux.intel.com,jgg@ziepe.ca,jarkko@kernel.org,jannh@google.com,jani.nikula@linux.intel.com,imbrenda@linux.ibm.com,hsweeten@visionengravers.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,edumazet@google.com,dsahern@kernel.org,dimitri.sivanich@hpe.com,davem@davemloft.net,daniel@iogearbox.net,cmllamas@google.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,ast@kernel.org,arve@android.com,arnd@arndb.de,andrii@kernel.org,aliceryhl@google.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,abbotti@mev.co.uk,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-use-__zap_vma_range-in-zap_vma_for_reaping.patch removed from -mm tree
Message-Id: <20260329003916.4B397C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: use __zap_vma_range() in zap_vma_for_reaping()
has been removed from the -mm tree.  Its filename was
     mm-memory-use-__zap_vma_range-in-zap_vma_for_reaping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/memory: use __zap_vma_range() in zap_vma_for_reaping()
Date: Fri, 27 Feb 2026 21:08:41 +0100

Let's call __zap_vma_range() instead of unmap_page_range() to prepare for
further cleanups.

To keep the existing behavior, whereby we do not call uprobe_munmap()
which could block, add a new "reaping" member to zap_details and use it.

Likely we should handle the possible blocking in uprobe_munmap()
differently, but for now keep it unchanged.

Link: https://lkml.kernel.org/r/20260227200848.114019-11-david@kernel.org
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

 include/linux/mm.h |    1 +
 mm/memory.c        |   13 +++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

--- a/include/linux/mm.h~mm-memory-use-__zap_vma_range-in-zap_vma_for_reaping
+++ a/include/linux/mm.h
@@ -2769,6 +2769,7 @@ struct zap_details {
 	struct folio *single_folio;	/* Locked folio to be unmapped */
 	bool skip_cows;			/* Do not zap COWed private pages */
 	bool reclaim_pt;		/* Need reclaim page tables? */
+	bool reaping;			/* Reaping, do not block. */
 	zap_flags_t zap_flags;		/* Extra flags for zapping */
 };
 
--- a/mm/memory.c~mm-memory-use-__zap_vma_range-in-zap_vma_for_reaping
+++ a/mm/memory.c
@@ -2079,14 +2079,18 @@ static void __zap_vma_range(struct mmu_g
 		unsigned long start, unsigned long end,
 		struct zap_details *details)
 {
+	const bool reaping = details && details->reaping;
+
 	VM_WARN_ON_ONCE(start >= end || !range_in_vma(vma, start, end));
 
-	if (vma->vm_file)
+	/* uprobe_munmap() might sleep, so skip it when reaping. */
+	if (vma->vm_file && !reaping)
 		uprobe_munmap(vma, start, end);
 
 	if (unlikely(is_vm_hugetlb_page(vma))) {
 		zap_flags_t zap_flags = details ? details->zap_flags : 0;
 
+		VM_WARN_ON_ONCE(reaping);
 		/*
 		 * vm_file will be NULL when we fail early while instantiating
 		 * a new mapping. In this case, no pages were mapped yet and
@@ -2111,11 +2115,12 @@ static void __zap_vma_range(struct mmu_g
  */
 int zap_vma_for_reaping(struct vm_area_struct *vma)
 {
+	struct zap_details details = {
+		.reaping = true,
+	};
 	struct mmu_notifier_range range;
 	struct mmu_gather tlb;
 
-	VM_WARN_ON_ONCE(is_vm_hugetlb_page(vma));
-
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
 				vma->vm_start, vma->vm_end);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
@@ -2123,7 +2128,7 @@ int zap_vma_for_reaping(struct vm_area_s
 		tlb_finish_mmu(&tlb);
 		return -EBUSY;
 	}
-	unmap_page_range(&tlb, vma, range.start, range.end, NULL);
+	__zap_vma_range(&tlb, vma, range.start, range.end, &details);
 	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
 	return 0;
_

Patches currently in -mm which might be from david@kernel.org are


