Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04AD36CE0E
	for <mm-commits@vger.kernel.org>; Wed,  7 Jan 2026 17:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767806805; cv=none; b=ZmxrC6T5Apx8U4j0YOnIuCQlxXsZ9cqfv5qGEwipLtV+TjgXBbBmvGg0vvxMwZ0On/lz1j62NLQHZ5Rt/SfNil6A4ezbU7BdWnofHEzhqAwydYJXQHSws5mBcnrG0TG2qpZlC8hIzfJ1EbXb1VpeESJ37RpbCc7XUNtsdQKU+kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767806805; c=relaxed/simple;
	bh=U5t+yindztRj+BBfUklo1mXd4gAf6QidO6BZEOIRRFE=;
	h=Date:To:From:Subject:Message-Id; b=OlTbgzYxFBOsqg76lb8O6i4JqCS+pxK0xJTdo61+h9B0IQ2CU5eDcqe/mwx9HQA15PY3czIhpdPmULSAdEb+55Eqp6UYDw2JFzin5FCgFt90O4rir7WOPpo7R+tm5wkUUhlK18/RjkSmRZI1F43KA++SHMM3UvLWyF6Cmqmt1vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PCWgOo0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PCWgOo0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25775C4CEF1;
	Wed,  7 Jan 2026 17:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767806804;
	bh=U5t+yindztRj+BBfUklo1mXd4gAf6QidO6BZEOIRRFE=;
	h=Date:To:From:Subject:From;
	b=PCWgOo0IqoB43V6evLvgNc+Uv0tXjtU77QaJwkNP6Cx/WNGbnTWPtqzHLFIYZrnRP
	 vSff+agzbcxSVNCCVimylHo6tRWrvuUL5IMYkT3iXeo7xIgWffUPzR9+Ud8RYseTG8
	 w5lkAXGbPGmlErFT4MSNcgSz+FK1Axstux5YbVLg=
Date: Wed, 07 Jan 2026 09:26:43 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-docs-combine-concepts-and-fdt-documentation-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260107172644.25775C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho-docs-combine-concepts-and-fdt-documentation-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-docs-combine-concepts-and-fdt-documentation-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-docs-combine-concepts-and-fdt-documentation-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Mike Rapoport <rppt@kernel.org>
Subject: kho-docs-combine-concepts-and-fdt-documentation-fix
Date: Wed, 7 Jan 2026 10:38:52 +0200

fix Documentation/core-api/kho/index.rst

Link: https://lkml.kernel.org/r/aV4bnHlBXGpT_FMc@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/kho/index.rst |    4 ++++
 kernel/liveupdate/luo_core.c         |    3 +--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/Documentation/core-api/kho/index.rst~kho-docs-combine-concepts-and-fdt-documentation-fix
+++ a/Documentation/core-api/kho/index.rst
@@ -1,5 +1,7 @@
 .. SPDX-License-Identifier: GPL-2.0-or-later
 
+.. _kho-concepts:
+
 ========================
 Kexec Handover Subsystem
 ========================
@@ -60,6 +62,8 @@ for boot memory allocations and as targe
 of that memory region may be reserved. These reservations are irrelevant for
 the next KHO, because kexec can overwrite even the original kernel.
 
+.. _kho-finalization-phase:
+
 KHO finalization phase
 ======================
 
--- a/kernel/liveupdate/luo_core.c~kho-docs-combine-concepts-and-fdt-documentation-fix
+++ a/kernel/liveupdate/luo_core.c
@@ -35,8 +35,7 @@
  * iommu, interrupts, vfio, participating filesystems, and memory management.
  *
  * LUO uses Kexec Handover to transfer memory state from the current kernel to
- * the next kernel. For more details see
- * Documentation/core-api/kho/concepts.rst.
+ * the next kernel. For more details see Documentation/core-api/kho/index.rst.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
_

Patches currently in -mm which might be from rppt@kernel.org are

mips-fix-highmem-initialization.patch
alpha-introduce-arch_zone_limits_init.patch
arc-introduce-arch_zone_limits_init.patch
arm-introduce-arch_zone_limits_init.patch
arm64-introduce-arch_zone_limits_init.patch
csky-introduce-arch_zone_limits_init.patch
hexagon-introduce-arch_zone_limits_init.patch
loongarch-introduce-arch_zone_limits_init.patch
m68k-introduce-arch_zone_limits_init.patch
microblaze-introduce-arch_zone_limits_init.patch
mips-introduce-arch_zone_limits_init.patch
nios2-introduce-arch_zone_limits_init.patch
openrisc-introduce-arch_zone_limits_init.patch
parisc-introduce-arch_zone_limits_init.patch
powerpc-introduce-arch_zone_limits_init.patch
riscv-introduce-arch_zone_limits_init.patch
s390-introduce-arch_zone_limits_init.patch
sh-introduce-arch_zone_limits_init.patch
sparc-introduce-arch_zone_limits_init.patch
um-introduce-arch_zone_limits_init.patch
x86-introduce-arch_zone_limits_init.patch
xtensa-introduce-arch_zone_limits_init.patch
arch-mm-consolidate-initialization-of-nodes-zones-and-memory-map.patch
arch-mm-consolidate-initialization-of-sparse-memory-model.patch
mips-drop-paging_init.patch
x86-dont-reserve-hugetlb-memory-in-setup_arch.patch
mm-arch-consolidate-hugetlb-cma-reservation.patch
mm-hugetlb-drop-hugetlb_cma_check.patch
revert-mm-hugetlb-deal-with-multiple-calls-to-hugetlb_bootmem_alloc.patch
kho-abi-luo-make-generated-documentation-more-coherent.patch
kho-abi-memfd-make-generated-documentation-more-coherent.patch
kho-docs-combine-concepts-and-fdt-documentation.patch
kho-docs-combine-concepts-and-fdt-documentation-fix.patch
kho-abi-add-memblock-abi-header.patch

