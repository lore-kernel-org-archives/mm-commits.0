Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5822874E9
	for <mm-commits@vger.kernel.org>; Sat, 22 Nov 2025 21:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763847703; cv=none; b=PaeYLLCCDyD1HHrPBr4725/wiQcrVnvhCf+wjpRqkyu821sc74xvXdQI3DEUE7EKsLMNbspx553laNPqGBX12tkgVIkm1NbJe5/Gfz+b/y41BLM1HfgqteVf8nPeGq0S+E1R3s1qdTNDAec4cN49s+L9DBqa7jZGHAIdRxwmjaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763847703; c=relaxed/simple;
	bh=Aw3sgdJorseTg5hkOJ6KHvqdHDywqyQ5j+8wxkTMc3c=;
	h=Date:To:From:Subject:Message-Id; b=cuNdkq919MGPA0pO5pfnn5B2AXFCyn2trElRAaivpvBP7kCxROsAyB9GfZTV/5XLNesR9Fv42VwDssqSKH8TzZlb6PVj/Hz/tDDRlO14jJ5Ye2fF4UKEiWg0J0l0ZvIYDg6xjYrc9C/u5EguK17JrmuPqL2mJb9utuEXiykE40o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WTgJUSL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WTgJUSL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487DAC4CEF5;
	Sat, 22 Nov 2025 21:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763847702;
	bh=Aw3sgdJorseTg5hkOJ6KHvqdHDywqyQ5j+8wxkTMc3c=;
	h=Date:To:From:Subject:From;
	b=WTgJUSL/qCdl3s8XMkEfesItDDkO4Y+fOgvxeyqMDUS0MrQ1PV/0yO16oNqZZ0Cg8
	 XqqHKPOm6awjqcVY2z+Ne+xXU5ahUWN2IaU76QxZ70hhbOI3J9LjWgXA/a9dM+5qo/
	 5qpQarxMmdo++gCUcSr0pmh+85ouk74QLI8RW5u8=
Date: Sat, 22 Nov 2025 13:41:41 -0800
To: mm-commits@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,changyuanl@google.com,catalin.marinas@arm.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages.patch added to mm-nonmm-unstable branch
Message-Id: <20251122214142.487DAC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: KHO: fix boot failure due to kmemleak access to non-PRESENT pages
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages.patch

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
Subject: KHO: fix boot failure due to kmemleak access to non-PRESENT pages
Date: Sat, 22 Nov 2025 18:29:29 +0000

When booting with debug_pagealloc=on while having:
CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=n
the system fails to boot due to page faults during kmemleak scanning.

This occurs because:
With debug_pagealloc is enabled, __free_pages() invokes
debug_pagealloc_unmap_pages(), clearing the _PAGE_PRESENT bit for
freed pages in the kernel page table.
Commit 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
triggers this when releases the KHO scratch region calling
init_cma_reserved_pageblock(). Subsequent kmemleak scanning accesses
these non-PRESENT pages, leading to fatal page faults.

Call kmemleak_ignore_phys() from kho_init() to exclude the reserved region
from kmemleak scanning before it is released to the buddy allocator to fix
this.

Link: https://lkml.kernel.org/r/20251122182929.92634-1-ranxiaokai627@163.com
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Alexander Graf <graf@amazon.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/liveupdate/kexec_handover.c~kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages
+++ a/kernel/liveupdate/kexec_handover.c
@@ -11,6 +11,7 @@
 
 #include <linux/cleanup.h>
 #include <linux/cma.h>
+#include <linux/kmemleak.h>
 #include <linux/count_zeros.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
@@ -1369,6 +1370,7 @@ static __init int kho_init(void)
 		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
 		unsigned long pfn;
 
+		kmemleak_ignore_phys(kho_scratch[i].addr);
 		for (pfn = base_pfn; pfn < base_pfn + count;
 		     pfn += pageblock_nr_pages)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

kho-fix-boot-failure-due-to-kmemleak-access-to-non-present-pages.patch

