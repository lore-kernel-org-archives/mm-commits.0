Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D802F745C
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 18:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781028912; cv=none; b=cuSoh6VKkW/JI38+XnwCYd54ASt/8ZkdiHYgpSMsCicP8AtEGNEpwmcnv80ejzuFxILS+454XLjhExhnHBwn40I3qWwWkBWzZTL0R1UzWNY75gwVK+atJceHftnwfTqFHSu2/WZE5isgYnr9SaSJyRZmSEoCooFvDirG4zrtRRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781028912; c=relaxed/simple;
	bh=u9s7pt1O/WVdOw/rTn9797JtOnVMsjDCNENNh7JnPCQ=;
	h=Date:To:From:Subject:Message-Id; b=CKI0jINXT7x73NlHjNRSVXIVqq9plxm+yJxN4fWVYtKHWNDH0KyVx1xLZAXXUkY9dTCB10TI1D4+84E3AwuWHmiDw/P/5vdGjWmORA197UFw8H1KTKgBzQ3Z2ahEpG0Y/MWVrJzoQ4Qwqot8KF9OZZ35427WAIorP6kXfkyDM0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=msGEyjOs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="msGEyjOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2044D1F00893;
	Tue,  9 Jun 2026 18:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781028911;
	bh=eRN+FIaasFF+XeLBQhnCz1o8evtgXsANlCsFrZxDAFY=;
	h=Date:To:From:Subject;
	b=msGEyjOsEcN2uxOo63nrXiJ+jaUuV1/0cdZaUl8EdJp/x9ADSJzArtuH7DPHFRLqC
	 8/49NSAGffRn8mZ/aUEFUelAtV6k1wc/RtDDjj3PKp/fn+UzOnrxGmqq8dpB1fBs70
	 vWtIVfQ1p3WCs6g1bz8qu80Z3hZSJnvfBPVW5qWA=
Date: Tue, 09 Jun 2026 11:15:10 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,linmiaohe@huawei.com,lance.yang@linux.dev,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,mst@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-serialize-testsetpagehwpoison-with-zone-lock.patch added to mm-unstable branch
Message-Id: <20260609181511.2044D1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: memory-failure: serialize TestSetPageHWPoison with zone->lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-serialize-testsetpagehwpoison-with-zone-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-serialize-testsetpagehwpoison-with-zone-lock.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: mm: memory-failure: serialize TestSetPageHWPoison with zone->lock
Date: Tue, 9 Jun 2026 06:12:49 -0400

TestSetPageHWPoison() is called without zone->lock, so its atomic update
to page->flags can race with non-atomic flag operations that run under
zone->lock in the buddy allocator.

In particular, __free_pages_prepare() does:

    page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;

This non-atomic read-modify-write, while correctly excluding __PG_HWPOISON
from the mask, can still lose a concurrent TestSetPageHWPoison if the read
happens before the poison bit is set and the write happens after.  Will
only get worse if/when we add more non-atomic flag operations.

Fix by acquiring zone->lock around TestSetPageHWPoison and around
ClearPageHWPoison in the retry path.  This serializes with all buddy flag
manipulation.  The cost is negligible: one lock/unlock in an extremely
rare path (hardware memory errors).

Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere in this
file operate on pages already removed from the buddy allocator or on
non-buddy pages (DAX, hugetlb), so they do not need zone->lock protection.

Link: https://lore.kernel.org/df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com
Fixes: 6a46079cf57a ("HWPOISON: The high level memory error handler in the VM v7")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failure-serialize-testsetpagehwpoison-with-zone-lock
+++ a/mm/memory-failure.c
@@ -2335,6 +2335,8 @@ int memory_failure(unsigned long pfn, in
 	int res = 0;
 	unsigned long page_flags;
 	bool retry = true;
+	struct zone *zone;
+	unsigned long mf_flags;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -2380,7 +2382,11 @@ try_again:
 	if (res != -ENOENT)
 		goto unlock_mutex;
 
+	/* Serialize with non-atomic buddy flag operations */
+	zone = page_zone(p);
+	spin_lock_irqsave(&zone->lock, mf_flags);
 	if (TestSetPageHWPoison(p)) {
+		spin_unlock_irqrestore(&zone->lock, mf_flags);
 		res = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
 			res = kill_accessing_process(current, pfn, flags);
@@ -2389,6 +2395,7 @@ try_again:
 		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		goto unlock_mutex;
 	}
+	spin_unlock_irqrestore(&zone->lock, mf_flags);
 
 	/*
 	 * We need/can do nothing about count=0 pages.
@@ -2410,7 +2417,10 @@ try_again:
 			} else {
 				/* We lost the race, try again */
 				if (retry) {
+					/* Serialize with non-atomic buddy flag operations */
+					spin_lock_irqsave(&zone->lock, mf_flags);
 					ClearPageHWPoison(p);
+					spin_unlock_irqrestore(&zone->lock, mf_flags);
 					retry = false;
 					goto try_again;
 				}
_

Patches currently in -mm which might be from mst@redhat.com are

mm-memory-failure-serialize-testsetpagehwpoison-with-zone-lock.patch

