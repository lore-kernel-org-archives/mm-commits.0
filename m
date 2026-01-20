Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DCC3161B5
	for <mm-commits@vger.kernel.org>; Tue, 20 Jan 2026 20:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768939419; cv=none; b=cyaNpM2u+Ph4VdyrIicI31UO3Z1DWcsQQ7X5tVriEjgKf0i9dE+OVGGbGeUstqlQkJKZfFlIT4GUCH6P4D4b8vE8F54PxXa9pyZtBEgUeq6eztfZ8cwrGE2R3r/cyVnwAG9YJPWoNNUAdrbfC/0VbcYrW2yyl+fkv5p7Kyjo9q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768939419; c=relaxed/simple;
	bh=C5hde2xuAA+1XP3Yad5cWzMS1EVgAY//i1bjSZc5sQk=;
	h=Date:To:From:Subject:Message-Id; b=pFXBbvBzdtbpV/ZHp1P18Mi8X/oMfX7qg2KWq+QRYVD1rQtCj66DzhJhsiBq6lQQuIqHbuLS+jodHqYRXLp7GK/iiHagjtwCU0BITeZsWMQJXE5PnxMBw4URvkJcFwgWBZPOfoMudHjcxpUonrX2rVOGNdzX2l8Eky7hhQqn4+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b4gSbvfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b4gSbvfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38D75C16AAE;
	Tue, 20 Jan 2026 20:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768939419;
	bh=C5hde2xuAA+1XP3Yad5cWzMS1EVgAY//i1bjSZc5sQk=;
	h=Date:To:From:Subject:From;
	b=b4gSbvfRRenBMeN+Q507VzjbibzEXxkLY6l/KV8VYHCGXoPDhCxYx693yhnAIbbW2
	 2PbpOtb+Lu2ZzXSq8KNZyKmfp/r8oLPw+T2Hqwwwc7OGGEQ/BiyrpaUZiw7z6I7kEz
	 IZFWu9YbchLUL0apDkRr1U9TP7VBC+i5/OJuHZFo=
Date: Tue, 20 Jan 2026 12:03:38 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-abi-add-memblock-abi-header-fix-2.patch added to mm-nonmm-unstable branch
Message-Id: <20260120200339.38D75C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho-abi-add-memblock-abi-header-fix-2
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-abi-add-memblock-abi-header-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-abi-add-memblock-abi-header-fix-2.patch

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
kho-docs-combine-concepts-and-fdt-documentation-fix.patch
kho-abi-add-memblock-abi-header.patch
kho-abi-add-memblock-abi-header-fix-2.patch

