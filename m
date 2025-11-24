Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C0D933509F
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025804; cv=none; b=gFaxO9Y8Cv+QHR9u5420RKZll2cTLVxINufAtNoIPbNCIi9IKP8mv2/i2xopL9sDuLu5A8750EJn222N26GJD+E6+AtHhMI37REGdlyPaJ+0DNM6XBNzRUIBE3922EJ6R/Fgutp0w4ty26xGqMnL17UXOFdwqL8unZjhrl8eWOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025804; c=relaxed/simple;
	bh=a6nl7Gafhy2ZtLJaSXmcGAJUc42RgnPrJ0YRtRbzm5M=;
	h=Date:To:From:Subject:Message-Id; b=ETQ1kNoPz3mhDgbbqeHl3LxRYggJ7x+l9i6otmZj6IAG70aC2Qm58VTW9n6mJveqNQn33HRIv2PpCTZdT3ixlBTEXNCfrDPWc5MReRx9n88e0Vi3UEXJANryqV3NEXb7N/rKSkpiNSyGJRyp3ghUwnAsA7E8Zf0x2L1hA4rhb7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=i1nJ00+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="i1nJ00+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1494C4CEF1;
	Mon, 24 Nov 2025 23:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025804;
	bh=a6nl7Gafhy2ZtLJaSXmcGAJUc42RgnPrJ0YRtRbzm5M=;
	h=Date:To:From:Subject:From;
	b=i1nJ00+gcvMmaab64DQQoJ+6OVqB2x8FgWYZVoQMTGg3XVz8Cn2v2+DJodFvQn5UP
	 ICa7dsjO0Ef7BmRSRUYB2VncJR2I7jG+VfbdYP1xxuaZYpcEW3xrX3i9OGeZb5xY3q
	 E1tImDhNKVCYI5SWmiUN2nfjtiOR8wRg9rd/akUQ=
Date: Mon, 24 Nov 2025 15:10:03 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,richard.weiyang@gmail.com,npache@redhat.com,nao.horiguchi@gmail.com,mcgrof@kernel.org,lorenzo.stoakes@oracle.com,linmiaohe@huawei.com,liam.howlett@oracle.com,lance.yang@linux.dev,kernel@pankajraghav.com,jane.chu@oracle.com,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-improve-large-block-size-folio-handling.patch removed from -mm tree
Message-Id: <20251124231003.E1494C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: improve large block size folio handling
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-improve-large-block-size-folio-handling.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/memory-failure: improve large block size folio handling
Date: Fri, 31 Oct 2025 12:20:00 -0400

Large block size (LBS) folios cannot be split to order-0 folios but
min_order_for_folio().  Current split fails directly, but that is not
optimal.  Split the folio to min_order_for_folio(), so that, after split,
only the folio containing the poisoned page becomes unusable instead.

For soft offline, do not split the large folio if its
min_order_for_folio() is not 0.  Since the folio is still accessible from
userspace and premature split might lead to potential performance loss.

Link: https://lkml.kernel.org/r/20251031162001.670503-3-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Suggested-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Pankaj Raghav <kernel@pankajraghav.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-improve-large-block-size-folio-handling
+++ a/mm/memory-failure.c
@@ -1659,12 +1659,13 @@ static int identify_page_state(unsigned
  * there is still more to do, hence the page refcount we took earlier
  * is still needed.
  */
-static int try_to_split_thp_page(struct page *page, bool release)
+static int try_to_split_thp_page(struct page *page, unsigned int new_order,
+		bool release)
 {
 	int ret;
 
 	lock_page(page);
-	ret = split_huge_page(page);
+	ret = split_huge_page_to_order(page, new_order);
 	unlock_page(page);
 
 	if (ret && release)
@@ -2420,6 +2421,9 @@ try_again:
 	folio_unlock(folio);
 
 	if (folio_test_large(folio)) {
+		const int new_order = min_order_for_split(folio);
+		int err;
+
 		/*
 		 * The flag must be set after the refcount is bumped
 		 * otherwise it may race with THP split.
@@ -2434,7 +2438,16 @@ try_again:
 		 * page is a valid handlable page.
 		 */
 		folio_set_has_hwpoisoned(folio);
-		if (try_to_split_thp_page(p, false) < 0) {
+		err = try_to_split_thp_page(p, new_order, /* release= */ false);
+		/*
+		 * If splitting a folio to order-0 fails, kill the process.
+		 * Split the folio regardless to minimize unusable pages.
+		 * Because the memory failure code cannot handle large
+		 * folios, this split is always treated as if it failed.
+		 */
+		if (err || new_order) {
+			/* get folio again in case the original one is split */
+			folio = page_folio(p);
 			res = -EHWPOISON;
 			kill_procs_now(p, pfn, flags, folio);
 			put_page(p);
@@ -2761,7 +2774,17 @@ static int soft_offline_in_use_page(stru
 	};
 
 	if (!huge && folio_test_large(folio)) {
-		if (try_to_split_thp_page(page, true)) {
+		const int new_order = min_order_for_split(folio);
+
+		/*
+		 * If new_order (target split order) is not 0, do not split the
+		 * folio at all to retain the still accessible large folio.
+		 * NOTE: if minimizing the number of soft offline pages is
+		 * preferred, split it to non-zero new_order like it is done in
+		 * memory_failure().
+		 */
+		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
+						       /* release= */ true)) {
 			pr_info("%#lx: thp split failed\n", pfn);
 			return -EBUSY;
 		}
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-huge_memory-change-folio_split_supported-to-folio_check_splittable.patch
mm-huge_memory-replace-can_split_folio-with-direct-refcount-calculation.patch
mm-huge_memory-make-min_order_for_split-always-return-an-order.patch
mm-huge_memory-fix-folio-split-stats-counting.patch

