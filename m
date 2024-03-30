Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048504685
	for <mm-commits@vger.kernel.org>; Sat, 30 Mar 2024 03:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711768195; cv=none; b=H8gc/OhM4Phm+IhHJlyqcIQTfiOYs4F5V0RjM5KDNO5nqWfie10S07hU6h7URgNsgI7ZdRju1nd/bVqxHBQZqrI/eKmVeGxe9SScpcBCd5t4D4P0nJDxGQdTYAyzIqFZMK//e38RUQEjiUxUXKHFOP8nqjVX43WYId0VhK9P2y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711768195; c=relaxed/simple;
	bh=w1hkHR88b/ooWgMsd1d2DiVqMWU0aV0QA3bNc5KywXE=;
	h=Date:To:From:Subject:Message-Id; b=LRbOuswrae+N2mMAm7Le85TnqTuBaKsyqvw/b0yZdCm0sIjdHb2JfwocDU60f471MWJeeFAc9Ks/6nnYoPLR3s5Pk/u0uJDj6hF67E8rEwGsPaHeMNCIxEvq38OvMqhfyrnJppHj8lOSBrMFxg3PG9gDeNqFBwHEXFqtHhpAWGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=t0nCUMH0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="t0nCUMH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671F8C433F1;
	Sat, 30 Mar 2024 03:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711768194;
	bh=w1hkHR88b/ooWgMsd1d2DiVqMWU0aV0QA3bNc5KywXE=;
	h=Date:To:From:Subject:From;
	b=t0nCUMH0+p1zbNg35hQpyZCKJ9rXiy27YNyc5q+0mNWofZ2IqYP4ZRQrMRc8jLN60
	 892CsSsOToh1mG5oswUoVf2CD0vBqIsP29RXFSxTiMPQFs7DvmM52Z/szoPRRExp2+
	 0tEYxGNBT5rEMRTyKOrg3UKZ41v/X2udhm/dJw0s=
Date: Fri, 29 Mar 2024 20:09:53 -0700
To: mm-commits@vger.kernel.org,kernel@xen0n.name,geert@linux-m68k.org,corbet@lwn.net,chenhuacai@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + documentation-kdump-clean-up-the-outdated-description.patch added to mm-nonmm-unstable branch
Message-Id: <20240330030954.671F8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Documentation: kdump: clean up the outdated description
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     documentation-kdump-clean-up-the-outdated-description.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/documentation-kdump-clean-up-the-outdated-description.patch

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
Subject: Documentation: kdump: clean up the outdated description
Date: Fri, 29 Mar 2024 21:28:25 +0800

After commit 443cbaf9e2fd ("crash: split vmcoreinfo exporting code out
from crash_core.c"), Kconfig item CRASH_CORE has gone away in kernel. 
Items VMCORE_INFO and CRASH_RESERVE are used instead.

So clean up the outdated description about CRASH_CORE and update it
accordingly.

Link: https://lkml.kernel.org/r/20240329132825.1102459-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kdump/kdump.rst |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/kdump/kdump.rst~documentation-kdump-clean-up-the-outdated-description
+++ a/Documentation/admin-guide/kdump/kdump.rst
@@ -136,10 +136,6 @@ System kernel config options
 
 	CONFIG_KEXEC_CORE=y
 
-   Subsequently, CRASH_CORE is selected by KEXEC_CORE::
-
-	CONFIG_CRASH_CORE=y
-
 2) Enable "sysfs file system support" in "Filesystem" -> "Pseudo
    filesystems." This is usually enabled by default::
 
@@ -168,6 +164,10 @@ Dump-capture kernel config options (Arch
 
 	CONFIG_CRASH_DUMP=y
 
+   And this will select VMCORE_INFO and CRASH_RESERVE::
+	CONFIG_VMCORE_INFO=y
+	CONFIG_CRASH_RESERVE=y
+
 2) Enable "/proc/vmcore support" under "Filesystems" -> "Pseudo filesystems"::
 
 	CONFIG_PROC_VMCORE=y
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

