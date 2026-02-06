Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806DF309EF4
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421698; cv=none; b=TAt6Y3InYQdq9TVesMnxl2cVaYFaM1kHY+0Dx6eUeY2uG6C9ruflzAtdUG+bn+D9Ys3AYN2m/11Y4doJd0TNp40B9daLpN5lVA2OhpvtAn7T/9y9D7cye0jOO0cA6p7aj6IedYuJ4TQSY4JMcY8lj57jnNwSgJCjJPc9MLcP4Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421698; c=relaxed/simple;
	bh=di+/gSesFnKjhSSrMzz7ZsArL/U0d8j1HYskBaOXte0=;
	h=Date:To:From:Subject:Message-Id; b=mpD82kQcCxa6xTZxTbr/I50M7iVa+lvLMyo3/4/Qbn68cXEwYLexPejSQREroXWLXWvk0VxA1jfxRgdtaTeCRtQVZDWuOfKo6xB7YoxJ7wvuoDtK9LSAzTkxmuJzzw7wZjgXNGnoZrLczMlyCRWqO0lZSgfaFFrMQgQP0dBRiAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=be7BzO7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="be7BzO7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC64C116C6;
	Fri,  6 Feb 2026 23:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421698;
	bh=di+/gSesFnKjhSSrMzz7ZsArL/U0d8j1HYskBaOXte0=;
	h=Date:To:From:Subject:From;
	b=be7BzO7omkJPIENq1GRN1DwmDufXbiZ02nUqstirw2ulYII9j69PLksKkxqAbrT5v
	 rzxa68PYYUhNF8nQPboLGbW5B930aXNKHxge1bA+XFK+RJTZb/CaRQkXCm80HpgScp
	 PbPZrVpPvurNScVOCs1Natcf1zmYSH5PVxcmnAHg=
Date: Fri, 06 Feb 2026 15:48:17 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@kernel.org,surenb@google.com,rppt@kernel.org,richard.weiyang@gmail.com,richard@nod.at,richard.henderson@linaro.org,peterz@infradead.org,npiggin@gmail.com,mingo@redhat.com,mhocko@suse.com,mattst88@gmail.com,lorenzo.stoakes@oracle.com,linmag7@gmail.com,Liam.Howlett@oracle.com,kernel@xen0n.name,johannes@sipsolutions.net,James.Bottomley@HansenPartnership.com,ioworker0@gmail.com,hpa@zytor.com,dev.jain@arm.com,deller@gmx.de,david@kernel.org,dave.hansen@linux.intel.com,chenhuacai@kernel.org,bp@alien8.de,anton.ivanov@cambridgegreys.com,aneesh.kumar@kernel.org,andreas@gaisler.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-change-mm-pt_reclaimc-to-use-asm-tlbh-instead-of-asm-generic-tlbh.patch removed from -mm tree
Message-Id: <20260206234818.0CC64C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: change mm/pt_reclaim.c to use asm/tlb.h instead of asm-generic/tlb.h
has been removed from the -mm tree.  Its filename was
     mm-change-mm-pt_reclaimc-to-use-asm-tlbh-instead-of-asm-generic-tlbh.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: change mm/pt_reclaim.c to use asm/tlb.h instead of asm-generic/tlb.h
Date: Tue, 27 Jan 2026 20:12:54 +0800

Patch series "enable PT_RECLAIM on more 64-bit architectures", v4.

This series aims to enable PT_RECLAIM on more 64-bit architectures.

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+).  To resolve this problem, we
need to enable PT_RECLAIM, which depends on MMU_GATHER_RCU_TABLE_FREE.

For these architectures that define its own __tlb_remove_table(), since
their page tables are not of type struct ptdesc, they cannot be supported
PT_RECLAIM.

Therefore, this series first enables MMU_GATHER_RCU_TABLE_FREE on all
64-bit architectures, then converts __HAVE_ARCH_TLB_REMOVE_TABLE to
CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config, and finally makes PT_RECLAIM
depend on MMU_GATHER_RCU_TABLE_FREE && !HAVE_ARCH_TLB_REMOVE_TABLE.  This
way, PT_RECLAIM can be enabled by default on most 64-bit architectures.

Of course, this will also be enabled on some 32-bit architectures that
already support MMU_GATHER_RCU_TABLE_FREE.  That's fine, PT_RECLAIM works
well on all 32-bit architectures as well.  Although the benefit isn't
significant, there's still memory that can be reclaimed.  Perhaps
PT_RECLAIM can be enabled on all 32-bit architectures in the future.


This patch (of 8):

Generally, the asm/tlb.h will include asm-generic/tlb.h, so change
mm/pt_reclaim.c to use asm/tlb.h instead of asm-generic/tlb.h.  This is a
preparation for enabling CONFIG_PT_RECLAIM on other architectures, such as
alpha.

Link: https://lkml.kernel.org/r/cover.1769515122.git.zhengqi.arch@bytedance.com
Link: https://lkml.kernel.org/r/befca537d10c6bf8d531b1ee0a8af1e3b31352b0.1769515122.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: WANG Xuerui <kernel@xen0n.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pt_reclaim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/pt_reclaim.c~mm-change-mm-pt_reclaimc-to-use-asm-tlbh-instead-of-asm-generic-tlbh
+++ a/mm/pt_reclaim.c
@@ -2,7 +2,7 @@
 #include <linux/hugetlb.h>
 #include <linux/pgalloc.h>
 
-#include <asm-generic/tlb.h>
+#include <asm/tlb.h>
 
 #include "internal.h"
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


