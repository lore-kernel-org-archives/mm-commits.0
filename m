Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793670999;
	b=4O2Ffr5vaLvgN9LJO0pCS7orZWhFWpjBBqihO0GOayNf6UrJwbtTKXenc9v2HIoNq96S
	 QVVYo7my2TpxB3Gp4mKX0ZaKgGavQNslgJKqhH//SWZs0nRLWeb7qx7Hyd5Gq5rNdmvhR
	 dDAs+DCgBfNSK41pPiudzEC0goGqG1PlPj5qFiDJ8EBQTOt/ESUkvGlPzbrtmFIMYs4nW
	 LE2iFbhU1Orynzhzlm8WH1rLbkWoqpgSPoFmCQCmrGdjKBfDTOpGEioLxz5fXfV9wWay9
	 ZROQ4sVYgllT0DgtPNuUIz2xdHvvDOjxNS5Dt1KQhRMFX4ngjhY0Abg8TUaDFdWT/FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793670999;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=IMWBjZh7i4+44ATRnNz9IUPksm6BbjdqQOc7Pot6YWY=;
	b=LONTtDFF70ktwxLQsxg43TK9g3RGgc5tLzEnR8I/EvlzLgPT7wM98g5PYcFvNpCwkiNA
	 9TpbyUa/tY7d4DtwQui9wuBRKohHj5FixYTTHihy40aFZOWAaO3B6sc0w7MvBgZlX7QcZ
	 Pt3HG4HQni4igkft+nIh2X5TR7dgaTp7FHBJtx+SvyJ5iJ5ocUZt0QRoK/BUmfJgmkoeU
	 8hyZQ71xqPqs4VbrxeQnDjhGaSqiX+Fd8v27edpXhNKgKgQOJe8MEUW03VlJKyXm5WAuZ
	 aWcrUa9wBGts16ymJrbkDRjciwCjTCEIxHjB2UxOmOXFIJ1SQMLH35C6MYovqvgznBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nx3GzhG3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64559606A324
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 01:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nx3GzhG3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2645B1F000C1;
	Tue,  3 Nov 2026 01:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793670999;
	bh=IMWBjZh7i4+44ATRnNz9IUPksm6BbjdqQOc7Pot6YWY=;
	h=Date:To:From:Subject;
	b=nx3GzhG36CfvOBEbnz09D+l9SaWtpzmmegER6GcmNmZYzDhTh+lbA2M0QY2OdMhSr
	 kPawXDTg8d7vFYj3+AEgKs6HD+o9I2wA90U2jvW8Ry/K+Uf+JMl1uLXxEDFHSi8fi7
	 5rhYjj5d04jy5qkuhT/aVEKi4dYWzAZk8F4lsW1U=
Date: Mon, 02 Nov 2026 17:56:38 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	willy@infradead.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,
	rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,matthew.brost@intel.com,
	ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,
	jhubbard@nvidia.com,jgg@ziepe.ca,jack@suse.cz,hughd@google.com,
	gourry@gourry.net,david@kernel.org,byungchul@sk.com,
	baolin.wang@linux.alibaba.com,apopple@nvidia.com,tz2294@columbia.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-find_lock_page.patch added to mm-new branch
Message-Id: <20261103015639.2645B1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: remove find_lock_page()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-find_lock_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-find_lock_page.patch

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
Subject: mm: remove find_lock_page()
Date: Mon, 02 Nov 2026 17:54:11 -0500

There are no callers left. Remove it. The name still appears in a
sample function graph trace in Documentation/trace/ftrace.rst, which
is recorded output and is left as it is.

Link: https://lore.kernel.org/20261102-page-wrappers-v1-6-e7280bdb31f6@columbia.edu
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

 include/linux/pagemap.h |   19 -------------------
 1 file changed, 19 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-find_lock_page
+++ a/include/linux/pagemap.h
@@ -847,25 +847,6 @@ static inline struct page *find_get_page
 }
 
 /**
- * find_lock_page - locate, pin and lock a pagecache page
- * @mapping: the address_space to search
- * @index: the page index
- *
- * Looks up the page cache entry at @mapping & @index.  If there is a
- * page cache page, it is returned locked and with an increased
- * refcount.
- *
- * Context: May sleep.
- * Return: A struct page or %NULL if there is no page in the cache for this
- * index.
- */
-static inline struct page *find_lock_page(struct address_space *mapping,
-					pgoff_t index)
-{
-	return pagecache_get_page(mapping, index, FGP_LOCK, 0);
-}
-
-/**
  * find_or_create_page - locate or add a pagecache page
  * @mapping: the page's address_space
  * @index: the page's index into the mapping
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

