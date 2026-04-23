Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909FA386C0D
	for <mm-commits@vger.kernel.org>; Thu, 23 Apr 2026 18:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776970315; cv=none; b=UzpkjS1UgQzdUstK1QkmGp6XzyNEHogjNNGzLCXZrkeutwbJxYJz6mWiYYFvnAd78sw88BpxGErR1lznVyUtc6W5iWuxKxjoJfW5V4TCIrryP5/gwXIWUse5L0S3BHReymdQ3MYImd5rqECxEuuAc0hMOrgWB5XcPP2A5jpH3o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776970315; c=relaxed/simple;
	bh=4ccwX8hqDRMW1HEuyW/UJaesNW+8MPPdtfG19QmbkPg=;
	h=Date:To:From:Subject:Message-Id; b=bsmF/TMRuiiaR4veTwwSGVYAr5vPlyIdLc8z7beGojRQg1Fn+trostEqqKSRzGMAh+sB/uxpFCzqHJ70aUuaM+CrnTFDhhccYi9bgP739YUw4fQoiuK8xMNtQGNPE6l4BM4xVhZ0ej3E31xogRt18Uhavbf08UmIRpsA4UOZt9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Sl42LyvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Sl42LyvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55248C2BCB2;
	Thu, 23 Apr 2026 18:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776970315;
	bh=4ccwX8hqDRMW1HEuyW/UJaesNW+8MPPdtfG19QmbkPg=;
	h=Date:To:From:Subject:From;
	b=Sl42LyvGUdU6c+e4qmxvxC0WTztmWy7rArV6z45c+qGRkpPpryWjjQrcQUjLY6tjY
	 G8DoK/9s2MWM++f1a8SdWvLtIq4Nmw3nfNeJgAFIdjYLKh7Bi3qTVg5E2p08Zh9ze1
	 xoSHHDx0UUBZPBZLQSTSvQmUFEX+E2I6Nkw/IOew=
Date: Thu, 23 Apr 2026 11:51:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ypodemsk@redhat.com,will@kernel.org,tglx@linutronix.de,shy828301@gmail.com,seanjc@google.com,ryan.roberts@arm.com,riel@surriel.com,peterz@infradead.org,pbonzini@redhat.com,npiggin@gmail.com,npache@redhat.com,mingo@redhat.com,ljs@kernel.org,liam@infradead.org,jgross@suse.com,jannh@google.com,hughd@google.com,hpa@zytor.com,dev.jain@arm.com,david@kernel.org,dave.hansen@intel.com,bp@alien8.de,boris.ostrovsky@oracle.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,arnd@arndb.de,aneesh.kumar@kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-tlb-skip-redundant-sync-ipis-for-native-tlb-flush.patch added to mm-new branch
Message-Id: <20260423185155.55248C2BCB2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/tlb: skip redundant sync IPIs for native TLB flush
has been added to the -mm mm-new branch.  Its filename is
     x86-tlb-skip-redundant-sync-ipis-for-native-tlb-flush.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-tlb-skip-redundant-sync-ipis-for-native-tlb-flush.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Lance Yang <lance.yang@linux.dev>
Subject: x86/tlb: skip redundant sync IPIs for native TLB flush
Date: Mon, 20 Apr 2026 11:08:51 +0800

Some page table operations need to synchronize with software/lockless
walkers after a TLB flush by calling tlb_remove_table_sync_{one,rcu}(). 
On x86, that extra synchronization is redundant when the preceding TLB
flush already broadcast IPIs to all relevant CPUs.

native_pv_tlb_init() checks whether native_flush_tlb_multi() is in use. 
On CONFIG_PARAVIRT systems, it checks pv_ops; on non-PARAVIRT, native
flush is always in use.

It decides once at boot whether to enable the optimization: if using
native TLB flush and INVLPGB is not supported, we know IPIs were sent and
can skip the redundant sync.  The decision is fixed via a static key as
Peter suggested[1].

PV backends (KVM, Xen, Hyper-V) typically have their own implementations
and don't call native_flush_tlb_multi() directly, so they cannot be
trusted to provide the IPI guarantees we need.

Also treat unshared_tables like freed_tables when issuing the TLB flush,
so lazy-TLB CPUs receive IPIs during unsharing of page tables as well. 
This allows us to safely implement
tlb_table_flush_implies_ipi_broadcast().

Two-step plan as David suggested[2]:

Step 1 (this patch): Skip redundant sync when we're 100% certain the TLB
flush sent IPIs. INVLPGB is excluded because when supported, we cannot
guarantee IPIs were sent, keeping it clean and simple.

Step 2 (future work): Send targeted IPIs only to CPUs actually doing
software/lockless page table walks, benefiting all architectures.

Regarding Step 2, it obviously only applies to setups where Step 1 does
not apply: like x86 with INVLPGB or arm64.

Link: https://lore.kernel.org/20260420030851.6735-3-lance.yang@linux.dev
Link: https://lore.kernel.org/linux-mm/20260302145652.GH1395266@noisy.programming.kicks-ass.net/ [1]
Link: https://lore.kernel.org/linux-mm/bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org/ [2]
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Juegren Gross <jgross@suse.com>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yair Podemsky <ypodemsk@redhat.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/tlb.h      |   18 +++++++++++++++++-
 arch/x86/include/asm/tlbflush.h |    2 ++
 arch/x86/kernel/smpboot.c       |    1 +
 arch/x86/mm/tlb.c               |   15 +++++++++++++++
 4 files changed, 35 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/tlbflush.h~x86-tlb-skip-redundant-sync-ipis-for-native-tlb-flush
+++ a/arch/x86/include/asm/tlbflush.h
@@ -18,6 +18,8 @@
 
 DECLARE_PER_CPU(u64, tlbstate_untag_mask);
 
+void __init native_pv_tlb_init(void);
+
 void __flush_tlb_all(void);
 
 #define TLB_FLUSH_ALL	-1UL
--- a/arch/x86/include/asm/tlb.h~x86-tlb-skip-redundant-sync-ipis-for-native-tlb-flush
+++ a/arch/x86/include/asm/tlb.h
@@ -5,11 +5,21 @@
 #define tlb_flush tlb_flush
 static inline void tlb_flush(struct mmu_gather *tlb);
 
+#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void);
+
 #include <asm-generic/tlb.h>
 #include <linux/kernel.h>
 #include <vdso/bits.h>
 #include <vdso/page.h>
 
+DECLARE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+	return static_branch_likely(&tlb_ipi_broadcast_key);
+}
+
 static inline void tlb_flush(struct mmu_gather *tlb)
 {
 	unsigned long start = 0UL, end = TLB_FLUSH_ALL;
@@ -20,7 +30,13 @@ static inline void tlb_flush(struct mmu_
 		end = tlb->end;
 	}
 
-	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
+	/*
+	 * Treat unshared_tables just like freed_tables, such that lazy-TLB
+	 * CPUs also receive IPIs during unsharing of page tables, allowing
+	 * us to safely implement tlb_table_flush_implies_ipi_broadcast().
+	 */
+	flush_tlb_mm_range(tlb->mm, start, end, stride_shift,
+			   tlb->freed_tables || tlb->unshared_tables);
 }
 
 static inline void invlpg(unsigned long addr)
--- a/arch/x86/kernel/smpboot.c~x86-tlb-skip-redundant-sync-ipis-for-native-tlb-flush
+++ a/arch/x86/kernel/smpboot.c
@@ -1256,6 +1256,7 @@ void __init native_smp_prepare_boot_cpu(
 		switch_gdt_and_percpu_base(me);
 
 	native_pv_lock_init();
+	native_pv_tlb_init();
 }
 
 void __init native_smp_cpus_done(unsigned int max_cpus)
--- a/arch/x86/mm/tlb.c~x86-tlb-skip-redundant-sync-ipis-for-native-tlb-flush
+++ a/arch/x86/mm/tlb.c
@@ -26,6 +26,8 @@
 
 #include "mm_internal.h"
 
+DEFINE_STATIC_KEY_FALSE(tlb_ipi_broadcast_key);
+
 #ifdef CONFIG_PARAVIRT
 # define STATIC_NOPV
 #else
@@ -1813,3 +1815,16 @@ static int __init create_tlb_single_page
 	return 0;
 }
 late_initcall(create_tlb_single_page_flush_ceiling);
+
+void __init native_pv_tlb_init(void)
+{
+#ifdef CONFIG_PARAVIRT
+	if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
+		return;
+#endif
+
+	if (cpu_feature_enabled(X86_FEATURE_INVLPGB))
+		return;
+
+	static_branch_enable(&tlb_ipi_broadcast_key);
+}
_

Patches currently in -mm which might be from lance.yang@linux.dev are

mm-mmu_gather-prepare-to-skip-redundant-sync-ipis.patch
x86-tlb-skip-redundant-sync-ipis-for-native-tlb-flush.patch

