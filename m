Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED23415E5BB
	for <mm-commits@vger.kernel.org>; Tue, 20 Jan 2026 00:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768869820; cv=none; b=U1Wr6hJ58eYxIGfEo2rlbMljwA+ahEu37Ucj+M0kQRfd3FOpegFDTiM/XKC2L3S+dPIxFDyrtbA7s66q++YaMt0MnjuIHQqvlVBojeSzSj6voFThmFGgydyttICeN36WDvjPf8Jrb9KJqfu3S0MK3u15KqdYG+ArXho938HT0ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768869820; c=relaxed/simple;
	bh=mgGj3oMeqoOhC+Irqh4+mlDckJ7Pbu82uVczqxZfQWM=;
	h=Date:To:From:Subject:Message-Id; b=b/tFFZfhmhLghxXb2irDhwrtoVjiLWuivc6MyGxUD+gk0ICrjISZQpEEOrFCyAXmNwn/c76IgjBfWEL/m9NxY5X0ZXEDjxKlep8An2v3L82HcD6X21ZbDV3xYdHt8ITCcwoEQa+saGDllv2eE3N9NiC1xcT3D+mmRTYC9Vui8Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cYUmPjfK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cYUmPjfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557C1C116C6;
	Tue, 20 Jan 2026 00:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768869819;
	bh=mgGj3oMeqoOhC+Irqh4+mlDckJ7Pbu82uVczqxZfQWM=;
	h=Date:To:From:Subject:From;
	b=cYUmPjfK3mTLB9bVo3JkYG5Jnm0lwSMepVq8YvtR863E0VXoMHruB+9aEzbcNWi4j
	 sNBMgl9RYYdvIsvZRwvqbLybAlRJTDW3cGXK3PKuFIYI8jZoMvI+GXywHOKJTyWb3W
	 OsrMFFFYqMWTG9KLWawyv23wQ2fzQ4t0VMGkzxWI=
Date: Mon, 19 Jan 2026 16:43:38 -0800
To: mm-commits@vger.kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch added to mm-new branch
Message-Id: <20260120004339.557C1C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-update-shmem__file_-functions-to-use-vma_flags_t-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-update-shmem__file_-functions-to-use-vma_flags_t-fix
Date: Mon Jan 19 04:41:11 PM PST 2026

fix mm/memfd_luo.c build

In file included from ./include/linux/bits.h:5,
                 from mm/memfd_luo.c:72:
mm/memfd_luo.c: In function 'memfd_luo_retrieve':
./include/vdso/bits.h:7:33: error: incompatible type for argument 3 of 'shmem_file_setup'
    7 | #define BIT(nr)                 (UL(1) << (nr))
      |                                 ^~~~~~~~~~~~~~~
      |                                 |
      |                                 long unsigned int
./include/linux/mm.h:400:28: note: in expansion of macro 'BIT'
  400 | #define INIT_VM_FLAG(name) BIT((__force int) VMA_ ## name ## _BIT)
      |                            ^~~
./include/linux/mm.h:427:25: note: in expansion of macro 'INIT_VM_FLAG'
  427 | #define VM_NORESERVE    INIT_VM_FLAG(NORESERVE)
      |                         ^~~~~~~~~~~~
mm/memfd_luo.c:446:40: note: in expansion of macro 'VM_NORESERVE'
  446 |         file = shmem_file_setup("", 0, VM_NORESERVE);
      |                                        ^~~~~~~~~~~~
In file included from mm/memfd_luo.c:79:
./include/linux/shmem_fs.h:105:74: note: expected 'vma_flags_t' but argument is of type 'long unsigned int'
  105 | struct file *shmem_file_setup(const char *name, loff_t size, vma_flags_t flags);
      |                                                              ~~~~~~~~~~~~^~~~~

Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memfd_luo.c~mm-update-shmem__file_-functions-to-use-vma_flags_t-fix
+++ a/mm/memfd_luo.c
@@ -443,7 +443,7 @@ static int memfd_luo_retrieve(struct liv
 	if (!ser)
 		return -EINVAL;
 
-	file = shmem_file_setup("", 0, VM_NORESERVE);
+	file = shmem_file_setup("", 0, mk_vma_flags(VMA_NORESERVE_BIT));
 
 	if (IS_ERR(file)) {
 		pr_err("failed to setup file: %pe\n", file);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-basic-tests-for-lazy_mmu-fix.patch
mm-vmscanc-shrink_folio_list-save-a-tabstop.patch
zram-fixup-read_block_state-fix.patch
zram-fixup-read_block_state-fix-2.patch
mm-block-fs-remove-laptop_mode-fix.patch
mm-fix-minor-spelling-mistakes-in-comments-fix.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-hugetlb-optimize-replace_free_hugepage_folios-v2-fix.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch
panic-add-panic_force_cpu=-parameter-to-redirect-panic-to-a-specific-cpu-checkpatch-fixes.patch

