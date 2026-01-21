Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F88366DD6
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966555; cv=none; b=btlbGoxpqkqLuJYJDK0sBAJZOPWFSzGZMbuKCNoQc0kn+hZJFXNWyzsMR4qwcjBNIMOponHezbSknNIX1QJmkGveE2Tor79/2Fs3I/PUovfICcnm6WXaBq8GQL7uutkuv1wUHHPECEo2w0j4oeu9GBq2kC+rD+lx8ZEtl0UuPMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966555; c=relaxed/simple;
	bh=8yjxQV9JhWYWtBT6POmaMa5wfjwJH/IdLXcNNYrg/+4=;
	h=Date:To:From:Subject:Message-Id; b=fdaQbFv2LIi1jCD17MjTlVsHzky/wOem9TMp+XilXQ/pUWVENswIR1qsTg8xLAcWcJOsGPqr/DKz8HljjwJUHWaYSNAzDaBFEeqdmVqV9vGJKUSPIAp6k4RhqKh9fezbTXp8YDLAPc4Q3EPl53vWJyZpi6KNVhOA4H+8bAstNuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q2DXvmk4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q2DXvmk4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08942C16AAE;
	Wed, 21 Jan 2026 03:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966555;
	bh=8yjxQV9JhWYWtBT6POmaMa5wfjwJH/IdLXcNNYrg/+4=;
	h=Date:To:From:Subject:From;
	b=Q2DXvmk4yFPVDbFJ659kAOlp6RwLZYQ8CICWt5/JyFx779IjOsQofNsIRiSkLkAab
	 n76REZg+/87c6ha58OnwL6V3R56u8PUhXz1lVIbMlOX/8JfC6kYQu8cxnq2QANkUXS
	 HG2BvJetW1/vdTHz6CpM7mlxQhFkUxje94yoj0/s=
Date: Tue, 20 Jan 2026 19:35:54 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kho-docs-combine-concepts-and-fdt-documentation-fix.patch removed from -mm tree
Message-Id: <20260121033555.08942C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho-docs-combine-concepts-and-fdt-documentation-fix
has been removed from the -mm tree.  Its filename was
     kho-docs-combine-concepts-and-fdt-documentation-fix.patch

This patch was dropped because it was folded into kho-docs-combine-concepts-and-fdt-documentation.patch

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
kho-relocate-vmalloc-preservation-structure-to-kho-abi-header-fix.patch
kho-abi-add-memblock-abi-header.patch
kho-abi-add-memblock-abi-header-fix-2.patch

