Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A7210979
	for <mm-commits@vger.kernel.org>; Tue,  5 Mar 2024 01:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709600572; cv=none; b=ffzmc0eRhsnJb6ChnAdOvlukXpkiJ2+LeXqL97O52iWjOa4gEeaHmng9uimHzpeJwJNiR/8BQEVqIKITPyrTPRt82ogFCgHCwe/NdL3Yb8/asEPvaniOKZa+fGlqJCCxsoQ0w7F084aOGanGjmX+FNgGpPDGbKsn2u2JUd2QbvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709600572; c=relaxed/simple;
	bh=6Y0izR4qu3N87A7hoLmXXgthD7yLsUYAUcWls/+tJOA=;
	h=Date:To:From:Subject:Message-Id; b=deOlxkjQR65J0RrE3rJqVlHE/aurDpBYVXgDJPIICZr6XqrlsdN4Q4p0uNnXWtwGRfP0jcMD/+WURkP4sBHomLvcVrseZ8lHP53BVUPDsoRYVlFIs00X/wiOTHsmh1jfuVn02E1De8maHj2eBL4234Qcs+cAssPmLh9/WxkCnhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ErQKuIhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ErQKuIhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4B8C433F1;
	Tue,  5 Mar 2024 01:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709600572;
	bh=6Y0izR4qu3N87A7hoLmXXgthD7yLsUYAUcWls/+tJOA=;
	h=Date:To:From:Subject:From;
	b=ErQKuIhGEHL3SNZ/na9j/Y/M7Hwm7fA+HaMo3JICAe2b/zixmQRk/FewlR9i8tdaY
	 TnSNyvT6wKx3DOJsnSk7kXe35JTZy81yQBzeWSM4heV/wfzpN2qV0bHZZzanTvXCHx
	 SYdRc/bjc0vjDUJsmAbwVF2+aDl9LbDQ/A6Mh3LE=
Date: Mon, 04 Mar 2024 17:02:51 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,mgorman@suse.de,david@redhat.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-free-folios-in-a-batch-in-shrink_folio_list.patch removed from -mm tree
Message-Id: <20240305010251.EA4B8C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: free folios in a batch in shrink_folio_list()
has been removed from the -mm tree.  Its filename was
     mm-free-folios-in-a-batch-in-shrink_folio_list.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -1006,14 +1006,15 @@ static unsigned int shrink_folio_list(st
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
@@ -1412,14 +1413,11 @@ free_it:
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
@@ -1483,9 +1481,9 @@ keep:
 
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

mm-separate-out-folio_flags-from-pageflags.patch
mm-remove-pagewaiters-pagesetwaiters-and-pageclearwaiters.patch
mm-remove-pageyoung-and-pageidle-definitions.patch
mm-add-__dump_folio.patch
mm-add-__dump_folio-fix.patch
mm-add-__dump_folio-fix-2.patch
mm-add-__dump_folio-fix-3.patch
mm-make-dump_page-take-a-const-argument.patch
mm-constify-testing-page-folio-flags.patch
mm-constify-more-page-folio-tests.patch
mm-remove-cast-from-page_to_nid.patch
mm-mempolicy-use-a-folio-in-do_mbind.patch

