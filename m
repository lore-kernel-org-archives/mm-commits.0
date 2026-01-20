Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64766399A62
	for <mm-commits@vger.kernel.org>; Tue, 20 Jan 2026 20:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768939560; cv=none; b=nSv9U6Rn6SdZ0raHosgcVcu8LeZl2+E1E4O9m3O55n/JY3+37rlhhTs+EnrioAKL+MxCCN+wK3tDYRd3xWYr6TReIRIB9xK3Pbn3T9sWGWgEnGXlREBggH/zz9ILM+YbifVoZfzeo9aB09qAb0mNhDYtvKgn07mbkekYTPJm3LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768939560; c=relaxed/simple;
	bh=wR+Cu+r21orWMHTPGdN84v9n9i6Afk3zKKEehqXa42w=;
	h=Date:To:From:Subject:Message-Id; b=kcv0BBc9CqGkjLKM3o1yVSbqU3jihw0spUEbQhl/ucEPaLa4AV+XOIf6MSZTB+PkMFIPkRcwUEWkqOxXV02qnnctpZDLmqkUov3+4bOZJucXLsWTsjkkS+C1qvXo+IPASwtnoSO9I8bomOuthvj/AcxxAjgOq90xtX2hskavC7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Eba9XJOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Eba9XJOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB75AC16AAE;
	Tue, 20 Jan 2026 20:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768939560;
	bh=wR+Cu+r21orWMHTPGdN84v9n9i6Afk3zKKEehqXa42w=;
	h=Date:To:From:Subject:From;
	b=Eba9XJOy+QLd78HfJVWQJVSX1oSZXq90hOYyZH/lpzILh3RQJF5XWqDIjmjNC/mH3
	 AkjkrYaX5kxn+Csro/szc3YHeibKb6ZDs+9Rmx17H9ad1DJcsngvsIGypXrL6lMqmH
	 nOseYzukHAikaoXdWa6B8chhvFy6MN0FfcTwFGsg=
Date: Tue, 20 Jan 2026 12:05:59 -0800
To: mm-commits@vger.kernel.org,pasha.tatashin@soleen.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-relocate-vmalloc-preservation-structure-to-kho-abi-header-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20260120200559.EB75AC16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho-relocate-vmalloc-preservation-structure-to-kho-abi-header-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-relocate-vmalloc-preservation-structure-to-kho-abi-header-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-relocate-vmalloc-preservation-structure-to-kho-abi-header-fix.patch

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
Subject: kho-relocate-vmalloc-preservation-structure-to-kho-abi-header-fix
Date: Tue, 20 Jan 2026 20:42:50 +0200

update comment, per Pratyush

Link: https://lkml.kernel.org/r/aW_Mqp6HcqLwQImS@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kho/abi/kexec_handover.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/kho/abi/kexec_handover.h~kho-relocate-vmalloc-preservation-structure-to-kho-abi-header-fix
+++ a/include/linux/kho/abi/kexec_handover.h
@@ -138,8 +138,8 @@ struct kho_vmalloc_hdr {
 /*
  * Each chunk is a single page and is part of a linked list that describes
  * a preserved vmalloc area. It contains the header with the link to the next
- * chunk and an array of physical addresses of the pages that make up the
- * preserved vmalloc area.
+ * chunk and a zero terminated array of physical addresses of the pages that
+ * make up the preserved vmalloc area.
  */
 struct kho_vmalloc_chunk {
 	struct kho_vmalloc_hdr hdr;
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
kho-relocate-vmalloc-preservation-structure-to-kho-abi-header-fix.patch
kho-abi-add-memblock-abi-header.patch
kho-abi-add-memblock-abi-header-fix-2.patch

