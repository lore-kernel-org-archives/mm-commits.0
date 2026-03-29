Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647CC255E43;
	Sun, 29 Mar 2026 00:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744887; cv=none; b=seSYooj82O+A368nwrhSC1Cs0On0wSD3vliDqQfsM+40Mh+HfTe9Xn/a9qOOx4yJz73dcywml75LQ3G8ysxqhMJiAswWbvWJtmc3jhjutolGhB2wHAQ4/GCyBwWWSVsDTR5vVxpsNc8RAnbIyV7pv/h6FPAcT9fXTVG05sUpHQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744887; c=relaxed/simple;
	bh=jy26vQCZLLxEXqRJ73cfVKDi71kp2lJ4cdFZMYVTAk0=;
	h=Date:To:From:Subject:Message-Id; b=qXJMS5TaAODk4acCjpGTmZ2s4B8iIOlvV4FrB/YO4/D8IApSeFiEVUK2sFoduwlZbiBqZkKeHpQrYlmvWFA/Ccy1V7KZYuYBR9114+NrLse4pCpQeVE+ojSptWJrhh6Gk5Wgtds63xeu4j8KxgchVrTKHQfpiG+tr4uC2GTxZ6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aZTmjcCr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aZTmjcCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334D2C4CEF7;
	Sun, 29 Mar 2026 00:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744887;
	bh=jy26vQCZLLxEXqRJ73cfVKDi71kp2lJ4cdFZMYVTAk0=;
	h=Date:To:From:Subject:From;
	b=aZTmjcCridaEWvVs6pp2MXyNsczBqjH4iZN7B//jU7oZu9SKTyVfHtWldn6LEyrPo
	 1cPgz+X4TbyKPRfh3Vv6mbdCZ/9/zNTA0TmjvHb2VAZOcnDlicHmP9K1K6+W/6loQd
	 LHjvRwTLFU2vbk/EnzN3fa6Ov83b+LHKr11i9z6o=
Date: Sat, 28 Mar 2026 17:41:26 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,willy@infradead.org,stable@vger.kernel.org,sj@kernel.org,richard.weiyang@gmail.com,rakie.kim@sk.com,npache@redhat.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-requeue-destination-folio-on-deferred-split-queue.patch removed from -mm tree
Message-Id: <20260329004127.334D2C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate: requeue destination folio on deferred split queue
has been removed from the -mm tree.  Its filename was
     mm-migrate-requeue-destination-folio-on-deferred-split-queue.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: migrate: requeue destination folio on deferred split queue
Date: Thu, 12 Mar 2026 03:47:23 -0700

During folio migration, __folio_migrate_mapping() removes the source folio
from the deferred split queue, but the destination folio is never
re-queued.  This causes underutilized THPs to escape the shrinker after
NUMA migration, since they silently drop off the deferred split list.

Fix this by recording whether the source folio was on the deferred split
queue and its partially mapped state before move_to_new_folio() unqueues
it, and re-queuing the destination folio after a successful migration if
it was.

By the time migrate_folio_move() runs, partially mapped folios without a
pin have already been split by migrate_pages_batch().  So only two cases
remain on the deferred list at this point:
  1. Partially mapped folios with a pin (split failed).
  2. Fully mapped but potentially underused folios.  The recorded
     partially_mapped state is forwarded to deferred_split_folio() so that
     the destination folio is correctly re-queued in both cases.

Because THPs are removed from the deferred_list, THP shinker cannot
split the underutilized THPs in time.  As a result, users will show
less free memory than before.  

Link: https://lkml.kernel.org/r/20260312104723.1351321-1-usama.arif@linux.dev
Fixes: dafff3f4c850 ("mm: split underused THPs")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/mm/migrate.c~mm-migrate-requeue-destination-folio-on-deferred-split-queue
+++ a/mm/migrate.c
@@ -1358,6 +1358,8 @@ static int migrate_folio_move(free_folio
 	int rc;
 	int old_page_state = 0;
 	struct anon_vma *anon_vma = NULL;
+	bool src_deferred_split = false;
+	bool src_partially_mapped = false;
 	struct list_head *prev;
 
 	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
@@ -1371,6 +1373,12 @@ static int migrate_folio_move(free_folio
 		goto out_unlock_both;
 	}
 
+	if (folio_order(src) > 1 &&
+	    !data_race(list_empty(&src->_deferred_list))) {
+		src_deferred_split = true;
+		src_partially_mapped = folio_test_partially_mapped(src);
+	}
+
 	rc = move_to_new_folio(dst, src, mode);
 	if (rc)
 		goto out;
@@ -1391,6 +1399,15 @@ static int migrate_folio_move(free_folio
 	if (old_page_state & PAGE_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
+	/*
+	 * Requeue the destination folio on the deferred split queue if
+	 * the source was on the queue.  The source is unqueued in
+	 * __folio_migrate_mapping(), so we recorded the state from
+	 * before move_to_new_folio().
+	 */
+	if (src_deferred_split)
+		deferred_split_folio(dst, src_partially_mapped);
+
 out_unlock_both:
 	folio_unlock(dst);
 	folio_set_owner_migrate_reason(dst, reason);
_

Patches currently in -mm which might be from usama.arif@linux.dev are


