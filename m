Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A7A1C3E
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711768192; cv=none; b=lfShUDBq7omsfvzurAyBCTNb9tZebDzJqKYodTidTjQVYz1ljpoe+gWSqmCeOqF4ennN+hDtVWfa2bB9JX2dPCOzXjEKFUSU+eUMLd6TAx2ktJo8tiOJNw23q4U2Yteed7uAFoNEs+8PW9ZrSZ9r8lMQBetLpEKFq3qD6g9/FIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711768192; c=relaxed/simple;
	bh=/bcAHS9dWpDzg4LCW66BjpZlqX9vfQu+KOe38BsCEE8=;
	h=Date:To:From:Subject:Message-Id; b=iTbQ1pwJvG8ErIH2KVz1+tdf4qgI+XJcii/dfIQa/72Fxt29cG1FKTVnawNV3zF4+X8ZTu/xWjQ50H1kPKm7zldKidxYeQYkoT29wYKRBv1Y8p2votd5RPuO/abgyyfpVZ/MbT6luuJhO09mBIxMx1J8f64XgGEOvlgG+68h1VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sVUKkVsh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sVUKkVsh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DC2C433C7;
	Sat, 30 Mar 2024 03:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711768191;
	bh=/bcAHS9dWpDzg4LCW66BjpZlqX9vfQu+KOe38BsCEE8=;
	h=Date:To:From:Subject:From;
	b=sVUKkVshLEznDBum4GzjTznx1jdolhXw/9x2L0hUr/jCC9LSAuArSArfofbuzLS02
	 hJncQueFAdbdDE3WzV/jYn7gH5z6E3ZSsauIw+aZdu3yeuqcuCfhy/2dJ/1JjmAOG/
	 Fv1/nD4MwFGtTjEwPeln0XGu7U6ul/G4wKmcPqrM=
Date: Fri, 29 Mar 2024 20:09:50 -0700
To: mm-commits@vger.kernel.org,kernel@xen0n.name,geert@linux-m68k.org,corbet@lwn.net,chenhuacai@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arch-loongarch-clean-up-the-left-code-and-kconfig-item-related-to-crash_core.patch added to mm-nonmm-unstable branch
Message-Id: <20240330030951.87DC2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arch/loongarch: clean up the left code and Kconfig item related to CRASH_CORE
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     arch-loongarch-clean-up-the-left-code-and-kconfig-item-related-to-crash_core.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arch-loongarch-clean-up-the-left-code-and-kconfig-item-related-to-crash_core.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: arch/loongarch: clean up the left code and Kconfig item related to CRASH_CORE
Date: Fri, 29 Mar 2024 21:28:24 +0800

Patch series "crash: clean up outdated codes and doc related to
CRASH_CORE".

As Geert pointed out that there are still left codes and doc related to
CRASH_CORE in arch/loongarch and Documentation.  So make these two patches
to clean them up.  Thanks to Geert.


This patch (of 2):

In commit 85fcde402db1 ("kexec: split crashkernel reservation code out
from crash_core.c"), crashkernel reservation code is split out from
crash_core.c, and add CRASH_RESERVE to control it.  And also rename each
ARCH's <asm/crash_core.h> to <asm/crash_reserve.h> accordingly.

But the relevant part in loongarch is missed. Do it now.

Link: https://lkml.kernel.org/r/20240329132825.1102459-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20240329132825.1102459-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/loongarch/Kconfig                     |    2 +-
 arch/loongarch/include/asm/crash_core.h    |   12 ------------
 arch/loongarch/include/asm/crash_reserve.h |   12 ++++++++++++
 3 files changed, 13 insertions(+), 13 deletions(-)

--- a/arch/loongarch/include/asm/crash_core.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-#ifndef _LOONGARCH_CRASH_CORE_H
-#define _LOONGARCH_CRASH_CORE_H
-
-#define CRASH_ALIGN			SZ_2M
-
-#define CRASH_ADDR_LOW_MAX		SZ_4G
-#define CRASH_ADDR_HIGH_MAX		memblock_end_of_DRAM()
-
-extern phys_addr_t memblock_end_of_DRAM(void);
-
-#endif
--- /dev/null
+++ a/arch/loongarch/include/asm/crash_reserve.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LOONGARCH_CRASH_RESERVE_H
+#define _LOONGARCH_CRASH_RESERVE_H
+
+#define CRASH_ALIGN			SZ_2M
+
+#define CRASH_ADDR_LOW_MAX		SZ_4G
+#define CRASH_ADDR_HIGH_MAX		memblock_end_of_DRAM()
+
+extern phys_addr_t memblock_end_of_DRAM(void);
+
+#endif
--- a/arch/loongarch/Kconfig~arch-loongarch-clean-up-the-left-code-and-kconfig-item-related-to-crash_core
+++ a/arch/loongarch/Kconfig
@@ -596,7 +596,7 @@ config ARCH_SELECTS_CRASH_DUMP
 	select RELOCATABLE
 
 config ARCH_HAS_GENERIC_CRASHKERNEL_RESERVATION
-	def_bool CRASH_CORE
+	def_bool CRASH_RESERVE
 
 config RELOCATABLE
 	bool "Relocatable kernel"
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch
x86-remove-unneeded-memblock_find_dma_reserve.patch
mm-mm_initc-remove-the-useless-dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_all_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core-v3.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch
mm-move-array-mem_section-init-code-out-of-memory_present.patch
mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node.patch
mm-make-__absent_pages_in_range-as-static.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2.patch
mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch
mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch
mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch
arch-loongarch-clean-up-the-left-code-and-kconfig-item-related-to-crash_core.patch
documentation-kdump-clean-up-the-outdated-description.patch

