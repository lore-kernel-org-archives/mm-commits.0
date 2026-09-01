Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C79A4746A9
	for <mm-commits@vger.kernel.org>; Tue,  1 Sep 2026 22:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788300524; cv=none; b=Xx06ZB9Lms9rpRAHhpBGd8djfGTdD2edm51dl5vntifTp+y2jpLDwZWFwkD7m8HXCjc89PznBUqjq09SOZsHErSV98lqpmNUr7ik0lb1tXMIIfRxpS0lRAZWZKgucr3aSu9qkuzqjQO1Ca0f/dWs0bSia8Y9N0HNgPxmqYruldk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788300524; c=relaxed/simple;
	bh=mTxLbs3YHrlL0ivg/kP5g+jbJVDiC+gQh+eObHD5sDM=;
	h=Date:To:From:Subject:Message-Id; b=OWFlPH0VcpowXPmLy/xu5aio4k0ox3GNYIMG0Xx5ogT7IYa7PvQFMMxdUDr2AyalsupRrTQUmS2eqGZo6Y0K4t3c4Ysx9suh6qNmX7EuW1RIqPvDzKQz17dUeOZkFMx6+WKnaWpTGbjqpUwNtaQO0LqFWbQTYxeE4rxJrKpK8MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fW4qb6SC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fW4qb6SC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549A01F00A3E;
	Tue,  1 Sep 2026 22:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788300520;
	bh=NZEk/55vfoJx/fTGJbXv4AGxPX1CqdB4JoVxj12GsnI=;
	h=Date:To:From:Subject;
	b=fW4qb6SC37VZUoN9255ul/t4t3viU/n8UACpNFnWD0VUlJRGijQOyZN0Crho+HGVv
	 DMbo1h6+6G2hHvRiSsrQrjvYoPOjcVtSBL3mMBDbu8ViDNawRVojZfLaWEyJwFcwOc
	 TZz3oNy0dOBXFahh5TmPLBaZYQiq3yjEevn6jT8I=
Date: Tue, 01 Sep 2026 15:08:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,zhaozhengzhuo@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-fix-function-name-in-kernel-doc.patch added to mm-new branch
Message-Id: <20260901220840.549A01F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate_device: fix function name in kernel-doc
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate_device-fix-function-name-in-kernel-doc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-fix-function-name-in-kernel-doc.patch

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
mm-migrate_device-fix-function-name-in-kernel-doc.patch

