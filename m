Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5993F3FA5F0
	for <mm-commits@vger.kernel.org>; Fri,  9 Oct 2026 05:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791525380; cv=none; b=t6/HtAnCc8zfykEYzueVWVqLFccXF9yoy/yKOWppGR+vms4NMZxJUFrbBkkYQhbUW5bfDScn6l2G1Gmk8jOkDhR4QP0Rg9kvR58slKsnm1hS7s13ATM3CVAoVnqm4Bf1eLp14qzexO9tdbSJqVoj24QXyx6oGcTdM8o02ovWGOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791525380; c=relaxed/simple;
	bh=nqpg/NwnrFlJHR8Z+oqcjPSrG3zXEyo2rFbiAvJOO9U=;
	h=Date:To:From:Subject:Message-Id; b=l01xZwttgkp4Ii8kpkKATiA0XvgLQtP8/sXfYax5uqZZ61aAKSisDOAyyR3sX5S1oD3UvDvMV2Xf4DqcEuRYKfZ82K9OmG1R+ZJazzIpKCCwrRL6d/EU1QsfwDnQje8xvCYciWkTRmlkXudCLV1AR7j5q9onlUKHVYjVshBEbiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h3RCNMqo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h3RCNMqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDCF1F000FF;
	Fri,  9 Oct 2026 05:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791525379;
	bh=b3ugJvbZaf4EGSJcsraEQfCI5kB0RlZ2WHq3UUz7DNg=;
	h=Date:To:From:Subject;
	b=h3RCNMqo9pfYgkX49abG11D+l7K7Fy837XWJSk27uCUT2s+2Kyqo/h/fOuwVgBaz1
	 sgADyezacagybFvJwb4RqoKqxqIGgja+RHGB9vx1Ne+xsFIZHUYluzIbP+jn4mNvm5
	 Wf/PWE7HQq3GX3X0XFX964SmOMYFNBcbSwhgAXtA=
Date: Thu, 08 Oct 2026 22:56:18 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,zhaozhengzhuo@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-fix-function-name-in-kernel-doc.patch removed from -mm tree
Message-Id: <20261009055619.2FDCF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: fix function name in kernel-doc
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-fix-function-name-in-kernel-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: mm/migrate_device: fix function name in kernel-doc
Date: Wed, 2 Sep 2026 11:12:29 +0800

The kernel-doc for migrate_device_range() says that migrate_vma_setup() is
similar to itself.  Refer to migrate_device_range() as the subject of the
comparison, making the distinction between virtual-address-based and
device-PFN-based migration clear.

Link: https://lore.kernel.org/13768B0F4A5FC1F5+20260902031229.1821112-1-zhaozhengzhuo@uniontech.com
Fixes: e778406b40db ("mm/migrate_device.c: add migrate_device_range()")
Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
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
+ * that instead of looking up pages based on virtual address mappings, a range
+ * of device pfns that should be migrated to system memory is used.
  *
  * This is useful when a driver needs to free device memory but doesn't know the
  * virtual mappings of every page that may be in device memory. For example this
_

Patches currently in -mm which might be from zhaozhengzhuo@uniontech.com are


