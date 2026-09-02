Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A864195A0
	for <mm-commits@vger.kernel.org>; Wed,  2 Sep 2026 22:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788389472; cv=none; b=ErNzHB93Is6b11ayz994DmEYVi2XKXxCIZDlGB9p3yr1e6+I/rL/C8ztm0Wpm6JcU1Ryxi7n0+7k3DaEBsXVbqrKEAmYN660tTPFViyyzRjr5/YGi4Bx/wteDrbiD9x2r/JV4vQtzdg/d+P4BzOYkXp3ZdNkW6UWslvy5QqV9Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788389472; c=relaxed/simple;
	bh=uxEBcOUJU611ArD2ALKzt/fdj/HJEcR9cnxIJX2jJwQ=;
	h=Date:To:From:Subject:Message-Id; b=C5DbJm2jA44HykS9I3LwZWEa/6g+7gjtvsdiT2ubOw81l6Yw2cKcONDTYxAB6BEHzo6hOqs0ddKupLXeA4WNylJVS9YFTZw4oS8wtBQpwDrY9E4yWdvghnBgSe0zqOmC3BWhnifXCAPAP8s6PfgsURD5zrMjssVr6VpAApNmxuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sXUmHwq2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sXUmHwq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57E21F000E9;
	Wed,  2 Sep 2026 22:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788389461;
	bh=ISzpSuu3fIaUkFGVE7ja7lI1OKWHrVfada84C3YoGSI=;
	h=Date:To:From:Subject;
	b=sXUmHwq2hdNf+PAKhFZhYjP71N1sLpCDUkptVF4QiUJ9JJ8KQCds1qcoE5oyLZDPM
	 SpvaRiXY7C4ZCBvy+uTvMjvKpy2xFej6JJqbbll3ThOsJOgy09qIoyK+r4ydwHpVit
	 V9Og55mTc68QLJWlihhH7ARXvF7SMapoGoJhfypw=
Date: Wed, 02 Sep 2026 15:51:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,zhaozhengzhuo@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-fix-function-name-in-kernel-doc.patch added to mm-new branch
Message-Id: <20260902225101.C57E21F000E9@smtp.kernel.org>
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
Date: Wed, 2 Sep 2026 11:12:29 +0800

The kernel-doc for migrate_device_range() says that migrate_vma_setup() is
similar to itself.  Refer to migrate_device_range() as the subject of the
comparison, making the distinction between virtual-address-based and
device-PFN-based migration clear.

Link: https://lore.kernel.org/13768B0F4A5FC1F5+20260902031229.1821112-1-zhaozhengzhuo@uniontech.com
Fixes: e778406b40db ("mm/migrate_device.c: add migrate_device_range()")
Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
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
+ * that instead of looking up pages based on virtual address mappings, a range
+ * of device pfns that should be migrated to system memory is used.
  *
  * This is useful when a driver needs to free device memory but doesn't know the
  * virtual mappings of every page that may be in device memory. For example this
_

Patches currently in -mm which might be from zhaozhengzhuo@uniontech.com are

selftests-damon-prevent-remaining-cross-object-state-pollution.patch
mm-migrate_device-fix-function-name-in-kernel-doc.patch

