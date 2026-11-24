Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795562972;
	b=YGEDlBnf99Irv2wyIKtE1k7gxCW4Kn5gKqbLLnIYWPJjfxapkK8SgkgMArAkOIsY7cW7
	 rACbElzOC+Cyzoxwbogy6y4AwOGG71ubcTyxC5kn6Yh8ztYew8xj/VwK8SuF03dTPLTai
	 ruQ4DO1aIzidcIM6B5XZZz2iWz/jB+HYSSnODGUAmJmxLWBLziyk9EHF0xYgovzupFnRi
	 E6nlhtdbD6tTX9it5eke6PPZ92g95AO0P+MM2/XU9/zCZM0FU3Dt+3xWsXdfOJNxUGXsJ
	 SS3O5jkKfbOR2fdvZjNlm3iM/WZpb4p5CbhBoIjAvX8WWd1QueB+T4MRZHlNP4+ESeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795562972;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Bf+XBPyChdHiXT7CR8kI8PmkqJa/ocekJYhEnaM1zK0=;
	b=coAuTxOajAliHyCdCDI4jUU6X9pkJbSxZbRDPcO59lzRkmrxNnjMM7PhO8OXkaDFsMdy
	 wORWXElmmeM5hLbVT6sAhpBgK+ID8Ewgo+wNc741zH5fSmk5RvuCeBNBc07LGtB7LEzPe
	 evH7Wd4uN0gkEpZUoxDkvZJhG88TAYZHoM1Knl1bxefyBjksEjaqRdfhUWsiLaqb23QvU
	 UBryTssCY7H2pvkXMPhmyxi9mfsu0faYwGxkukfX4dPcwWt2RsNxLvFSvuDDGa8qx17go
	 flMRn4WLd4YtMOoyW8AE67ym9ELrWx7ljYyvPPbcLK4BI/3ml/8Ab96HS+YzKtoYrXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mYlq0kUW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E643606A321;
	Tue, 24 Nov 2026 23:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=mYlq0kUW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9941F000D0;
	Tue, 24 Nov 2026 23:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795562972;
	bh=Bf+XBPyChdHiXT7CR8kI8PmkqJa/ocekJYhEnaM1zK0=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=mYlq0kUW2IRakdostg7qCwA2d6dNIH6zs6v5Ej1s3zTVRkpw8rOdzZFhar4+W75Gx
	 FYjx23UTd6ktLaQqmEKRhYXFvOGrqNdM/UEbfaPm3uYwRb43rLfee+W4TXidXuFTX4
	 +71scsIZ4YIJur9mwNZj7zOtuB/QTQYoOm8wCkhQ=
Date: Tue, 24 Nov 2026 15:29:31 -0800
To: mm-commits@vger.kernel.org,xu.xin@linux.dev,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,
	shakeel.butt@linux.dev,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,kees@kernel.org,josef@toxicpanda.com,
	joey.gouly@arm.com,jannh@google.com,hughd@google.com,gourry@gourry.net,
	david@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,
	bunk@stusta.de,azpijr@gmail.com,a.p.zijlstra@chello.nl,aaw@google.com,
	mason@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-4-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-4-236e925d9b64@kernel.org>
Subject: + mm-vma-fix-uncharge-after-failed-stack-relocation.patch added to mm-new branch
Message-Id: <20261124232931.EA9941F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vma: fix uncharge after failed stack relocation
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-fix-uncharge-after-failed-stack-relocation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-fix-uncharge-after-failed-stack-relocation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Chris Mason <mason@kernel.org>
Subject: mm/vma: fix uncharge after failed stack relocation
Date: Sat, 21 Nov 2026 16:02:30 +0000

An execve() that fails to relocate its stack can underflow
vm_committed_as, and the commit limit of vm.overcommit_memory=2 then no
longer holds.

exit_mmap() uncharges vma_pages() of each VMA with VMA_ACCOUNT_BIT, so
the charge has to match the size of the VMA. relocate_vma_down() expands
the stack VMA by the relocation distance without a charge, and relies on
its vma_shrink() to make the two match again. But it returns with the
VMA still expanded if move_page_tables() can't allocate a page table,
for example at the memory cgroup limit, or if vma_shrink() fails:

    relocate_vma_down()             charged    vma_pages()
    ===================             =======    ===========
                                    L          L
    vma_expand()                    L          L + shift
    move_page_tables() fails
      return -ENOMEM

    exit_mmap()
      tear_down_vmas()
      vm_unacct_memory(L + shift)   -shift

On x86-64 with 4-level page tables, the distance is up to 16 GiB for a
64-bit program, and about 128 TiB for a 32-bit one.

Fix the issue by giving back the charge of the stack VMA where its
relocation fails, and excluding the VMA from what exit_mmap() uncharges.
The argument pages of the dying task are then outside the commit charge
until exit_mmap() frees them.

Link: https://patch.msgid.link/20261121-some-more-ai-fixes-v1-4-236e925d9b64@kernel.org
Fixes: b6a2fea39318 ("mm: variable length argument support")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
  Link: https://lore.kernel.org/179536262938.412063.9413830491196612418.b4-reply@b4
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ollie Wild <aaw@google.com>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Xu Xin <xu.xin@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Cc: <stable@vger.kernel.org>

 mm/vma_exec.c |   22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

--- a/mm/vma_exec.c~mm-vma-fix-uncharge-after-failed-stack-relocation
+++ a/mm/vma_exec.c
@@ -45,6 +45,7 @@ int relocate_vma_down(struct vm_area_str
 	struct vm_area_struct *next;
 	struct mmu_gather tlb;
 	PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
+	int err;
 
 	BUG_ON(new_start > new_end);
 
@@ -68,8 +69,10 @@ int relocate_vma_down(struct vm_area_str
 	 * process cleanup to remove whatever mess we made.
 	 */
 	pmc.for_stack = true;
-	if (length != move_page_tables(&pmc))
-		return -ENOMEM;
+	if (length != move_page_tables(&pmc)) {
+		err = -ENOMEM;
+		goto err_unacct;
+	}
 
 	tlb_gather_mmu(&tlb, mm);
 	next = vma_next(&vmi);
@@ -93,7 +96,20 @@ int relocate_vma_down(struct vm_area_str
 
 	vma_prev(&vmi);
 	/* Shrink the vma to just the new range */
-	return vma_shrink(&vmi, vma, new_end);
+	err = vma_shrink(&vmi, vma, new_end);
+	if (err)
+		goto err_unacct;
+
+	return 0;
+
+err_unacct:
+	/*
+	 * The vma now spans more than was charged, so exit_mmap() must not
+	 * derive the uncharge from its size.
+	 */
+	vm_unacct_memory(length >> PAGE_SHIFT);
+	vma_clear_flags(vma, VMA_ACCOUNT_BIT);
+	return err;
 }
 
 /*
_

Patches currently in -mm which might be from mason@kernel.org are

mm-swap-fix-large-swap-in-across-swap-file-extents.patch
hugetlbfs-do-not-grow-a-sealed-file-in-mmap.patch
mm-hugetlb-keep-surplus-folios-that-are-reserved.patch
mm-hugetlb-fix-reservation-leak-on-min_size=-mounts.patch
mm-cachestat-count-each-page-only-once.patch
mm-cachestat-restart-the-walk-after-each-entry.patch
percpu-queue-the-balance-work-on-an-unbound-workqueue.patch
mm-vma-fix-uncharge-after-failed-stack-relocation.patch
mm-mremap-apply-the-mmap-offset-limits-on-expansion.patch
mm-mremap-respect-guard-gaps-on-in-place-expansion.patch
mm-vma-make-brk-mappings-non-executable-under-mdwe.patch

