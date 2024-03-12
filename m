Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE2B14264A
	for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2024 20:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710274069; cv=none; b=BhoaYkRiuQASh4IpwdzprZgy/Ff8+nDQwORLGB0+n8o8CN7nm4HMvnNfa1qs1UqeWE09H8TzMy3quFmXw1T8tMA0gdrYkjFRa25GGQJ2YdxNs2VSONKS9+CoSytTQPw+NhwK20ReJF3ynXj/T2W/TItxJffvNFhG4OkA5bDAm7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710274069; c=relaxed/simple;
	bh=UkA0V4gyWOALjGG7BDrXHYdxPVU8MLW7tPnNHFsKn70=;
	h=Date:To:From:Subject:Message-Id; b=PNJbOP9QMMGt236QRNZs424QOu4uNrCyJ+jbNg2dU7+xdZsIHXqJ6M8Yu87ohQBR3MTjXhnGDbKhpAWf8fCFc7kVhvCYSqZjVpyDD+a1lwN3j/qI0SIkejUwS9qzjy+wIPBnIyiKduewzwrGXkVbglBKYuViFDdCCc9QXknjVn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c12htL1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c12htL1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539D4C433F1;
	Tue, 12 Mar 2024 20:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710274069;
	bh=UkA0V4gyWOALjGG7BDrXHYdxPVU8MLW7tPnNHFsKn70=;
	h=Date:To:From:Subject:From;
	b=c12htL1Di0DLxzaXy0PrchAumnmj0zHuy/0AVV+gYLEs454GrEd2pAWTrUcQp3My2
	 nzjfdZp//gXydORvMi+VWtR1pXiu6NKISDaCwSxdKsiQDNqZ8QiPD4jEyfnXcEq1K9
	 5Lwq59iu8ToFYsa+UCmOEO6/cjpE6Lm5qtWwFACk=
Date: Tue, 12 Mar 2024 13:07:48 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,shy828301@gmail.com,ryan.roberts@arm.com,kirill.shutemov@linux.intel.com,david@redhat.com,dan.carpenter@linaro.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-check-new-folio-order-when-split-a-folio.patch removed from -mm tree
Message-Id: <20240312200749.539D4C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: check new folio order when split a folio
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-check-new-folio-order-when-split-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: check new folio order when split a folio
Date: Thu, 7 Mar 2024 13:18:53 -0500

A folio can only be split into lower orders.

Since there are no new_order checks in debugfs, any new_order can be
passed via debugfs into split_huge_page_to_list_to_order().

Check new_order to make sure it is smaller than input folio order.

Link: https://lkml.kernel.org/r/20240307181854.138928-1-zi.yan@sent.com
Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-mm/7dda9283-b437-4cf8-ab0d-83c330deb9c0@moroto.mountain/
Cc: David Hildenbrand <david@redhat.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-check-new-folio-order-when-split-a-folio
+++ a/mm/huge_memory.c
@@ -3052,6 +3052,9 @@ int split_huge_page_to_list_to_order(str
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
 
+	if (new_order >= folio_order(folio))
+		return -EINVAL;
+
 	/* Cannot split anonymous THP to order-1 */
 	if (new_order == 1 && folio_test_anon(folio)) {
 		VM_WARN_ONCE(1, "Cannot split to order-1 folio");
_

Patches currently in -mm which might be from ziy@nvidia.com are


