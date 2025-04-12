Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E9B134D4
	for <mm-commits@vger.kernel.org>; Sat, 12 Apr 2025 00:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744418001; cv=none; b=DJIqQUyTYCG3eLYFZNj2juqXWzEZ764g7kBPqYXRjRzUS/yopq/xHChDd81mzIU+PIbBdis3/zDg2QjRJj0lVsr4vaeVAsV4eKxEQfhY+X7Oy1VCzGPrwOnsgzUyeyCfLAoRyjWAqJ7NboBrY4rC/ZNPBz9W5xtwfORbUUbQFnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744418001; c=relaxed/simple;
	bh=+Ap5m09SdZztj5Eys1HCGCZ7FHQNtLQ9iu1u65DXWr0=;
	h=Date:To:From:Subject:Message-Id; b=N/ezpPnl7bQApgorbtI79rLwnoDs/ZTPHj41byttQed42qxbsFl4OadVUBMM/gRDwplYbWMfNEp3kKEyjxTGhBUpgchVffH0+fgqBJh5AgWScubpTQeKl5hz7TuEQ0fxpRJ0GIhhyvbVNzB0p8zrOtp6oxTBvaDvcQscxtXmMmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bqkIyeHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bqkIyeHW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C0BC4CEE2;
	Sat, 12 Apr 2025 00:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744418001;
	bh=+Ap5m09SdZztj5Eys1HCGCZ7FHQNtLQ9iu1u65DXWr0=;
	h=Date:To:From:Subject:From;
	b=bqkIyeHWv9LV7IErWzwcfRn9gXg3hACGTJBJXRGSCHFv7xgREggY8H3nGhQkj4kVb
	 Jg4sHyqrpPLE4uHgGIzHhXgHppqREsknAdNgbVa/HiAkGh4giddM5ob/SikPL4xjEV
	 RECOSqW0cYguuRQ5dO57i5aRg8KB+SSEiJFtOY3k=
Date: Fri, 11 Apr 2025 17:33:20 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-hugetlb-fix-nid-mismatch-in-alloc_surplus_hugetlb_folio.patch removed from -mm tree
Message-Id: <20250412003321.24C0BC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: fix nid mismatch in alloc_surplus_hugetlb_folio()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-nid-mismatch-in-alloc_surplus_hugetlb_folio.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/hugetlb: fix nid mismatch in alloc_surplus_hugetlb_folio()
Date: Thu, 3 Apr 2025 14:41:38 +0800

It's wrong to use nid directly since the nid may be changed in allocation.
Use folio_nid() to obtain the nid of folio instead.

Fix: 2273dea6b1e1 ("mm/hugetlb: update nr_huge_pages and surplus_huge_pages together")
Link: https://lkml.kernel.org/r/20250403064138.2867929-1-liushixin2@huawei.com
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-nid-mismatch-in-alloc_surplus_hugetlb_folio
+++ a/mm/hugetlb.c
@@ -2271,7 +2271,7 @@ static struct folio *alloc_surplus_huget
 	 * as surplus_pages, otherwise it might confuse
 	 * persistent_huge_pages() momentarily.
 	 */
-	__prep_account_new_huge_page(h, nid);
+	__prep_account_new_huge_page(h, folio_nid(folio));
 
 	/*
 	 * We could have raced with the pool size change.
_

Patches currently in -mm which might be from liushixin2@huawei.com are


