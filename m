Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008EC1DE4FB
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744749; cv=none; b=BlURU4Gcv5IKofBmP2mPJ/DpvNrS9mmRQcSeizQ9aQikFjheuX4iQ77E8l0jQr7PdZj9nn+gEPJzFHO+945WWsMLMkzsaVHVFhMFRyhSaNGXVhyhq+3pULty+9HLE+JG6KNwk0OhaKtL1OAk4dhcJS4YfIrEyPqP249yeANluAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744749; c=relaxed/simple;
	bh=kiUmgktbfvf+HF1laDxIk0p68ibiJMAU1TXubLA/hCg=;
	h=Date:To:From:Subject:Message-Id; b=E5cPv6ef7cll030yweR45ecnaOAGg1yHpB1quuvXrwYfyumaoJ5E7MN0zqcI7ycuZsS7m+j3ZBwvZajnDJWKze0JpncJ4pqggYYbbIoN6+rtHyxNV6OW7X8dd8dfPmmlLfJIH2zzZeDqWq8ph0yYL6yn8XgPJdhYh/rNAJIt+z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=oi4GknXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="oi4GknXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1C3C4CEF7;
	Sun, 29 Mar 2026 00:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744748;
	bh=kiUmgktbfvf+HF1laDxIk0p68ibiJMAU1TXubLA/hCg=;
	h=Date:To:From:Subject:From;
	b=oi4GknXTmAnwgCLeEStVJwVlDErUBDYtWNt0BgP+TPU1TTNscTywFeyZAUzTdd9WO
	 tJmmWasMuafd3Ox5QX47LANhFJrEvNHDyGHZ4AWaiYH+GRIdymsARN74WnWVw06erw
	 GX7v5ouuZ6LBJ8DaKi6SSwi++evAM9BL39CyFs2k=
Date: Sat, 28 Mar 2026 17:39:08 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,vincenzo.frascino@arm.com,tursulin@ursulin.net,tkjos@android.com,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rodrigo.vivi@intel.com,rientjes@google.com,pfalcato@suse.de,peterz@infradead.org,pabeni@redhat.com,ojeda@kernel.org,ncardwell@google.com,namhyung@kernel.org,mpe@ellerman.id.au,mingo@redhat.com,mhocko@suse.com,maddy@linux.ibm.com,luto@kernel.org,ljs@kernel.org,liam.howlett@oracle.com,leon@kernel.org,kuba@kernel.org,joonas.lahtinen@linux.intel.com,jgg@ziepe.ca,jarkko@kernel.org,jannh@google.com,jani.nikula@linux.intel.com,imbrenda@linux.ibm.com,hsweeten@visionengravers.com,hca@linux.ibm.com,gregkh@linuxfoundation.org,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,frankja@linux.ibm.com,edumazet@google.com,dsahern@kernel.org,dimitri.sivanich@hpe.com,davem@davemloft.net,daniel@iogearbox.net,cmllamas@google.com,brauner@kernel.org,bp@alien8.de,borntraeger@linux.ibm.com,ast@kernel.org,arve@android.com,arnd@arndb.de,andrii@kernel.org,aliceryhl@google.com,airlied@gmail.com,agordeev@linux.ibm.com,acme@kernel.org,abbotti@mev.co.uk,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-oom_kill-factor-out-zapping-of-vma-into-zap_vma_for_reaping.patch removed from -mm tree
Message-Id: <20260329003908.9D1C3C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/oom_kill: factor out zapping of VMA into zap_vma_for_reaping()
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-factor-out-zapping-of-vma-into-zap_vma_for_reaping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/oom_kill: factor out zapping of VMA into zap_vma_for_reaping()
Date: Fri, 27 Feb 2026 21:08:37 +0100

Let's factor it out so we can turn unmap_page_range() into a static
function instead, and so oom reaping has a clean interface to call.

Note that hugetlb is not supported, because it would require a bunch of
hugetlb-specific further actions (see zap_page_range_single_batched()).

Link: https://lkml.kernel.org/r/20260227200848.114019-7-david@kernel.org
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

 mm/internal.h |    5 +----
 mm/memory.c   |   36 ++++++++++++++++++++++++++++++++----
 mm/oom_kill.c |   15 +--------------
 3 files changed, 34 insertions(+), 22 deletions(-)

--- a/mm/internal.h~mm-oom_kill-factor-out-zapping-of-vma-into-zap_vma_for_reaping
+++ a/mm/internal.h
@@ -536,13 +536,10 @@ static inline void sync_with_folio_pmd_z
 }
 
 struct zap_details;
-void unmap_page_range(struct mmu_gather *tlb,
-			     struct vm_area_struct *vma,
-			     unsigned long addr, unsigned long end,
-			     struct zap_details *details);
 void zap_page_range_single_batched(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, unsigned long addr,
 		unsigned long size, struct zap_details *details);
+int zap_vma_for_reaping(struct vm_area_struct *vma);
 int folio_unmap_invalidate(struct address_space *mapping, struct folio *folio,
 			   gfp_t gfp);
 
--- a/mm/memory.c~mm-oom_kill-factor-out-zapping-of-vma-into-zap_vma_for_reaping
+++ a/mm/memory.c
@@ -2054,10 +2054,9 @@ static inline unsigned long zap_p4d_rang
 	return addr;
 }
 
-void unmap_page_range(struct mmu_gather *tlb,
-			     struct vm_area_struct *vma,
-			     unsigned long addr, unsigned long end,
-			     struct zap_details *details)
+static void unmap_page_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
+		unsigned long addr, unsigned long end,
+		struct zap_details *details)
 {
 	pgd_t *pgd;
 	unsigned long next;
@@ -2116,6 +2115,35 @@ static void unmap_single_vma(struct mmu_
 }
 
 /**
+ * zap_vma_for_reaping - zap all page table entries in the vma without blocking
+ * @vma: The vma to zap.
+ *
+ * Zap all page table entries in the vma without blocking for use by the oom
+ * killer. Hugetlb vmas are not supported.
+ *
+ * Returns: 0 on success, -EBUSY if we would have to block.
+ */
+int zap_vma_for_reaping(struct vm_area_struct *vma)
+{
+	struct mmu_notifier_range range;
+	struct mmu_gather tlb;
+
+	VM_WARN_ON_ONCE(is_vm_hugetlb_page(vma));
+
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma->vm_mm,
+				vma->vm_start, vma->vm_end);
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+	if (mmu_notifier_invalidate_range_start_nonblock(&range)) {
+		tlb_finish_mmu(&tlb);
+		return -EBUSY;
+	}
+	unmap_page_range(&tlb, vma, range.start, range.end, NULL);
+	mmu_notifier_invalidate_range_end(&range);
+	tlb_finish_mmu(&tlb);
+	return 0;
+}
+
+/**
  * unmap_vmas - unmap a range of memory covered by a list of vma's
  * @tlb: address of the caller's struct mmu_gather
  * @unmap: The unmap_desc
--- a/mm/oom_kill.c~mm-oom_kill-factor-out-zapping-of-vma-into-zap_vma_for_reaping
+++ a/mm/oom_kill.c
@@ -548,21 +548,8 @@ static bool __oom_reap_task_mm(struct mm
 		 * count elevated without a good reason.
 		 */
 		if (vma_is_anonymous(vma) || !(vma->vm_flags & VM_SHARED)) {
-			struct mmu_notifier_range range;
-			struct mmu_gather tlb;
-
-			mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0,
-						mm, vma->vm_start,
-						vma->vm_end);
-			tlb_gather_mmu(&tlb, mm);
-			if (mmu_notifier_invalidate_range_start_nonblock(&range)) {
-				tlb_finish_mmu(&tlb);
+			if (zap_vma_for_reaping(vma))
 				ret = false;
-				continue;
-			}
-			unmap_page_range(&tlb, vma, range.start, range.end, NULL);
-			mmu_notifier_invalidate_range_end(&range);
-			tlb_finish_mmu(&tlb);
 		}
 	}
 
_

Patches currently in -mm which might be from david@kernel.org are


