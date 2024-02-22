Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D699290E
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560066; cv=none; b=cx88J6RUMSxBmH7qs+R68iA6KMCPGMmukvtM9a/oLQ9sSJoVQqZMIyzK/Pe9QDDTCFQ9XMFtJAQ0HsE3MXbu4EKGLGO0VW3t8etGun9jkj1KcM/V1YtVn7pTKIgFatMfxTtsRElynrQlkHGJmjCxpGAaJSqMFI9qnE+rOwy6z+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560066; c=relaxed/simple;
	bh=jFlJIovL2/K2HaZQkxNnD55teKeBaH/CnalEy+svm9A=;
	h=Date:To:From:Subject:Message-Id; b=oMmr3w1sJpgN8xtUeDHFS6ktMdeF/dQOzr4cN5NuG5F4J9a7PMQSrB9wTpMKFRRz8TEHRyM7ziP1786pLzVxp6Ll8KJ3+ZaO+FuWzK5VZCrIolwD0a+ZXjpa9t09QPof+9j/jcfZ1yCzXQ2RTKPOkDxEbnnwYEUzInQXfQaDsHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1kheuH1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1kheuH1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E2FC43394;
	Thu, 22 Feb 2024 00:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560066;
	bh=jFlJIovL2/K2HaZQkxNnD55teKeBaH/CnalEy+svm9A=;
	h=Date:To:From:Subject:From;
	b=1kheuH1TqFTgApdkhwTjTDRmK1p65MzTgHdeUJ+p6RZFijLeTqzeHqkDpDbTsChw8
	 4uFc2VN+3kQUwXuw0iVtQSyhGaNyi2Pr0mkXbdg+4JPRBtIXvX2/8Q3528IIyi+iCO
	 ll5k7Hq4+3j9rAzcmPYXuPKzgOk6pl4d4XAhCs74=
Date: Wed, 21 Feb 2024 16:01:05 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-use-nth_page-in-clear-copy_subpage.patch removed from -mm tree
Message-Id: <20240222000106.58E2FC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory: use nth_page() in clear/copy_subpage()
has been removed from the -mm tree.  Its filename was
     mm-memory-use-nth_page-in-clear-copy_subpage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: use nth_page() in clear/copy_subpage()
Date: Fri, 29 Dec 2023 16:22:07 +0800

The clear and copy of huge gigantic page has converted to use nth_page()
to handle the possible discontinuous struct page(SPARSEMEM without
VMEMMAP), but not change for the non-gigantic part, fix it too.

Link: https://lkml.kernel.org/r/20231229082207.60235-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/memory.c~mm-memory-use-nth_page-in-clear-copy_subpage
+++ a/mm/memory.c
@@ -6163,7 +6163,7 @@ static int clear_subpage(unsigned long a
 {
 	struct page *page = arg;
 
-	clear_user_highpage(page + idx, addr);
+	clear_user_highpage(nth_page(page, idx), addr);
 	return 0;
 }
 
@@ -6213,10 +6213,11 @@ struct copy_subpage_arg {
 static int copy_subpage(unsigned long addr, int idx, void *arg)
 {
 	struct copy_subpage_arg *copy_arg = arg;
+	struct page *dst = nth_page(copy_arg->dst, idx);
+	struct page *src = nth_page(copy_arg->src, idx);
 
-	if (copy_mc_user_highpage(copy_arg->dst + idx, copy_arg->src + idx,
-				  addr, copy_arg->vma)) {
-		memory_failure_queue(page_to_pfn(copy_arg->src + idx), 0);
+	if (copy_mc_user_highpage(dst, src, addr, copy_arg->vma)) {
+		memory_failure_queue(page_to_pfn(src), 0);
 		return -EHWPOISON;
 	}
 	return 0;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-compaction-early-termination-in-compact_nodes.patch

