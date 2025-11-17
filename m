Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BB121FF4C
	for <mm-commits@vger.kernel.org>; Mon, 17 Nov 2025 01:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763343147; cv=none; b=uQo9AcDDAlIZihfXTzGTUwo5H3kZ/m2B/yJys1jDFqvzO6f36w/IsmG8QJaRWGzSBatmVer+Sd7NAddWkzvwzR3zRgpq6FDsiPno5aufuq9mJIfAzLEf+k5kdK7chk591/Eb+5J6pzO3+YgWna8IbE1lp31l2siEyVw6kC0JCdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763343147; c=relaxed/simple;
	bh=rSJg5mnFh6X/krX4Q2cF/jIxZa5MOejDweBBgdprJ7o=;
	h=Date:To:From:Subject:Message-Id; b=Adhu47ZqJiv3V8Tcpcl5Rrsp8acdpcVsWPXHaRQp2w/hZA/K5DJCm1wP8b5u5J/w7xOM8ouEyI6WztKQ1ZTMxvaTf9ih+0WRr4MjYU+40efqBTHrKuBPI514aBOSu2iKmoOoxjRrStjWzS46QtOn4jYxuvAkidAI1LCF2Si9qHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HJMKCsuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HJMKCsuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DF32C4CEF1;
	Mon, 17 Nov 2025 01:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763343147;
	bh=rSJg5mnFh6X/krX4Q2cF/jIxZa5MOejDweBBgdprJ7o=;
	h=Date:To:From:Subject:From;
	b=HJMKCsuBZibq4qLM1m/TWtrFVoUk9qAQnDbddYmKLl9rCA5cxmt3PACKTrJWwtJUs
	 zlTwM7GB+Ipo7QquUcexu2b2nNa7x0RFaqrYHeVFMQuYcZXIcegsW/TsAqT6IK7EQM
	 uCjjil9YimYpK7sYfZUzyow/4BhTZ295ArA2mQEI=
Date: Sun, 16 Nov 2025 17:32:27 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vishal.moola@gmail.com,sj@kernel.org,ryan.roberts@arm.com,riel@redhat.com,richard.weiyang@gmail.com,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,aarcange@redhat.com,lianux.mm@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-fix-comment-for-default-scan-sleep-duration.patch removed from -mm tree
Message-Id: <20251117013227.8DF32C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: fix comment for default scan sleep duration
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-fix-comment-for-default-scan-sleep-duration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: wang lian <lianux.mm@gmail.com>
Subject: mm/khugepaged: fix comment for default scan sleep duration
Date: Wed, 15 Oct 2025 17:29:57 +0800

The comment for khugepaged_scan_sleep_millisecs incorrectly states the
default scan period is 30 seconds.  The actual default value in the code
is 10000ms (10 seconds).

This patch corrects the comment to match the code, preventing potential
confusion.  The incorrect comment has existed since the feature was first
introduced.  While at it, replace the magic value 512 by HPAGE_PMD_NR and
use 'ptes'.

Link: https://lkml.kernel.org/r/20251015092957.37432-1-lianux.mm@gmail.com
Signed-off-by: wang lian <lianux.mm@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Acked-by: Nico Pache <npache@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-khugepaged-fix-comment-for-default-scan-sleep-duration
+++ a/mm/khugepaged.c
@@ -67,7 +67,7 @@ enum scan_result {
 static struct task_struct *khugepaged_thread __read_mostly;
 static DEFINE_MUTEX(khugepaged_mutex);
 
-/* default scan 8*512 pte (or vmas) every 30 second */
+/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
 static unsigned int khugepaged_pages_to_scan __read_mostly;
 static unsigned int khugepaged_pages_collapsed;
 static unsigned int khugepaged_full_scans;
_

Patches currently in -mm which might be from lianux.mm@gmail.com are


