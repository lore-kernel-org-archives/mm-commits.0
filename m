Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D5F2E3399;
	Sat, 22 Mar 2025 05:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742619855; cv=none; b=UvahWKDVN3f1U1/yKm8//0+kn2xrlLkUlQ0q4/8G7qUEqVFA/wfFjI8qOIaD8wsuaKvvEOShqgZQ3LEV181F0vn/G6j/T6DX1bMOicOe3ezx0388tYLVoMWDeyoG7zysivZKUrMbTG0UoNmg6W3v+9cvNL8Sv+QuFWIvnEtAFv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742619855; c=relaxed/simple;
	bh=t5l8FCsLU4Kcl4/gGy5xCbTw+b4105DY5SJP8PlAZdM=;
	h=Date:To:From:Subject:Message-Id; b=h8osh/LBChXUyne+zje40A1O9usqMcGTYA2jeRONc4zb2Gh4pkN1aJbobg/k6T87ocn6jGCATZ4Eukg1CqKJA8O3t30J2n149xGUkYqGKY/MoW8RoEwLhT8ZrJk89AifONYRKWJFIFOvuXYt7OZ8b8F+29uXmx/c5jig3w3uIpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zSY8aTYo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zSY8aTYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD2EC4CEDD;
	Sat, 22 Mar 2025 05:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742619855;
	bh=t5l8FCsLU4Kcl4/gGy5xCbTw+b4105DY5SJP8PlAZdM=;
	h=Date:To:From:Subject:From;
	b=zSY8aTYoICM1vCdJ7CueU510hzfuy1JH9wpmSlohyhuy0uj4XaGjQ6h1ufn9zmPCW
	 EQQ9beOlGI+IQ4GE0O+LMxqMQn8QpVKLYTDxsPo3aBffyCcjrrfdMGsry55sF7pDqb
	 pqKbhRcWjAaeqD42veLd7LrN2OAnl7wYTyejxOWs=
Date: Fri, 21 Mar 2025 22:04:14 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,kernel.org,stable@vger,nao.horiguchi@gmail.com,linmiaohe@huawei.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-introduce-folio_contain_hwpoisoned_page-helper.patch removed from -mm tree
Message-Id: <20250322050415.3DD2EC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hwpoison: introduce folio_contain_hwpoisoned_page() helper
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-introduce-folio_contain_hwpoisoned_page-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/hwpoison: introduce folio_contain_hwpoisoned_page() helper
Date: Tue, 18 Mar 2025 16:39:38 +0800

Patch series "mm/vmscan: don't try to reclaim hwpoison folio".

Fix a bug during memory reclaim if folio is hwpoisoned.


This patch (of 2):

Introduce helper folio_contain_hwpoisoned_page() to check if the entire
folio is hwpoisoned or it contains hwpoisoned pages.

Link: https://lkml.kernel.org/r/20250318083939.987651-1-tujinjiang@huawei.com
Link: https://lkml.kernel.org/r/20250318083939.987651-2-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: <stable@vger,kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    6 ++++++
 mm/memory_hotplug.c        |    3 +--
 mm/shmem.c                 |    3 +--
 3 files changed, 8 insertions(+), 4 deletions(-)

--- a/include/linux/page-flags.h~mm-hwpoison-introduce-folio_contain_hwpoisoned_page-helper
+++ a/include/linux/page-flags.h
@@ -1098,6 +1098,12 @@ static inline bool is_page_hwpoison(cons
 	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
 }
 
+static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
+{
+	return folio_test_hwpoison(folio) ||
+	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
+}
+
 bool is_free_buddy_page(const struct page *page);
 
 PAGEFLAG(Isolated, isolated, PF_ANY);
--- a/mm/memory_hotplug.c~mm-hwpoison-introduce-folio_contain_hwpoisoned_page-helper
+++ a/mm/memory_hotplug.c
@@ -1828,8 +1828,7 @@ static void do_migrate_range(unsigned lo
 		if (unlikely(page_folio(page) != folio))
 			goto put_folio;
 
-		if (folio_test_hwpoison(folio) ||
-		    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))) {
+		if (folio_contain_hwpoisoned_page(folio)) {
 			if (WARN_ON(folio_test_lru(folio)))
 				folio_isolate_lru(folio);
 			if (folio_mapped(folio)) {
--- a/mm/shmem.c~mm-hwpoison-introduce-folio_contain_hwpoisoned_page-helper
+++ a/mm/shmem.c
@@ -3290,8 +3290,7 @@ shmem_write_begin(struct file *file, str
 	if (ret)
 		return ret;
 
-	if (folio_test_hwpoison(folio) ||
-	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio))) {
+	if (folio_contain_hwpoisoned_page(folio)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		return -EIO;
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-contig_alloc-fix-alloc_contig_range-when-__gfp_comp-and-order-max_order.patch

