Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0BB7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zcVN1VHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DB2C433C7;
	Mon, 11 Dec 2023 01:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257796;
	bh=eENaBIQKVHcYWl/KfjIKIMwPLYrjByYo080TSUPC2Eo=;
	h=Date:To:From:Subject:From;
	b=zcVN1VHZNa2Nwb5St+jNrTXcsYfYTrZYPMMnRkmfcNXSD0Riv+mGaN785pP1uE4Hv
	 7s9zdHiHi7E6stGawMvQpOcyL1CtWG32uTlxKrrB/8Extdre/e5mHBLMvdeiSKcajK
	 tGGREJIxvA68EuC61dijNnj+K0lLDQRC00K8NKA4=
Date: Sun, 10 Dec 2023 17:23:16 -0800
To: mm-commits@vger.kernel.org,bcain@quicinc.com,arnd@arndb.de,nathan@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] hexagon-vm_tlb-include-asm-tlbflushh-for-prototypes.patch removed from -mm tree
Message-Id: <20231211012316.97DB2C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hexagon: vm_tlb: include asm/tlbflush.h for prototypes
has been removed from the -mm tree.  Its filename was
     hexagon-vm_tlb-include-asm-tlbflushh-for-prototypes.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: hexagon: vm_tlb: include asm/tlbflush.h for prototypes
Date: Thu, 30 Nov 2023 15:58:20 -0700

Clang warns about several missing prototypes that are declared in this
header:

  arch/hexagon/mm/vm_tlb.c:25:6: warning: no previous prototype for function 'flush_tlb_range' [-Wmissing-prototypes]
     25 | void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
        |      ^
  arch/hexagon/mm/vm_tlb.c:25:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     25 | void flush_tlb_range(struct vm_area_struct *vma, unsigned long start,
        | ^
        | static
  arch/hexagon/mm/vm_tlb.c:37:6: warning: no previous prototype for function 'flush_tlb_one' [-Wmissing-prototypes]
     37 | void flush_tlb_one(unsigned long vaddr)
        |      ^
  arch/hexagon/mm/vm_tlb.c:37:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     37 | void flush_tlb_one(unsigned long vaddr)
        | ^
        | static
  arch/hexagon/mm/vm_tlb.c:47:6: warning: no previous prototype for function 'tlb_flush_all' [-Wmissing-prototypes]
     47 | void tlb_flush_all(void)
        |      ^
  arch/hexagon/mm/vm_tlb.c:47:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     47 | void tlb_flush_all(void)
        | ^
        | static
  arch/hexagon/mm/vm_tlb.c:56:6: warning: no previous prototype for function 'flush_tlb_mm' [-Wmissing-prototypes]
     56 | void flush_tlb_mm(struct mm_struct *mm)
        |      ^
  arch/hexagon/mm/vm_tlb.c:56:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     56 | void flush_tlb_mm(struct mm_struct *mm)
        | ^
        | static
  arch/hexagon/mm/vm_tlb.c:66:6: warning: no previous prototype for function 'flush_tlb_page' [-Wmissing-prototypes]
     66 | void flush_tlb_page(struct vm_area_struct *vma, unsigned long vaddr)
        |      ^
  arch/hexagon/mm/vm_tlb.c:66:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     66 | void flush_tlb_page(struct vm_area_struct *vma, unsigned long vaddr)
        | ^
        | static
  arch/hexagon/mm/vm_tlb.c:78:6: warning: no previous prototype for function 'flush_tlb_kernel_range' [-Wmissing-prototypes]
     78 | void flush_tlb_kernel_range(unsigned long start, unsigned long end)
        |      ^
  arch/hexagon/mm/vm_tlb.c:78:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
     78 | void flush_tlb_kernel_range(unsigned long start, unsigned long end)
        | ^
        | static
  6 warnings generated.

Link: https://lkml.kernel.org/r/20231130-hexagon-missing-prototypes-v1-7-5c34714afe9e@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Brian Cain <bcain@quicinc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/hexagon/mm/vm_tlb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/mm/vm_tlb.c~hexagon-vm_tlb-include-asm-tlbflushh-for-prototypes
+++ a/arch/hexagon/mm/vm_tlb.c
@@ -14,6 +14,7 @@
 #include <linux/sched.h>
 #include <asm/page.h>
 #include <asm/hexagon_vm.h>
+#include <asm/tlbflush.h>
 
 /*
  * Initial VM implementation has only one map active at a time, with
_

Patches currently in -mm which might be from nathan@kernel.org are

buffer-fix-grow_buffers-for-block-size-page_size-fix.patch

