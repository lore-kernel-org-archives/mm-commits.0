Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F0C445AC6
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 22:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788389419; cv=none; b=NCc1yq0lCxNHn6yHtYlz0GnZ5ud3xnpYpZXo/iEEr9PsVHkAEOz3+yOyor/SKQDdjgff+jpev/IywjXAxdPx1mxjPwyM5jqPpT2wtrSQ8ae65nma2rmWFRj9JYXoy6yfKvjBZeygWDHX0AJvvnkBwGkJCh0/WujcwiYfxYFoqlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788389419; c=relaxed/simple;
	bh=cO60hv9Oq4VhAQ6sK3OeXMby5wn/yamKfji0xVTBeZ8=;
	h=Date:To:From:Subject:Message-Id; b=cLN/nMiWiksoTVPTe7vVdL+Ei34dhimv4/WYObrmxL1OfvIiun0vmM8whfv3i4Tj3zchMDu2dvj/7r70gNmXpJFaxv9+ysyy23OPim6i4yZGJ1LAOLs59EP2/1xidKCQkBOdFqXwZLQjH/joFcr+B1ZXDCIVSmOUMVPIWi+c8dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1N6RSNCs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1N6RSNCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA0D1F000E9;
	Wed,  2 Sep 2026 22:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788389410;
	bh=tlTkaegBhqiViRWfrO4bfdXqsLMKJHBfhIvJ3aZJHTs=;
	h=Date:To:From:Subject;
	b=1N6RSNCsS7LbJkExHNsRdap7auE+Rnbh8Q1fmk4S1Gu51CJku1rat2hEVewKU0NlI
	 TFwPUkJmeBJtu3mdRrnXud/j4VOXP5zq2XcPPYlC1TxN02oKtuwTrYwxaFhnrPtIKa
	 jFkPXNbpWiC/T+TdFAOJGUp9z4vjR3VRyVZOGa18=
Date: Wed, 02 Sep 2026 15:50:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,zhaozhengzhuo@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-migrate_device-fix-function-name-in-kernel-doc.patch removed from -mm tree
Message-Id: <20260902225010.1BA0D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: fix function name in kernel-doc
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-fix-function-name-in-kernel-doc.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: mm/migrate_device: fix function name in kernel-doc
Date: Tue, 1 Sep 2026 14:51:31 +0800

The kernel-doc for migrate_device_range() says that migrate_vma_setup() is
similar to itself.  Refer to migrate_device_range() as the subject of the
comparison, making the distinction between virtual-address-based and
device-PFN-based migration clear.

Link: https://lore.kernel.org/7D206FC95BDCAA0F+20260901065131.1759298-1-zhaozhengzhuo@uniontech.com
Fixes: e778406b40db ("mm/migrate_device.c: add migrate_device_range()")
Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-fix-function-name-in-kernel-doc
+++ a/mm/migrate_device.c
@@ -1398,9 +1398,9 @@ static unsigned long migrate_device_pfn_
  * @start: starting pfn in the range to migrate.
  * @npages: number of pages to migrate.
  *
- * migrate_vma_setup() is similar in concept to migrate_vma_setup() except that
- * instead of looking up pages based on virtual address mappings a range of
- * device pfns that should be migrated to system memory is used instead.
+ * migrate_device_range() is similar in concept to migrate_vma_setup(), except
+ * that instead of looking up pages based on virtual address mappings a range
+ * of device pfns that should be migrated to system memory is used instead.
  *
  * This is useful when a driver needs to free device memory but doesn't know the
  * virtual mappings of every page that may be in device memory. For example this
_

Patches currently in -mm which might be from zhaozhengzhuo@uniontech.com are

selftests-damon-prevent-remaining-cross-object-state-pollution.patch

