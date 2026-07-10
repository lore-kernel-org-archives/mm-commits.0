Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C589E407599
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723658; cv=none; b=SV5eb6szETjMMA3+JTWxFX35p+qsQmogktqJmR2AeOA7cSTnNalXuANNvHv1uKGEgS0sxuPhGCn+gNdlEiRkqwbHGEEyJU3DoeSwcsKs/cupsOpkhiSeO0ezB1tNvG6M7oSZ7XMRLjVTGYDSbTluM1R4IjyeLhHoBlwjkQQ5QQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723658; c=relaxed/simple;
	bh=cnx/X4inOmbjRo9o562/B9JM4TiwV41Set2ZUoNGSiI=;
	h=Date:To:From:Subject:Message-Id; b=VR78hnS9pqte+0ayp3CNnGYSLJs5r1OUyr7NvIAix5d59kgORGqcN2bFK7/krHg08V1DjnOqU59mNwKHXdFFwPI8/9nSaek4C+MMU0pz/k9mZsaOWUbcOpFZPlp1aZni/JnoNge7Yhc43xkOQwltjHh3XQu+Om3vmxGnCzGu/5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tWpauvyb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tWpauvyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0E71F00A3A;
	Fri, 10 Jul 2026 22:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723656;
	bh=N+qDBqMR1Q+nOALiK+X1iv365tnwNiA9UNx7zxso604=;
	h=Date:To:From:Subject;
	b=tWpauvybJaTpj94v9F76aTlrqhHrVQeoAYFCvDhjPmW8oTxyAoXs4s5Wpu9f3u9mb
	 gCcnCbQURwi0Opsb2lUN70v+E8Ih1yp/WNur2rhuIKE08DHaw5HRgjY2Sj9DHnrQuy
	 jWGYuZ1KE66V0KW8rFVWaRkU4pAAspS+aWTetJaI=
Date: Fri, 10 Jul 2026 15:47:36 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch added to mm-new branch
Message-Id: <20260710224736.9B0E71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools/testing/vma: default VMA, mm flag bits to 64-bit
has been added to the -mm mm-new branch.  Its filename is
     tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch

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
From: Lorenzo Stoakes <ljs@kernel.org>
Subject: tools/testing/vma: default VMA, mm flag bits to 64-bit
Date: Fri, 10 Jul 2026 21:17:13 +0100

With all of the sanitisers turned on, setting the VMA and mm flag bits
depth to 128 by default results in overly long build times.

Reduce this to 64 - we can always manipulate these later for testing of
larger bitmaps as needed.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-32-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/vma/Makefile~tools-testing-vma-default-vma-mm-flag-bits-to-64-bit
+++ a/tools/testing/vma/Makefile
@@ -10,7 +10,7 @@ OFILES = $(SHARED_OFILES) main.o shared.
 TARGETS = vma
 
 # These can be varied to test different sizes.
-CFLAGS += -DNUM_VMA_FLAG_BITS=128 -DNUM_MM_FLAG_BITS=128
+CFLAGS += -DNUM_VMA_FLAG_BITS=64 -DNUM_MM_FLAG_BITS=64
 
 main.o: main.c shared.c shared.h vma_internal.h tests/merge.c tests/mmap.c tests/vma.c ../../../mm/vma.c ../../../mm/vma_init.c ../../../mm/vma_exec.c ../../../mm/vma.h include/custom.h include/dup.h include/stubs.h
 
_

Patches currently in -mm which might be from ljs@kernel.org are

mm-move-alloc-tag-to-mm.patch
mm-ptdump-always-stabilise-against-page-table-freeing-using-init_mm.patch
mm-vmalloc-acquire-init_mm-read-lock-on-huge-vmap-promotion.patch
revert-arm64-enable-vmalloc-huge-with-ptdump.patch
mm-move-vma_start_pgoff-into-mmh-and-clean-up.patch
mm-add-kdoc-comments-for-vma_start-last_pgoff.patch
tools-testing-vma-use-vma_start_pgoff-in-merge-tests.patch
mm-introduce-and-use-vma_end_pgoff.patch
mm-rmap-update-mm-interval_treec-comments.patch
mm-rmap-parameterise-vma_interval_tree_-by-address_space.patch
mm-rmap-elide-unnecessary-static-inlines-in-interval_treec.patch
mm-rmap-rename-vma_interval_tree_-to-mapping_rmap_tree_.patch
mm-rmap-parameterise-anon_vma_interval_tree_-by-anon_vma.patch
mm-rmap-rename-anon_vma_interval_tree_-params-and-use-pgoff_t.patch
mm-rmap-rename-anon_vma_interval_tree_-to-anon_rmap_tree_.patch
maintainers-move-mm-interval_treec-to-rmap-section.patch
mm-vma-introduce-and-use-vmg_pages-vmg__pgoff.patch
mm-vma-clean-up-anon_vma_compatible.patch
mm-vma-refactor-vmg_adjust_set_range-for-clarity.patch
mm-vma-minor-cleanup-of-expand_.patch
mm-introduce-and-use-linear_page_delta.patch
mm-vma-use-vma_start_pgoff-linear_page_index-in-mm-code.patch
mm-prefer-vma__pgoff-to-vma-vm_pgoff-in-kernel.patch
mm-vma-remove-duplicative-vma_pgoff_offset-helper.patch
mm-use-linear_page_-consistently.patch
mm-vma-introduce-vma_assert_can_modify.patch
mm-vma-add-and-use-vma__pgoff.patch
mm-vma-move-__install_special_mapping-to-vmac.patch
mm-vma-make-vma_set_range-static-drop-insert_vm_struct-decl.patch
mm-vma-update-vma_shrink-to-not-pass-start-pgoff-parameters.patch
mm-vma-update-vmg_adjust_set_range-to-offset-pgoff-instead.patch
mm-vma-slightly-rework-the-anonymous-check-in-__mmap_new_vma.patch
mm-vma-introduce-and-use-vma_set_pgoff.patch
mm-vma-correct-incorrect-vmah-inclusion.patch
mm-vma-use-guard-clauses-in-can_vma_merge_.patch
tools-testing-vma-default-vma-mm-flag-bits-to-64-bit.patch
tools-testing-vma-output-compared-expression-on-assert_.patch

