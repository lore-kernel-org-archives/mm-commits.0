Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01ACB3161A1
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 01:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768960108; cv=none; b=KbpQfU6dNYcOX0YWYyLjr9p5AGXKHBarY6/D7Y5TNnj/pHpkd4YGm5W9sg/U01W6Zb4AmThfUQv0pFu9LaH6xcrkiSUVepft/G0gSmiIMePsqNJLPGgO1mJzOI29hwDcrv1Jk7J7/i6jVKWzAJyRvBELutJHtM3Jf+BSfAz1qps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768960108; c=relaxed/simple;
	bh=Gb/G87XI4wGB3O7/Pn3m/W40A26knkXouKWrMQOCQt4=;
	h=Date:To:From:Subject:Message-Id; b=HH4hMV05ICkUlOLYaRqF2H2q/NWmfN+z5gwEIu67nUZe8HsJijqpE/SoYUcYb0twzEILCQdkHB3aasLWQLgbVaPGu3G9RTg+wxdB6NZjNywonb1xrG9yBzHGd5tMIS6KAho0Yv+PFlyxjICjvLP1CIV76+GX0ky8T3ebjoledSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lqnJuizJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lqnJuizJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793E5C16AAE;
	Wed, 21 Jan 2026 01:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768960106;
	bh=Gb/G87XI4wGB3O7/Pn3m/W40A26knkXouKWrMQOCQt4=;
	h=Date:To:From:Subject:From;
	b=lqnJuizJM5KCp8bo2P0y57bs5d61/IL8CuYg06HnCjY0dqbOwb+zHJXo1jnDF9WMF
	 gxmMOPIDd3/0x8RGCGq5HCcDwNZgHBE8TeMrPCw+ANYTsYEABq6Dx5OEPiIMn3TH5Q
	 fCI3xM7MuR9uAjsxMoDGK87m/0WeUxVS12+KohBs=
Date: Tue, 20 Jan 2026 17:48:25 -0800
To: mm-commits@vger.kernel.org,ritesh.list@gmail.com,kevin.brodsky@arm.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-add-basic-tests-for-lazy_mmu-fix.patch removed from -mm tree
Message-Id: <20260121014826.793E5C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-add-basic-tests-for-lazy_mmu-fix
has been removed from the -mm tree.  Its filename was
     mm-add-basic-tests-for-lazy_mmu-fix.patch

This patch was dropped because it was folded into mm-add-basic-tests-for-lazy_mmu.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-add-basic-tests-for-lazy_mmu-fix
Date: Tue Dec 16 08:07:21 PM PST 2025

export ppc64_tlb_batch and __flush_tlb_pending to modules for
mm/tests/lazy_mmu_mode_kunit.ko.

Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Subject: mm-add-basic-tests-for-lazy_mmu-fix-fix
Date: Wed, 17 Dec 2025 21:16:14 +0530

use EXPORT_SYMBOL_IF_KUNIT()

Link: https://lkml.kernel.org/r/87a4zhkt6h.ritesh.list@gmail.com
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: mm-add-basic-tests-for-lazy_mmu-fix-fix-fix
Date: Wed, 17 Dec 2025 16:38:12 +0000

move MODULE_IMPORT_NS(), add comment

Link: https://lkml.kernel.org/r/20251217163812.2633648-2-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/book3s64/hash_tlb.c |    4 +++-
 mm/tests/lazy_mmu_mode_kunit.c      |    3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/book3s64/hash_tlb.c~mm-add-basic-tests-for-lazy_mmu-fix
+++ a/arch/powerpc/mm/book3s64/hash_tlb.c
@@ -25,11 +25,12 @@
 #include <asm/tlb.h>
 #include <asm/bug.h>
 #include <asm/pte-walk.h>
-
+#include <kunit/visibility.h>
 
 #include <trace/events/thp.h>
 
 DEFINE_PER_CPU(struct ppc64_tlb_batch, ppc64_tlb_batch);
+EXPORT_SYMBOL_IF_KUNIT(ppc64_tlb_batch);
 
 /*
  * A linux PTE was changed and the corresponding hash table entry
@@ -154,6 +155,7 @@ void __flush_tlb_pending(struct ppc64_tl
 		flush_hash_range(i, local);
 	batch->index = 0;
 }
+EXPORT_SYMBOL_IF_KUNIT(__flush_tlb_pending);
 
 void hash__tlb_flush(struct mmu_gather *tlb)
 {
--- a/mm/tests/lazy_mmu_mode_kunit.c~mm-add-basic-tests-for-lazy_mmu-fix
+++ a/mm/tests/lazy_mmu_mode_kunit.c
@@ -2,6 +2,9 @@
 #include <kunit/test.h>
 #include <linux/pgtable.h>
 
+/* For some symbols referenced by arch_{enter,leave}_lazy_mmu_mode on powerpc */
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+
 static void expect_not_active(struct kunit *test)
 {
 	KUNIT_EXPECT_FALSE(test, is_lazy_mmu_mode_active());
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-add-basic-tests-for-lazy_mmu.patch
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
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix.patch
list-add-primitives-for-private-list-manipulations-fix.patch
init-mainc-check-if-rdinit-was-explicitly-set-before-printing-warning-fix.patch

