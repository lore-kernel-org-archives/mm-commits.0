Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DA280028
	for <mm-commits@vger.kernel.org>; Tue, 12 Dec 2023 18:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vCrh56ab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024C7C433C7;
	Tue, 12 Dec 2023 18:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702407592;
	bh=08QIn7Z/qbEX+Povzc1OAxfZlj6V7xA9VZH8ggCxeWs=;
	h=Date:To:From:Subject:From;
	b=vCrh56abPsg4XU508KpCwtX4ptSH+pGeTeCVTpXkzZzzEOLtUH2JRfkHOunaipqiO
	 axbO9CWjUBX1G+H1KIGX52UrBT8ZBi5vUlGf4lg6DJeCXmKQYOqaNs6W+ILUPXwNJY
	 x9A6CVFschhnFpxXVfTKEgVrxbSh2eqtt3tzkCfE=
Date: Tue, 12 Dec 2023 10:59:51 -0800
To: mm-commits@vger.kernel.org,mike.kravetz@oracle.com,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-move-mmap-lock-to-vmemmap_remap_range.patch removed from -mm tree
Message-Id: <20231212185952.024C7C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: move mmap lock to vmemmap_remap_range()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-move-mmap-lock-to-vmemmap_remap_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: move mmap lock to vmemmap_remap_range()
Date: Tue, 5 Dec 2023 11:08:53 +0800

All the users of vmemmap_remap_range() will hold the mmap lock and release
it once it returns, it is naturally to move the lock to
vmemmap_remap_range() to simplify the code and the users.

Link: https://lkml.kernel.org/r/20231205030853.3921-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |   17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-move-mmap-lock-to-vmemmap_remap_range
+++ a/mm/hugetlb_vmemmap.c
@@ -163,8 +163,10 @@ static int vmemmap_remap_range(unsigned
 
 	VM_BUG_ON(!PAGE_ALIGNED(start | end));
 
+	mmap_read_lock(&init_mm);
 	ret = walk_page_range_novma(&init_mm, start, end, &vmemmap_remap_ops,
 				    NULL, walk);
+	mmap_read_unlock(&init_mm);
 	if (ret)
 		return ret;
 
@@ -282,7 +284,6 @@ static void vmemmap_restore_pte(pte_t *p
 static int vmemmap_remap_split(unsigned long start, unsigned long end,
 			       unsigned long reuse)
 {
-	int ret;
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= NULL,
 		.flags		= VMEMMAP_SPLIT_NO_TLB_FLUSH,
@@ -291,11 +292,7 @@ static int vmemmap_remap_split(unsigned
 	/* See the comment in the vmemmap_remap_free(). */
 	BUG_ON(start - reuse != PAGE_SIZE);
 
-	mmap_read_lock(&init_mm);
-	ret = vmemmap_remap_range(reuse, end, &walk);
-	mmap_read_unlock(&init_mm);
-
-	return ret;
+	return vmemmap_remap_range(reuse, end, &walk);
 }
 
 /**
@@ -358,7 +355,6 @@ static int vmemmap_remap_free(unsigned l
 	 */
 	BUG_ON(start - reuse != PAGE_SIZE);
 
-	mmap_read_lock(&init_mm);
 	ret = vmemmap_remap_range(reuse, end, &walk);
 	if (ret && walk.nr_walked) {
 		end = reuse + walk.nr_walked * PAGE_SIZE;
@@ -377,7 +373,6 @@ static int vmemmap_remap_free(unsigned l
 
 		vmemmap_remap_range(reuse, end, &walk);
 	}
-	mmap_read_unlock(&init_mm);
 
 	return ret;
 }
@@ -434,11 +429,7 @@ static int vmemmap_remap_alloc(unsigned
 	if (alloc_vmemmap_page_list(start, end, &vmemmap_pages))
 		return -ENOMEM;
 
-	mmap_read_lock(&init_mm);
-	vmemmap_remap_range(reuse, end, &walk);
-	mmap_read_unlock(&init_mm);
-
-	return 0;
+	return vmemmap_remap_range(reuse, end, &walk);
 }
 
 DEFINE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


