Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793894089;
	b=mcmUVSKch3RhY+mH9U8ekuC02os2qnHnh1RENjggk/JF3/t/qWe30j3bHRXN5WLnQ2Sc
	 ZhxFRAjGA6iLH8nP5jSMRKTxVRrLYHXQkO9BdwzJw2wqJ9//99gdaEMnvtvxoGb9mOf8t
	 VQZYqsXFpWEVQVLfrNLtJIM2Ywk9ID7jIgBWDkw/CH3e5JQ2ZOSSf0q2HjvmeGSgD+ucA
	 yUfAmHccSEO5BujUjvO3lyKH+jOFw++DhnNdMQV/iTxPUES++7HYfdjnQRPKSDJTJ33+1
	 nRBL1a5RrGJx5lPogyk6SuxTfCI8s6sN9qxyfVN9Hnwtal9/Qd2xT/T3pJF/nYZqCyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793894089;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=xmFyKgcmrHzGSi8fvDUfEzi/uJRWsh3D1MCdCGUQtQ4=;
	b=bGTy5zzqqPGzRa5dqgoiv/rc4OUVn5bHRMAJmZXi/stWthV/syXiM02zJnelfc1lIEUX
	 oUffigPZBhR+Z+HyjDV8ee3Y91a0umqPNuZ9721I9I2uLXx1/71+w6RFXwWOzMT7dWSAi
	 cJ93U1KKu588uJuj5FkgRO0e/b4QOyhqM8iZP6rC+SjzCzrHEcUS8bG0y3n5SCYvpj0dB
	 cjXvOSIevhUr9VjZ0UGer8Cj65f20GJvmOxEQ0G6R8mxPiOFYbpXgw5W79KaiNBQB/+1d
	 6pj9bLZlNs3UEWiVuxNuvnAybftuDdA/1Z5I9kieQDnYUMnYevnCwHqAtjfTzMBzA9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Uwblp6qT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60E2606BE83
	for <mm-commits@vger.kernel.org>; Thu,  5 Nov 2026 15:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Uwblp6qT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD4B1F00A18;
	Thu,  5 Nov 2026 15:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793894088;
	bh=xmFyKgcmrHzGSi8fvDUfEzi/uJRWsh3D1MCdCGUQtQ4=;
	h=Date:To:From:Subject;
	b=Uwblp6qTDzF6vY0k10jn1DKIYwoyNljeJCUBOKgIstihX4poNcAjgwXl2EXjltyVN
	 9FjlLQOcUEOuTg9+gkCU593r+dJy542mcjZnTl51Yh666cW+cKAWClv9IUxL+8vYmx
	 rk+rmC/1rRgPA6Hv2E6rALIk+SptiBlk+igKzAeY=
Date: Thu, 05 Nov 2026 07:54:47 -0800
To: mm-commits@vger.kernel.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-remove-find_lock_page.patch removed from -mm tree
Message-Id: <20261105155448.5FD4B1F00A18@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm: remove find_lock_page()
has been removed from the -mm tree.  Its filename was
     mm-remove-find_lock_page.patch

This patch was dropped because an updated version will be issued

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
mm-remove-read_cache_page_gfp.patch
mm-remove-thp_size-and-thp_order.patch

