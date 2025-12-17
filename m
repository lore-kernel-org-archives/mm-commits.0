Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E78284890
	for <mm-commits@vger.kernel.org>; Wed, 17 Dec 2025 18:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765995889; cv=none; b=jAPz3aOJDa6ugZkhIddTIk2m6U9SmquGqTHzijtX2F9YlUNnWo9SBNZl43wJEYWzpaCziDBBxWAoHzZ91bzSdpgDb/E+a4YFahlZQGDE66OnW8kheu7HE88kTizfPlYW0K6di+Z/Be/KkEDm6HLE8cCds5SepNXPPVZxmVL5s68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765995889; c=relaxed/simple;
	bh=7aE9Gc5fjaEgLLQIcR6AaOZ9peX1Cs7l7nIOo9vT45I=;
	h=Date:To:From:Subject:Message-Id; b=HzY0+YHiD/uWsH1SHpNp8foWmTtZto+yDi/vrtQXXh26Dm9fC/ANeMR3opDcm+uMeyi7VpHfevAmaJKKa3TD9OEVdVKM/nIoTcwUPD5oN9xHmDgXS3I2nh3KbwcdnkOhW6LHKsLKD1UW8Mp5ILeFnGHjrbLVbPaEOO9wPWX7xfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=C33cdXhu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="C33cdXhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E27CC4CEF5;
	Wed, 17 Dec 2025 18:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765995886;
	bh=7aE9Gc5fjaEgLLQIcR6AaOZ9peX1Cs7l7nIOo9vT45I=;
	h=Date:To:From:Subject:From;
	b=C33cdXhuZmXSZxQ+TDBB/Ogcg6FNWQ8MVb4Wi9vwrU2pTm1wdM3XJ+5hyaWKVwmLG
	 k3u+/rELr9jpa1Nod678wE1z/R3wqmf0vbOY+Svd6mV+oCnI8Bdinyfe+GQTTh7Ixr
	 Gpobcu9dE3KuS1b5MByXlPo38sKGxawO2YLRkfFU=
Date: Wed, 17 Dec 2025 10:24:45 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,tsbogend@alpha.franken.de,richard@nod.at,richard.henderson@linaro.org,peterz@infradead.org,npiggin@gmail.com,mattst88@gmail.com,linmag7@gmail.com,kernel@xen0n.name,johannes@sipsolutions.net,James.Bottomley@HansenPartnership.com,ioworker0@gmail.com,dev.jain@arm.com,deller@gmx.de,david@kernel.org,chenhuacai@kernel.org,anton.ivanov@cambridgegreys.com,aneesh.kumar@kernel.org,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + alpha-mm-enable-mmu_gather_rcu_table_free.patch added to mm-new branch
Message-Id: <20251217182446.7E27CC4CEF5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: alpha: mm: enable MMU_GATHER_RCU_TABLE_FREE
has been added to the -mm mm-new branch.  Its filename is
     alpha-mm-enable-mmu_gather_rcu_table_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/alpha-mm-enable-mmu_gather_rcu_table_free.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: alpha: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Wed, 17 Dec 2025 17:45:43 +0800

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+).  To resolve this problem,
first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
PT_RECLAIM feature, which resolves this problem.

Link: https://lkml.kernel.org/r/3018b189364a57a76fc70dcb477aa5f0da045b05.1765963770.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig           |    1 +
 arch/alpha/include/asm/tlb.h |    6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/arch/alpha/include/asm/tlb.h~alpha-mm-enable-mmu_gather_rcu_table_free
+++ a/arch/alpha/include/asm/tlb.h
@@ -4,7 +4,7 @@
 
 #include <asm-generic/tlb.h>
 
-#define __pte_free_tlb(tlb, pte, address)		pte_free((tlb)->mm, pte)
-#define __pmd_free_tlb(tlb, pmd, address)		pmd_free((tlb)->mm, pmd)
- 
+#define __pte_free_tlb(tlb, pte, address)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
+#define __pmd_free_tlb(tlb, pmd, address)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd))
+
 #endif
--- a/arch/alpha/Kconfig~alpha-mm-enable-mmu_gather_rcu_table_free
+++ a/arch/alpha/Kconfig
@@ -38,6 +38,7 @@ config ALPHA
 	select OLD_SIGSUSPEND
 	select CPU_NO_EFFICIENT_FFS if !ALPHA_EV67
 	select MMU_GATHER_NO_RANGE
+	select MMU_GATHER_RCU_TABLE_FREE
 	select SPARSEMEM_EXTREME if SPARSEMEM
 	select ZONE_DMA
 	help
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-change-mm-pt_reclaimc-to-use-asm-tlbh-instead-of-asm-generic-tlbh.patch
alpha-mm-enable-mmu_gather_rcu_table_free.patch
loongarch-mm-enable-mmu_gather_rcu_table_free.patch
mips-mm-enable-mmu_gather_rcu_table_free.patch
parisc-mm-enable-mmu_gather_rcu_table_free.patch
um-mm-enable-mmu_gather_rcu_table_free.patch
mm-make-pt_reclaim-depends-on-mmu_gather_rcu_table_free.patch

