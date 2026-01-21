Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E3032D435
	for <mm-commits@vger.kernel.org>; Wed, 21 Jan 2026 03:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768966583; cv=none; b=YbfRWPn8T7KxAjm1LFOxGKe2mllyGOwvJObbGrg9HSK8x28Bkd8dVgx8Eqjq1j9IeafMMjSncfLuQbSbVBbfl7dh+tkL/tpWY7emmCbFEGOacc0/5tRDr8qEBr1CA3wnTXmMJy+ObI/PluSJxkRuiuJm/Sr09//gxV8/EF/liMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768966583; c=relaxed/simple;
	bh=q69qBQ+JlkxcRzYemVKsNjneyTBjxD4w1BUVJa/azQ4=;
	h=Date:To:From:Subject:Message-Id; b=iPkd5rctS+CzVDq++Mn1/a5tOPqRUZow4pln6ZtLVN1uIfyxLvAEBbUNKbeVCdxXDJpgwAlzw2hG1oUvCAoxzoTUH0FSXSGMARp9pzXjD2x1I3YdQXK9iOXetDTe/0NRUj9RwcCyEPzvRtSynNMwhxJuGf7Mxe9Z6/12kElPlco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1GmKAGju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1GmKAGju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84970C16AAE;
	Wed, 21 Jan 2026 03:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768966582;
	bh=q69qBQ+JlkxcRzYemVKsNjneyTBjxD4w1BUVJa/azQ4=;
	h=Date:To:From:Subject:From;
	b=1GmKAGjuftaDGFAzYp+Ms4DjpQ412kUllbUfKuHAqgQyZh4mKheWo+PNp9zWWbx5f
	 5c3R6EICSRWbsZ8ZF+KBQpYc1LDiTN55qUARNV9ATA8uePcEV13C0MSDuqFZkISv66
	 Ue5YAjOm7a61D6L7p78ZrR8sDmfIkjaw3qWMN4e8=
Date: Tue, 20 Jan 2026 19:36:22 -0800
To: mm-commits@vger.kernel.org,pratyush@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kho-relocate-vmalloc-preservation-structure-to-kho-abi-header-fix.patch removed from -mm tree
Message-Id: <20260121033622.84970C16AAE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho-relocate-vmalloc-preservation-structure-to-kho-abi-header-fix
has been removed from the -mm tree.  Its filename was
     kho-relocate-vmalloc-preservation-structure-to-kho-abi-header-fix.patch

This patch was dropped because it was folded into kho-relocate-vmalloc-preservation-structure-to-kho-abi-header.patch

------------------------------------------------------
From: Mike Rapoport <rppt@kernel.org>
Subject: kho-relocate-vmalloc-preservation-structure-to-kho-abi-header-fix
Date: Tue, 20 Jan 2026 20:42:50 +0200

update comment, per Pratyush

Link: https://lkml.kernel.org/r/aW_Mqp6HcqLwQImS@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
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
kho-relocate-vmalloc-preservation-structure-to-kho-abi-header.patch
kho-abi-add-memblock-abi-header.patch
kho-abi-add-memblock-abi-header-fix-2.patch

