Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D6D8633C;
	Thu, 19 Dec 2024 03:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734577522; cv=none; b=J1sQIsJJeOHLGDvcpzP4X4bWaKO8SA2KLbw3RpFmK26S1G0qJH7e/zdeLoJCyph7WJVBOHm3z3+rLaeF3PhNcuURKVM4nFk2O/8blUZIbirjt/jl5e5PbwsQ7vVdNKRrz0OoyNOfyDyE65h2/7T8BXoFzzz5XrT9pOttTAoqSmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734577522; c=relaxed/simple;
	bh=/OHIEGSTfZf+A9eEjJGxmnCCH1I/TKJHqY4khua7/08=;
	h=Date:To:From:Subject:Message-Id; b=bR0jOyO3Wwg9flN0UYZYTWgvXOuyAB9R0wBoX47jgR73nVbtqmGTakhxZ/MoGX4xEC/QxAa89qr9SZCi5LcT2gxjMoUK9UFpTSL3lQzT8zX2DGsHveQoQRp4203ygZ6+v1BKHh2m1BTMVraQFT+wbKgYg3yOKtogG313QaZD6Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jcpAx41A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jcpAx41A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DC2C4CED4;
	Thu, 19 Dec 2024 03:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734577521;
	bh=/OHIEGSTfZf+A9eEjJGxmnCCH1I/TKJHqY4khua7/08=;
	h=Date:To:From:Subject:From;
	b=jcpAx41Ao2BMVUrrKOfOOpTdtmaJ+yUBSIigxAVfzlhPTE3zKiSznyxvjurXzi3O7
	 HTdmYc7hEBfy5525KIyP/zg6A8Ds9xZW6vRzkUE8aVwrgKeKRXZ4x0EaOU2+N+2G/A
	 do14Ok6em7YeupU+LRElkQLstMMAVkPSKQhND2Fs=
Date: Wed, 18 Dec 2024 19:05:21 -0800
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,stable@vger.kernel.org,muchun.song@linux.dev,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-use-aligned-address-in-clear_gigantic_page.patch removed from -mm tree
Message-Id: <20241219030521.92DC2C4CED4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: use aligned address in clear_gigantic_page()
has been removed from the -mm tree.  Its filename was
     mm-use-aligned-address-in-clear_gigantic_page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: use aligned address in clear_gigantic_page()
Date: Mon, 28 Oct 2024 22:56:55 +0800

In current kernel, hugetlb_no_page() calls folio_zero_user() with the
fault address.  Where the fault address may be not aligned with the huge
page size.  Then, folio_zero_user() may call clear_gigantic_page() with
the address, while clear_gigantic_page() requires the address to be huge
page size aligned.  So, this may cause memory corruption or information
leak, addtional, use more obvious naming 'addr_hint' instead of 'addr' for
clear_gigantic_page().

Link: https://lkml.kernel.org/r/20241028145656.932941-1-wangkefeng.wang@huawei.com
Fixes: 78fefd04c123 ("mm: memory: convert clear_huge_page() to folio_zero_user()")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 mm/memory.c          |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~mm-use-aligned-address-in-clear_gigantic_page
+++ a/fs/hugetlbfs/inode.c
@@ -825,7 +825,7 @@ static long hugetlbfs_fallocate(struct f
 			error = PTR_ERR(folio);
 			goto out;
 		}
-		folio_zero_user(folio, ALIGN_DOWN(addr, hpage_size));
+		folio_zero_user(folio, addr);
 		__folio_mark_uptodate(folio);
 		error = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (unlikely(error)) {
--- a/mm/memory.c~mm-use-aligned-address-in-clear_gigantic_page
+++ a/mm/memory.c
@@ -6815,9 +6815,10 @@ static inline int process_huge_page(
 	return 0;
 }
 
-static void clear_gigantic_page(struct folio *folio, unsigned long addr,
+static void clear_gigantic_page(struct folio *folio, unsigned long addr_hint,
 				unsigned int nr_pages)
 {
+	unsigned long addr = ALIGN_DOWN(addr_hint, folio_size(folio));
 	int i;
 
 	might_sleep();
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-dont-try-thp-align-for-fs-without-get_unmapped_area.patch

