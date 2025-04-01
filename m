Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3D321D585
	for <mm-commits@vger.kernel.org>; Tue,  1 Apr 2025 22:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545904; cv=none; b=dfq/j/O7pxREvoQTm6Awkpjr8GHvNh/Uz+ippDNX0SJkfhJrQlgwE39YQVoHgu09T92gc34S+1QHYV3nauDWtoVXhXAlk2ZvZsXDJpx5yRf8IKCV+RmhGNFpBqxOisYDRQ9ZgDjq+t6n+8rSFtrlV3jYD2q8xliB9Oy7s9m28nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545904; c=relaxed/simple;
	bh=ijriksgm0gE82IY3tjOyW9TUwVPb67qNDdmfj08AeZI=;
	h=Date:To:From:Subject:Message-Id; b=QzKy5ZXPSiTTwjHZrfNzp+pT/WcRMbvu0BX+AbGrROsrD4Rg7BVhNIabmm4h4JxTAZHTfZoEjHWFBq5kUx5+49T7OVvOEEpnikHx11tqbuLUy/6WkOtuFmJrdmJUDp0Ugod2E65VqDPgS5i1LoxaJ0thiw7sOxRqHhh62dtg1Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b6zp0+hs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b6zp0+hs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABCDC4CEE4;
	Tue,  1 Apr 2025 22:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1743545903;
	bh=ijriksgm0gE82IY3tjOyW9TUwVPb67qNDdmfj08AeZI=;
	h=Date:To:From:Subject:From;
	b=b6zp0+hsbq98MiHm2ymPmAkJFMAY75IcXj/N5RbWmmu7woVoKy3RKn3k6VuJK2+Xl
	 Kn+oqeGjXH5lqfUEZW7oNmKXcd2Nh9/7t82L1GBIPMG5YBMNwIIwHna+cTPcYkHkWf
	 B3HdJg/xdzeC2+TSIFQ5D9Rx8lN9yP7OZHZ0SKck=
Date: Tue, 01 Apr 2025 15:18:23 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,will@kernel.org,vishal.moola@gmail.com,rppt@kernel.org,riel@surriel.com,peterz@infradead.org,npiggin@gmail.com,muchun.song@linux.dev,kevin.brodsky@arm.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,arnd@arndb.de,aneesh.kumar@kernel.org,alexghiti@rivosinc.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-pgtable-remove-tlb_remove_page_ptdesc.patch removed from -mm tree
Message-Id: <20250401221823.9ABCDC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: pgtable: remove tlb_remove_page_ptdesc()
has been removed from the -mm tree.  Its filename was
     mm-pgtable-remove-tlb_remove_page_ptdesc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: pgtable: remove tlb_remove_page_ptdesc()
Date: Tue, 25 Feb 2025 11:45:56 +0800

The tlb_remove_ptdesc()/tlb_remove_table() is specially designed for page
table pages, and now all architectures have been converted to use it to
remove page table pages.  So let's remove tlb_remove_page_ptdesc(), it
currently has no users and should not be used for page table pages.

Link: https://lkml.kernel.org/r/3df04c8494339073b71be4acb2d92e108ecd1b60.1740454179.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Alexandre Ghiti <alexghiti@rivosinc.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Will Deacon <will@kernel.org>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/tlb.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/asm-generic/tlb.h~mm-pgtable-remove-tlb_remove_page_ptdesc
+++ a/include/asm-generic/tlb.h
@@ -498,12 +498,6 @@ static inline void tlb_remove_ptdesc(str
 	tlb_remove_table(tlb, pt);
 }
 
-/* Like tlb_remove_ptdesc, but for page-like page directories. */
-static inline void tlb_remove_page_ptdesc(struct mmu_gather *tlb, struct ptdesc *pt)
-{
-	tlb_remove_page(tlb, ptdesc_page(pt));
-}
-
 static inline void tlb_change_page_size(struct mmu_gather *tlb,
 						     unsigned int page_size)
 {
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


