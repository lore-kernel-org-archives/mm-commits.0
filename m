Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F173C10A7
	for <mm-commits@vger.kernel.org>; Tue,  9 Jun 2026 19:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781035115; cv=none; b=MjnIw2VA2xCerqazD5ehi35TmMEOfmZ7tCXzy0kzvds0Lq9sUc/8MJC5HCYErmLFevCOwtuCOmp6nx5bIgyhnLtPrBDSrX+Iueb3Oa0y+Lm16XjJl5+9N6kb6a0NDxoRKzCxXF8H8e27p8UfW0vj9iaOnUQljOj7sCf+EpVVh68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781035115; c=relaxed/simple;
	bh=g3WbZMa/VJPygUy5nXPDUUC4Eb84fVfeODwIyGQonuk=;
	h=Date:To:From:Subject:Message-Id; b=nRbSjrbEIP/pLWz7zFAtYahOVqjHLRpIHo/ZoTxhkAKAeW+7FpyPTetdxAtkNUuG3DS548VyyxA8cyHAX1d9aB9WwFSwAoiaKt8L6rJSwEWNc0km9WAss1nMfsa4G4tWGYIxGR8v55kGWfvluj9Yn+98GUuqauH8DBB0061lDW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KXmYs+xr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KXmYs+xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89801F00893;
	Tue,  9 Jun 2026 19:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781035113;
	bh=ZhShnf12kP5zuJstYVPPvZbmH2IbJrBDYU6pj6uKIY8=;
	h=Date:To:From:Subject;
	b=KXmYs+xrxi2RbEbIwcKWmeEOPAlGvvUFwIIMYWO3HEZAxILenf77ZWLk93KoN3Ihv
	 2gM7SstCdzKJuPKaSNTdJpNuxCNQHuSxYDNKXZna7Du8XlSwQvkRrYEcG/suUtgvkV
	 at9KPPeti6Fwi+/0KqpxIbUarL9/+VN3yV4vr7SY=
Date: Tue, 09 Jun 2026 12:58:33 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,rppt@kernel.org,osalvador@suse.de,muchun.song@linux.dev,mhocko@suse.com,matthew.brost@intel.com,ljs@kernel.org,linmiaohe@huawei.com,lance.yang@linux.dev,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,bhe@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,mst@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-memory-failure-serialize-testsetpagehwpoison-with-zone-lock.patch removed from -mm tree
Message-Id: <20260609195833.A89801F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory-failure: serialize TestSetPageHWPoison with zone->lock
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-serialize-testsetpagehwpoison-with-zone-lock.patch

This patch was dropped because an updated version will be issued

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


