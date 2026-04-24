Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A050A223DCE
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 09:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777023510; cv=none; b=auDl95yS+bBp6bj19VRobBLka5fwZPH44JbC7iY+Gq25GIKTS/3OgG1sHkly8ncPk4Ubp/KUF2JL5q7G9bXSKhtkK9v92gkOc10tM5swUtKz4kICXe4qOsU8iHn8djVB5I3ExHOWesh2zNSSsEE7inmVmZVDqk9AV8YCgWdf3/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777023510; c=relaxed/simple;
	bh=qk5Z4II17iKoSjZKW0kwGy6j7wgcliSjFpdHezK/tbo=;
	h=Date:To:From:Subject:Message-Id; b=ZF/yI5mSrX4SCoAGlzyfVSw30MUg8dqq3Zag9mh4RKUrsgmUpYjpPuadDtv9/mGK6kbAg/rXiy+lQFxe9FsjapydiQEpdDQ26Wc+yt7cTcQB+4kKFJMnMbvssMvwLBOAWEdwK0cXdLZC7P+a9uWy5td24ky7DIArFWIbo4pEv8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FWwVpwhb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FWwVpwhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423D7C19425;
	Fri, 24 Apr 2026 09:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777023510;
	bh=qk5Z4II17iKoSjZKW0kwGy6j7wgcliSjFpdHezK/tbo=;
	h=Date:To:From:Subject:From;
	b=FWwVpwhboGHrQeJPX0+huOzOvDhA4+W0wGd61xDJweAnLngVQ308zOw7LFkBxj2uD
	 Duw8G+CkUmrqEDdMNCXwYIKdaAIK/mZ7VU4aF7dS4IVL3JZBbTULGZXdPE8ucoLBN/
	 EMyN1Z0uLIxElQ49Q1zlnkdP1miVT55KKP6xhxjk=
Date: Fri, 24 Apr 2026 02:38:29 -0700
To: mm-commits@vger.kernel.org,lance.yang@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mmu_gather-prepare-to-skip-redundant-sync-ipis.patch removed from -mm tree
Message-Id: <20260424093830.423D7C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmu_gather: prepare to skip redundant sync IPIs
has been removed from the -mm tree.  Its filename was
     mm-mmu_gather-prepare-to-skip-redundant-sync-ipis.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Lance Yang <lance.yang@linux.dev>
Subject: mm/mmu_gather: prepare to skip redundant sync IPIs
Date: Mon, 20 Apr 2026 11:08:50 +0800

Patch series "skip redundant sync IPIs when TLB flush sent them", v9.

When page table operations require synchronization with software/lockless
walkers, they call tlb_remove_table_sync_{one,rcu}() after flushing the
TLB (tlb->freed_tables or tlb->unshared_tables).

On architectures where the TLB flush already sends IPIs to all target
CPUs, the subsequent sync IPI broadcast is redundant.  This is not only
costly on large systems where it disrupts all CPUs even for single-process
page table operations, but has also been reported to hurt RT workloads[1].

This series introduces tlb_table_flush_implies_ipi_broadcast() to check if
the prior TLB flush already provided the necessary synchronization.  When
true, the sync calls can early-return.

A few cases rely on this synchronization:

1) hugetlb PMD unshare[2]: The problem is not the freeing but the reuse
   of the PMD table for other purposes in the last remaining user after
   unsharing.

2) khugepaged collapse[3]: Ensure no concurrent GUP-fast before collapsing
   and (possibly) freeing the page table / re-depositing it.

Two-step plan as David suggested[4]:

Step 1 (this series): Skip redundant sync when we're 100% certain the TLB
flush sent IPIs. INVLPGB is excluded because when supported, we cannot
guarantee IPIs were sent, keeping it clean and simple.

Step 2 (future work): Send targeted IPIs only to CPUs actually doing
software/lockless page table walks, benefiting all architectures.

Regarding Step 2, it obviously only applies to setups where Step 1 does not
apply: like x86 with INVLPGB or arm64. Step 2 work is ongoing; early
attempts showed ~3% GUP-fast overhead. Reducing the overhead requires more
work and tuning; it will be submitted separately once ready.

On a 64-core Intel x86 server, the CAL interrupt count in
/proc/interrupts dropped from 646,316 to 785 when collapsing a 20 GiB
range with this series applied.

David Hildenbrand did the initial implementation. I built on his work and
relied on off-list discussions to push it further - thanks a lot David!


This patch (of 2):

When page table operations require synchronization with software/lockless
walkers, they call tlb_remove_table_sync_{one,rcu}() after flushing the
TLB (tlb->freed_tables or tlb->unshared_tables).

On architectures where the TLB flush already sends IPIs to all target
CPUs, the subsequent sync IPI broadcast is redundant.  This is not only
costly on large systems where it disrupts all CPUs even for single-process
page table operations, but has also been reported to hurt RT workloads[5].

Introduce tlb_table_flush_implies_ipi_broadcast() to check if the prior
TLB flush already provided the necessary synchronization.  When true, the
sync calls can early-return.

A few cases rely on this synchronization:

1) hugetlb PMD unshare[6]: The problem is not the freeing but the reuse
   of the PMD table for other purposes in the last remaining user after
   unsharing.

2) khugepaged collapse[7]: Ensure no concurrent GUP-fast before collapsing
   and (possibly) freeing the page table / re-depositing it.

Currently always returns false (no behavior change). The follow-up patch
will enable the optimization for x86.

Link: https://lore.kernel.org/20260420030851.6735-1-lance.yang@linux.dev
Link: https://lore.kernel.org/20260420030851.6735-2-lance.yang@linux.dev
Link: https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/ [1]
Link: https://lore.kernel.org/linux-mm/6a364356-5fea-4a6c-b959-ba3b22ce9c88@kernel.org/ [2]
Link: https://lore.kernel.org/linux-mm/2cb4503d-3a3f-4f6c-8038-7b3d1c74b3c2@kernel.org/ [3]
Link: https://lore.kernel.org/linux-mm/bbfdf226-4660-4949-b17b-0d209ee4ef8c@kernel.org/ [4]
Link: https://lore.kernel.org/linux-mm/1b27a3fa-359a-43d0-bdeb-c31341749367@kernel.org/ [5]
Link: https://lore.kernel.org/linux-mm/6a364356-5fea-4a6c-b959-ba3b22ce9c88@kernel.org/ [6]
Link: https://lore.kernel.org/linux-mm/2cb4503d-3a3f-4f6c-8038-7b3d1c74b3c2@kernel.org/ [7]
Signed-off-by: Lance Yang <lance.yang@linux.dev>
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
Cc: Peter Zijlstra <peterz@infradead.org>
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

 include/asm-generic/tlb.h |   17 +++++++++++++++++
 mm/mmu_gather.c           |   15 +++++++++++++++
 2 files changed, 32 insertions(+)

--- a/include/asm-generic/tlb.h~mm-mmu_gather-prepare-to-skip-redundant-sync-ipis
+++ a/include/asm-generic/tlb.h
@@ -240,6 +240,23 @@ static inline void tlb_remove_table(stru
 }
 #endif /* CONFIG_MMU_GATHER_TABLE_FREE */
 
+/**
+ * tlb_table_flush_implies_ipi_broadcast - does TLB flush imply IPI sync
+ *
+ * When page table operations require synchronization with software/lockless
+ * walkers, they flush the TLB (tlb->freed_tables or tlb->unshared_tables)
+ * then call tlb_remove_table_sync_{one,rcu}(). If the flush already sent
+ * IPIs to all CPUs, the sync call is redundant.
+ *
+ * Returns false by default. Architectures can override by defining this.
+ */
+#ifndef tlb_table_flush_implies_ipi_broadcast
+static inline bool tlb_table_flush_implies_ipi_broadcast(void)
+{
+	return false;
+}
+#endif
+
 #ifdef CONFIG_MMU_GATHER_RCU_TABLE_FREE
 /*
  * This allows an architecture that does not use the linux page-tables for
--- a/mm/mmu_gather.c~mm-mmu_gather-prepare-to-skip-redundant-sync-ipis
+++ a/mm/mmu_gather.c
@@ -283,6 +283,14 @@ void tlb_remove_table_sync_one(void)
 	 * It is however sufficient for software page-table walkers that rely on
 	 * IRQ disabling.
 	 */
+
+	/*
+	 * Skip IPI if the preceding TLB flush already synchronized with
+	 * all CPUs that could be doing software/lockless page table walks.
+	 */
+	if (tlb_table_flush_implies_ipi_broadcast())
+		return;
+
 	smp_call_function(tlb_remove_table_smp_sync, NULL, 1);
 }
 
@@ -312,6 +320,13 @@ static void tlb_remove_table_free(struct
  */
 void tlb_remove_table_sync_rcu(void)
 {
+	/*
+	 * Skip RCU wait if the preceding TLB flush already synchronized
+	 * with all CPUs that could be doing software/lockless page table walks.
+	 */
+	if (tlb_table_flush_implies_ipi_broadcast())
+		return;
+
 	synchronize_rcu();
 }
 
_

Patches currently in -mm which might be from lance.yang@linux.dev are

x86-tlb-skip-redundant-sync-ipis-for-native-tlb-flush.patch

