Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D3C2F7F01
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723586; cv=none; b=Pi48BNgI275apnWh8MrURQp3v+eCjqdskzkZaEeUcuoS5NhdUZ+BIQ6lxwZfn0d+qEisZBJQQWwCK+ahm86DsqihWCH58yyhnjfkvYx8MPP5P3El9nrLBzAL3ANCzR2g/yWFvMJry5VP9Lvb8Jon/r2qVNteh+4Z1DijWIivlZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723586; c=relaxed/simple;
	bh=Vlq4VzhTNLeK2BuW2jjzHVg74JqG71/+vIzhs59IdV8=;
	h=Date:To:From:Subject:Message-Id; b=M4xqrTc+06z94kAdugy5ujW5zxPW0mz3sBpZJJqSOXtUHg+N9/zOXM+4ElDpnWL6HWDG/xl1F12GQDiiOog9O0lozhR7nQaTwsmZGbdHrhLO3BD71KGP9fwPtZ3tu7q4bV7byKrsclQJQQGSohtN8OuahsX6EOM6gfk/wGXE9s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tpch/cO0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tpch/cO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB0A1F000E9;
	Fri, 10 Jul 2026 22:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723585;
	bh=XhG8tQuSoHWLv+nZWnxM6uI7Kmr9Ltmlo6QDUuC4fhk=;
	h=Date:To:From:Subject;
	b=tpch/cO0gBGfMrcnXAxeSRQrkSvMVqOt/JABAYMILM4RIkhVNnjYd2aWe2MHTpy07
	 R+yCUO6NL5dD1ft70hUYIZGDfFgKRa50bbtv92fQXvm3JhYyicYKPO5v+toIycJwC5
	 GeykMRWHxH+azQiEt3ZJ9pm/eEPClUPbFLgEHmvo=
Date: Fri, 10 Jul 2026 15:46:25 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-move-mm-interval_treec-to-rmap-section.patch added to mm-new branch
Message-Id: <20260710224625.6AB0A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: Move mm/interval_tree.c to rmap section
has been added to the -mm mm-new branch.  Its filename is
     maintainers-move-mm-interval_treec-to-rmap-section.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-move-mm-interval_treec-to-rmap-section.patch

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
Subject: MAINTAINERS: Move mm/interval_tree.c to rmap section
Date: Fri, 10 Jul 2026 21:16:53 +0100

This file implements code for the interval trees used by the file and anon
rmap implementation, so belongs in the rmap section.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-12-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-move-mm-interval_treec-to-rmap-section
+++ a/MAINTAINERS
@@ -17211,6 +17211,7 @@ R:	Lance Yang <lance.yang@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/rmap.h
+F:	mm/interval_tree.c
 F:	mm/page_vma_mapped.c
 F:	mm/rmap.c
 F:	tools/testing/selftests/mm/rmap.c
@@ -17316,7 +17317,6 @@ T:	git git://git.kernel.org/pub/scm/linu
 F:	include/trace/events/mmap.h
 F:	fs/proc/task_mmu.c
 F:	fs/proc/task_nommu.c
-F:	mm/interval_tree.c
 F:	mm/mincore.c
 F:	mm/mlock.c
 F:	mm/mmap.c
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

