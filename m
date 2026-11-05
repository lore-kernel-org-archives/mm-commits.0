Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894084;
	b=ovY/O8APvpUncW1bBfKVklFer5b/+FCU39pNDvO+fSEzAVqzbzXtyNFr8Rnk6Og2et5Y
	 yLloHqud5BPCGu0PPEvl4nZ44PKrLQuMmAfJL3o4kBxbtFihyEvSZK4zRJOFGKOrmfxJR
	 DHxjIehLDoahoVDJEekz1S5nCkk7zWxmgj2nSJiKwHOfmBLYBwvbVPqVu1GkKTKAwDUao
	 0nNbFF3xQjfVkG2c1v4gk6YjN6UDBW10uSOY4a52l1Ec/KMZm/Y3z9/Y+AhMiCb7UbjU+
	 O5fRS08HerZHrxHseQzxX8sfq/6bbA/nBUlneyLsvUGursXnQMVxCTjAUGQno7KfpeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894084;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=b5lS3liSrI3CLijtltHyo1MoVFjUEE4wsNNrDirUIwo=;
	b=Fst3p4PTgIs5bMU4s2X3bPD+Fq4dZpZh/k+kVMFPjmP9UJl7xuFCVqP4rsHa1csAtX0w
	 jK0JfwbAwgcvMm2bq/dCgpE0PyysmYz6vdin9H24By58MZSbbTF5ZK7hBubXU76hbzlZ9
	 5Atvy/iJjSsJSiiXQ+D9nmVlgiUCGbHaR/tN/k8e7jPdxIJjIanTFqfp0MzOiW3HyIxfU
	 lsMpMZfVImjDhcNxKSt/WphNhOa0MKYj2jCyBPf+LRiYw5JESMw9G1EIVTsGZwUuVmQIT
	 h1LTZv30RFiQ0fgjX9kzCxzqDq1rFnwu4qn3R8JmIA0lFjuKMYgNfwLXN4X7ogOC1tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y5ERmGUd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65642606BE83
	for <mm-commits@vger.kernel.org>; Thu,  5 Nov 2026 15:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y5ERmGUd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AF81F00A18;
	Thu,  5 Nov 2026 15:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793894084;
	bh=b5lS3liSrI3CLijtltHyo1MoVFjUEE4wsNNrDirUIwo=;
	h=Date:To:From:Subject;
	b=Y5ERmGUdX0kDWxaIOuxkP2aWl7oTwIzCKihdkLcfg0qfl53G0vhVDPa1P8gccdVq4
	 gbRkhCcuv2QF/jk07shlIK4lWcKisW7jogHspxpKpenD3TPhzgMm7oSbTtj43IIjTV
	 f23ofIs8406g0sv3l53vEiVZs4abkV+bc5nUMh4o=
Date: Thu, 05 Nov 2026 07:54:43 -0800
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-remove-end_page_writeback.patch removed from -mm tree
Message-Id: <20261105155444.15AF81F00A18@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: remove end_page_writeback()
has been removed from the -mm tree.  Its filename was
     mm-remove-end_page_writeback.patch

This patch was dropped because an updated version will be issued

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
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
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
mm-remove-clear_page_dirty_for_io.patch
mm-remove-attach_page_private-and-detach_page_private.patch
mm-remove-find_get_page_flags.patch
mm-remove-find_lock_page.patch
mm-remove-read_cache_page_gfp.patch
mm-remove-thp_size-and-thp_order.patch

