Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD0F23C6EA
	for <mm-commits@vger.kernel.org>; Tue, 14 Jan 2025 06:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736837006; cv=none; b=EY+TUg9JLM2SF7JQo7oE8ZrB3Nb17tGb0wjCB6zxvk+qM2yec2ro8snQEdOIT9VYS7cUkml3VSt4r6hiPJSZyyJ/+T6LcGzIO5XzbyFDNje9LmSl0ad0FE+mxxS2QwRAuy7ottGGrhjT2V1zaqv4rx/+9VgMnp3pZ6R0BHhiRZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736837006; c=relaxed/simple;
	bh=aCEfXpsl+DRbeIVVNdTxqfG8ETUDGvu5IZx8e9Sl7tM=;
	h=Date:To:From:Subject:Message-Id; b=OHLyTVhL+PGkZdmh0X2ceT68w0+PJcnvxmGuC6PI0SRV6om+Z7nIbeN1YwBpNSOt8PphZgYIFbdc/+wIeS9fzzfnYD/pk1bN0ArRxwbNpmWn+nofv1KDXy0q/gF42YJnPahoCQccaiuGmbrCvbY9eA6z1qyHY3eqd3b4VfW+DvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CvPj3b+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CvPj3b+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CD1C4CEDD;
	Tue, 14 Jan 2025 06:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736837006;
	bh=aCEfXpsl+DRbeIVVNdTxqfG8ETUDGvu5IZx8e9Sl7tM=;
	h=Date:To:From:Subject:From;
	b=CvPj3b+4Vp4nlvXuB069X+gnVfnqMaK2nz+g/M/awnnoXNqQhsV9Z+nrBoZuouUVo
	 xm0y+ILMX62i/2RkeMEkC6B8Jz+2UnIPeGTQSe6TNXkbDeV7QqWtY7jEZr3orvcG3S
	 zatmtYgIcARHfl+eg3oUfE4dHpG0ss/6+c9lI6HQ=
Date: Mon, 13 Jan 2025 22:43:25 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,willy@infradead.org,will@kernel.org,rientjes@google.com,peterz@infradead.org,peterx@redhat.com,muchun.song@linux.dev,mgorman@suse.de,luto@kernel.org,lorenzo.stoakes@oracle.com,jannh@google.com,hughd@google.com,david@redhat.com,dave.hansen@linux.intel.com,dan.carpenter@linaro.org,catalin.marinas@arm.com,zhengqi.arch@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-make-zap_pte_range-handle-full-within-pmd-range.patch removed from -mm tree
Message-Id: <20250114064326.16CD1C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: make zap_pte_range() handle full within-PMD range
has been removed from the -mm tree.  Its filename was
     mm-make-zap_pte_range-handle-full-within-pmd-range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm: make zap_pte_range() handle full within-PMD range
Date: Wed, 4 Dec 2024 19:09:48 +0800

In preparation for reclaiming empty PTE pages, this commit first makes
zap_pte_range() to handle the full within-PMD range, so that we can more
easily detect and free PTE pages in this function in subsequent commits.

Link: https://lkml.kernel.org/r/76c95ee641da7808cd66d642ab95841df4048295.1733305182.git.zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Jann Horn <jannh@google.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memory.c~mm-make-zap_pte_range-handle-full-within-pmd-range
+++ a/mm/memory.c
@@ -1718,6 +1718,7 @@ static unsigned long zap_pte_range(struc
 	pte_t *pte;
 	int nr;
 
+retry:
 	tlb_change_page_size(tlb, PAGE_SIZE);
 	init_rss_vec(rss);
 	start_pte = pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
@@ -1757,6 +1758,13 @@ static unsigned long zap_pte_range(struc
 	if (force_flush)
 		tlb_flush_mmu(tlb);
 
+	if (addr != end) {
+		cond_resched();
+		force_flush = false;
+		force_break = false;
+		goto retry;
+	}
+
 	return addr;
 }
 
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


