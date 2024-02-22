Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE251CD10
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644470; cv=none; b=GaPVG1QiQN4Q1WNTD5YLVuZTTJrQrjQee9YCxBh0QmFZunIvt5RSClo4AIHS7aoXnTbt2cK+CuVaNAdFTHCU5msSVELgP78NFMjjCuObdVqkA6cwl3tU71Ytg3oIkI+qMN5p1kBi+lAir4fn0ncwiojeEadPu7/d/HCQfJFxSOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644470; c=relaxed/simple;
	bh=3uizSxTn0H32jKj3VFdKfc5iAhlDj+cBj7XTPoXtuJQ=;
	h=Date:To:From:Subject:Message-Id; b=eWK8lXL9UGdBL/YWefQQhBQi0qOMpIQLx/r7jS1SIeWL4JoHp6zicQ3qYQdlVHOy+r5rE9e9wHQ1uOWMYoY9wR2Xls9I+6NkTBAK55XzawSPnR77QQtj3bmffxTvJU0zAPM2kxoTY89PRS4djtbPNgFLM3U2v3c75c8zP7f2RTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b82f2QWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b82f2QWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F83C433F1;
	Thu, 22 Feb 2024 23:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644469;
	bh=3uizSxTn0H32jKj3VFdKfc5iAhlDj+cBj7XTPoXtuJQ=;
	h=Date:To:From:Subject:From;
	b=b82f2QWOvnqx4Xq1Mbe8F5DF2Ui4ibsCi46rofcd/UYzRiBQidI1tE+EEvSaPgEhb
	 wEMo9fwKtLysqUfbD/g8Cx+VrGqoDHrzSpHvgZpWGSDgcS7ctwT33UY9ilYeomGb21
	 k3Go6suhcLYMv7GKd/YlJRAdVK04nM2Tf4WF7GX8=
Date: Thu, 22 Feb 2024 15:27:49 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@suse.cz,mgorman@techsingularity.net,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-compaction-limit-the-suitable-target-page-order-to-be-less-than-cc-order.patch removed from -mm tree
Message-Id: <20240222232749.B3F83C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: compaction: limit the suitable target page order to be less than cc->order
has been removed from the -mm tree.  Its filename was
     mm-compaction-limit-the-suitable-target-page-order-to-be-less-than-cc-order.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: compaction: limit the suitable target page order to be less than cc->order
Date: Mon, 22 Jan 2024 21:01:53 +0800

It can not improve the fragmentation if we isolate the target free pages
exceeding cc->order, especially when the cc->order is less than
pageblock_order.  For example, suppose the pageblock_order is MAX_ORDER
(size is 4M) and cc->order is 2M THP size, we should not isolate other 2M
free pages to be the migration target, which can not improve the
fragmentation.

Moreover this is also applicable for large folio compaction.

Link: https://lkml.kernel.org/r/afcd9377351c259df7a25a388a4a0d5862b986f4.1705928395.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/compaction.c~mm-compaction-limit-the-suitable-target-page-order-to-be-less-than-cc-order
+++ a/mm/compaction.c
@@ -1365,12 +1365,14 @@ static bool suitable_migration_target(st
 {
 	/* If the page is a large free page, then disallow migration */
 	if (PageBuddy(page)) {
+		int order = cc->order > 0 ? cc->order : pageblock_order;
+
 		/*
 		 * We are checking page_order without zone->lock taken. But
 		 * the only small danger is that we skip a potentially suitable
 		 * pageblock, so it's not worth to check order for valid range.
 		 */
-		if (buddy_order_unsafe(page) >= pageblock_order)
+		if (buddy_order_unsafe(page) >= order)
 			return false;
 	}
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are


