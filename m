Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267ECBA46
	for <mm-commits@vger.kernel.org>; Sat, 29 Jun 2024 02:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719628230; cv=none; b=nlh2aBVsTLh7tUzQm1q/J10UkUrQpOySdYmMLCfBZt8X9mrMgcKBA8F/3UST1kkgPo6qWbEd4gdMRxHKNhJOnk5HqKPvmFRam8OunZRFqmPcXgbAnVFNyt/DVW4lTmkaB3gMzOWMJ9u5anZ5lzME0COZHs2eI2BUlJ2YAgBdRkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719628230; c=relaxed/simple;
	bh=NmaHhBFFTHOdnOn9Tj6LI4IJJ6BKd7+VCiUgCBJsMDs=;
	h=Date:To:From:Subject:Message-Id; b=n5/MtR9T63MkawoRwZsXuZA/gtNtX8dqMzgqXpdQnAI+cHoWM7BpC8LI+eKbacHDOjQe0z5AoqbZS0apc66EVpxm0K393hP4+JgMHZJxOAacmGO7yeIFbbZ5/B2lJZPY0oR2iM6k7f4cfpoLtlqflUAQKssqqsxSK3Jw1ITHReg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KvwPpV4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KvwPpV4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C74C116B1;
	Sat, 29 Jun 2024 02:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719628230;
	bh=NmaHhBFFTHOdnOn9Tj6LI4IJJ6BKd7+VCiUgCBJsMDs=;
	h=Date:To:From:Subject:From;
	b=KvwPpV4Iy0RW53T/xGxgE3WkRyy26KvwN/65xMSNuHty4N3/fb3veLgUxc6WKPGkk
	 eE7kSgOmEda6ofoGQcgtL3xl3oEnN7TIRanDL2zicWqqoDh4MrS9ypu6D0wVaXN0E2
	 kA5KtkSET6XI8omEWA58a9d4+n9sYxAZyQp/ehhI=
Date: Fri, 28 Jun 2024 19:30:29 -0700
To: mm-commits@vger.kernel.org,ying.huang@intel.com,willy@infradead.org,muchun.song@linux.dev,david@redhat.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-rename-pages_per_huge_page-to-nr_pages.patch removed from -mm tree
Message-Id: <20240629023029.F2C74C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory: rename pages_per_huge_page to nr_pages
has been removed from the -mm tree.  Its filename was
     mm-memory-rename-pages_per_huge_page-to-nr_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory: rename pages_per_huge_page to nr_pages
Date: Tue, 18 Jun 2024 17:12:42 +0800

Since the callers are converted to use nr_pages naming, use it inside too.

Link: https://lkml.kernel.org/r/20240618091242.2140164-5-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/memory.c~mm-memory-rename-pages_per_huge_page-to-nr_pages
+++ a/mm/memory.c
@@ -6387,23 +6387,23 @@ EXPORT_SYMBOL(__might_fault);
  * cache lines hot.
  */
 static inline int process_huge_page(
-	unsigned long addr_hint, unsigned int pages_per_huge_page,
+	unsigned long addr_hint, unsigned int nr_pages,
 	int (*process_subpage)(unsigned long addr, int idx, void *arg),
 	void *arg)
 {
 	int i, n, base, l, ret;
 	unsigned long addr = addr_hint &
-		~(((unsigned long)pages_per_huge_page << PAGE_SHIFT) - 1);
+		~(((unsigned long)nr_pages << PAGE_SHIFT) - 1);
 
 	/* Process target subpage last to keep its cache lines hot */
 	might_sleep();
 	n = (addr_hint - addr) / PAGE_SIZE;
-	if (2 * n <= pages_per_huge_page) {
+	if (2 * n <= nr_pages) {
 		/* If target subpage in first half of huge page */
 		base = 0;
 		l = n;
 		/* Process subpages at the end of huge page */
-		for (i = pages_per_huge_page - 1; i >= 2 * n; i--) {
+		for (i = nr_pages - 1; i >= 2 * n; i--) {
 			cond_resched();
 			ret = process_subpage(addr + i * PAGE_SIZE, i, arg);
 			if (ret)
@@ -6411,8 +6411,8 @@ static inline int process_huge_page(
 		}
 	} else {
 		/* If target subpage in second half of huge page */
-		base = pages_per_huge_page - 2 * (pages_per_huge_page - n);
-		l = pages_per_huge_page - n;
+		base = nr_pages - 2 * (nr_pages - n);
+		l = nr_pages - n;
 		/* Process subpages at the begin of huge page */
 		for (i = 0; i < base; i++) {
 			cond_resched();
@@ -6442,12 +6442,12 @@ static inline int process_huge_page(
 }
 
 static void clear_gigantic_page(struct folio *folio, unsigned long addr,
-				unsigned int pages_per_huge_page)
+				unsigned int nr_pages)
 {
 	int i;
 
 	might_sleep();
-	for (i = 0; i < pages_per_huge_page; i++) {
+	for (i = 0; i < nr_pages; i++) {
 		cond_resched();
 		clear_user_highpage(folio_page(folio, i), addr + i * PAGE_SIZE);
 	}
@@ -6477,15 +6477,15 @@ void folio_zero_user(struct folio *folio
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
-				     unsigned long addr,
-				     struct vm_area_struct *vma,
-				     unsigned int pages_per_huge_page)
+				   unsigned long addr,
+				   struct vm_area_struct *vma,
+				   unsigned int nr_pages)
 {
 	int i;
 	struct page *dst_page;
 	struct page *src_page;
 
-	for (i = 0; i < pages_per_huge_page; i++) {
+	for (i = 0; i < nr_pages; i++) {
 		dst_page = folio_page(dst, i);
 		src_page = folio_page(src, i);
 
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-move-memory_failure_queue-into-copy_mc__highpage.patch
mm-add-folio_mc_copy.patch
mm-migrate-split-folio_migrate_mapping.patch
mm-migrate-support-poisoned-recover-from-migrate-folio.patch
fs-hugetlbfs-support-poisoned-recover-from-hugetlbfs_migrate_folio.patch
mm-migrate-remove-folio_migrate_copy.patch

