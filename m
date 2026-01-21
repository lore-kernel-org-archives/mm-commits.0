Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F42364E9A
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966608; cv=none; b=pTYSVkLpKy+dTDYdh0TbY5IKwnIHqw66OX5+UukJ+zBrihmNE+kvbHw9w9TKQ2lozfngmKohSe4VSmjtqpyeqrj+ejqs3uRM9d/ZYTiso3P/KSYh8z1J9BZjQbv1wIn8WdCYKNbOwnb2rtKUsC4YnHLKz2M1gh9T/6njHYWZmFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966608; c=relaxed/simple;
	bh=iOP54y8DPHg2tWRlHpuhc06gXOtp3O7pUJt8kgyey70=;
	h=Date:To:From:Subject:Message-Id; b=kjhzyeFaeGFWI8fuwZVhA1fzBlRij5eSh72wgRmaajt9li0wyHcptzgMzjI6s1l4L5B6/5A6+zmstwaPcLS+2xcEnars9QGz26G5q2pZ6eOcBxLSeEDl9NQcjGmd5LTshaYbJ8LGPEJ/B2OcTKdKVaW7kM6OXNlYMKekDirx7tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NEASARNR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NEASARNR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38687C16AAE;
	Wed, 21 Jan 2026 03:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966608;
	bh=iOP54y8DPHg2tWRlHpuhc06gXOtp3O7pUJt8kgyey70=;
	h=Date:To:From:Subject:From;
	b=NEASARNRvMBQu+tOC22Z2OQViFlsAkSZnBcNR5XQxgUwZ+UqA4d1CepSazMUIHa8q
	 0svXACnASZR7OjzZIa0Y07CtFSHKleSsplhPf/dhZSgniHvm4yXZ41DDSE+dqyOO8u
	 CQG0f94ZCn4prc3bKafwyN5HGHqBRGfrfBpXH9mE=
Date: Tue, 20 Jan 2026 19:36:47 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kho-abi-add-memblock-abi-header-fix-2.patch removed from -mm tree
Message-Id: <20260121033648.38687C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho-abi-add-memblock-abi-header-fix-2
has been removed from the -mm tree.  Its filename was
     kho-abi-add-memblock-abi-header-fix-2.patch

This patch was dropped because it was folded into kho-abi-add-memblock-abi-header.patch

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: kho-abi-add-memblock-abi-header-fix-2
Date: Tue, 20 Jan 2026 20:44:08 +0200

update reserved_mem node description, per Pratyush

Link: https://lkml.kernel.org/r/aW_M-HYZzx5SkbnZ@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kho/abi/memblock.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/kho/abi/memblock.h~kho-abi-add-memblock-abi-header-fix-2
+++ a/include/linux/kho/abi/memblock.h
@@ -45,7 +45,8 @@
  *     Identifies the overall memblock ABI version.
  *
  * reserved_mem node:
- *   These nodes describe all reserve_mem regions.
+ *   These nodes describe all reserve_mem regions. The node name is the name
+ *   defined by the user for a reserve_mem region.
  *
  *   - compatible: "reserve-mem-v1"
  *
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
kho-abi-add-memblock-abi-header.patch

