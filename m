Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795562982;
	b=2fmLCGOFXMFl1wZ/6q5gQlaAt4P/aTErwc//ItpCJWCcSPg+EwpkENi64v8xqBHCeH26
	 tpBAkyj3Oa2VCLA+SBTP3Lk4Jx5xCUaDDnytQAs+ZX3YZk9SCa6AcZ/QaIQkL+s1n6Bxz
	 3zCMPpGZ9AqqD/DR7LNGaoXR5L8nRUf4BK07d7MSEc7eQ11egTADEVwMFt16UlO2jYF0+
	 Ze8ipTyNePaVaKD9Evl5gKo51PaQttQPD/8etL+zRLlLKH0VxmMGuHXc6R8vUrIxTFfR3
	 zVCGPN6s7tVMyM3Kd+CvypUm6RZp356LyEwrS30sMzebBtFIpfItgWmonMicwYl2ayw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795562982;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=RjvB5DGQveRYmZK17YSm5fVmzri5qVSLARz1TpILN7g=;
	b=QBL3O3/+R45/PmCPeXQIHkpMi5jCKt6v/83lUd2rTnzMRR/S0Ijwse+WpjeAnhmnX4A0
	 hE82DEFJ8mTv7BOacvEJtAd3pbpdUVT2qC83QM7c5RFIyjTI544BF5QPvN1Ax1p4PEUU2
	 fmLbqJBxCpEpmL/Z0jjhvj7ij7C7SL4nV94fvO5a2UpLMoiuo8NM0Zw2xSKG2us1CPrDI
	 Gk9wyIaFsk+ABMmTsC4zho2kki+l2M+j01brzEYbOPv3RbC4KmHRvlUseOtAnwvBKB2jS
	 Zsff7wesBJphWSAVA/9PXvIJ1d2+g+DECnK0dKQgF3sWl3lrU8bucyWytYRXw5nRitQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=asmFhzMk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355E1606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 23:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=asmFhzMk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16B31F000D2;
	Tue, 24 Nov 2026 23:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795562981;
	bh=RjvB5DGQveRYmZK17YSm5fVmzri5qVSLARz1TpILN7g=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=asmFhzMkvA0gEJKEK0xVrSDkaIbBXptF1GCCa9EGmyQ8WtaF706k4CZeKTomy5H3B
	 2oQGkKNRt1v7JH9ekoedWvU66KrTFxkSIi8i5N88e2eR+cicsaxcU8Ra+CsF24KB2e
	 9X7IIlCL0HmwOEmA2diwTorkEfjvVM1tW/XZl6CM=
Date: Tue, 24 Nov 2026 15:29:41 -0800
To: mm-commits@vger.kernel.org,xu.xin@linux.dev,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,
	pfalcato@suse.de,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,
	kees@kernel.org,josef@toxicpanda.com,joey.gouly@arm.com,jannh@google.com,
	hughd@google.com,gourry@gourry.net,david@kernel.org,chengming.zhou@linux.dev,
	catalin.marinas@arm.com,bunk@stusta.de,azpijr@gmail.com,
	a.p.zijlstra@chello.nl,aaw@google.com,mason@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-7-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-7-236e925d9b64@kernel.org>
Subject: + mm-vma-make-brk-mappings-non-executable-under-mdwe.patch added to mm-new branch
Message-Id: <20261124232941.B16B31F000D2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vma: make brk mappings non-executable under MDWE
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-make-brk-mappings-non-executable-under-mdwe.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-make-brk-mappings-non-executable-under-mdwe.patch

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
Subject: mm/vma: make brk mappings non-executable under MDWE
Date: Sat, 21 Nov 2026 16:02:33 +0000

With PR_SET_MDWE in effect, brk() and the ELF loader can still create
anonymous mappings that are both writable and executable.

MDWE only holds if every path that decides the flags of a VMA asks
map_deny_write_exec(). mmap_region() and do_mprotect_pkey() do, but
do_brk_flags() does not. It always sets VMA_WRITE_BIT, and it gets
VMA_EXEC_BIT in any of these cases:

    VMA_DATA_DEFAULT_FLAGS is
      VMA_DATA_FLAGS_TSK_EXEC    the personality has READ_IMPLIES_EXEC
                                 (e.g. x86, arm, arm64, mips)
      VMA_DATA_FLAGS_EXEC        always
                                 (the default, e.g. m68k, sh, sparc)
    vm_brk_flags(is_exec)        elf_load() of a PT_LOAD with PF_X and
                                 p_memsz > p_filesz

Fix the issue by dropping VMA_EXEC_BIT if MDWE is in effect, so that
brk() and execve() keep working where the bit is only a default.

Under MDWE, a task that runs code from its heap, or from the part of an
executable PT_LOAD beyond p_filesz, now gets SIGSEGV in the cases above.

mprotect(PROT_READ | PROT_EXEC) on these mappings now fails with
-EACCES. While the personality has READ_IMPLIES_EXEC, so does
mprotect(PROT_READ), as on any other anonymous mapping that is not
executable.

[ljs@kernel.org: switched to MMF_HAS_MDWE test, tweaked commit msg]
Link: https://patch.msgid.link/20261121-some-more-ai-fixes-v1-7-236e925d9b64@kernel.org
Fixes: b507808ebce2 ("mm: implement memory-deny-write-execute as a prctl")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
  Link: https://lore.kernel.org/179536252140.412063.16869457803147347876.b4-reply@b4
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
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

 mm/vma.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/vma.c~mm-vma-make-brk-mappings-non-executable-under-mdwe
+++ a/mm/vma.c
@@ -3235,6 +3235,10 @@ int do_brk_flags(struct vma_iterator *vm
 	vma_flags_set(&vma_flags, VMA_ACCOUNT_BIT);
 	vma_flags_set_mask(&vma_flags, mm->def_vma_flags);
 
+	/* The flags are implied, so under MDWE drop exec rather than fail. */
+	if (mm_flags_test(MMF_HAS_MDWE, mm))
+		vma_flags_clear(&vma_flags, VMA_EXEC_BIT);
+
 	vma_flags = ksm_vma_flags(mm, NULL, vma_flags);
 	if (!may_expand_vm(mm, &vma_flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
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

