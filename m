Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFD3231CB0
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837133; cv=none; b=PNJ9Vc3YMpxxBmbUePNRcJ9BlRaBlswUFgjEjpt2PowuFNrJCxkj7eUMZpRKFV8xAgQSRX3zYUvZ4o0FCtM34DseGvmnDBaoJ4AWtz5h8FRBc8bSutbvdP1lps2IB0gLbA2ZwU+Yhm1FIwunQG/gu09JMe6bcslfWLHDxUOfYRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837133; c=relaxed/simple;
	bh=JNZsFEajjW16cAmjO3SjPVCWvSxTV9d19MwEU81wnZo=;
	h=Date:To:From:Subject:Message-Id; b=hhTI4AFO7OK6eqYqHy9LZO5Jq4QMUauG1u597CRqM4XMWTjKSlEP2quBiBiD4n4e6XD8rTu+z1XtNqXTxK1U3COy0BVBCtZL4BYnR2Oe1DFNTdZ2OjuDB8YyDvlVpL3pYpBXHL3CYsnjPc22ZMwIs/ITraH1rBZ0ryLSECkrgWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WJg4idAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WJg4idAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CD5C4CEE5;
	Tue, 14 Jan 2025 06:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837132;
	bh=JNZsFEajjW16cAmjO3SjPVCWvSxTV9d19MwEU81wnZo=;
	h=Date:To:From:Subject:From;
	b=WJg4idACLWKpr94NfWI3psJtLQ6LAs4iteEkmV+lLhRzRTiBAVER7CHL8mhuCVvMJ
	 GcFy602PmBspwQqRoJ7ctrafMeEVU2RwNd2V2kc3n+ZQ9QIWPIxyFpwH5N1Fn96fb/
	 Svu/pzXyS3bTuGVu0hT5tCJMhzrCTvWwIaaYHY68=
Date: Mon, 13 Jan 2025 22:45:31 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,palmer@dabbelt.com,npiggin@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,andreas@gaisler.com,alexghiti@rivosinc.com,alex@ghiti.fr,agordeev@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pgtable-move-__tlb_remove_table_one-in-x86-to-generic-file.patch removed from -mm tree
Message-Id: <20250114064532.72CD5C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pgtable: move __tlb_remove_table_one() in x86 to generic file
has been removed from the -mm tree.  Its filename was
     mm-pgtable-move-__tlb_remove_table_one-in-x86-to-generic-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: move __tlb_remove_table_one() in x86 to generic file
Date: Wed, 8 Jan 2025 14:57:32 +0800

The __tlb_remove_table_one() in x86 does not contain architecture-specific
content, so move it to the generic file.

Link: https://lkml.kernel.org/r/aab8a449bc67167943fd2cb5aab0a3a23b7b1cd7.1736317725.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/tlb.h |   19 -------------------
 mm/mmu_gather.c            |   20 ++++++++++++++++++--
 2 files changed, 18 insertions(+), 21 deletions(-)

--- a/arch/x86/include/asm/tlb.h~mm-pgtable-move-__tlb_remove_table_one-in-x86-to-generic-file
+++ a/arch/x86/include/asm/tlb.h
@@ -20,25 +20,6 @@ static inline void tlb_flush(struct mmu_
 	flush_tlb_mm_range(tlb->mm, start, end, stride_shift, tlb->freed_tables);
 }
 
-#ifdef CONFIG_PT_RECLAIM
-static inline void __tlb_remove_table_one_rcu(struct rcu_head *head)
-{
-	struct ptdesc *ptdesc;
-
-	ptdesc = container_of(head, struct ptdesc, pt_rcu_head);
-	__tlb_remove_table(ptdesc);
-}
-
-static inline void __tlb_remove_table_one(void *table)
-{
-	struct ptdesc *ptdesc;
-
-	ptdesc = table;
-	call_rcu(&ptdesc->pt_rcu_head, __tlb_remove_table_one_rcu);
-}
-#define __tlb_remove_table_one __tlb_remove_table_one
-#endif /* CONFIG_PT_RECLAIM */
-
 static inline void invlpg(unsigned long addr)
 {
 	asm volatile("invlpg (%0)" ::"r" (addr) : "memory");
--- a/mm/mmu_gather.c~mm-pgtable-move-__tlb_remove_table_one-in-x86-to-generic-file
+++ a/mm/mmu_gather.c
@@ -311,13 +311,29 @@ static inline void tlb_table_invalidate(
 	}
 }
 
-#ifndef __tlb_remove_table_one
+#ifdef CONFIG_PT_RECLAIM
+static inline void __tlb_remove_table_one_rcu(struct rcu_head *head)
+{
+	struct ptdesc *ptdesc;
+
+	ptdesc = container_of(head, struct ptdesc, pt_rcu_head);
+	__tlb_remove_table(ptdesc);
+}
+
+static inline void __tlb_remove_table_one(void *table)
+{
+	struct ptdesc *ptdesc;
+
+	ptdesc = table;
+	call_rcu(&ptdesc->pt_rcu_head, __tlb_remove_table_one_rcu);
+}
+#else
 static inline void __tlb_remove_table_one(void *table)
 {
 	tlb_remove_table_sync_one();
 	__tlb_remove_table(table);
 }
-#endif
+#endif /* CONFIG_PT_RECLAIM */
 
 static void tlb_remove_table_one(void *table)
 {
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


