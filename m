Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793403400;
	b=OLv7iBfoociMlnY2dtV6jYhGpeW5+t+xICgMI7P1zyfkKI7irMCI5P83zyTFXcZ9T4HJ
	 aep2o9Ctm4pd+BpNT4WuALBGMPAmUr9SaWwjscU4EZriQvsMx8jnCJleH0R0SR/ntjrZ3
	 GFzNYHcEDvzIX5P9h8+X2xXAqa88nMqs7CqRzH7iUs5lKVTdhgX+rqGPAbh/uewkScmcg
	 sC16KvwPl5f241Lt1ihtH9/LaYyTH5AQE9emFuE3AQhzt+05yrUH0MI+y3qtKzwJ+9qw2
	 1D8PkeS7snBI922c/oBHs1ah+tZ124/FgaFcCAj4I+oZxWh6t67gEOiiFZ5xSPpws7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793403400;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=udozCS/vBQV+UPrMhePtC6bIUr5IypfLnA1f69iftSw=;
	b=hvBNzDcwvQmLqKoRl5J5Rif4qGCG1IPZhIc8auvxBEIwliaK6Pjf3flJLH/Y8xM2uj07
	 /D0E1KWCGQKDYqtU9j3Sb7wiI9a7F9rwygCWWJIYa/hKOMFl/EDu35ZS+z6C4y08s3C3j
	 DfMxiDN4vnYNaJSvOmqpsDKW7uat/vlmuktqGKWpBBEFa2ujTP06xyjPz1lN0y3d65gji
	 qwXlN+zdOe2hvOxydn5oydTRxeQ6950XJGPv0c3y8X1tNcYVoAMjhxGuhZ3HTyJH3fgps
	 Ry+O64zJJSxjU/CId0u1wFrljZZH0T5kn+tjM4OVXEZuQa9hHrQnpLW/Lh+GBAy+WaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ir9aEBRD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66667606A31F;
	Fri, 30 Oct 2026 23:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ir9aEBRD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39DA1F000C1;
	Fri, 30 Oct 2026 23:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793403399;
	bh=udozCS/vBQV+UPrMhePtC6bIUr5IypfLnA1f69iftSw=;
	h=Date:To:From:Subject;
	b=ir9aEBRDIvRnna18o5bZ5MiWiaEzOcFPdZsIiqe5fi67jYnM5yKZV5lFl6jnPiDOi
	 Oz5hcp9osoAejZYLcRaSyI8cYnrOrUXXkb+d1td4ifCFe1/KcUKchfkP1LM+IEd9wS
	 ewWFeQVvthVoXoRol4ZAs63cM7tz952gN2PcSlNc=
Date: Fri, 30 Oct 2026 16:36:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,usama.arif@linux.dev,
	tz2294@columbia.edu,stable@vger.kernel.org,ryan.roberts@arm.com,
	richard.weiyang@gmail.com,nico.pache@linux.dev,nao.horiguchi@gmail.com,
	mcgrof@kernel.org,ljs@kernel.org,liyouhong@kylinos.cn,linmiaohe@huawei.com,
	liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,baohua@kernel.org,david@kernel.org,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch added to mm-hotfixes-unstable branch
Message-Id: <20261030233639.D39DA1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/memory-failure: fix folio refcount leak and min_order_for_split() locking
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: mm/memory-failure: fix folio refcount leak and min_order_for_split() locking
Date: Fri, 30 Oct 2026 23:29:13 +0100

hwpoison code can end up calling min_order_for_split() without holding the
folio lock.  There isn't really something that would prevent concurrent
folio split.  Consequently folio->mapping can get set to NULL after
checking for "!folio->mapping", and if the compiler reloads
folio->mapping, mapping_min_folio_order() would try to dereference NULL.

While very unlikely to happen in practice, let's just enforce that
min_order_for_split() is called with the folio lock held.  We can
significantly cleanup the calling hwpoison code, and just get rid of
try_to_split_thp_page() to hold the folio lock for a bit longer.

Just work on folios now, which further cleans up the code.  We just have
to be careful about doing the page_folio() after splitting, which we have
to do already either way.  Do not change the way we split for now, this
needs more thought and should be done separately.

Cleaning this up we fix another issue: in soft_offline_in_use_page(), we
would currently have leaked a folio reference.

In min_order_for_split(), document and assert that we need the folio lock.
Drop the questionable VM_BUG_ON_PAGE(!page_count(p), p) check entirely.

While updating the comment in soft_offline_in_use_page(), just drop the
"NOTE" part that does not add any value to current code.

The folio->mapping problem was identified by Sashiko, and Li Youhong
reported it by sending a proposal fix.

This likely does not really warrant CCing stable, but I expect little
conflicts when doing the backport, so let's just CC stable because of the
refcount leak.

Link: https://lore.kernel.org/20261030-try_to_split_thp_page-v2-1-c957c9b42eab@kernel.org
Fixes: 689b8986776c ("mm/memory-failure: improve large block size folio handling")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Li Youhong <liyouhong@kylinos.cn>
Closes: https://lore.kernel.org/r/20260804035828.2684059-1-dayou5941@163.com
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: <stable@vger.kernel.org>
---

 mm/huge_memory.c    |    4 ++
 mm/memory-failure.c |   63 ++++++++++++++----------------------------
 2 files changed, 25 insertions(+), 42 deletions(-)

--- a/mm/huge_memory.c~mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking
+++ a/mm/huge_memory.c
@@ -4492,10 +4492,14 @@ int folio_split(struct folio *folio, uns
  * If a file-backed folio is truncated, 0 will be returned. Any subsequent
  * split attempt should get -EBUSY from split checking code.
  *
+ * Context: @folio must be locked.
+ *
  * Return: @folio's minimum order for split
  */
 unsigned int min_order_for_split(struct folio *folio)
 {
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+
 	if (folio_test_anon(folio))
 		return 0;
 
--- a/mm/memory-failure.c~mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking
+++ a/mm/memory-failure.c
@@ -1744,26 +1744,6 @@ static int identify_page_state(unsigned
 	return page_action(ps, p, pfn);
 }
 
-/*
- * When 'release' is 'false', it means that if thp split has failed,
- * there is still more to do, hence the page refcount we took earlier
- * is still needed.
- */
-static int try_to_split_thp_page(struct page *page, unsigned int new_order,
-		bool release)
-{
-	int ret;
-
-	lock_page(page);
-	ret = split_huge_page_to_order(page, new_order);
-	unlock_page(page);
-
-	if (ret && release)
-		put_page(page);
-
-	return ret;
-}
-
 static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
 		struct address_space *mapping, pgoff_t index, int flags)
 {
@@ -2548,9 +2528,6 @@ try_again:
 	folio_unlock(folio);
 
 	if (folio_test_large(folio)) {
-		const int new_order = min_order_for_split(folio);
-		int err;
-
 		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
@@ -2565,24 +2542,25 @@ try_again:
 		 * page is a valid handlable page.
 		 */
 		folio_set_has_hwpoisoned(folio);
-		err = try_to_split_thp_page(p, new_order, /* release= */ false);
+
+		folio_lock(folio);
+		split_huge_page_to_order(p, min_order_for_split(folio));
+		folio = page_folio(p);
+		folio_unlock(folio);
+
 		/*
 		 * If splitting a folio to order-0 fails, kill the process.
 		 * Split the folio regardless to minimize unusable pages.
 		 * Because the memory failure code cannot handle large
 		 * folios, this split is always treated as if it failed.
 		 */
-		if (err || new_order) {
-			/* get folio again in case the original one is split */
-			folio = page_folio(p);
+		if (folio_test_large(folio)) {
 			res = -EHWPOISON;
 			kill_procs_now(p, pfn, flags, folio);
-			put_page(p);
+			folio_put(folio);
 			action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
 			goto unlock_mutex;
 		}
-		VM_BUG_ON_PAGE(!page_count(p), p);
-		folio = page_folio(p);
 	}
 
 	/*
@@ -2900,25 +2878,26 @@ static int soft_offline_in_use_page(stru
 		.reason = MR_MEMORY_FAILURE,
 	};
 
+	folio_lock(folio);
 	if (!huge && folio_test_large(folio)) {
-		const int new_order = min_order_for_split(folio);
-
 		/*
-		 * If new_order (target split order) is not 0, do not split the
-		 * folio at all to retain the still accessible large folio.
-		 * NOTE: if minimizing the number of soft offline pages is
-		 * preferred, split it to non-zero new_order like it is done in
-		 * memory_failure().
+		 * If we cannot split to order-0, do not split the folio at all
+		 * to retain the still accessible large folio.
 		 */
-		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
-						       /* release= */ true)) {
+		if (!min_order_for_split(folio))
+			ret = split_huge_page_to_order(page, 0) ? -EBUSY : 0;
+		else
+			ret = -EBUSY;
+		folio = page_folio(page);
+
+		if (ret) {
+			folio_unlock(folio);
+			folio_put(folio);
 			pr_info("%#lx: thp split failed\n", pfn);
-			return -EBUSY;
+			return ret;
 		}
-		folio = page_folio(page);
 	}
 
-	folio_lock(folio);
 	if (!huge)
 		folio_wait_writeback(folio);
 	if (PageHWPoison(page)) {
_

Patches currently in -mm which might be from david@kernel.org are

mm-fix-address-wraparound-when-scanning-large-folio-ptes.patch
mm-hugetlb-disable-pmd-sharing-for-uffd-missing-mode.patch
mm-vma-write-lock-source-vma-before-duplicating-it-in-__split_vma.patch
mm-madvise-preserve-vma_softdirty_bit-when-changing-anonymous-names.patch
mm-memory-failure-fix-folio-refcount-leak-and-min_order_for_split-locking.patch

