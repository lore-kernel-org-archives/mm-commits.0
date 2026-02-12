Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA212857CF
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939993; cv=none; b=QS8tf6cdIVWbnbMOEmiCxGYqlSaT1RnYfjjomiENytEeU6GtRkabwpwCQBIBzR6zRzf+AwRdMsp15hAHXI1W2Lf9V3NDJrYHMjznRQcA0acWUI8JJ/5H9x4ZwqKV2Jnmvhfx6nBc7uqXVn7UZzReLB7dh8t+jEOuG3ldfQNQkxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939993; c=relaxed/simple;
	bh=Dw+xL9zqRliSscg84xay5n+TgS+36WVWJzpYGkaXUiM=;
	h=Date:To:From:Subject:Message-Id; b=fzZF4whXeLEsaYHdJZUd6VoLQfrrVAL0+ONxG0TqfdHlQ6sEwV0yY/vhDppMI2ZOlRhJMs68svsdv9ykLCcP6/61MKfY3bGfX4GyJUd01HY/1+V9WGqfNa79HBQG19QY6/0u9AhzgpceKyhD6ROQATXB1DgP8khHeuYjV2J4YKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DVXYXL0n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DVXYXL0n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16A1C4CEF7;
	Thu, 12 Feb 2026 23:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939992;
	bh=Dw+xL9zqRliSscg84xay5n+TgS+36WVWJzpYGkaXUiM=;
	h=Date:To:From:Subject:From;
	b=DVXYXL0n5Fcz25zq7umKKsMBUYgdNATkW8KfpomHTgsQbp/Ztb88HCErKhb/oVVjC
	 rlGOb/d3TfMBDqp4Mvoo0mru/5eO2lRtO0jNST8Ed53DjVdSYvfgg7T7m223QbyddT
	 CVaIWNatQhjpAhqblwnM8qUJ3wzyxqtYbr/7Th0o=
Date: Thu, 12 Feb 2026 15:46:32 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-fix-missing-early_memunmap-call-in-kho_populate.patch removed from -mm tree
Message-Id: <20260212234632.D16A1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kho: fix missing early_memunmap() call in kho_populate()
has been removed from the -mm tree.  Its filename was
     kho-fix-missing-early_memunmap-call-in-kho_populate.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
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


