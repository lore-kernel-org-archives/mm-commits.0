Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3DB21578B
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188282; cv=none; b=PZH5MB9t0TdsuNNDhdzER89216QGUR26VEXEGtjvsu9REoosIYve5IBLI6s6rQi/EA/rw0eOQH9CTQ/nhbVRO/zkELddpuGSfMpdfow8DOZnMhIxFg4FrsrcvQDUvCwrS/UHJ7XW/HRaZPcBddvN3Ewn5eCU2VwJL9AzcAawruY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188282; c=relaxed/simple;
	bh=q827WodItOH+PPd7vWC5gGFlQr6HBzgbJZgOl7jKxGo=;
	h=Date:To:From:Subject:Message-Id; b=jf2hYFlhLRtUiEg6C4iW5YeiTv3SdZeQtUHztnvmOtK/2ZVPni016T9RyfA5viG0TcC0J9eTXCyAW0b2VJShi/P+pwjVY63333WvYpC/KmKLkeSvkSyqP+rd3uS9OwPdfBP1ItFWj2K9DOG20NlRi5eWeBcw6eQFXJ92ZSMnJRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WVASz8/F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WVASz8/F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CECC4CEEC;
	Mon, 17 Mar 2025 05:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188281;
	bh=q827WodItOH+PPd7vWC5gGFlQr6HBzgbJZgOl7jKxGo=;
	h=Date:To:From:Subject:From;
	b=WVASz8/FbJVn1QrcFBH4pcYP/+KO1KIniIHC+jcAX0EEmhkRe6I1Q+ZevbgeYdEgN
	 PJznjKDkc7VESaqVtLTNt4y3aE2LDTcqC60qX15Ey/nRaOQ/yYJOqr4BEOnxLa/Gvx
	 JvRY1GRdBYsCOBSFYJHKGh4c3qV8Lbv692TmUmyA=
Date: Sun, 16 Mar 2025 22:11:21 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,will@kernel.org,peterz@infradead.org,npiggin@gmail.com,aneesh.kumar@kernel.org,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mmu_gather-remove-unused-__tlb_remove_page.patch removed from -mm tree
Message-Id: <20250317051121.84CECC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mmu_gather: remove unused __tlb_remove_page()
has been removed from the -mm tree.  Its filename was
     mm-mmu_gather-remove-unused-__tlb_remove_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/mmu_gather: remove unused __tlb_remove_page()
Date: Tue, 11 Feb 2025 18:13:39 +0800

Nobody is using __tlb_remove_page() now, clean it up.

And also remove the code comment above tlb_remove_page() because it's not
meaningful any more.

Link: https://lkml.kernel.org/r/Z6si0/A/zzEF/bFJ@MiWiFi-R3L-srv
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |   10 ----------
 1 file changed, 10 deletions(-)

--- a/include/asm-generic/tlb.h~mm-mmu_gather-remove-unused-__tlb_remove_page
+++ a/include/asm-generic/tlb.h
@@ -489,16 +489,6 @@ static inline void tlb_remove_page_size(
 		tlb_flush_mmu(tlb);
 }
 
-static __always_inline bool __tlb_remove_page(struct mmu_gather *tlb,
-		struct page *page, bool delay_rmap)
-{
-	return __tlb_remove_page_size(tlb, page, delay_rmap, PAGE_SIZE);
-}
-
-/* tlb_remove_page
- *	Similar to __tlb_remove_page but will call tlb_flush_mmu() itself when
- *	required.
- */
 static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
 {
 	return tlb_remove_page_size(tlb, page, PAGE_SIZE);
_

Patches currently in -mm which might be from bhe@redhat.com are


