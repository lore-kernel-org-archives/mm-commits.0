Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795562967;
	b=D+wZORZealas56JJqKc+rAsXB8SdWcm4ziG7ZlqB1F9pExxKWwbO4sfKfPsyw/qP3rJM
	 lab58PHjopcDjWzIfj1xHq0AyptoxgiqC9bMJSYdGh/9zSPNjCgl+Kdns8bm9AEKEOpui
	 qUfLgblbvCUPrzAiRUy6XsvX2GhGTAyKuQRBskP2gFcjJ2pumNnyyZP+4tP7No0bGi/QA
	 fnwwFSZbHP4nUbkdeYN177/ELipDiCBhNXAJucVTiIebXgPGNpXZ4BK8bOuWByppwLxdf
	 RMcTC6VjXYu4O/1QIDEsB8SaXITlaYJ/cyy7+7U5bd+tQ+jduq0RaCaKTeL+yI1TLPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795562967;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=XhgswX+2BxvWbdI6UgO4qn0YcrmwAn/1VOrRZCvTqqk=;
	b=vyCS7HKTH7guPxvLtsTAcXIgY22DhgSHJ+HqmI3vp0DBs1NHDNSJiFkSxDOm2fj7QXCL
	 Kt9lUJ5WJXkTMUie9jzczIydC4UiPtyit6lr+PBD5bzTYNRMY1vKPU6zo/cgUFfobOo3S
	 qgqqqaTnSl6eE5jhd/AYudP9aMu5ehhYBmZ+EhtLk0txWrB/EYyzuun/kbl4OxM2EBI8e
	 kANVdGuAk7UjCGJBK42yp3eFSO4XIzkvthbH+VF/M0OBNQ6FGrhY3QoLTDs71ajq6l/Yy
	 I6zPG+yvyYaXBLTuTgnqFl05i3VOi+G7PQepdDmwu82rZWUuF7WbImDZPRKcvUlWh0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LRCnuMJ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED4A606A31E;
	Tue, 24 Nov 2026 23:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LRCnuMJ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B471F000CF;
	Tue, 24 Nov 2026 23:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795562966;
	bh=XhgswX+2BxvWbdI6UgO4qn0YcrmwAn/1VOrRZCvTqqk=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=LRCnuMJ8sOxnDyyz5p6WEEhpO+xyg3VA5gtXK3EFjr0Fpr208uhNvXfUPB/Jtz+wB
	 lQzoF+O2mlIkEgQKj2o8GcfpJQSQFPjr8wM1dksxlinO4atUVHQY4EsK1PmHBTbK8T
	 dl1tTsrrutz18+e1xxMbWGooRTZWKUeFuCQ8mJ5s=
Date: Tue, 24 Nov 2026 15:29:25 -0800
To: mm-commits@vger.kernel.org,xu.xin@linux.dev,willy@infradead.org,
	vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,
	shakeel.butt@linux.dev,rppt@kernel.org,pfalcato@suse.de,mhocko@suse.com,
	mason@kernel.org,liam@infradead.org,kees@kernel.org,josef@toxicpanda.com,
	joey.gouly@arm.com,jannh@google.com,hughd@google.com,gourry@gourry.net,
	david@kernel.org,chengming.zhou@linux.dev,catalin.marinas@arm.com,
	bunk@stusta.de,azpijr@gmail.com,a.p.zijlstra@chello.nl,aaw@google.com,
	ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-1-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-1-236e925d9b64@kernel.org>
Subject: + mm-vma-error-out-on-invalid-bounds-in-unmapped_area_topdown.patch added to mm-new branch
Message-Id: <20261124232926.16B471F000CF@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/vma: error out on invalid bounds in unmapped_area_topdown()
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-error-out-on-invalid-bounds-in-unmapped_area_topdown.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-error-out-on-invalid-bounds-in-unmapped_area_topdown.patch

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
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: mm/vma: error out on invalid bounds in unmapped_area_topdown()
Date: Sat, 21 Nov 2026 16:02:27 +0000

Patch series "mm: reworked AI-generated VMA and mremap fixes".

I have reordered the patches here by priority, David - the first 2 should
be prioritised as hotfixes, the rest can go in 7.5:

== Critical ==

1. unmapped_area_topdown() invalid bounds - possible memory corruption,
   triggerable by any local user.
2. Lock VMAs before mm_all_locks_mutex - system-wide unkillable hang,
   triggerable by a local user with FUSE.

== Need fixing ==

3. Uncharge after failed stack relocation - strict overcommit limit
   defeated system-wide.
4. mmap() offset limits on mremap() expansion - invalid file offset
   reaches the DAX fault handler.

== Hardening (no need for Cc: stable) ==

5. Guard gaps on in-place mremap() expansion.
6. Non-executable brk mappings under MDWE.

As usual, please go through and check these carefully for correctness,


This patch (of 6):

unmapped_area_topdown() suffers from a class of bug arising from a mismatch
between how maple tree functions and VMA iterator functions express ranges
- the former inclusively, the latter exclusively.

This is problematic with an exclusive upper bound of 0, as it translates
to an inclusive upper bound of ULONG_MAX, that is a range which extends to
the end of the address space, and start < end or equivalent comparisons
evaluate false in a situation where in fact the expression should evaluate
true.

unmapped_area_topdown() calls vma_iter_area_highest() to position the VMA
iterator into the next highest empty range spanning [low_limit,
high_limit), iteratively reducing high_limit without checking whether it
has reached 0.

This can result in a [low_limit, 0) pair being passed to
vma_iter_area_highest() and thus unexpected underflow. Consider:

    vm_start        = 0x30000
    stack_guard_gap = 0x100000
    info->length    = 0x1000
    high_limit      = vm_start_gap() = 0
    high_limit - 1  = ULONG_MAX
    window          = [low_limit, ULONG_MAX]
    vma_iter_end()  = ULONG_MAX + 1 = 0
    gap             = 0 - info->length = 0xfffffffffffff000

The result is page aligned and below the IS_ERR_VALUE() range, so it
does not look like an error. What follows depends on the caller:

 - mmap() with no hint can fail with -ENOMEM while space is free. The
   bottom-up fallback is skipped, and __get_unmapped_area() refuses the
   address as above TASK_SIZE.
 - On x86-64, find_nearest_trampoline() can pick the address for the
   uprobe trampoline. _install_special_mapping() then inserts a VMA
   whose vm_end is 0, and exit_mmap() frees kernel page tables that
   every mm shares.
 - On powerpc64 with the hash MMU, slice_get_unmapped_area() can pass
   the address to alloc_extended_context(), which then writes out of
   bounds of mm->context.extended_id[].

mmap() can succeed with an address from the wrapped window where the
range above TASK_SIZE is too short for the request and its alignment
padding. On s390 that range is one page, so this takes no more than the
default stack_guard_gap.

Fix the issue by converting the loop into one that explicitly tests
low_limit < high_limit.

Additionally, simplify the logic by declaring the VMA iterator in the
loop (it is reset on each iteration anyway) and exiting with the correct
output value on success rather than performing a goto when an iteration is
required.

Link: https://lore.kernel.org/20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org
Link: https://patch.msgid.link/20261121-some-more-ai-fixes-v1-1-236e925d9b64@kernel.org
Fixes: 58c5d0d6d522 ("mm/mmap: regression fix for unmapped_area{_topdown}")
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Chris Mason <mason@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
  Link: https://lore.kernel.org/179536291280.412063.6169498898856535364.b4-reply@b4
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
Cc: <stable@vger.kernel.org>

 mm/vma.c |   42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

--- a/mm/vma.c~mm-vma-error-out-on-invalid-bounds-in-unmapped_area_topdown
+++ a/mm/vma.c
@@ -3369,8 +3369,6 @@ unsigned long unmapped_area_topdown(stru
 {
 	unsigned long length, gap, gap_end;
 	unsigned long low_limit, high_limit;
-	struct vm_area_struct *tmp;
-	VMA_ITERATOR(vmi, current->mm, 0);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask + info->start_gap;
@@ -3381,31 +3379,31 @@ unsigned long unmapped_area_topdown(stru
 	if (low_limit < mmap_min_addr)
 		low_limit = mmap_min_addr;
 	high_limit = info->high_limit;
-retry:
-	if (vma_iter_area_highest(&vmi, low_limit, high_limit, length))
-		return -ENOMEM;
 
-	gap = vma_iter_end(&vmi) - info->length;
-	gap -= (gap - info->align_offset) & info->align_mask;
-	gap_end = vma_iter_end(&vmi);
-	tmp = vma_next(&vmi);
-	 /* Avoid prev check if possible */
-	if (tmp && vma_test_any_mask(tmp, VMA_STARTGAP_FLAGS)) {
-		if (vm_start_gap(tmp) < gap_end) {
+	while (low_limit < high_limit) {
+		VMA_ITERATOR(vmi, current->mm, 0);
+		struct vm_area_struct *tmp;
+
+		if (vma_iter_area_highest(&vmi, low_limit, high_limit, length))
+			break;
+
+		gap = vma_iter_end(&vmi) - info->length;
+		gap -= (gap - info->align_offset) & info->align_mask;
+		gap_end = vma_iter_end(&vmi);
+		tmp = vma_next(&vmi);
+		/* Avoid prev check if possible */
+		if (tmp && vma_test_any_mask(tmp, VMA_STARTGAP_FLAGS)) {
+			if (vm_start_gap(tmp) >= gap_end)
+				return gap;
 			high_limit = vm_start_gap(tmp);
-			vma_iter_reset(&vmi);
-			goto retry;
-		}
-	} else {
-		tmp = vma_prev(&vmi);
-		if (tmp && vm_end_gap(tmp) > gap) {
+		} else {
+			tmp = vma_prev(&vmi);
+			if (!tmp || vm_end_gap(tmp) <= gap)
+				return gap;
 			high_limit = tmp->vm_start;
-			vma_iter_reset(&vmi);
-			goto retry;
 		}
 	}
-
-	return gap;
+	return -ENOMEM;
 }
 
 /*
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-msync-return-enomem-if-page-aligned-length-overflows.patch
mm-vma-drop-mm-asynchronously-in-vma_start_read.patch
mm-vma-predicate-vma_assert_stabilised-on-config_debug_vm.patch
mm-only-assert-mmap-locks-if-config_debug_vm-or-lockdep-is-set.patch
mm-only-assert-vma-locks-if-config_debug_vm-is-set.patch
mm-convert-warn_on_onces-to-vm_warn_on_once-in-vma-lock-code.patch
mm-madvise-zap-markers-from-guard-regions.patch
mm-mmap-free-gathered-pages-before-mmf_oom_skip.patch
percpu-fix-contig-hints-that-are-too-low.patch
percpu-search-the-whole-reserved-chunk.patch
mm-filemap-convert-fault-and-readahead-logic-to-use-vma_flags_t.patch
mm-madvise-convert-madvise_vma_behavior-to-use-vma_flags_t.patch
mm-convert-miscellaneous-vma-flag-tests-to-use-vma_flags_t.patch
fs-proc-task_mmu-convert-vma-flag-tests-to-use-vma_flags_t.patch
fs-coredump-convert-vma_dump_size-to-use-vma_flags_t.patch
uprobes-convert-vma-flag-tests-to-use-vma_flags_t.patch
perf-convert-vma-flag-tests-to-use-vma_flags_t.patch
selinux-convert-vma-flag-tests-to-use-vma_flags_t.patch
apparmor-convert-vma-flag-tests-to-use-vma_flags_t.patch
ima-convert-vma-flag-tests-to-use-vma_flags_t.patch
ipe-convert-vma-flag-tests-to-use-vma_flags_t.patch
xen-privcmd-convert-mmap-hook-to-mmap_prepare.patch
kvm-ppc-book3s-convert-spapr-tce-mmap-hook-to-mmap_prepare.patch
mshv_vtl-convert-mmap-hooks-to-mmap_prepare.patch
x86-sgx-convert-vepc-mmap-hook-to-mmap_prepare.patch
udf-convert-mmap-hook-to-mmap_prepare.patch
selinuxfs-convert-mmap-hooks-to-mmap_prepare.patch
xen-convert-xenstore-interface-mmap-hooks-to-mmap_prepare.patch
soc-aspeed-convert-lpc-and-p2a-control-mmap-hooks-to-mmap_prepare.patch
soc-qcom-rmtfs_mem-convert-mmap-hook-to-mmap_prepare.patch
tee-convert-shm-mmap-hook-to-mmap_prepare.patch
misc-bcm-vk-convert-mmap-hook-to-mmap_prepare.patch
ptp-vmclock-convert-mmap-hook-to-mmap_prepare.patch
vhost-vdpa-convert-mmap-hook-to-mmap_prepare.patch
mm-vma-error-out-on-invalid-bounds-in-unmapped_area_topdown.patch
mm-vma-lock-vmas-before-taking-mm_all_locks_mutex.patch

