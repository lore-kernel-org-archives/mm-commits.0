Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011CABA21
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 18:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770922690; cv=none; b=h1cZ/ncQ9HpvOKzmZ4Xptasi7FYKjzmeavt73ewiD91JlhBXTOLn5ts/0PXejuc3ki+2YXPaHcC4mHCIYP7/OjsyutEeMkj6ZpcCKtkZ+WSUrPQbZWETtEmoCUWbIvUs2sGSjU+Lv/xVuD544AZwPAgrxBI8U23EVFN/2254xFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770922690; c=relaxed/simple;
	bh=t4R49vTG+q2CSlas+3ryH3tJHf0U/nCCOpYx/ACvdmo=;
	h=Date:To:From:Subject:Message-Id; b=p4KVOhbhEy9zPKmX+0S+MjyxUhnY+3PV46aFAEq87VOv6bvAL3TFZ1tN7q+tUB8Vph3tgXGXnUSfx71Qzm6nvfWwFXifY7NL8FUEbA1DSbPCCGDpmlvBvwAVnQmKMq1AOl+4dBaFUxI+FLOLrgapG9PjyICFG7HrGI5jV1ByCMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BNzs4ukk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BNzs4ukk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74851C4CEF7;
	Thu, 12 Feb 2026 18:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770922689;
	bh=t4R49vTG+q2CSlas+3ryH3tJHf0U/nCCOpYx/ACvdmo=;
	h=Date:To:From:Subject:From;
	b=BNzs4ukkdBtykuwsr3DxE/Yz2vqR5b7gev1VcZmhYVG1HhxUEcZMOx/MLxFAciUIL
	 +7T0t6RsgOVcOH5qRkVB/tcBSOOtXX3Vcc/JAt+l2gXa8x0AgzMhLE3uP0Uz7LuMQ1
	 NkS0qmvlQ6ZfUAdGn+LorwYKypx5xxpTLNnGj6Sg=
Date: Thu, 12 Feb 2026 10:58:08 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-fix-missing-early_memunmap-call-in-kho_populate.patch added to mm-nonmm-unstable branch
Message-Id: <20260212185809.74851C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: fix missing early_memunmap() call in kho_populate()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-fix-missing-early_memunmap-call-in-kho_populate.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-fix-missing-early_memunmap-call-in-kho_populate.patch

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
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: kho: fix missing early_memunmap() call in kho_populate()
Date: Thu, 12 Feb 2026 11:11:45 +0000

Patch series "two fixes in kho_populate()", v3.


This patch (of 2):

kho_populate() returns without calling early_memunmap() on success path,
this will cause early ioremap virtual address space leak.

Link: https://lkml.kernel.org/r/20260212111146.210086-1-ranxiaokai627@163.com
Link: https://lkml.kernel.org/r/20260212111146.210086-2-ranxiaokai627@163.com
Fixes: b50634c5e84a ("kho: cleanup error handling in kho_populate()")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/kernel/liveupdate/kexec_handover.c~kho-fix-missing-early_memunmap-call-in-kho_populate
+++ a/kernel/liveupdate/kexec_handover.c
@@ -1463,36 +1463,37 @@ void __init kho_populate(phys_addr_t fdt
 	struct kho_scratch *scratch = NULL;
 	phys_addr_t mem_map_phys;
 	void *fdt = NULL;
+	bool populated = false;
 	int err;
 
 	/* Validate the input FDT */
 	fdt = early_memremap(fdt_phys, fdt_len);
 	if (!fdt) {
 		pr_warn("setup: failed to memremap FDT (0x%llx)\n", fdt_phys);
-		goto err_report;
+		goto report;
 	}
 	err = fdt_check_header(fdt);
 	if (err) {
 		pr_warn("setup: handover FDT (0x%llx) is invalid: %d\n",
 			fdt_phys, err);
-		goto err_unmap_fdt;
+		goto unmap_fdt;
 	}
 	err = fdt_node_check_compatible(fdt, 0, KHO_FDT_COMPATIBLE);
 	if (err) {
 		pr_warn("setup: handover FDT (0x%llx) is incompatible with '%s': %d\n",
 			fdt_phys, KHO_FDT_COMPATIBLE, err);
-		goto err_unmap_fdt;
+		goto unmap_fdt;
 	}
 
 	mem_map_phys = kho_get_mem_map_phys(fdt);
 	if (!mem_map_phys)
-		goto err_unmap_fdt;
+		goto unmap_fdt;
 
 	scratch = early_memremap(scratch_phys, scratch_len);
 	if (!scratch) {
 		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
 			scratch_phys, scratch_len);
-		goto err_unmap_fdt;
+		goto unmap_fdt;
 	}
 
 	/*
@@ -1509,7 +1510,7 @@ void __init kho_populate(phys_addr_t fdt
 		if (WARN_ON(err)) {
 			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
 				&area->addr, &size, ERR_PTR(err));
-			goto err_unmap_scratch;
+			goto unmap_scratch;
 		}
 		pr_debug("Marked 0x%pa+0x%pa as scratch", &area->addr, &size);
 	}
@@ -1529,16 +1530,17 @@ void __init kho_populate(phys_addr_t fdt
 	kho_in.scratch_phys = scratch_phys;
 	kho_in.mem_map_phys = mem_map_phys;
 	kho_scratch_cnt = scratch_cnt;
-	pr_info("found kexec handover data.\n");
 
-	return;
+	populated = true;
+	pr_info("found kexec handover data.\n");
 
-err_unmap_scratch:
+unmap_scratch:
 	early_memunmap(scratch, scratch_len);
-err_unmap_fdt:
+unmap_fdt:
 	early_memunmap(fdt, fdt_len);
-err_report:
-	pr_warn("disabling KHO revival\n");
+report:
+	if (!populated)
+		pr_warn("disabling KHO revival\n");
 }
 
 /* Helper functions for kexec_file_load */
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

kho-fix-missing-early_memunmap-call-in-kho_populate.patch
kho-remove-unnecessary-warn_onerr-in-kho_populate.patch

