Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B2D407599
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 22:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783723651; cv=none; b=Cjsr09iHHCLrH4AfBpAGerJ1gQvNBE+SeEgrhMtXyb2ZaZvVEPmSgEGnaulUYiGTqE2UCyswmcDh+m4KiOwicRK/Qfyid+z1WVPRLg4lS64sytuaGbzIT1fTLcZSvti1Q7Jhw/22AreFSkmV+S+yRTZDW5VZQjdLGtolTj6HasI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783723651; c=relaxed/simple;
	bh=mv6OYlxAkZeVwTKSXsLor9r1pwX9Tgmc4GFC8OMKLhI=;
	h=Date:To:From:Subject:Message-Id; b=h4uOaHsb8w+QXK9UarlbDr9YBFaWKqBkrHFJd2C9iNhqBAGzypIZxogjU9GhzbdoVYpPi2ctRyG7SjPRg7NyhLLxVssXlQLiPx7RxGM+Py9NRyc6AY26zmmstjK5NBZ1Cr8NfqNwB8LJB0POq2iXe47CZks/qsYPZqjOPv53pAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Cf0tHO1r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Cf0tHO1r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D762F1F000E9;
	Fri, 10 Jul 2026 22:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783723650;
	bh=13xS1C+S7wvORbcuBblCxgbh7Nt5DvvqWjlefUX/OmI=;
	h=Date:To:From:Subject;
	b=Cf0tHO1rBoUlROx0oURWqc93PUAHHGd3MKnKWNlYoBPQntEtD1m0boM0Srs2aP8a8
	 htBKkKQxrFZUvQtnVQ8yzljFx1d+BZyXSmmqNbRmJiNU1NbI9nteDKAHVb/JGRFNO2
	 ql2YM0x7dScvvOQu0/eYnxzRqIN7BNpfiJ4kx1xg=
Date: Fri, 10 Jul 2026 15:47:29 -0700
To: mm-commits@vger.kernel.org,ljs@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-correct-incorrect-vmah-inclusion.patch added to mm-new branch
Message-Id: <20260710224729.D762F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/vma: correct incorrect vma.h inclusion
has been added to the -mm mm-new branch.  Its filename is
     mm-vma-correct-incorrect-vmah-inclusion.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-correct-incorrect-vmah-inclusion.patch

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
Subject: mm/vma: correct incorrect vma.h inclusion
Date: Fri, 10 Jul 2026 21:17:11 +0100

The only files which should be including vma.h are the implementation files
for the core VMA logic - vma.c, vma_init.c, and vma_exec.c.

This is in order to allow for userland testing of core VMA logic. In this
cases, vma_internal.h and vma.h are included, providing both the
dependencies upon which the core VMA logic requires and its declarations.

Userland testable VMA logic is achieved by having separate vma_internal.h
implementations for userland and kernel.

Callers other than the core VMA implementation should include internal.h
instead. This header does not need to include vma_internal.h as it only
contains the vma.h declarations, for which the includes already present
suffice.

Update code to reflect this, update comments to reflect the fact there are
3 VMA implementation files and document things more clearly.

While we're here, slightly improve the language of the comment describing
vma_exec.c.

No functional change intended.

Link: https://lore.kernel.org/20260710-b4-pre-scalable-cow-v2-30-2a5aa403d977@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: SJ Park <sj@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |    2 +-
 mm/nommu.c        |    1 -
 mm/vma.c          |    4 ++++
 mm/vma.h          |    9 ++++++++-
 mm/vma_exec.c     |    8 ++++++--
 mm/vma_init.c     |    4 ++++
 mm/vma_internal.h |    4 ++--
 7 files changed, 25 insertions(+), 7 deletions(-)

--- a/mm/mmu_notifier.c~mm-vma-correct-incorrect-vmah-inclusion
+++ a/mm/mmu_notifier.c
@@ -19,7 +19,7 @@
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
 
-#include "vma.h"
+#include "internal.h"
 
 /* global SRCU for all MMs */
 DEFINE_STATIC_SRCU(srcu);
--- a/mm/nommu.c~mm-vma-correct-incorrect-vmah-inclusion
+++ a/mm/nommu.c
@@ -41,7 +41,6 @@
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include "internal.h"
-#include "vma.h"
 
 unsigned long highest_memmap_pfn;
 int heap_stack_gap = 0;
--- a/mm/vma.c~mm-vma-correct-incorrect-vmah-inclusion
+++ a/mm/vma.c
@@ -4,6 +4,10 @@
  * VMA-specific functions.
  */
 
+/*
+ * To allow for userland testing we place internal dependencies in
+ * vma_internal.h and external VMA API declarations in vma.h.
+ */
 #include "vma_internal.h"
 #include "vma.h"
 
--- a/mm/vma_exec.c~mm-vma-correct-incorrect-vmah-inclusion
+++ a/mm/vma_exec.c
@@ -1,10 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
 /*
- * Functions explicitly implemented for exec functionality which however are
- * explicitly VMA-only logic.
+ * Functions provided for exec functionality which however are
+ * specifically VMA-only logic.
  */
 
+/*
+ * To allow for userland testing we place internal dependencies in
+ * vma_internal.h and external VMA API declarations in vma.h.
+ */
 #include "vma_internal.h"
 #include "vma.h"
 
--- a/mm/vma.h~mm-vma-correct-incorrect-vmah-inclusion
+++ a/mm/vma.h
@@ -2,7 +2,14 @@
 /*
  * vma.h
  *
- * Core VMA manipulation API implemented in vma.c.
+ * Core VMA manipulation API implemented in vma.c, vma_init.c and vma_exec.c.
+ *
+ * Note that, in order for VMA logic to be userland testable, this header
+ * intentionally includes no dependencies.
+ *
+ * This is specifically scoped to mm-only. Users of this functionality (other
+ * than the core VMA implementation itself) should not include this header
+ * directly, but rather include internal.h.
  */
 #ifndef __MM_VMA_H
 #define __MM_VMA_H
--- a/mm/vma_init.c~mm-vma-correct-incorrect-vmah-inclusion
+++ a/mm/vma_init.c
@@ -5,6 +5,10 @@
  * between CONFIG_MMU and non-CONFIG_MMU kernel configurations.
  */
 
+/*
+ * To allow for userland testing we place internal dependencies in
+ * vma_internal.h and external VMA API declarations in vma.h.
+ */
 #include "vma_internal.h"
 #include "vma.h"
 
--- a/mm/vma_internal.h~mm-vma-correct-incorrect-vmah-inclusion
+++ a/mm/vma_internal.h
@@ -2,8 +2,8 @@
 /*
  * vma_internal.h
  *
- * Headers required by vma.c, which can be substituted accordingly when testing
- * VMA functionality.
+ * Headers required by vma.c, vma_init.c and vma_exec.c, which can be
+ * substituted accordingly when testing VMA functionality.
  */
 
 #ifndef __MM_VMA_INTERNAL_H
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

