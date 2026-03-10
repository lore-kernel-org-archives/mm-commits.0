Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9382C3B38A9
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 16:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773161441; cv=none; b=JqeK9hQIlEwmYLfE9hPg5xwMds+nsPNdMOKqyetBwTPQZOkRRz3VqpO/C7jpydZXXrRP+QCaJmo7Bz9Z359y0PN+0wBVIYs2h5FgO30Vuq2pnf8M5ckP+pI1gAumzfvN4JtZc+VWDg8QO68cLPnb5+pfPA/3UlYGDqnBk3NUtjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773161441; c=relaxed/simple;
	bh=O8jPwTqfC8L8+eMEteGv58DpdvRmpPdr0AEqDZSHEpg=;
	h=Date:To:From:Subject:Message-Id; b=dsZ3WunZvwAisuOKpWxIs5DL2fE2u5oYruNzqCTAPi4t8bN+L0E8BHBbNm4FW/8kbgzWID2nO35acVYNAYW5Doa9HeS6ie7foyqFpreIzRAgPoHYY2+5CLQi89oJocXzfyS+M0zpilrR3QziDDmLtX2LjTI+6kPli2jN97jJ7Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N/Et44A9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N/Et44A9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B863C19423;
	Tue, 10 Mar 2026 16:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773161441;
	bh=O8jPwTqfC8L8+eMEteGv58DpdvRmpPdr0AEqDZSHEpg=;
	h=Date:To:From:Subject:From;
	b=N/Et44A9hGzWle7UvK0ZRlpN7SQ9izTo2hLmP2IOCMs51Yo7gJZ7acNJgtzbJXN3/
	 /xJswo2VJdmzcDRqWpMwA5LispukAleydOZTWbKrdjvJGxlrJyPIRPpLcsnX4SLkRY
	 O8ewokKcYzulkpOAmWvX5T54POz1+XQQYLHsLmD8=
Date: Tue, 10 Mar 2026 09:50:40 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,willy@infradead.org,rakie.kim@sk.com,npache@redhat.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-requeue-destination-folio-on-deferred-split-queue.patch added to mm-new branch
Message-Id: <20260310165041.5B863C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: requeue destination folio on deferred split queue
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate-requeue-destination-folio-on-deferred-split-queue.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-requeue-destination-folio-on-deferred-split-queue.patch

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
Subject: mm: migrate: requeue destination folio on deferred split queue
Date: Tue, 10 Mar 2026 03:54:19 -0700

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

Link: https://lkml.kernel.org/r/20260310105419.3256755-1-usama.arif@linux.dev
Fixes: dafff3f4c850 ("mm: split underused THPs")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/mm/migrate.c~mm-migrate-requeue-destination-folio-on-deferred-split-queue
+++ a/mm/migrate.c
@@ -1360,6 +1360,8 @@ static int migrate_folio_move(free_folio
 	int rc;
 	int old_page_state = 0;
 	struct anon_vma *anon_vma = NULL;
+	bool src_deferred_split = false;
+	bool src_partially_mapped = false;
 	struct list_head *prev;
 
 	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
@@ -1373,6 +1375,12 @@ static int migrate_folio_move(free_folio
 		goto out_unlock_both;
 	}
 
+	if (folio_test_large(src) && folio_test_large_rmappable(src) &&
+	    !data_race(list_empty(&src->_deferred_list))) {
+		src_deferred_split = true;
+		src_partially_mapped = folio_test_partially_mapped(src);
+	}
+
 	rc = move_to_new_folio(dst, src, mode);
 	if (rc)
 		goto out;
@@ -1393,6 +1401,15 @@ static int migrate_folio_move(free_folio
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

mm-migrate_device-document-folio_get-requirement-before-frozen-pmd-split.patch
mm-migrate-requeue-destination-folio-on-deferred-split-queue.patch

