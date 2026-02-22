Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4C5B352F87
	for <mm-commits@vger.kernel.org>; Sun, 22 Feb 2026 19:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771789391; cv=none; b=RhfMD39SUR4zZ2ibnkYuKDdlO3HdkGfMSxLzNewV46SUfTUPHvy+XbPKFuRTSRfYLyMgmQKgC2leZgM22av22L4ZyCF8QdBenLyv50ZE6RZeHZBVI9VJFGaqrEteT98JBdorTYVUb0y6StzREo4HhjsDMOgP9JqqQSS9JT0i50A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771789391; c=relaxed/simple;
	bh=iqXU5txLi8TVPpNXU++6/Hk27mZ7Lmt+4sJx8pbc4Ec=;
	h=Date:To:From:Subject:Message-Id; b=GXHTu3hIIH7w2/c3OV2FVaSfD9PdO3fQSijAGgesLRnXAfy6hXUsdRqsoJOG7D46HRy2FBjNeU7898Ut73ZBynPm1lfRkEyUQCbSTR2EulEg+zEAl1nSEcS0fYbMRfSQ3j6Usb5ze+layPHI6ab51D5B1MiSRXadZ4bto05LjNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u4ngmQAA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u4ngmQAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DAEC116D0;
	Sun, 22 Feb 2026 19:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771789390;
	bh=iqXU5txLi8TVPpNXU++6/Hk27mZ7Lmt+4sJx8pbc4Ec=;
	h=Date:To:From:Subject:From;
	b=u4ngmQAAMsYBsX1tWW/GT5D7KIMmH7YjTALbXkWgPu85/1t21r2PJHKXJwV404jYf
	 1W2dzb2tDzJZsr0WahA+v+zwXCZkN2WBGRpOFbS4t+wS+QUkLgiw7yGxTW6Zbl3It/
	 KvnJfV1K7QMZlziz2KDPcXS6WXEJ8wD0F32I3qps=
Date: Sun, 22 Feb 2026 11:43:09 -0800
To: mm-commits@vger.kernel.org,will@kernel.org,qi.zheng@linux.dev,peterz@infradead.org,npiggin@gmail.com,david@kernel.org,aneesh.kumar@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mmu_gather-define-rcu-version-tlb_remove_table_one-in-config_mmu_gather_rcu_table_free.patch added to mm-new branch
Message-Id: <20260222194310.76DAEC116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mmu_gather: define RCU version tlb_remove_table_one() in CONFIG_MMU_GATHER_RCU_TABLE_FREE
has been added to the -mm mm-new branch.  Its filename is
     mm-mmu_gather-define-rcu-version-tlb_remove_table_one-in-config_mmu_gather_rcu_table_free.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mmu_gather-define-rcu-version-tlb_remove_table_one-in-config_mmu_gather_rcu_table_free.patch

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

This patch moves the definition of single table freeing in
CONFIG_MMU_GATHER_RCU_TABLE_FREE, so we have both RCU version batch/single
table freeing if CONFIG_MMU_GATHER_RCU_TABLE_FREE.

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

mm-mmu_gather-define-rcu-version-tlb_remove_table_one-in-config_mmu_gather_rcu_table_free.patch

