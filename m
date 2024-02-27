Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4B150A80
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059684; cv=none; b=qfbxU81z1SW3oHWt4J4QjhBLAakU/AldvzFc3aGVxyCd2dHgyIWpu6jDn9xdGK3W+u6gOSB8EkJOrg4pLDc35+2W/AHtPCK+XWbwXpXQsM0YZpYH3fdNhbWOGD+BKBiDPwjf5hapdl/KxBcvtm1kzgP1wIKTj6ydKEJbukdARtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059684; c=relaxed/simple;
	bh=4S9DwBqgXPJZNYI26P2yRaMB+wRFSh1Q4mioao8zCcQ=;
	h=Date:To:From:Subject:Message-Id; b=gIB8I4bLPMD1MoLKRMYRJHvQHJ7kfoXYo7RSDds3FcsyIHGT26BZoZOfc+mQsuQ6lg39zBLt6EpeRg9T3+aPlHhxDQ6VdgARm2NGSOH/YVmjytbHRyv1h0w7LWtTM89shnNHIIPSAJ7xbRkMHFljif+c+MHMetJkKTV0zFqCcv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q3Wf+Qkj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q3Wf+Qkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4AE6C43390;
	Tue, 27 Feb 2024 18:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709059684;
	bh=4S9DwBqgXPJZNYI26P2yRaMB+wRFSh1Q4mioao8zCcQ=;
	h=Date:To:From:Subject:From;
	b=Q3Wf+QkjOVcbfxn0sDFADHaiixNZETAbILKNJqq1cKV+CxHDoe8+KKrTUnJAmMrDJ
	 OUR6Ynr7+KC3WzOww4fnLFD240QoxSHM+SzDnCv00foCmHeMr201RdL0o3T6LffSs+
	 /8q2rpu0xuPwJMhAucfoMyW16aqKgRGrwwg7cjKo=
Date: Tue, 27 Feb 2024 10:48:04 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-free-folios-in-a-batch-in-shrink_folio_list.patch added to mm-unstable branch
Message-Id: <20240227184804.A4AE6C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: free folios in a batch in shrink_folio_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-free-folios-in-a-batch-in-shrink_folio_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-free-folios-in-a-batch-in-shrink_folio_list.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: free folios in a batch in shrink_folio_list()
Date: Tue, 27 Feb 2024 17:42:45 +0000

Use free_unref_page_batch() to free the folios.  This may increase the
number of IPIs from calling try_to_unmap_flush() more often, but that's
going to be very workload-dependent.  It may even reduce the number of
IPIs as we now batch-free large folios instead of freeing them one at a
time.

Link: https://lkml.kernel.org/r/20240227174254.710559-12-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/mm/vmscan.c~mm-free-folios-in-a-batch-in-shrink_folio_list
+++ a/mm/vmscan.c
@@ -1009,14 +1009,15 @@ static unsigned int shrink_folio_list(st
 		struct pglist_data *pgdat, struct scan_control *sc,
 		struct reclaim_stat *stat, bool ignore_references)
 {
+	struct folio_batch free_folios;
 	LIST_HEAD(ret_folios);
-	LIST_HEAD(free_folios);
 	LIST_HEAD(demote_folios);
 	unsigned int nr_reclaimed = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
 	struct swap_iocb *plug = NULL;
 
+	folio_batch_init(&free_folios);
 	memset(stat, 0, sizeof(*stat));
 	cond_resched();
 	do_demote_pass = can_demote(pgdat->node_id, sc);
@@ -1415,14 +1416,11 @@ free_it:
 		 */
 		nr_reclaimed += nr_pages;
 
-		/*
-		 * Is there need to periodically free_folio_list? It would
-		 * appear not as the counts should be low
-		 */
-		if (unlikely(folio_test_large(folio)))
-			destroy_large_folio(folio);
-		else
-			list_add(&folio->lru, &free_folios);
+		if (folio_batch_add(&free_folios, folio) == 0) {
+			mem_cgroup_uncharge_folios(&free_folios);
+			try_to_unmap_flush();
+			free_unref_folios(&free_folios);
+		}
 		continue;
 
 activate_locked_split:
@@ -1486,9 +1484,9 @@ keep:
 
 	pgactivate = stat->nr_activate[0] + stat->nr_activate[1];
 
-	mem_cgroup_uncharge_list(&free_folios);
+	mem_cgroup_uncharge_folios(&free_folios);
 	try_to_unmap_flush();
-	free_unref_page_list(&free_folios);
+	free_unref_folios(&free_folios);
 
 	list_splice(&ret_folios, folio_list);
 	count_vm_events(PGACTIVATE, pgactivate);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-support-order-1-folios-in-the-page-cache.patch
mm-make-folios_put-the-basis-of-release_pages.patch
mm-convert-free_unref_page_list-to-use-folios.patch
mm-add-free_unref_folios.patch
mm-use-folios_put-in-__folio_batch_release.patch
memcg-add-mem_cgroup_uncharge_folios.patch
mm-remove-use-of-folio-list-from-folios_put.patch
mm-use-free_unref_folios-in-put_pages_list.patch
mm-use-__page_cache_release-in-folios_put.patch
mm-handle-large-folios-in-free_unref_folios.patch
mm-allow-non-hugetlb-large-folios-to-be-batch-processed.patch
mm-free-folios-in-a-batch-in-shrink_folio_list.patch
mm-free-folios-directly-in-move_folios_to_lru.patch
memcg-remove-mem_cgroup_uncharge_list.patch
mm-remove-free_unref_page_list.patch
mm-remove-lru_to_page.patch
mm-convert-free_pages_and_swap_cache-to-use-folios_put.patch
mm-use-a-folio-in-__collapse_huge_page_copy_succeeded.patch
mm-convert-free_swap_cache-to-take-a-folio.patch

