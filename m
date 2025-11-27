Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9695031ED92
	for <mm-commits@vger.kernel.org>; Thu, 27 Nov 2025 22:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764282435; cv=none; b=i6NY4LewbNy9+JQRut9vVDEDduqCFqMAPsMk4AM1FY1maQMv1oa3KrfemRDV1sUjx+XjIcshqtTQyfPTLCKVF89Mbvx/Qx69CPzhpnyAnX2ewkRiWwYEkRyIlgBCwUqC2wt/TYPQqEtovJ2jvhpYSbyoYb5WUv8KHgSbfOoT+HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764282435; c=relaxed/simple;
	bh=5k8Fyd9KtN3Jg9Bu3DGnHpeYH/D1kXNInuUtVxv2k2I=;
	h=Date:To:From:Subject:Message-Id; b=rUcH+N9ckFKm0Zu4VQGrGVWRNITO9o3X+tqA1SSR3s5Z5DfiUfEfGvDgREy8jZA2IVNVPs77z4j9ILGfJVMd15yFaoGqnkkPzN2m0vyZCMU1JOwbBRle4wT8Gd4SBRIrrQ2T7huzzwWstJbTbBZJsZrRHIe3MKBw0wh5GnEwnsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MftdX6cM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MftdX6cM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE44C4CEF8;
	Thu, 27 Nov 2025 22:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764282435;
	bh=5k8Fyd9KtN3Jg9Bu3DGnHpeYH/D1kXNInuUtVxv2k2I=;
	h=Date:To:From:Subject:From;
	b=MftdX6cMXodrlWhrjesBQoget6LX7ez+UHi39DaL3MBW9BV9TzipqL4FTAVvgu75q
	 8EqC/aKAHdnLfvhumigmy74dxLI2Bf5lNFOOWQ/QiyXzwBM3WiquKutxuwfMqTolYp
	 MghJVvRRbJjGf3RCQbXGNL5loy1JhSn8XlVsGs80=
Date: Thu, 27 Nov 2025 14:27:14 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,changyuanl@google.com,catalin.marinas@arm.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages.patch removed from -mm tree
Message-Id: <20251127222715.6DE44C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: KHO: fix boot failure due to kmemleak access to non-PRESENT pages
has been removed from the -mm tree.  Its filename was
     kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: KHO: fix boot failure due to kmemleak access to non-PRESENT pages
Date: Sat, 22 Nov 2025 18:29:29 +0000

When booting with debug_pagealloc=on while having:
CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=n
the system fails to boot due to page faults during kmemleak scanning.

This occurs because:
With debug_pagealloc is enabled, __free_pages() invokes
debug_pagealloc_unmap_pages(), clearing the _PAGE_PRESENT bit for freed
pages in the kernel page table.  KHO scratch areas are allocated from
memblock and noted by kmemleak.  But these areas don't remain reserved but
released later to the page allocator using init_cma_reserved_pageblock(). 
This causes subsequent kmemleak scans access non-PRESENT pages, leading to
fatal page faults.

Mark scratch areas with kmemleak_ignore_phys() after they are allocated
from memblock to exclude them from kmemleak scanning before they are
released to buddy allocator to fix this.

[ran.xiaokai@zte.com.cn: add comment]
  Link: https://lkml.kernel.org/r/20251127122700.103927-1-ranxiaokai627@163.com
Link: https://lkml.kernel.org/r/20251122182929.92634-1-ranxiaokai627@163.com
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/liveupdate/kexec_handover.c~kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages
+++ a/kernel/liveupdate/kexec_handover.c
@@ -11,6 +11,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/cma.h>
+#include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
@@ -1369,6 +1370,15 @@ static __init int kho_init(void)
 		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
 		unsigned long pfn;
 
+		/*
+		 * When debug_pagealloc is enabled, __free_pages() clears the
+		 * corresponding PRESENT bit in the kernel page table.
+		 * Subsequent kmemleak scans of these pages cause the
+		 * non-PRESENT page faults.
+		 * Mark scratch areas with kmemleak_ignore_phys() to exclude
+		 * them from kmemleak scanning.
+		 */
+		kmemleak_ignore_phys(kho_scratch[i].addr);
 		for (pfn = base_pfn; pfn < base_pfn + count;
 		     pfn += pageblock_nr_pages)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are


