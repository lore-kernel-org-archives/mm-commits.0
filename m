Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DAB13DDAE
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 18:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783621440; cv=none; b=RGqfOXVc2sr+1DFlpV1ziOf/ZeZJwT3VXGd9S3CqY3vOZ8ggK53cvC7enOcdUoK17Ridb5t3UwiuaQJN79B3LFRyQQrjF6Yl9HxMaDuPZrY9fMg9ChB5hb7Kkc8Fqr+ZJxaDvySZu19kmP3LqEsQdGez2x82rfefvdaVxtgpDWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783621440; c=relaxed/simple;
	bh=7/zuMRBQ3YjrYXHG3tMeMQ5KMUOhR/YHV+LjpihuCKI=;
	h=Date:To:From:Subject:Message-Id; b=ikg/qzT06JXZn2wF5NU4w7vVK88nQUUQlOxXOv7OPo7xUfC09pV6sBCtGdF17umAmzUOEiKHvHN5Nvo2aa4fdexUG2pgT6ly+JP1RBtqSKJQkwmLniObeUjCZZGM6BlQoNsyzfvz1ZJ3H3eHDiVzPtkiDh2DE7UzUu1AIYzrml0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0K41vSRw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0K41vSRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A821F00A3D;
	Thu,  9 Jul 2026 18:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783621439;
	bh=VOUNU1/2qD/7lX+xBk66Rz61tlDw/OkwqIWMkG0yzu0=;
	h=Date:To:From:Subject;
	b=0K41vSRwb7kMUHFveUtw8Hj+q7j4IqmWWDeFJ3SvvD3oAa6wxU0pp6C1xsTbic84u
	 8C90tb1R/n7tTlb/ECd42HZ513cAZswerxqC/xOElazFSCjpj9RE2W2EIS0InkglWN
	 66+eeWpdM7ZcsF5dgDrbPb1R5xBUCAOHcwoI1oRE=
Date: Thu, 09 Jul 2026 11:23:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-compaction-stop-recording-free-page-order-in-page-private.patch removed from -mm tree
Message-Id: <20260709182359.18A821F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/compaction: stop recording free page order in page->private
has been removed from the -mm tree.  Its filename was
     mm-compaction-stop-recording-free-page-order-in-page-private.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/compaction: stop recording free page order in page->private
Date: Fri, 03 Jul 2026 09:47:47 -0400

Commit 733aea0b3a7bb ("mm/compaction: add support for >0 order folio
memory compaction.") stores isolated free pages in an array indexed by
free page orders, it is no longer needed to store the order in each page's
->private field.  And there is no code using the stored order.  Stop doing
that.

It also prepares for an upcoming change that ensures subpage->private is
zero at page free time and the removal of set_page_private(0) from
prep_compound_tail().

Link: https://lore.kernel.org/20260703-keep-subpage-private-zero-at-free-v2-2-2970fe777dd6@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/compaction.c~mm-compaction-stop-recording-free-page-order-in-page-private
+++ a/mm/compaction.c
@@ -645,7 +645,6 @@ static unsigned long isolate_freepages_b
 		isolated = __isolate_free_page(page, order);
 		if (!isolated)
 			break;
-		set_page_private(page, order);
 
 		nr_scanned += isolated - 1;
 		total_isolated += isolated;
@@ -1618,7 +1617,6 @@ static void fast_isolate_freepages(struc
 		/* Isolate the page if available */
 		if (page) {
 			if (__isolate_free_page(page, order)) {
-				set_page_private(page, order);
 				nr_isolated = 1 << order;
 				nr_scanned += nr_isolated - 1;
 				total_isolated += nr_isolated;
@@ -1847,7 +1845,6 @@ again:
 		size >>= 1;
 
 		list_add(&freepage[size].lru, &cc->freepages[start_order]);
-		set_page_private(&freepage[size], start_order);
 	}
 	dst = (struct folio *)freepage;
 
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_owner-add-numa-node-filter-fix.patch
mm-huge_memory-add-page-private-check-back-in-__split_folio_to_order.patch
mm-page_alloc-make-sure-tail_page-private-is-zero-at-page-free-time.patch
mm-page_alloc-remove-set_page_private-in-prep_compound_tail.patch

