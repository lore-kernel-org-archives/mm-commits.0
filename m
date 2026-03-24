Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9019F35F5FB
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388474; cv=none; b=gfBhRduxAxrQO3rlmQpWNu/ecHrB0JGcZTDPinIkMmSiIEWVKGpMazDskWqZyEYXvdiWZV9wwsU0KCPrR+tNUBI5RjmlBMZolDwuehYyPga8CDyREIBAUkWpUsWI4UjckDu1wWVFs89BvrdilJWt5+Iex0VXt3MxnbqVM86Pm80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388474; c=relaxed/simple;
	bh=TZaRH7zNjtxRGG3jSKSvRnwQnxAMRwTxWHjDf+/adnw=;
	h=Date:To:From:Subject:Message-Id; b=jBOFzWMm+bA0vO8LMOp1pJGasajgv+fdtfcf4umdLvvmUODXMywQ5dGqmpvZ1L2Mxvg1VYL2liK2HyizV8R7cCwnfwcE29ZcjrVmQnlXlbXdUoM7zwr44QvW0NrHBk3uHabm5GO5nPC4AFGvV6sO1NuT/lAsoV2VE+JU4hHvDZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zpjd27AK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zpjd27AK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A7F9C19424;
	Tue, 24 Mar 2026 21:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388474;
	bh=TZaRH7zNjtxRGG3jSKSvRnwQnxAMRwTxWHjDf+/adnw=;
	h=Date:To:From:Subject:From;
	b=Zpjd27AKaU5wkDM0h7aWPaoneqnFVGNvQcGO+6N67aCsBWe0QdAAhvRAVV3o/GjtB
	 PdHWtC0QoKhQaGhDYw4l3xYA4pQigo3Uev17GOjP8x70rHnXkjZ/UyMAUHxKId23Td
	 gfkwwSdyHE2CNj8xne8sDQFKHOli8yk1EAdL5o5g=
Date: Tue, 24 Mar 2026 14:41:13 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,surenb@google.com,mhocko@suse.com,jackmanb@google.com,hannes@cmpxchg.org,hu.shengming@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-avoid-overcounting-bulk-alloc-in-watermark-check.patch removed from -mm tree
Message-Id: <20260324214114.3A7F9C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: avoid overcounting bulk alloc in watermark check
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-avoid-overcounting-bulk-alloc-in-watermark-check.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shengming Hu <hu.shengming@zte.com.cn>
Subject: mm/page_alloc: avoid overcounting bulk alloc in watermark check
Date: Thu, 29 Jan 2026 22:38:14 +0800

alloc_pages_bulk_noprof() only fills NULL slots and already tracks how
many entries are pre-populated via nr_populated.

The fast watermark check was adding nr_pages unconditionally, which can
overestimate the demand.  Use (nr_pages - nr_populated) instead, as an
upper bound on the remaining pages this call can still allocate without
scanning the whole array.

Link: https://lkml.kernel.org/r/tencent_F36C5B5FB4DED98C79D9BDEE1210CD338C06@qq.com
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-overcounting-bulk-alloc-in-watermark-check
+++ a/mm/page_alloc.c
@@ -5136,7 +5136,7 @@ unsigned long alloc_pages_bulk_noprof(gf
 
 		cond_accept_memory(zone, 0, alloc_flags);
 retry_this_zone:
-		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages;
+		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
 		if (zone_watermark_fast(zone, 0,  mark,
 				zonelist_zone_idx(ac.preferred_zoneref),
 				alloc_flags, gfp)) {
_

Patches currently in -mm which might be from hu.shengming@zte.com.cn are


