Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0386828E3
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628228; cv=none; b=BAY2vx1CxyNlVFiY1Xw7CCUTZKck1V+kzmJTBXQTBQCYvn7NsHHhs9YhYzdGiN+/IhVSYtBzJWtQR+3wov+XlQqGYqUBph47TBz5d6y/5rY0QkJoUgqNVeYlDUuCYQSDexgYzKwOlzpu6hO++0SfEEvKoc3AjpN45+BjJ9T+s2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628228; c=relaxed/simple;
	bh=AF9OLYSimOZyePUCWqj7FJyAkYiVmgRe8w9jp1gJyD0=;
	h=Date:To:From:Subject:Message-Id; b=GGr/XqW26grTD1SihErV6OZ0yIVC4mFuLU7WR5PFQOH/6KO96LnXll8hyEuz/sIzWb4JfHadaMPH/5mHjuwsnrNgwuGquvvpLUI8UB2zd4mn8kiJaWiRkoSsdkojtvyIHgW1JE9+grCcyoLb8cZVdohFDzJRjWc+z4ZWAet7SkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZMp17uZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZMp17uZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E26FC32781;
	Sat, 29 Jun 2024 02:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628227;
	bh=AF9OLYSimOZyePUCWqj7FJyAkYiVmgRe8w9jp1gJyD0=;
	h=Date:To:From:Subject:From;
	b=ZMp17uZE63PEqBZd6qwiuSX4YXVlp1wOGDyxpVscj0oKmOkmE+cgQYw3qAfT42hVa
	 QisPo8cH3/AyjEymq87LEcGVuKdT/qWN/xutQ5eH4q5IId0jI8qYVj5xPPhdXd9TTG
	 lZnN6EvwYcH0rz4SBoGOybxyQDClUH+nU7OmnieQ=
Date: Fri, 28 Jun 2024 19:30:27 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-use-folio-in-struct-copy_subpage_arg.patch removed from -mm tree
Message-Id: <20240629023027.7E26FC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory: use folio in struct copy_subpage_arg
has been removed from the -mm tree.  Its filename was
     mm-memory-use-folio-in-struct-copy_subpage_arg.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: use folio in struct copy_subpage_arg
Date: Tue, 18 Jun 2024 17:12:40 +0800

Directly use folio in struct copy_subpage_arg.

Link: https://lkml.kernel.org/r/20240618091242.2140164-3-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/memory.c~mm-memory-use-folio-in-struct-copy_subpage_arg
+++ a/mm/memory.c
@@ -6500,16 +6500,16 @@ static int copy_user_gigantic_page(struc
 }
 
 struct copy_subpage_arg {
-	struct page *dst;
-	struct page *src;
+	struct folio *dst;
+	struct folio *src;
 	struct vm_area_struct *vma;
 };
 
 static int copy_subpage(unsigned long addr, int idx, void *arg)
 {
 	struct copy_subpage_arg *copy_arg = arg;
-	struct page *dst = nth_page(copy_arg->dst, idx);
-	struct page *src = nth_page(copy_arg->src, idx);
+	struct page *dst = folio_page(copy_arg->dst, idx);
+	struct page *src = folio_page(copy_arg->src, idx);
 
 	if (copy_mc_user_highpage(dst, src, addr, copy_arg->vma)) {
 		memory_failure_queue(page_to_pfn(src), 0);
@@ -6525,8 +6525,8 @@ int copy_user_large_folio(struct folio *
 	unsigned long addr = addr_hint &
 		~(((unsigned long)pages_per_huge_page << PAGE_SHIFT) - 1);
 	struct copy_subpage_arg arg = {
-		.dst = &dst->page,
-		.src = &src->page,
+		.dst = dst,
+		.src = src,
 		.vma = vma,
 	};
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch

