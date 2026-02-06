Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21766313547
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421700; cv=none; b=TupGtI5GU5ZBRN2b5CVxLv6hmJqlpPIwifebTViw3c8/CNMgiM1EAfHHn2ed5z/W5MdXnNx7BUrxD2dkiKQigY71bOyAIdQjz0scW/lEpPDcJfnWZwnwr0pV4Hg5YuIHUMOdYVKE0CwYXitoUxEe7E+s5m0uHWG5S2yrRB633ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421700; c=relaxed/simple;
	bh=mQEspHsf8soizR/bHQVvvCkZKxlbMaQGwsAe7eYJpDw=;
	h=Date:To:From:Subject:Message-Id; b=ZOXNArzFTvjgpySa+C7MCPrM5+m5B+s/QdlaLhhZ3YKzsiHqYjIQhwor+Dz8OXXMQxbMslNM9y6yzKm+nRZ6MyJfeHfSDxMoIb4O8PcKMwYcI1NmTn5XooOFSc3j2DxlbNtuhqoKDclImUivVMnCfeYe/pth1wA+Dc/A9cuIuk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mgmQLQr+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mgmQLQr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6407C116C6;
	Fri,  6 Feb 2026 23:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421700;
	bh=mQEspHsf8soizR/bHQVvvCkZKxlbMaQGwsAe7eYJpDw=;
	h=Date:To:From:Subject:From;
	b=mgmQLQr+s9/ZqlXP8Ra/0lBKxwxAG3Q1t/ELz9d37ddPZ8Pw7naDzNJnnEy4T/EBS
	 McgRVE5N/trThns0oKC8zisxf6deCgXVVZQXsHCIauU9N13DI1yHTO0129LkN4sBEk
	 63ZZwP4Ox2C9C3au2JYtP9EBkXbQUmMU4cOiEVbA=
Date: Fri, 06 Feb 2026 15:48:19 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@kernel.org,surenb@google.com,rppt@kernel.org,richard.weiyang@gmail.com,richard@nod.at,richard.henderson@linaro.org,peterz@infradead.org,npiggin@gmail.com,mingo@redhat.com,mhocko@suse.com,mattst88@gmail.com,lorenzo.stoakes@oracle.com,linmag7@gmail.com,Liam.Howlett@oracle.com,kernel@xen0n.name,johannes@sipsolutions.net,James.Bottomley@HansenPartnership.com,ioworker0@gmail.com,hpa@zytor.com,dev.jain@arm.com,deller@gmx.de,david@kernel.org,dave.hansen@linux.intel.com,chenhuacai@kernel.org,bp@alien8.de,anton.ivanov@cambridgegreys.com,aneesh.kumar@kernel.org,andreas@gaisler.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] alpha-mm-enable-mmu_gather_rcu_table_free.patch removed from -mm tree
Message-Id: <20260206234819.E6407C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: alpha: mm: enable MMU_GATHER_RCU_TABLE_FREE
has been removed from the -mm tree.  Its filename was
     alpha-mm-enable-mmu_gather_rcu_table_free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: alpha: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Tue, 27 Jan 2026 20:12:55 +0800

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+).  To resolve this problem,
first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
PT_RECLAIM feature, which resolves this problem.

Link: https://lkml.kernel.org/r/3380f40a89b73c488202c85f9a8abf99fb08543b.1769515122.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Magnus Lindholm <linmag7@gmail.com>		[alpha]
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Helge Deller <deller@gmx.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Weinberger <richard@nod.at>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Wei Yang <richard.weiyang@gmail.com>
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


