Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB74B125DB;
	Fri, 26 Jan 2024 07:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706255693; cv=none; b=ZAYi8gVUaFTpvJQYRO+YPOXSyzAkQJnYxZw/9l/SuNwLmWEyEvvjKgyyBRvKPK9Knl+URUwCPDdTVkBei+NF703f6g4DkSwyTfYg5s7bFvtA7ktfaWmUYkJihAvQj2x5SplTRRZpwr4pKcRnZWz0HhluR4D/wISWz861gMHhMqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706255693; c=relaxed/simple;
	bh=MJSGM7A/KIuGUOsWYbsWQtkX5KkTHNXkKabPAiRps0A=;
	h=Date:To:From:Subject:Message-Id; b=Lqbt0F2DrXhjlMPPfM4/TksqccUwBNzLBXKXrPoaG8rLH3RZAiEBsQAnqEmZH4fTjbQDfH6i3I8rgM+8t1w4iJvKAjaTjgpZfB8730eZ5DRyqHyrWhXg2athkBohzIfu/RGi+bR7cxFpKkU2VFdz268nduK6T5eY4FwP4rEbkmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I0BX1JL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I0BX1JL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406AFC433C7;
	Fri, 26 Jan 2024 07:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706255692;
	bh=MJSGM7A/KIuGUOsWYbsWQtkX5KkTHNXkKabPAiRps0A=;
	h=Date:To:From:Subject:From;
	b=I0BX1JL9/lloGVI0+P9EKSZ4ZMYuN5Dqz2ZXpS/KPJPwo9Gg+vu1R1QmCuCFAIS1B
	 PgkkVhXbrKKiXADCNkicEZXbxAAvuo0M12qqUs/jBgphdzDUDoHADUGGpb25U3WUfx
	 zGq44b3yf/enNiTgxhoqjbYzLZ1ZlqPZZm68dsyI=
Date: Thu, 25 Jan 2024 23:54:49 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,usama.anjum@collabora.com,stable@vger.kernel.org,naoya.horiguchi@nec.com,muchun.song@linux.dev,linmiaohe@huawei.com,jthoughton@google.com,jiaqiyan@google.com,sidhartha.kumar@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-hugetlbfs-inodec-mm-memory-failurec-fix-hugetlbfs-hwpoison-handling.patch removed from -mm tree
Message-Id: <20240126075452.406AFC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/hugetlbfs/inode.c: mm/memory-failure.c: fix hugetlbfs hwpoison handling
has been removed from the -mm tree.  Its filename was
     fs-hugetlbfs-inodec-mm-memory-failurec-fix-hugetlbfs-hwpoison-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Subject: fs/hugetlbfs/inode.c: mm/memory-failure.c: fix hugetlbfs hwpoison handling
Date: Fri, 12 Jan 2024 10:08:40 -0800

has_extra_refcount() makes the assumption that the page cache adds a ref
count of 1 and subtracts this in the extra_pins case.  Commit a08c7193e4f1
(mm/filemap: remove hugetlb special casing in filemap.c) modifies
__filemap_add_folio() by calling folio_ref_add(folio, nr); for all cases
(including hugtetlb) where nr is the number of pages in the folio.  We
should adjust the number of references coming from the page cache by
subtracing the number of pages rather than 1.

In hugetlbfs_read_iter(), folio_test_has_hwpoisoned() is testing the wrong
flag as, in the hugetlb case, memory-failure code calls
folio_test_set_hwpoison() to indicate poison.  folio_test_hwpoison() is
the correct function to test for that flag.

After these fixes, the hugetlb hwpoison read selftest passes all cases.

Link: https://lkml.kernel.org/r/20240112180840.367006-1-sidhartha.kumar@oracle.com
Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Closes: https://lore.kernel.org/linux-mm/20230713001833.3778937-1-jiaqiyan@google.com/T/#m8e1469119e5b831bbd05d495f96b842e4a1c5519
Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: James Houghton <jthoughton@google.com>
Cc: Jiaqi Yan <jiaqiyan@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>	[6.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 mm/memory-failure.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/hugetlbfs/inode.c~fs-hugetlbfs-inodec-mm-memory-failurec-fix-hugetlbfs-hwpoison-handling
+++ a/fs/hugetlbfs/inode.c
@@ -340,7 +340,7 @@ static ssize_t hugetlbfs_read_iter(struc
 		} else {
 			folio_unlock(folio);
 
-			if (!folio_test_has_hwpoisoned(folio))
+			if (!folio_test_hwpoison(folio))
 				want = nr;
 			else {
 				/*
--- a/mm/memory-failure.c~fs-hugetlbfs-inodec-mm-memory-failurec-fix-hugetlbfs-hwpoison-handling
+++ a/mm/memory-failure.c
@@ -982,7 +982,7 @@ static bool has_extra_refcount(struct pa
 	int count = page_count(p) - 1;
 
 	if (extra_pins)
-		count -= 1;
+		count -= folio_nr_pages(page_folio(p));
 
 	if (count > 0) {
 		pr_err("%#lx: %s still referenced by %d users\n",
_

Patches currently in -mm which might be from sidhartha.kumar@oracle.com are

maple_tree-fix-comment-describing-mas_node_count_gfp.patch

