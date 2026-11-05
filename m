Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894084;
	b=VXgrxgy2EA+3aw+0ULoluA6Ubx7UMHb2aa0WNZv/ppjx9Fd8XG9m7gBBdih+iJgvr1Nl
	 SH2Be6zsNB04FXMCLHpjRT+kFf5JyieQNiYCMcJaZf3Xbltg+h2Nb1OcfQn3a2sZPWq7u
	 6l5c2TDzYrfYA3FqnaIcjgKv3gMCPkW2r7SVvpZaBqdnNoKaLE2gU3iFKdmrwX5uhyOi5
	 wunb4rFlY5l0AOid++bkncSQvJ10M5WYPnDBbWrb1MHTVSPGqBYnuQvkbcpSrfUUTIAR/
	 B25/ccgVZUNcx+xU53fsWjE+oTz6XxvJTTn4veuceiohRl94kmIaqJC1Awn+ac1Ak5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894084;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=FRkWUIYuAxs/jdcuHToebFx1r3MC++mX34bB1Ptclmk=;
	b=WSBeEVjDx1r3eYdU+U+ORikYWmU1/S6B29smdaBUqn+YPZrf+YKFeDoIJMYszXBFkVrc
	 jeYq/8OobBVZCKROIKLaxaZ3PuRfRzd5+m/iJQ4w6nI88Su+At4x9yK7XseX4mQ0Mkgkv
	 tIC5r0XP3pwxp64Ft81XaqPrCjpugv9D+EfGhsd5S7uRn8sPyojZAhxBI6stLfPBldv/O
	 lSJx5J0zKf4Bd3CvZlMtF/kauuEJ9bX8hlwyGWE6QbI4NKnbXiOiQFBigeMXB6qpLEKFB
	 Ez/WBQ2gLJF4EZiYoZddD/idX9NuJgQtYV0icFkjOu5xR0I4SNo3NNjDbRSoXozsbnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=m8F8hzi0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8195606B476
	for <mm-commits@vger.kernel.org>; Thu,  5 Nov 2026 15:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=m8F8hzi0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103C11F00A02;
	Thu,  5 Nov 2026 15:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793894083;
	bh=FRkWUIYuAxs/jdcuHToebFx1r3MC++mX34bB1Ptclmk=;
	h=Date:To:From:Subject;
	b=m8F8hzi0Epj2dkuWXf0FtkSHKeAEq/veTdVS2VK5ijvOT+UbieyC4enQ8txD7YxhZ
	 0FbVJKr5h5KOeu8H9GNuMfSdbqYocGsHpY0ZjVPIXF5y2rHN0ck3HbT6rjx3sO+kyS
	 Ge8JKSKOXLfPrwm/+Jj2+ISQwURY6FIak6XOb5Hw=
Date: Thu, 05 Nov 2026 07:54:42 -0800
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-remove-wait_on_page_writeback.patch removed from -mm tree
Message-Id: <20261105155443.103C11F00A02@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: remove wait_on_page_writeback()
has been removed from the -mm tree.  Its filename was
     mm-remove-wait_on_page_writeback.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm: remove wait_on_page_writeback()
Date: Mon, 02 Nov 2026 17:54:06 -0500

Patch series "mm: remove newly-unused page wrapper APIs".

After some folio conversions done last cycle (namely ceph, f2fs, btrfs,
fuse, and page_io.c), there are a number of newly-unused page APIs.
Let's remove them and update comments as necessary.

Patches 1 and 8 are taken from the ceph writeback folio series [1],
along with tags.


This patch (of 8):

The last caller was converted to folio_wait_writeback(), so drop the
wait_on_page_writeback() compatibility wrapper and its declaration.

Link: https://lore.kernel.org/20261102-page-wrappers-v1-0-e7280bdb31f6@columbia.edu
Link: https://lore.kernel.org/20261102-page-wrappers-v1-1-e7280bdb31f6@columbia.edu
Link: https://lore.kernel.org/r/20260810-remove-wait-on-page-writeback-v3-0-dd7531704f26@columbia.edu/ [1]
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vishal Moola (Fractile) <vishal.moola@gmail.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Jan Kara <jack@suse.cz>
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

 include/linux/pagemap.h |    1 -
 mm/folio-compat.c       |    6 ------
 2 files changed, 7 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-wait_on_page_writeback
+++ a/include/linux/pagemap.h
@@ -1299,7 +1299,6 @@ static inline int folio_wait_locked_kill
 }
 
 void folio_end_read(struct folio *folio, bool success);
-void wait_on_page_writeback(struct page *page);
 void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
 void end_page_writeback(struct page *page);
--- a/mm/folio-compat.c~mm-remove-wait_on_page_writeback
+++ a/mm/folio-compat.c
@@ -23,12 +23,6 @@ void end_page_writeback(struct page *pag
 }
 EXPORT_SYMBOL(end_page_writeback);
 
-void wait_on_page_writeback(struct page *page)
-{
-	return folio_wait_writeback(page_folio(page));
-}
-EXPORT_SYMBOL_GPL(wait_on_page_writeback);
-
 void mark_page_accessed(struct page *page)
 {
 	folio_mark_accessed(page_folio(page));
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-memcontrol-remove-mod_memcg_page_state.patch
mm-memcontrol-remove-page_memcg_check.patch
mm-userfaultfd-store-the-childs-new-uffd-context-in-the-wait-queue-entry.patch
mm-remove-end_page_writeback.patch
mm-remove-clear_page_dirty_for_io.patch
mm-remove-attach_page_private-and-detach_page_private.patch
mm-remove-find_get_page_flags.patch
mm-remove-find_lock_page.patch
mm-remove-read_cache_page_gfp.patch
mm-remove-thp_size-and-thp_order.patch

