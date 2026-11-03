Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793670987;
	b=ZSbjkaf3/WYCqdnd1qS7PZ1qAezFUnjd1j0hxukxOgv7ZlNiJbPBSuLq4GFA4jOuCAas
	 oj/rLJg/FyhRvkrnt5IxIDDwitkCvXXl6Gg7Gf64oNAkrICo0guV5FrQ8jGj3ip8EyFcv
	 n/qsUUmJHJwI6f93q4yZzEEwDfRtEjymjU4koZng4R2mmIuRM388s6jdrKha/JaXdFiJ3
	 td0xXs9ovXGjH94DQesmUbzsk5Q6JQHALXUtEjoXw1cMMYlzGOxTz/v/icSV/DobJ+cgl
	 fHOJEQNjKkKAzuIgQXpkQUOW1JJwktOTyGh9D3SEE2teB2AbiexV4ufK8wAqAz4AMwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793670987;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=WTlKf7MmDRYoLhoGaLxVViJOQduMLd1NRKZ8iknXCgo=;
	b=M24egx5SQAz2WmwqFz3SWz7WwqFjjxZbjclzn4B2QYkprEQ3ILoKnf/mAteYQf0X7t9d
	 8iEHbRQu7e3xCTiu3j1QoazbZUVMM7ZysTsRupu/Olg1+kRWfECcil5auK84rF9B/GHjh
	 ADEKsrd6d2ferXd0/Qn9SKfpWQUfTA04nV85ImLngU47fUXm6SJm3s6YzAW9LAAg7I/Vj
	 EaZYz2PJOsmpZ3tQu/8OC7rQPxZ4q0r0Txk2WuE1BYPg5mbzUkfIXb6xDNIo4lQFeirnZ
	 wFFKeE0846skM/JXKAT8BURnlAXW/nBh7l8UBE799f+JHOwEU0Uf69rCQqjCN/viDYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nyov6MOt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322BD606A329
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 01:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nyov6MOt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A75461F00A02;
	Tue,  3 Nov 2026 01:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793670986;
	bh=WTlKf7MmDRYoLhoGaLxVViJOQduMLd1NRKZ8iknXCgo=;
	h=Date:To:From:Subject;
	b=nyov6MOtVXacKgX9oJ+dZt+7jVS8HCSYyx962mxCodqHDDlKlHLABDPt3lWyHE/zK
	 UyHqEGriA0MU16DsQSh0RHw745Ezetuc/B9A4p8HqzY6lxHj3XdcX2np+Do7PB/QKQ
	 EDLyjCnTD20zVR9bLmDv+PLJ/Nd2SZ5boBxAvVz4=
Date: Mon, 02 Nov 2026 17:56:26 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	willy@infradead.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,
	rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,matthew.brost@intel.com,
	ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,
	jhubbard@nvidia.com,jgg@ziepe.ca,jack@suse.cz,hughd@google.com,
	gourry@gourry.net,david@kernel.org,byungchul@sk.com,
	baolin.wang@linux.alibaba.com,apopple@nvidia.com,tz2294@columbia.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-wait_on_page_writeback.patch added to mm-new branch
Message-Id: <20261103015626.A75461F00A02@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: remove wait_on_page_writeback()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-wait_on_page_writeback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-wait_on_page_writeback.patch

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
Cc: Jan Kara <jack@suse.cz>
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
mm-remove-wait_on_page_writeback.patch
mm-remove-end_page_writeback.patch
mm-remove-clear_page_dirty_for_io.patch
mm-remove-attach_page_private-and-detach_page_private.patch
mm-remove-find_get_page_flags.patch
mm-remove-find_lock_page.patch
mm-remove-read_cache_page_gfp.patch
mm-remove-thp_size-and-thp_order.patch

