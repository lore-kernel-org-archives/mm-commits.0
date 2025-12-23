Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8758134B1B0;
	Tue, 23 Dec 2025 19:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766517858; cv=none; b=m2hbmzP8daepnEIg+GIBZtEVZaZ4zGfjLFLFsGtM/ENDaq0jjEcmgGct4tIzXEINHxxMgmPoI0cCGrk5bbDuzQ6Zomwl/I58SDSZWZjblFelNDX9vZYNTzrzYDMbW5ast7T4I0s91aL3+95mevHacYTifkdZpBallMEBEQiUHvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766517858; c=relaxed/simple;
	bh=9wvCxG7257X4Vy0U7DIW8wzxKGRtU9k7DSSK4UVEDb4=;
	h=Date:To:From:Subject:Message-Id; b=e6nWC78860XEq//u2DrQwSdmYZA8TDwzgaf7oY1T0wqsD9bBwoSyArvcCFcLRhKVq2lAJx/IEPRzLdcsJleHg7ykYqPH52SH6CrNv4cUDZR377k6mvmUM8TZcgdTicn12dcv956sCui3uegr7bX1XleugLhmQ692WuLMob5Fzmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VQPAokiB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VQPAokiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A4FFC113D0;
	Tue, 23 Dec 2025 19:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766517858;
	bh=9wvCxG7257X4Vy0U7DIW8wzxKGRtU9k7DSSK4UVEDb4=;
	h=Date:To:From:Subject:From;
	b=VQPAokiBcnz3wKVhDV1TRCOoPM7LkegSeE2caNO68KcNeRuJ8c2Z6EgDAhxySo513
	 vFcGWJVFDufPmJ4+cJtkmjIfKxpVbUwa+OzL7eHr0AsDsoNHALg2UO6UGMJt0WgLYe
	 v0oUJ68CEUU6vyurqTpnYLRU8oNwvzL8Op02BfmA=
Date: Tue, 23 Dec 2025 11:24:17 -0800
To: mm-commits@vger.kernel.org,zhaochongxi2019@email.szu.edu.cn,stable@vger.kernel.org,kaushlendra.kumar@intel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-mm-page_owner_sort-fix-timestamp-comparison-for-stable-sorting.patch removed from -mm tree
Message-Id: <20251223192418.1A4FFC113D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools/mm/page_owner_sort: fix timestamp comparison for stable sorting
has been removed from the -mm tree.  Its filename was
     tools-mm-page_owner_sort-fix-timestamp-comparison-for-stable-sorting.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Subject: tools/mm/page_owner_sort: fix timestamp comparison for stable sorting
Date: Tue, 9 Dec 2025 10:15:52 +0530

The ternary operator in compare_ts() returns 1 when timestamps are equal,
causing unstable sorting behavior. Replace with explicit three-way
comparison that returns 0 for equal timestamps, ensuring stable qsort
ordering and consistent output.

Link: https://lkml.kernel.org/r/20251209044552.3396468-1-kaushlendra.kumar@intel.com
Fixes: 8f9c447e2e2b ("tools/vm/page_owner_sort.c: support sorting pid and time")
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-page_owner_sort-fix-timestamp-comparison-for-stable-sorting
+++ a/tools/mm/page_owner_sort.c
@@ -181,7 +181,11 @@ static int compare_ts(const void *p1, co
 {
 	const struct block_list *l1 = p1, *l2 = p2;
 
-	return l1->ts_nsec < l2->ts_nsec ? -1 : 1;
+	if (l1->ts_nsec < l2->ts_nsec)
+		return -1;
+	if (l1->ts_nsec > l2->ts_nsec)
+		return 1;
+	return 0;
 }
 
 static int compare_cull_condition(const void *p1, const void *p2)
_

Patches currently in -mm which might be from kaushlendra.kumar@intel.com are

tools-mm-thp_swap_allocator_test-fix-small-folio-alignment.patch
tools-mm-slabinfo-fix-partial-long-option-mapping.patch

