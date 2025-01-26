Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7367125A620;
	Sun, 26 Jan 2025 04:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737866583; cv=none; b=oAsy8XxObRuhzXYoBRXUa9T06Fg8qaon9d8HiFaNXTjuAnJFrpzHfUO32mXtX6DCjIomfM3gTio7HBKRntfnshHwodFsv76t73LQSyYek0j6lck0tUXZOn500KAt78nxzgymO1IQ7J9eygKx9jK2dxoxL4izDCt0qZwIAr4VdLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737866583; c=relaxed/simple;
	bh=+m2KE/dUv68mYkMD1zmWXybluHZ886DZKHBPpCdC0Y4=;
	h=Date:To:From:Subject:Message-Id; b=ZKYaJika0vNLo5sr5bE5g35KY4KzFVRzGQV1LQhRmOHADWBeiMoPV79iRHeo8u373TTCq0jFWssDAYTXk59iejVTgA5EoO4oiFIDPjGXglfW3YAEYJKMTOceFuMhhi5Q78gjGju37QlX9Qbg5KvVhoyEFwKDEIvc1HwfRiuRJrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qDXtTHt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qDXtTHt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35A6C4CED3;
	Sun, 26 Jan 2025 04:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737866582;
	bh=+m2KE/dUv68mYkMD1zmWXybluHZ886DZKHBPpCdC0Y4=;
	h=Date:To:From:Subject:From;
	b=qDXtTHt6xBclHOxkMHJ8qaXVgq04nb60h0eKFkzQX9udotVNG97d4cWXTls0DLNAt
	 ycyO3zjiZuoznqO3w16nsMVrY9h10aP01Cs7hObDR2KyfkpHviM1mFHgjCSKoyBhZb
	 niCnBrC+rYBs63NTzT0WpqtjEwa5BeG/AyLapcKw=
Date: Sat, 25 Jan 2025 20:43:02 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,sunnanyong@huawei.com,stable@vger.kernel.org,shikemeng@huaweicloud.com,osalvador@suse.de,mgorman@techsingularity.net,david@redhat.com,baolin.wang@linux.alibaba.com,liushixin2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-fix-ubsan-shift-out-of-bounds-warning.patch removed from -mm tree
Message-Id: <20250126044302.C35A6C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/compaction: fix UBSAN shift-out-of-bounds warning
has been removed from the -mm tree.  Its filename was
     mm-compaction-fix-ubsan-shift-out-of-bounds-warning.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/compaction: fix UBSAN shift-out-of-bounds warning
Date: Thu, 23 Jan 2025 10:10:29 +0800

syzkaller reported a UBSAN shift-out-of-bounds warning of (1UL << order)
in isolate_freepages_block().  The bogus compound_order can be any value
because it is union with flags.  Add back the MAX_PAGE_ORDER check to fix
the warning.

Link: https://lkml.kernel.org/r/20250123021029.2826736-1-liushixin2@huawei.com
Fixes: 3da0272a4c7d ("mm/compaction: correctly return failure with bogus compound_order in strict mode")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reviewed-by: Kemeng Shi <shikemeng@huaweicloud.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-fix-ubsan-shift-out-of-bounds-warning
+++ a/mm/compaction.c
@@ -631,7 +631,8 @@ static unsigned long isolate_freepages_b
 		if (PageCompound(page)) {
 			const unsigned int order = compound_order(page);
 
-			if (blockpfn + (1UL << order) <= end_pfn) {
+			if ((order <= MAX_PAGE_ORDER) &&
+			    (blockpfn + (1UL << order) <= end_pfn)) {
 				blockpfn += (1UL << order) - 1;
 				page += (1UL << order) - 1;
 				nr_scanned += (1UL << order) - 1;
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-page_isolation-avoid-call-folio_hstate-without-hugetlb_lock.patch

