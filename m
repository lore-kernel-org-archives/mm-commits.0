Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1638D3EBF1D
	for <mm-commits@vger.kernel.org>; Sun,  1 Feb 2026 00:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769905027; cv=none; b=eeIaB8W6J3dlO36l083RFhFPQCAJ88vK+7kSU4o4z9KUlFabGHmCrBand2QlDacOTy2k0tyIwEq8Lb2kgJQgWIvkr1y19Oyn9k5KFcqQy4/zi7KTBCiTL3Ye/04RNQwM4XOoX9Xe/O+0kdJBN+cshvw09Gm2K8AbsO4eYk8NbR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769905027; c=relaxed/simple;
	bh=vUohPP/l3IxjkkGXC+R4s/IZH2ynYKe2S7juRjQwe6s=;
	h=Date:To:From:Subject:Message-Id; b=KTEnvr8DoXXmyE8qM/NT0QCPDxTDMoZ0kXrAca+oTQnY6YhyHyB8elu6BEtZ3IAdn8NFzroBKnvsjnDKlMZryja3D9MiQTphtM3hKrFKpwckkCImzbqPvt7XoUY0wEXtVZxKoMAVpB4nSeZ+Bs5bFrC435ddQIPOnSe3TwYEmfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qTcfKUhK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qTcfKUhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E6EC4CEF1;
	Sun,  1 Feb 2026 00:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769905027;
	bh=vUohPP/l3IxjkkGXC+R4s/IZH2ynYKe2S7juRjQwe6s=;
	h=Date:To:From:Subject:From;
	b=qTcfKUhKljGbjFvKf6W/xTxaULQjCJRK+gGNICVqA+Q5J97mP/Z6ojK7R7W4f/ykz
	 ALXQawSSiLDJfOfXq11TlI8KNZd2SgC0PG6GTg6sWRqwC0736Y4aqq9v5wQKWDo/0F
	 MIS/k97mT31s1yrl3JLhH2STXa2b6PeTrjKyrnzo=
Date: Sat, 31 Jan 2026 16:17:06 -0800
To: mm-commits@vger.kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-cleanup-error-handling-in-kho_populate.patch removed from -mm tree
Message-Id: <20260201001706.E1E6EC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: cleanup error handling in kho_populate()
has been removed from the -mm tree.  Its filename was
     kho-cleanup-error-handling-in-kho_populate.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
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


