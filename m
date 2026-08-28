Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0DB3ACF17;
	Fri, 28 Aug 2026 03:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787889062; cv=none; b=r+nwDYtZOxuXborbk+LeEaHQ259sGD1cX077gXHYxfsQYTmvaWBvEiJb0HrK1mGdgLV/BIMOb45aAiPReoPhTuGDgi9cXjE68rMaCg7aY6ISoAjz+TqYI6cjNQnwJAmpcQSV3bsl0FvpzH6rGNYaz4mDC94arJNkFCkSpEm1m8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787889062; c=relaxed/simple;
	bh=1YQL62NrmnqpVU4xJ3S9ABHcAUq9wxwdtNMAfndb+i8=;
	h=Date:To:From:Subject:Message-Id; b=DsBRle0/E5CVpqD/FPvjwCHHDoR15vBE30wPibcTb4+6w+GLmc5Mwvjmk5GLtu4nbYj8D1wX4IjRqZXNT5Bvv1wlQjv+rlpkecgP0vWjuktwSzGmyPbMTtCJOrmHjSQ1Dm3jikJUTaeaO2vkQeqXxKJR0sN1QkuP3rDOMkAahOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AXXc97yV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AXXc97yV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8791F00A3A;
	Fri, 28 Aug 2026 03:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787889057;
	bh=q4sGpVU1eIDY4386JITFkelPRvGigsd1VnyGJYsRlZY=;
	h=Date:To:From:Subject;
	b=AXXc97yVBcQaTe8NP6aCP0vszg9yTiEP5Mn+Rwb4/RWajz0dGGAnUEvQHBZ5gtmHm
	 a56zFDfZo4CecPBU1oRFqnBSGYNdnMfZ2j6BgPtFeuzbid6x5CPpQ4NVLgvM9eF2pO
	 /kk27HdrOP/Xy7ABfNYdZnngRvg3i71K57xEKo7U=
Date: Thu, 27 Aug 2026 20:50:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,sunnanyong@huawei.com,stable@vger.kernel.org,mhocko@suse.com,hannes@cmpxchg.org,brendan.jackman@linux.dev,xiqi2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-guard-compound_order-against-racing.patch added to mm-new branch
Message-Id: <20260828035057.3E8791F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_isolation: guard compound_order() against racing
has been added to the -mm mm-new branch.  Its filename is
     mm-page_isolation-guard-compound_order-against-racing.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-guard-compound_order-against-racing.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Qi Xi <xiqi2@huawei.com>
Subject: mm/page_isolation: guard compound_order() against racing
Date: Tue, 25 Aug 2026 20:05:49 +0800

The PageCompound branch reads compound_head() without holding a reference.
A racing split or free can cause compound_head() to return a stale
pointer, and compound_nr() reads the order from that stale head, leading
to out-of-range shifts and making the skip distance meaningless.

Read the order explicitly with compound_order() and validate it is within
MAX_FOLIO_ORDER before shifting.  Also verify the derived head_pfn against
the legitimate pfn: the head must not be past pfn, must be aligned to
nr_pages, and pfn must fall within the compound page.  Bail out with
-EBUSY if any check fails.

Link: https://lore.kernel.org/20260825120549.966271-3-xiqi2@huawei.com
Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Signed-off-by: Qi Xi <xiqi2@huawei.com>
Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-guard-compound_order-against-racing
+++ a/mm/page_isolation.c
@@ -419,10 +419,28 @@ static int isolate_single_pageblock(unsi
 		if (PageCompound(page)) {
 			struct page *head = compound_head(page);
 			unsigned long head_pfn = page_to_pfn(head);
-			unsigned long nr_pages = compound_nr(head);
+			unsigned int order = compound_order(head);
+			unsigned long nr_pages;
+
+			/* compound_order() is racy. Cap it at MAX_FOLIO_ORDER. */
+			if (order > MAX_FOLIO_ORDER)
+				goto failed;
+
+			nr_pages = 1UL << order;
+
+			/*
+			 * compound_head() is also racy, so the derived head_pfn
+			 * needs additional checks to make sure it is valid.
+			 * Otherwise, just fail the check. pfn comes from
+			 * __first_valid_page() as a legitimate PFN, so use it to
+			 * check head_pfn.
+			 */
+			if (head_pfn > pfn || !IS_ALIGNED(head_pfn, nr_pages) ||
+			    pfn - head_pfn >= nr_pages)
+				goto failed;
 
 			if (head_pfn + nr_pages <= boundary_pfn ||
-			    PageHuge(page)) {
+			    PageHuge(head)) {
 				pfn = head_pfn + nr_pages;
 				continue;
 			}
_

Patches currently in -mm which might be from xiqi2@huawei.com are

mm-drop-stale-max_order-references.patch
mm-page_isolation-fix-ubsan-shift-out-of-bounds-warning.patch
mm-page_isolation-guard-compound_order-against-racing.patch

