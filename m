Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844BF3D1CBC
	for <mm-commits@vger.kernel.org>; Thu, 22 Jan 2026 17:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769101482; cv=none; b=Z5jXwK0Rnj1JSZbpjmpSa5lO6MhPy8D56zG4EuAKaTxzJ9KaeC5ZdJ+mv80HPWx0ETorKAcecMI55LnPXIuBr/Qn24vIuUVQBb6V08ZQobul8Wqdj++rbz8VO7JSlRUGy1IJId/94JCMmlrSkKez8XGpbBQ6wjLddhvL034wzQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769101482; c=relaxed/simple;
	bh=Cn9F9kgpp/q1lVL2SM5OEpeqHc6R/CE9uVKoyLXNHbI=;
	h=Date:To:From:Subject:Message-Id; b=NSkRLzPjHKFp4HOMjjrIaT1jThAeCi+PK3dYxWzTLeOFN2tKiZnQP27g6PJf1CgAmgLtPDO9I13EnTCeZ2oSQY9SnQHOLcS06W492oC3gSeYVP4oBo5gtNPUAV+Q2hCaU2dIlUK7PVw5SMlz9H8tr9vxlcHjQMjY5lu22PZU4sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZxHEcN9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZxHEcN9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6CCC116C6;
	Thu, 22 Jan 2026 17:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769101480;
	bh=Cn9F9kgpp/q1lVL2SM5OEpeqHc6R/CE9uVKoyLXNHbI=;
	h=Date:To:From:Subject:From;
	b=ZxHEcN9hTe4GC6Y73q+jhZeTj9oCiwUkSnHoVUvsecZG2+tjwW8UvTt4ZGtu9Tprx
	 Zm5pnB02qsxVhaRT3XQQ0Wia/frSpoFP8TcL0GIAjbbfJQ8sqo/1OMFbJSP6h9ABlg
	 tjv4gz6QPKo0CALHGexfc1RWmnwX413mk8udGF5s=
Date: Thu, 22 Jan 2026 09:04:39 -0800
To: mm-commits@vger.kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-cleanup-error-handling-in-kho_populate.patch added to mm-nonmm-unstable branch
Message-Id: <20260122170440.2F6CCC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: cleanup error handling in kho_populate()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-cleanup-error-handling-in-kho_populate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-cleanup-error-handling-in-kho_populate.patch

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
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: kho: cleanup error handling in kho_populate()
Date: Thu, 22 Jan 2026 14:17:57 +0200

* use dedicated labels for error handling instead of checking if a pointer
  is not null to decide if it should be unmapped
* drop assignment of values to err that are only used to print a numeric
  error code, there are pr_warn()s for each failure already so printing a
  numeric error code in the next line does not add anything useful

Link: https://lkml.kernel.org/r/20260122121757.575987-1-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   39 +++++++++++----------------
 1 file changed, 17 insertions(+), 22 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-cleanup-error-handling-in-kho_populate
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1455,46 +1455,40 @@ void __init kho_memory_init(void)
 void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 			 phys_addr_t scratch_phys, u64 scratch_len)
 {
+	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 	struct kho_scratch *scratch = NULL;
 	phys_addr_t mem_map_phys;
 	void *fdt = NULL;
-	int err = 0;
-	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
+	int err;
 
 	/* Validate the input FDT */
 	fdt = early_memremap(fdt_phys, fdt_len);
 	if (!fdt) {
 		pr_warn("setup: failed to memremap FDT (0x%llx)\n", fdt_phys);
-		err = -EFAULT;
-		goto out;
+		goto err_report;
 	}
 	err = fdt_check_header(fdt);
 	if (err) {
 		pr_warn("setup: handover FDT (0x%llx) is invalid: %d\n",
 			fdt_phys, err);
-		err = -EINVAL;
-		goto out;
+		goto err_unmap_fdt;
 	}
 	err = fdt_node_check_compatible(fdt, 0, KHO_FDT_COMPATIBLE);
 	if (err) {
 		pr_warn("setup: handover FDT (0x%llx) is incompatible with '%s': %d\n",
 			fdt_phys, KHO_FDT_COMPATIBLE, err);
-		err = -EINVAL;
-		goto out;
+		goto err_unmap_fdt;
 	}
 
 	mem_map_phys = kho_get_mem_map_phys(fdt);
-	if (!mem_map_phys) {
-		err = -ENOENT;
-		goto out;
-	}
+	if (!mem_map_phys)
+		goto err_unmap_fdt;
 
 	scratch = early_memremap(scratch_phys, scratch_len);
 	if (!scratch) {
 		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
 			scratch_phys, scratch_len);
-		err = -EFAULT;
-		goto out;
+		goto err_unmap_fdt;
 	}
 
 	/*
@@ -1511,7 +1505,7 @@ void __init kho_populate(phys_addr_t fdt
 		if (WARN_ON(err)) {
 			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
 				&area->addr, &size, ERR_PTR(err));
-			goto out;
+			goto err_unmap_scratch;
 		}
 		pr_debug("Marked 0x%pa+0x%pa as scratch", &area->addr, &size);
 	}
@@ -1533,13 +1527,14 @@ void __init kho_populate(phys_addr_t fdt
 	kho_scratch_cnt = scratch_cnt;
 	pr_info("found kexec handover data.\n");
 
-out:
-	if (fdt)
-		early_memunmap(fdt, fdt_len);
-	if (scratch)
-		early_memunmap(scratch, scratch_len);
-	if (err)
-		pr_warn("disabling KHO revival: %d\n", err);
+	return;
+
+err_unmap_scratch:
+	early_memunmap(scratch, scratch_len);
+err_unmap_fdt:
+	early_memunmap(fdt, fdt_len);
+err_report:
+	pr_warn("disabling KHO revival\n");
 }
 
 /* Helper functions for kexec_file_load */
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
kho-cleanup-error-handling-in-kho_populate.patch

