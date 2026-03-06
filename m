Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46C217DFE7
	for <mm-commits@vger.kernel.org>; Fri,  6 Mar 2026 23:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772838552; cv=none; b=TUEN9wWyE44h2vWQYrdhawopZWraFh3GanYNUt0zY1jKOu2Ge4fJTh4x1gNNU2h7t5/Hxco0yLpc7a+k9Hym8FJXYMwQATU8zTldA7BYBl1HaV8kVoQTd0MEevI9ZEWeJj3ERLlUdL5vNT4BNICFjHgYLj3kf/Qf6vD1VIYeWEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772838552; c=relaxed/simple;
	bh=IOrTruQcEc10vIm/kpbx84Yc9kNj6tVrKcRUVcrb/sM=;
	h=Date:To:From:Subject:Message-Id; b=mkKhuYEs1KxJOL49R4OnDCklKcDcazYlqHf3pqCiIrLxGnuM9rmkVbUK1Pz5diq1LgUjdpbtHAzYWAXnmz5xfPwm8SrraVwMPa7f7XQVvrfrSa0po2NDSWr0yiYvtV9QbQWDaS4ug5/ypHWYKIvs+xNfROPAvsMVxljXN9SwF8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g/M/POAt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g/M/POAt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E9EC4CEF7;
	Fri,  6 Mar 2026 23:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772838552;
	bh=IOrTruQcEc10vIm/kpbx84Yc9kNj6tVrKcRUVcrb/sM=;
	h=Date:To:From:Subject:From;
	b=g/M/POAtL/a2U5xEciG2jxNTlA9IRlWGGV934WjzwBesO6pLrBkOGnLSDxhICV6zh
	 exRm0U0D+waliWoq5AOL5SJt7PKdvQl3tkIqZf3fS5sdb0aVI2M+pAuN/r0myqFrot
	 V+LNU7hXF90rvhBcJ31iGmKN4ydkrmPnxtOC5yBE=
Date: Fri, 06 Mar 2026 15:09:11 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,shakeel.butt@linux.dev,riel@surriel.com,rakie.kim@sk.com,npache@redhat.com,mpenttil@redhat.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,byungchul@sk.com,balbirs@nvidia.com,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-document-folio_get-requirement-before-frozen-pmd-split.patch added to mm-new branch
Message-Id: <20260306230912.23E9EC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate_device: document folio_get requirement before frozen PMD split
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate_device-document-folio_get-requirement-before-frozen-pmd-split.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-document-folio_get-requirement-before-frozen-pmd-split.patch

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
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/migrate_device: document folio_get requirement before frozen PMD split
Date: Fri, 6 Mar 2026 02:44:09 -0800

split_huge_pmd_address() with freeze=true splits a PMD migration entry
into PTE migration entries, consuming one folio reference in the process. 
The folio_get() before it provides this reference.

Add a comment explaining this relationship and a VM_WARN_ON_ONCE to catch
an unexpected refcount != 1 entry state.

Link: https://lkml.kernel.org/r/20260306104409.3915811-1-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/migrate_device.c~mm-migrate_device-document-folio_get-requirement-before-frozen-pmd-split
+++ a/mm/migrate_device.c
@@ -908,6 +908,11 @@ static int migrate_vma_split_unmapped_fo
 	unsigned long flags;
 	int ret = 0;
 
+	VM_WARN_ON_ONCE(folio_ref_count(folio) != 1);
+	/*
+	 * take a reference, since split_huge_pmd_address() with freeze = true
+	 * drops a reference at the end.
+	 */
 	folio_get(folio);
 	split_huge_pmd_address(migrate->vma, addr, true);
 	ret = folio_split_unmapped(folio, 0);
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-migrate_device-document-folio_get-requirement-before-frozen-pmd-split.patch

