Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793670989;
	b=NNo7BBKj7HsLGl0ESJeDdQOHJXBMU+6yTcDCys3xNvLcwWxcvGUTaV+dIvPABW02oooJ
	 Jc/hQ/tJbSI2GbcUcwLH+wL3D+sMpjyIxCEtgpYr5hFLH3NoWfR/UbgVhffde7QYseMY9
	 M0TwjYHtd2o8uO52qkIfce0nd7KGvWfnZ2xzvfjQVIxwNyzh+szLsPEBBm3aeRLUSme6f
	 kERglX3IIb42Fgx0tn4vYnNvhRsfRf6YW46QorOC7z5GPzwc5tu8dlH262t8uDhLcLBCV
	 c5vpDiEHac+AOke2WyqgSTpNE5sXL9S3RZKcAYEzcOWp5QZUJwihvDHHJf+GDrzYYvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793670989;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=b1XtlWqmsvpam3DgR3100a5MM8YO7iWoXvcfu6F/PG8=;
	b=qVMcDDsQ+CJysYmpiPsKDLX26Q/37DglS37Z8EZNWguzeIiInRkpZixe/48iJIfiEVll
	 +dl40mu9SobJwwjT0PFNgQQK11/2+cuuIM0mGLJAXOcLzIJp94BK2FjGzgkSDOcvYCHlQ
	 XbOaQTpN7tH1Cb6O44a0DkghTlMgnDdPlT9dGfCXRi0R27DxHnOnUMbfiWlGXmtwc6Rr0
	 3WZrw3FRXXTYgpxXIk32PfvQyydr9Fck1mSD8GdIMNk2E9SPkXpBeSVCfvixcot0UDiNg
	 ksW+bafTfa/Eu6Lfne9T7l6aU28V/8gPHV56cUlq4aK7LHz6HrECekPqwkhEvFRSW9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iv6mrz1j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB7F606A32F
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 01:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iv6mrz1j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFB01F000C1;
	Tue,  3 Nov 2026 01:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793670989;
	bh=b1XtlWqmsvpam3DgR3100a5MM8YO7iWoXvcfu6F/PG8=;
	h=Date:To:From:Subject;
	b=iv6mrz1jSRKOzN9uA9QZtnqB0OdLZyrG10BODLDmdFSLyseewodLThbM7BKU6z32K
	 9qatnCepOw478mJyprfopMiUE8CfRSJwF/sMGEMDLGYzT1IF5isy52Ro4chJTZSLHh
	 8HVdH2EcsGV9/hgtH8ckdPfol8ervm51KQi/ieIk=
Date: Mon, 02 Nov 2026 17:56:28 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	willy@infradead.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,
	rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,matthew.brost@intel.com,
	ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,
	jhubbard@nvidia.com,jgg@ziepe.ca,jack@suse.cz,hughd@google.com,
	gourry@gourry.net,david@kernel.org,byungchul@sk.com,
	baolin.wang@linux.alibaba.com,apopple@nvidia.com,tz2294@columbia.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-end_page_writeback.patch added to mm-new branch
Message-Id: <20261103015629.0BFB01F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: remove end_page_writeback()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-end_page_writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-end_page_writeback.patch

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
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove end_page_writeback()
Date: Mon, 02 Nov 2026 17:54:07 -0500

There are no callers left. Update the two comments that still named
it to refer to folio_end_writeback().

Link: https://lore.kernel.org/20261102-page-wrappers-v1-2-e7280bdb31f6@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
---

 include/linux/pagemap.h   |    1 -
 include/linux/writeback.h |    2 +-
 mm/folio-compat.c         |    6 ------
 mm/migrate.c              |    2 +-
 4 files changed, 2 insertions(+), 9 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-end_page_writeback
+++ a/include/linux/pagemap.h
@@ -1301,7 +1301,6 @@ static inline int folio_wait_locked_kill
 void folio_end_read(struct folio *folio, bool success);
 void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
-void end_page_writeback(struct page *page);
 void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
--- a/include/linux/writeback.h~mm-remove-end_page_writeback
+++ a/include/linux/writeback.h
@@ -124,7 +124,7 @@ struct wb_domain {
 	 * writeout speed.
 	 *
 	 * We do this by keeping a floating proportion between BDIs, based
-	 * on page writeback completions [end_page_writeback()]. Those
+	 * on page writeback completions [folio_end_writeback()]. Those
 	 * devices that write out pages fastest will get the larger share,
 	 * while the slower will get a smaller share.
 	 *
--- a/mm/folio-compat.c~mm-remove-end_page_writeback
+++ a/mm/folio-compat.c
@@ -17,12 +17,6 @@ void unlock_page(struct page *page)
 }
 EXPORT_SYMBOL(unlock_page);
 
-void end_page_writeback(struct page *page)
-{
-	return folio_end_writeback(page_folio(page));
-}
-EXPORT_SYMBOL(end_page_writeback);
-
 void mark_page_accessed(struct page *page)
 {
 	folio_mark_accessed(page_folio(page));
--- a/mm/migrate.c~mm-remove-end_page_writeback
+++ a/mm/migrate.c
@@ -859,7 +859,7 @@ void folio_migrate_flags(struct folio *n
 
 	/*
 	 * PG_readahead shares the same bit with PG_reclaim.  The above
-	 * end_page_writeback() may clear PG_readahead mistakenly, so set the
+	 * folio_end_writeback() may clear PG_readahead mistakenly, so set the
 	 * bit after that.
 	 */
 	if (folio_test_readahead(folio))
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-remove-mod_memcg_page_state.patch
mm-memcontrol-remove-page_memcg_check.patch
mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry.patch
mm-remove-wait_on_page_writeback.patch
mm-remove-end_page_writeback.patch
mm-remove-clear_page_dirty_for_io.patch
mm-remove-attach_page_private-and-detach_page_private.patch
mm-remove-find_get_page_flags.patch
mm-remove-find_lock_page.patch
mm-remove-read_cache_page_gfp.patch
mm-remove-thp_size-and-thp_order.patch

