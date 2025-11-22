Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2D6257859
	for <mm-commits@vger.kernel.org>; Sat, 22 Nov 2025 21:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763847660; cv=none; b=HvGKUl/UJPwRdeElZ5S8emhxuUD97N0p9ZbrBIMLosBZj6o9bay5YZuXDZsKr2CT8yDig40tw7BmDTN2OxQx7K36Z7/D/xaQ/m2uK0b63V8Cva7i+/BZAdqYW66LTP0S6bHi39wTLw7a3iSFpb1eYIA6wygk0Rx49/oYlIlZxP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763847660; c=relaxed/simple;
	bh=Zf+Iq9Zp0rpZZiG5lMo8xQnBfbY2Ado5YxmrlEtkMyY=;
	h=Date:To:From:Subject:Message-Id; b=ThkdLHcaBMf6r4jxYbA3HmMI7KYRZulwYidTAfA3I0+phhd+TttqEzbrOwDZNoCQgkF0UV8xeIDKYYAj2mz+jbRG6TbMaBuWDDPgyT0QhoUDXunvXrzW/x8vL70k3Pl/AcPcusQR6MujjsXF9EBgubom92Kda09SfNt/h/Ge7gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Tps4/7VY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Tps4/7VY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F616C4CEF5;
	Sat, 22 Nov 2025 21:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763847659;
	bh=Zf+Iq9Zp0rpZZiG5lMo8xQnBfbY2Ado5YxmrlEtkMyY=;
	h=Date:To:From:Subject:From;
	b=Tps4/7VYLLlhmzcdLpWfUsbMxiqoPRoK5bumreupU8VF29BSvCL5xsiUpQKUy3tn3
	 4pF3UNXvkQptmjrFtoa0HCgr7x0HaemBFz8V2Z0iE7CIE1O9awuxMnQjVO23q/VAhK
	 m6gjDq2tnHbGCaXsgY1/vT/iZBYNiobp+83ttzIg=
Date: Sat, 22 Nov 2025 13:40:58 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,changyuanl@google.com,catalin.marinas@arm.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] liveupdate-fix-boot-failure-due-to-kmemleak-access-to-unmapped-pages.patch removed from -mm tree
Message-Id: <20251122214059.8F616C4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: liveupdate: fix boot failure due to kmemleak access to unmapped pages
has been removed from the -mm tree.  Its filename was
     liveupdate-fix-boot-failure-due-to-kmemleak-access-to-unmapped-pages.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: liveupdate: fix boot failure due to kmemleak access to unmapped pages
Date: Thu, 20 Nov 2025 14:41:47 +0000

When booting with debug_pagealloc=on while having:
CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=n
the system fails to boot due to page faults during kmemleak scanning.

This occurs because:
With debug_pagealloc enabled, __free_pages() invokes
debug_pagealloc_unmap_pages(), clearing the _PAGE_PRESENT bit for freed
pages in the direct mapping.  Commit 3dc92c311498 ("kexec: add Kexec
HandOver (KHO) generation helpers") releases the KHO scratch region via
init_cma_reserved_pageblock(), unmapping its physical pages.  Subsequent
kmemleak scanning accesses these unmapped pages, triggering fatal page
faults.

Call kmemleak_no_scan_phys() from kho_reserve_scratch() to exclude the
reserved region from scanning before it is released to the buddy
allocator.

Link: https://lkml.kernel.org/r/20251120144147.90508-3-ranxiaokai627@163.com
Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Alexander Graf <graf@amazon.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/liveupdate/kexec_handover.c~liveupdate-fix-boot-failure-due-to-kmemleak-access-to-unmapped-pages
+++ a/kernel/liveupdate/kexec_handover.c
@@ -11,6 +11,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/cma.h>
+#include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
@@ -654,6 +655,7 @@ static void __init kho_reserve_scratch(v
 	if (!addr)
 		goto err_free_scratch_desc;
 
+	kmemleak_no_scan_phys(addr);
 	kho_scratch[i].addr = addr;
 	kho_scratch[i].size = size;
 	i++;
@@ -664,6 +666,7 @@ static void __init kho_reserve_scratch(v
 	if (!addr)
 		goto err_free_scratch_areas;
 
+	kmemleak_no_scan_phys(addr);
 	kho_scratch[i].addr = addr;
 	kho_scratch[i].size = size;
 	i++;
@@ -676,6 +679,7 @@ static void __init kho_reserve_scratch(v
 		if (!addr)
 			goto err_free_scratch_areas;
 
+		kmemleak_no_scan_phys(addr);
 		kho_scratch[i].addr = addr;
 		kho_scratch[i].size = size;
 		i++;
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are


