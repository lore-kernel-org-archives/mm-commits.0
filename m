Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CF8328611
	for <mm-commits@vger.kernel.org>; Thu, 20 Nov 2025 15:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763653276; cv=none; b=LXRc0MBSAvkVmJ+w+58WL/xt0BwK15gD5H2ur1IzYwIesTbHvedxcrPE60GyjtHkoHlEI8C2psprxMFK8xSw30781bStft3XCjEiyGTOmMzLj95dL3wdFQIhPS3J9xyV6h9BDTZMg3Lr1XWWKAOWQrG76UeTKj1eGc9WjZBwc7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763653276; c=relaxed/simple;
	bh=3Cy+auwEU89JUqnbKwHYxyfo6/vUj7vx2S+/PIpI4oQ=;
	h=Date:To:From:Subject:Message-Id; b=jAZL4O6ctdDkeoBlB4Yx8uIQz0qVL/8PaOzBjCpMeVtYXa2QLhjMwT1YakjJ6gNUtfsN6YNOWb5B/SWDNYnioakFVPUGSEEO8gMyb7FHaf1j5D9B/gRnYETjGNt34jQyGAQPXL5QS3MBH2yU5TzqCxAaACkN7oCioK3vhDH8H7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1vcoZ4MQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1vcoZ4MQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3A5C116C6;
	Thu, 20 Nov 2025 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763653275;
	bh=3Cy+auwEU89JUqnbKwHYxyfo6/vUj7vx2S+/PIpI4oQ=;
	h=Date:To:From:Subject:From;
	b=1vcoZ4MQnqQ2mnLej+hjG1IkA3wjWbgGLmjAutckbDRVlujyeHM3yTVDpj0YDotWD
	 N7OkMcY6Z/+iQDYUqMgN1uFayOgOxPFHHUNdn4Jsvacq+0kEr/a2eGHQdw853Ht9q+
	 QKadxLoWZFEg++27VhPipo7AoqWKdiL0ryORx0vI=
Date: Thu, 20 Nov 2025 07:41:14 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,changyuanl@google.com,catalin.marinas@arm.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + liveupdate-fix-boot-failure-due-to-kmemleak-access-to-unmapped-pages.patch added to mm-nonmm-unstable branch
Message-Id: <20251120154114.EE3A5C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: liveupdate: fix boot failure due to kmemleak access to unmapped pages
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     liveupdate-fix-boot-failure-due-to-kmemleak-access-to-unmapped-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/liveupdate-fix-boot-failure-due-to-kmemleak-access-to-unmapped-pages.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-kmemleak-introduce-kmemleak_no_scan_phys-helper.patch
liveupdate-fix-boot-failure-due-to-kmemleak-access-to-unmapped-pages.patch

