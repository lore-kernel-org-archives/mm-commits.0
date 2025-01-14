Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A2F23353A
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837134; cv=none; b=Fkr1FZ/9M/BRx3wP2I+F7vLIK8rQgi4krwBspD+6wkEfRLmSdx92jyI+0MmeAEPKb/wNVVkucXeIAnREuIG1kL28CojEIe15FsmcdaEEfU/dP3Hc88sJx7GJvC9FqT8LNAiradQ2p/PcXH644oNoejmBewHCsD5O/MfzuJtxil4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837134; c=relaxed/simple;
	bh=7H9vevQhpjlG2150w1DAG3n9jSA6CWsleU9gkpPD3DA=;
	h=Date:To:From:Subject:Message-Id; b=fJ0t3BlQZPfXpFP+O36ezK+4d7DTe3SPXVRn1kV6jkwW8azmIi+EL/NE5qt8fV5MLOvkRp7qDucHGClLcU29sbfGlDVCv7/52Gt+tpBAqLhqiSQ1jbByQjEe9bXk/6nY0jwoa8ypvVGZQWB/NfTpLVEO02RHlo+ctPmRYLkrfkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BTQB3NTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BTQB3NTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A70C4CEDD;
	Tue, 14 Jan 2025 06:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837134;
	bh=7H9vevQhpjlG2150w1DAG3n9jSA6CWsleU9gkpPD3DA=;
	h=Date:To:From:Subject:From;
	b=BTQB3NTp5/SgW+NogaiERUDBxvyGM1bLPGSivRenhc9GAGNQGjDNuC/sphh1GFyyS
	 wRkfDpU9SpzR5RH1CsHKJhuMx3Iz0Uudav+w5kA6KwqsPwz6sriGdYKTcQmyKsJEx5
	 ij+fgayjfT8Lck7N9s7WA8YsNNS3D+/n8HSn8AqA=
Date: Mon, 13 Jan 2025 22:45:33 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,rientjes@google.com,peterz@infradead.org,palmer@dabbelt.com,npiggin@gmail.com,muchun.song@linux.dev,lorenzo.stoakes@oracle.com,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,andreas@gaisler.com,alexghiti@rivosinc.com,alex@ghiti.fr,agordeev@linux.ibm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pgtable-introduce-generic-pagetable_dtor_free.patch removed from -mm tree
Message-Id: <20250114064534.11A70C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pgtable: introduce generic pagetable_dtor_free()
has been removed from the -mm tree.  Its filename was
     mm-pgtable-introduce-generic-pagetable_dtor_free.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: introduce generic pagetable_dtor_free()
Date: Wed, 8 Jan 2025 14:57:33 +0800

The pte_free(), pmd_free(), __pud_free() and __p4d_free() in
asm-generic/pgalloc.h and the generic __tlb_remove_table() are basically
the same, so let's introduce pagetable_dtor_free() to deduplicate them.

In addition, the pagetable_dtor_free() in s390 does the same thing, so
let's s390 also calls generic pagetable_dtor_free().

Link: https://lkml.kernel.org/r/1663a0565aca881d1338ceb7d1db4aa9c333abd6.1736317725.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>	[s390]
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
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/pgalloc.c        |    6 ------
 include/asm-generic/pgalloc.h |   12 ++++--------
 include/asm-generic/tlb.h     |    3 +--
 include/linux/mm.h            |    6 ++++++
 4 files changed, 11 insertions(+), 16 deletions(-)

--- a/arch/s390/mm/pgalloc.c~mm-pgtable-introduce-generic-pagetable_dtor_free
+++ a/arch/s390/mm/pgalloc.c
@@ -180,12 +180,6 @@ unsigned long *page_table_alloc(struct m
 	return table;
 }
 
-static void pagetable_dtor_free(struct ptdesc *ptdesc)
-{
-	pagetable_dtor(ptdesc);
-	pagetable_free(ptdesc);
-}
-
 void page_table_free(struct mm_struct *mm, unsigned long *table)
 {
 	struct ptdesc *ptdesc = virt_to_ptdesc(table);
--- a/include/asm-generic/pgalloc.h~mm-pgtable-introduce-generic-pagetable_dtor_free
+++ a/include/asm-generic/pgalloc.h
@@ -109,8 +109,7 @@ static inline void pte_free(struct mm_st
 {
 	struct ptdesc *ptdesc = page_ptdesc(pte_page);
 
-	pagetable_dtor(ptdesc);
-	pagetable_free(ptdesc);
+	pagetable_dtor_free(ptdesc);
 }
 
 
@@ -153,8 +152,7 @@ static inline void pmd_free(struct mm_st
 	struct ptdesc *ptdesc = virt_to_ptdesc(pmd);
 
 	BUG_ON((unsigned long)pmd & (PAGE_SIZE-1));
-	pagetable_dtor(ptdesc);
-	pagetable_free(ptdesc);
+	pagetable_dtor_free(ptdesc);
 }
 #endif
 
@@ -202,8 +200,7 @@ static inline void __pud_free(struct mm_
 	struct ptdesc *ptdesc = virt_to_ptdesc(pud);
 
 	BUG_ON((unsigned long)pud & (PAGE_SIZE-1));
-	pagetable_dtor(ptdesc);
-	pagetable_free(ptdesc);
+	pagetable_dtor_free(ptdesc);
 }
 
 #ifndef __HAVE_ARCH_PUD_FREE
@@ -248,8 +245,7 @@ static inline void __p4d_free(struct mm_
 	struct ptdesc *ptdesc = virt_to_ptdesc(p4d);
 
 	BUG_ON((unsigned long)p4d & (PAGE_SIZE-1));
-	pagetable_dtor(ptdesc);
-	pagetable_free(ptdesc);
+	pagetable_dtor_free(ptdesc);
 }
 
 #ifndef __HAVE_ARCH_P4D_FREE
--- a/include/asm-generic/tlb.h~mm-pgtable-introduce-generic-pagetable_dtor_free
+++ a/include/asm-generic/tlb.h
@@ -213,8 +213,7 @@ static inline void __tlb_remove_table(vo
 {
 	struct ptdesc *ptdesc = (struct ptdesc *)table;
 
-	pagetable_dtor(ptdesc);
-	pagetable_free(ptdesc);
+	pagetable_dtor_free(ptdesc);
 }
 #endif
 
--- a/include/linux/mm.h~mm-pgtable-introduce-generic-pagetable_dtor_free
+++ a/include/linux/mm.h
@@ -3001,6 +3001,12 @@ static inline void pagetable_dtor(struct
 	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
 }
 
+static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
+{
+	pagetable_dtor(ptdesc);
+	pagetable_free(ptdesc);
+}
+
 static inline bool pagetable_pte_ctor(struct ptdesc *ptdesc)
 {
 	struct folio *folio = ptdesc_folio(ptdesc);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


