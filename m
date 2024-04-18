Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AD917994D
	for <mm-commits@vger.kernel.org>; Thu, 18 Apr 2024 18:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713463714; cv=none; b=EaGakAxAM+ORM0fRBjl+EMIEuxxLCTDAxoM87rxG30ejjc+1PWTE90EcgkJ+52wo+c2A/ZaN/YnkKE0V190iik6E/3n2LwaentA5Bpu5cgw1PAiHuiJSVu4sYv9PoGr1omyL3bp5vPArfCsFrSf+cZTX+Cy4aqkmtHk7YAj1rQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713463714; c=relaxed/simple;
	bh=YcSSlIfwKgfJ4B7vdMRZo644btxErjgsNP+mpqwW4Gc=;
	h=Date:To:From:Subject:Message-Id; b=LIMTcaTo2mox/hjn6EwRyEUcfYHEzxe6tCVNIljQDdDjhqY6vEW2hQznLhh6/1uhOub+8QBDe2xkLNPIFxrL1zUfbpttXmoVMLcwy+qJypkGXhw15rEEYfkfwj0xmtbS4tp4OgKP3pZ3wH612K7YubXbWbjPqzZ0q4IZAogAK3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uXylEXpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uXylEXpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52089C113CC;
	Thu, 18 Apr 2024 18:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713463713;
	bh=YcSSlIfwKgfJ4B7vdMRZo644btxErjgsNP+mpqwW4Gc=;
	h=Date:To:From:Subject:From;
	b=uXylEXpkOsYWA3EqYPRi2aCV+ITf4T3052uZAh2W/6EnUCzXUYcKDyO21dzkXTfzk
	 waFO7888VJ+hfpFwr/NUY0Ehaw+qEMZjJXndSRRgjo7xDvvmWfAtu0tWZLtIf0y97v
	 1cRbDVhB550oLdK92QdU7rfmG2ZnqlSN9k+DoDMo=
Date: Thu, 18 Apr 2024 11:08:32 -0700
To: mm-commits@vger.kernel.org,kernel@xen0n.name,geert@linux-m68k.org,corbet@lwn.net,chenhuacai@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] arch-loongarch-clean-up-the-left-code-and-kconfig-item-related-to-crash_core.patch removed from -mm tree
Message-Id: <20240418180833.52089C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arch/loongarch: clean up the left code and Kconfig item related to CRASH_CORE
has been removed from the -mm tree.  Its filename was
     arch-loongarch-clean-up-the-left-code-and-kconfig-item-related-to-crash_core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -595,7 +595,7 @@ config ARCH_SELECTS_CRASH_DUMP
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
mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node-v2.patch
mm-make-__absent_pages_in_range-as-static.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists-v2.patch
mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch
mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch
mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch
documentation-kdump-clean-up-the-outdated-description.patch
kexec-fix-the-unexpected-kexec_dprintk-macro.patch

