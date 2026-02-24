Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAB9B67A
	for <mm-commits@vger.kernel.org>; Tue, 24 Feb 2026 04:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771907498; cv=none; b=BS7banRwLXEVjMEIa8HLMKAuGHcke2IKBNlEFxtBW/9OK59MnUJCAFQHiA3SaDg3WRtclM95JenvFJ9aLk4sy0MeqR7XmNtgw7pznexmKXqGBtbj2QAgNL/3pXHS6lzVqyPXQtVNnda8hyuo0cH+7oDktphG6nJ36skpypEJLIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771907498; c=relaxed/simple;
	bh=EQqMJLMbiZ4XCI5JpSkbxVfESZJmWhLSzPDMhluiVGQ=;
	h=Date:To:From:Subject:Message-Id; b=hOCuiZejUtwN5+yW/eZ6oFhDkVmGxRvMzejJyF5Hw/NngvMAC1ZJ4SHeZCpUhpKlUOltj23S4Fv6x4/XMMIDYdhFvLdqeN5HK1ylnZOmCz2iSVfSu2BG2rMHcWVu/FQacZY8Egnzl8w4RqWsukXOcc1mFjIupbnTlRXHJQOk4j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I2F2a3rN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I2F2a3rN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56C3C116D0;
	Tue, 24 Feb 2026 04:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771907497;
	bh=EQqMJLMbiZ4XCI5JpSkbxVfESZJmWhLSzPDMhluiVGQ=;
	h=Date:To:From:Subject:From;
	b=I2F2a3rNgrjIjNb+M5KObnEplYrFz0nBWXgOxIfZn33RS0Qbj1t/eXXDOe4i7D35T
	 8D0kuO6BuO/iq260jpxCwagiYHPAZYvpeJ9FAxTsF1XdC/zfcBk28GUnBkftafqvWJ
	 BOnBDv3UFytWvKR/B/LEUxouIQ341OFf0vq/MzvE=
Date: Mon, 23 Feb 2026 20:31:37 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,qi.zheng@linux.dev,peterz@infradead.org,npiggin@gmail.com,david@kernel.org,aneesh.kumar@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [withdrawn] mm-mmu_gather-define-rcu-version-tlb_remove_table_one-in-config_mmu_gather_rcu_table_free.patch removed from -mm tree
Message-Id: <20260224043137.C56C3C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmu_gather: define RCU version tlb_remove_table_one() in CONFIG_MMU_GATHER_RCU_TABLE_FREE
has been removed from the -mm tree.  Its filename was
     mm-mmu_gather-define-rcu-version-tlb_remove_table_one-in-config_mmu_gather_rcu_table_free.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/mmu_gather: define RCU version tlb_remove_table_one() in CONFIG_MMU_GATHER_RCU_TABLE_FREE
Date: Sun, 22 Feb 2026 00:45:12 +0000

Before commit 718b13861d22 ("x86: mm: free page table pages by RCU instead
of semi RCU"), the page table pages will be freed by semi RCU, that is:

  - batch table freeing: asynchronous free by RCU
  - single table freeing: IPI + synchronous free

This commit introduce a RCU version for single table freeing to support
PT_RECLAIM.  While it is not necessary to limit the RCU version only in
CONFIG_PT_RECLAIM.  It is reasonable to asynchronous free single table by
RCU if CONFIG_MMU_GATHER_RCU_TABLE_FREE.

This cleanup patch moves the definition of single table freeing in
CONFIG_MMU_GATHER_RCU_TABLE_FREE, so we have both RCU version
batch/single table freeing if CONFIG_MMU_GATHER_RCU_TABLE_FREE.

Link: https://lkml.kernel.org/r/20260222004512.839-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_gather.c |   51 +++++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 29 deletions(-)

--- a/mm/mmu_gather.c~mm-mmu_gather-define-rcu-version-tlb_remove_table_one-in-config_mmu_gather_rcu_table_free
+++ a/mm/mmu_gather.c
@@ -296,6 +296,22 @@ static void tlb_remove_table_free(struct
 	call_rcu(&batch->rcu, tlb_remove_table_rcu);
 }
 
+static inline void __tlb_remove_table_one_rcu(struct rcu_head *head)
+{
+	struct ptdesc *ptdesc;
+
+	ptdesc = container_of(head, struct ptdesc, pt_rcu_head);
+	__tlb_remove_table(ptdesc);
+}
+
+static inline void tlb_remove_table_one(void *table)
+{
+	struct ptdesc *ptdesc;
+
+	ptdesc = table;
+	call_rcu(&ptdesc->pt_rcu_head, __tlb_remove_table_one_rcu);
+}
+
 #else /* !CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 static void tlb_remove_table_free(struct mmu_table_batch *batch)
@@ -303,6 +319,12 @@ static void tlb_remove_table_free(struct
 	__tlb_remove_table_free(batch);
 }
 
+static inline void tlb_remove_table_one(void *table)
+{
+	tlb_remove_table_sync_one();
+	__tlb_remove_table(table);
+}
+
 #endif /* CONFIG_MMU_GATHER_RCU_TABLE_FREE */
 
 /*
@@ -320,35 +342,6 @@ static inline void tlb_table_invalidate(
 	}
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
-#else
-static inline void __tlb_remove_table_one(void *table)
-{
-	tlb_remove_table_sync_one();
-	__tlb_remove_table(table);
-}
-#endif /* CONFIG_PT_RECLAIM */
-
-static void tlb_remove_table_one(void *table)
-{
-	__tlb_remove_table_one(table);
-}
-
 static void tlb_table_flush(struct mmu_gather *tlb)
 {
 	struct mmu_table_batch **batch = &tlb->batch;
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


