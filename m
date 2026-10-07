Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B4E2C21F4;
	Wed,  7 Oct 2026 00:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334145; cv=none; b=l1zrSdLwDESP4l16NBZkhkLCxxFS+5TgslcaDChFeD5O5B9532y8v33evUog1iAGRNo1j/9aaLQF3RHZx6Igo1B43rtLm/DXSJME6vO7PvcfEwcMisnBI69mqirTjZk0WW1FU/qGUSw+ns5xoTf162k5O6Eko+RsZW56NUSgBvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334145; c=relaxed/simple;
	bh=vIdVxafOQkiOMcCO5cxVJwKf745WpUGPLQLfWs0R4Zg=;
	h=Date:To:From:Subject:Message-Id; b=HLPEAycZUXvZ+65TKaRK/oUk+ZwpDLb+B5YaN2p3cNZyoc5daRPL4Fk1SUQ5N7h1sedtI7eAb/CTzvnCQ4bdsxHNpquwupEo4KbpEpvV9Zcey6Q3Fa5Cp/NSPAn7qmm/jl9UdnDdD8fPnctEt3s4YBDwKif08mSJmbXXLZsb3/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MnzNnLx2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MnzNnLx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4511F0089C;
	Wed,  7 Oct 2026 00:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334144;
	bh=D4HsU3G7tQbWx00D/ng1yAexV4UZJyHHPFL4t0iKv24=;
	h=Date:To:From:Subject;
	b=MnzNnLx2r04APBV/SfGY0tkf8QHE6GdmMs8wovoYKLwrS/p+zCo4rh3DX99hnPuSc
	 +kkQ6XTZZ9joAVxAyQFiynrirTeEginCfHPva0agAoQKkCsuKBm8vzhaG4mdNpwTj0
	 7Xhstxly6Y4LyyCw8xEQPULpR07kRanke0RLCZmA=
Date: Tue, 06 Oct 2026 17:49:03 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,vbabka@kernel.org,surenb@google.com,sunnanyong@huawei.com,stable@vger.kernel.org,mhocko@suse.com,hannes@cmpxchg.org,brendan.jackman@linux.dev,xiqi2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_isolation-guard-compound_order-against-racing.patch removed from -mm tree
Message-Id: <20261007004904.2A4511F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_isolation: guard compound_order() against racing
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-guard-compound_order-against-racing.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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


