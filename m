Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793156804;
	b=RkJdyh2tLr/Ry6MDzPv0eGPBKhzun0xaTKzD/7zC6AdDaOCdo7jlXNCAIq4aCkmDcocc
	 uX1ZFSz79mVBmSe51S/Kp6za/1PxCfZAprslX+u8AaAbUgcZDSoEiWjzI5eXZtfIU/7Ys
	 eam8jHZ2m5s2Kxr5R28w9Y2RAyvRd3x2psIpDwY8sm6sJp16gjK+Fdh/Rs24hKYL9alNg
	 9qqw7n0ksHMV7+9vzvcGbucQh3TDMeWJHFYa4FdSUWS4wr4pV7bMtUWzPqaap6uTRtaau
	 xpstmOnt7EucCLGYo44NwLFzOYWSVbZaxBaphuI2eAc7EXyE26YqotkAwDdzOe35Y3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793156804;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=DBdwUfsBdMvdd05UGfYk/F/suUI6kx3MJW4W4fl1LvM=;
	b=iBS+2AbzLStd/pPrNYWjJ8k2U76A6+dXLTxB6bDnCrKqIpcXVAe3OHOZT7Kin0rli7JN
	 gxTyhxNoNPUgcPvE5v5hU3zY4yFbQ86wSIsAKvHjANhb7GOBAHtxn1SzT7wLIWnRQjDLV
	 0VXqB0mTYv9yMnLnPeB7wRsQohqVJ6NGVaFxtkIG61UoAxw20tecckTIy1789QSIO0Map
	 T62V9HlFFbcgZohBMhcwJUOeKNQ9a8tZzClj0Qy3ydLJBAyVLwIHCimEIg06MRTPr/iM2
	 16MXe4j6slQgtHR8E3ZVykoX7e9SSZ3wbV+hUok2kIacNTvFPC+2Z34NRVVYl3Po63g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uu86d0hq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549BB606A31A
	for <mm-commits@vger.kernel.org>; Wed, 28 Oct 2026 03:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=uu86d0hq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB321F01828;
	Wed, 28 Oct 2026 03:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793156803;
	bh=DBdwUfsBdMvdd05UGfYk/F/suUI6kx3MJW4W4fl1LvM=;
	h=Date:To:From:Subject;
	b=uu86d0hqGKcPu0lKJsl8ay2gyday69NI/bQleZIYXmT1tORik9rJm7m+7rn+n+WWy
	 /SAtNugJlFZBh8wxcdU5gCX8koqvw+2v0ZUG1r8+8slk20YjRWfIP4CG9DhthLeNuS
	 WcbepJAR+m/yOYsLDubLcFA3xNHzcmSPhh4yh2AQ=
Date: Tue, 27 Oct 2026 20:06:43 -0700
To: mm-commits@vger.kernel.org,josef@toxicpanda.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-page_isolation-do-not-take-slab-pages-for-free.patch removed from -mm tree
Message-Id: <20261028030643.BFB321F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: page_isolation: do not take slab pages for free
has been removed from the -mm tree.  Its filename was
     mm-page_isolation-do-not-take-slab-pages-for-free.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Josef Bacik <josef@toxicpanda.com>
Subject: mm: page_isolation: do not take slab pages for free
Date: Tue, 27 Oct 2026 16:46:33 +0100

page_is_unmovable() regards a page with a reference count of zero as free
or about to be freed. Since slab allocates frozen pages, they will
be wrongly considered to be freed if order 0 (higher-order compound
pages are caught earlier).

If such slabs are the only unmovable pages of a memory block, memory
offlining now isolates the block, this can lead to offline_pages()
looping without progress.

Thus detect the slab pages as removable to return -EBUSY, as would
happen before commit 9aec2fb0fd5e ("slab: allocate frozen pages").

Link: https://lore.kernel.org/20261027-pgalloc-ai-hotfixes-v1-7-9c7d1aca801e@kernel.org
Fixes: 9aec2fb0fd5e ("slab: allocate frozen pages")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Zi Yan <ziy@nvidia.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>
---

 mm/memory_hotplug.c |    7 +++++++
 mm/page_isolation.c |    7 +++++++
 2 files changed, 14 insertions(+)

--- a/mm/memory_hotplug.c~mm-page_isolation-do-not-take-slab-pages-for-free
+++ a/mm/memory_hotplug.c
@@ -1847,6 +1847,13 @@ static int scan_movable_pages(unsigned l
 		if (PageOffline(page) && page_count(page))
 			return -EBUSY;
 
+		/*
+		 * A page that was allocated, but was not a slab page yet, when
+		 * its pageblock was isolated.
+		 */
+		if (PageSlab(page))
+			return -EBUSY;
+
 		folio = page_folio(page);
 		if (!folio_test_hugetlb(folio))
 			continue;
--- a/mm/page_isolation.c~mm-page_isolation-do-not-take-slab-pages-for-free
+++ a/mm/page_isolation.c
@@ -75,6 +75,13 @@ bool page_is_unmovable(struct zone *zone
 	}
 
 	/*
+	 * Slab pages are frozen: do not take their reference count of zero
+	 * for that of a free page.
+	 */
+	if (PageSlab(page))
+		return true;
+
+	/*
 	 * We can't use page_count without pin a page
 	 * because another CPU can free compound page.
 	 * This check already skips compound tails of THP
_

Patches currently in -mm which might be from josef@toxicpanda.com are

mm-memory_hotplug-resize-zones-under-their-seqlock.patch
mm-page_alloc-check-pageblock-pfns-under-span-seqlock.patch
mm-filemap-dont-lose-a-folio-lock-wakeup-to-a-signal.patch

