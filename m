Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8CA30F52F
	for <mm-commits@vger.kernel.org>; Fri,  6 Feb 2026 23:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770421706; cv=none; b=SXea0ve2DzEAFwmGqlVSM/WW4OM8np3Cc9N2vJieBFOBxQ9XLo786cHoQNDN9V3JwSuXp3r1170+DqQruJvIAPXO+mFXjvH1RgKF7OqU3ugv9EzSJM5A76Eik9+95/oejwSnkMogmuB3W4Sppsi9GACXvgh5EYXaBmZRVekc7c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770421706; c=relaxed/simple;
	bh=aX4xFhOSwnoSfNZmfo4GmrqwJ5tDbRBITZA2BpY2Mdo=;
	h=Date:To:From:Subject:Message-Id; b=NMf2M6rF3BC/VRv518S7m18caj0x3mDhiZk79qlijjomCYhDPdIQ+wcN38bfHEsk6CMwzAnzEg4afnvLdMGSHe1dkitM3q8e5XCjl7lVIf2yojjIWdm5FLLk7K86IceiGqXpYNjqydNq+0zBlc2etAuni4dxuQ764wXqd9zF384=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KpopqNm4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KpopqNm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D16C116C6;
	Fri,  6 Feb 2026 23:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770421705;
	bh=aX4xFhOSwnoSfNZmfo4GmrqwJ5tDbRBITZA2BpY2Mdo=;
	h=Date:To:From:Subject:From;
	b=KpopqNm4PVOFg/xabc1zoPuH8GuYVaHG9jxrz5pvLcQzf8q/+sOjhoeX7gwtlxg+M
	 A7oZ2tN5AkT3Zy9FoEv4Yd5XlFmQfDoc+W5guhyHgNep+pSlEAn9kVDe5gJqiJVjd0
	 o6h4pE1h5xPwdU2os6XCYVAHeLMEqM94zXbjz448=
Date: Fri, 06 Feb 2026 15:48:25 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,vbabka@suse.cz,tsbogend@alpha.franken.de,tglx@kernel.org,surenb@google.com,rppt@kernel.org,richard.weiyang@gmail.com,richard@nod.at,richard.henderson@linaro.org,peterz@infradead.org,npiggin@gmail.com,mingo@redhat.com,mhocko@suse.com,mattst88@gmail.com,lorenzo.stoakes@oracle.com,linmag7@gmail.com,Liam.Howlett@oracle.com,kernel@xen0n.name,johannes@sipsolutions.net,James.Bottomley@HansenPartnership.com,ioworker0@gmail.com,hpa@zytor.com,dev.jain@arm.com,deller@gmx.de,david@kernel.org,dave.hansen@linux.intel.com,chenhuacai@kernel.org,bp@alien8.de,anton.ivanov@cambridgegreys.com,aneesh.kumar@kernel.org,andreas@gaisler.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] parisc-mm-enable-mmu_gather_rcu_table_free.patch removed from -mm tree
Message-Id: <20260206234825.B2D16C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: parisc: mm: enable MMU_GATHER_RCU_TABLE_FREE
has been removed from the -mm tree.  Its filename was
     parisc-mm-enable-mmu_gather_rcu_table_free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: parisc: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Tue, 27 Jan 2026 20:12:58 +0800

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+).  To resolve this problem,
first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
PT_RECLAIM feature, which resolves this problem.

Link: https://lkml.kernel.org/r/b827939046dbc94bc7c585cdbed8522baab75b15.1769515122.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Magnus Lindholm <linmag7@gmail.com>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Henderson <richard.henderson@linaro.org>
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

 arch/parisc/Kconfig           |    1 +
 arch/parisc/include/asm/tlb.h |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/parisc/include/asm/tlb.h~parisc-mm-enable-mmu_gather_rcu_table_free
+++ a/arch/parisc/include/asm/tlb.h
@@ -5,8 +5,8 @@
 #include <asm-generic/tlb.h>
 
 #if CONFIG_PGTABLE_LEVELS == 3
-#define __pmd_free_tlb(tlb, pmd, addr)	pmd_free((tlb)->mm, pmd)
+#define __pmd_free_tlb(tlb, pmd, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd))
 #endif
-#define __pte_free_tlb(tlb, pte, addr)	pte_free((tlb)->mm, pte)
+#define __pte_free_tlb(tlb, pte, addr)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #endif
--- a/arch/parisc/Kconfig~parisc-mm-enable-mmu_gather_rcu_table_free
+++ a/arch/parisc/Kconfig
@@ -79,6 +79,7 @@ config PARISC
 	select GENERIC_CLOCKEVENTS
 	select CPU_NO_EFFICIENT_FFS
 	select THREAD_INFO_IN_TASK
+	select MMU_GATHER_RCU_TABLE_FREE
 	select NEED_DMA_MAP_STATE
 	select NEED_SG_DMA_LENGTH
 	select HAVE_ARCH_KGDB
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


