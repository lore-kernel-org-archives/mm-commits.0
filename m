Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7F61FAA
	for <mm-commits@vger.kernel.org>; Fri,  6 Jun 2025 05:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749186178; cv=none; b=q72TyaJtTzkBYXyj26wn5eZBSWCUgG8GJ0IABkOetF1Oi8IEMIF96L0aaskN7qTAoUrBP71l8kYBzBmsIXUHCC59wCJchStKCPtgRS4LvAtVKW7nQxBOf0LjVZ/w0LPtSVdoOQbBkT/VuzoZ9qgGKHWT52bCdoaQQsugMae1tQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749186178; c=relaxed/simple;
	bh=B6+jAMp9K98iJY9AHOdlggCWjdgzfQyoLPLOqMnMccs=;
	h=Date:To:From:Subject:Message-Id; b=IJPffpWv77vcRapJOp9AKRP0mJnjFi1UqQHC+9xrHK/RuYDWNd3PnYjuH9kkSNnIZr/c1mycQtXLvakHJazUerAjYD7s0uhsxCdlHYeHtjDTrLZDH7RAy0uq34mtP1g+R94GWQwjUV8tFq8j3JDhuYBhz98BjnivJllpUJBWKKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OJHXNIR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OJHXNIR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21783C4CEEB;
	Fri,  6 Jun 2025 05:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749186178;
	bh=B6+jAMp9K98iJY9AHOdlggCWjdgzfQyoLPLOqMnMccs=;
	h=Date:To:From:Subject:From;
	b=OJHXNIR4CMm3ZIHy4QN4rNuLvtzNSAyTsXxAC24KDjPLt9nbUWbq+yPGbXgCFpfWd
	 ivm5GG4FqKQicwwCxMImFb/8W184xNVov/v699uW3i5nPcPJ2Dc8S1qeS6pwjA7DuZ
	 im65s7U+IO+KeUEw04bsAQkQCtxV+S+/HzW1qw1c=
Date: Thu, 05 Jun 2025 22:02:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,rakie.kim@sk.com,matthew.brost@intel.com,lorenzo.stoakes@oracle.com,joshua.hahnjy@gmail.com,david@redhat.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] maintainers-add-myself-as-reviewer-of-mm-memory-policy.patch removed from -mm tree
Message-Id: <20250606050258.21783C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: MAINTAINERS: add Alistair as reviewer of mm memory policy
has been removed from the -mm tree.  Its filename was
     maintainers-add-myself-as-reviewer-of-mm-memory-policy.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: MAINTAINERS: add Alistair as reviewer of mm memory policy
Date: Fri, 30 May 2025 11:49:17 +1000

I'm particularly familiar with mm/migrate.c and especially
mm/migrate_device.c so add myself to MAINTAINERS.

Link: https://lkml.kernel.org/r/20250530014917.2946940-1-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Matthew Brost <matthew.brost@intel.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

--- a/MAINTAINERS~maintainers-add-myself-as-reviewer-of-mm-memory-policy
+++ a/MAINTAINERS
@@ -15744,6 +15744,7 @@ R:	Rakie Kim <rakie.kim@sk.com>
 R:	Byungchul Park <byungchul@sk.com>
 R:	Gregory Price <gourry@gourry.net>
 R:	Ying Huang <ying.huang@linux.alibaba.com>
+R:	Alistair Popple <apopple@nvidia.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
_

Patches currently in -mm which might be from apopple@nvidia.com are

mm-remove-pfn_map-pfn_special-pfn_sg_chain-and-pfn_sg_last.patch

