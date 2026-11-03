Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793670997;
	b=W6uCSRMMd+Ybt7+t92TUb+vnkSCEBbgoFU5zKaK7yldDcBk9mR7mK68JTgnwNLP9hkPK
	 eF9sIT40ZUcvhIZHrP1KOKFRG+cR3c3fLHQP52jTSjoCS1VZV/QxMjInfb5awRnE9TdTc
	 GrFM4jj89ceyE9LtgVSqRY3iadfPwqmvjJZhzyI/1nJNNoqrK4IHf8d09qOHAIuQTT/pL
	 BAEX30H1w2VLJEH9ZgdttkmGQgIWdA+YELxUoDBxZndAoc/HOQXvcyYTqYE4vy9RnXYtu
	 NxYJb5fXjixKLt7EHx44G8IQn0AqUcbDw36EJlNxB6OsX2gt+vSFP66yNrQMBMp8Y4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793670997;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=TEWRBr7FwR+rbA02LawhM/8xMBbkq8eVPXnPGxV2uY8=;
	b=dq7V0azdUC3a5ZQylLJfl4wITM+nZee8ocylbaEXtSsDsvBmRg4h5hgzvuWctG9tWvXX
	 DjWcymQJ02wO9kZEufpnc52QCY9Nk7VsGB5yUW4SZXctM2pmKwaa9n7twF0HcVDJYy/Rg
	 U2bss68S+MaYWIecq8/I+2z+UiPqVUKlyRdswiHpXB7pmX7ZI5gTIYQ2Bj2lyRbuXyVfR
	 HLGH55jpKX2NEn0dOANwONWE+Gc8B9tZ/Wwc77nhvcGJvTjFa6dX67NevfKhW9d1zcjmR
	 Vt2td/BtIuq/SVF5dTkp6fPCp1zJoGpxnWoJZPaZXcwdw7mrrIoEjuW6kkXEBWikX9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Xj6Bek5W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8536F606A32D
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 01:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Xj6Bek5W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B721F00A18;
	Tue,  3 Nov 2026 01:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793670997;
	bh=TEWRBr7FwR+rbA02LawhM/8xMBbkq8eVPXnPGxV2uY8=;
	h=Date:To:From:Subject;
	b=Xj6Bek5WLH29xcv6tluhELz/8mN/U2lLocSKoSDiUzXsbsoJ8mr9aFOM0tzwdKb6o
	 uJXxjeX7mXVGh/iBWh+vQkKSE4GPsOciUKyAE2I7i1A8DrSSllbzAWv21Ufedlru4j
	 zhXNTvg2uCbHvWMQHeb/qmOfdVwjlfQy/gUUvvkw=
Date: Mon, 02 Nov 2026 17:56:36 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	willy@infradead.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,
	rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,matthew.brost@intel.com,
	ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,
	jhubbard@nvidia.com,jgg@ziepe.ca,jack@suse.cz,hughd@google.com,
	gourry@gourry.net,david@kernel.org,byungchul@sk.com,
	baolin.wang@linux.alibaba.com,apopple@nvidia.com,tz2294@columbia.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-find_get_page_flags.patch added to mm-new branch
Message-Id: <20261103015637.54B721F00A18@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: remove find_get_page_flags()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-find_get_page_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-find_get_page_flags.patch

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
Subject: mm: remove find_get_page_flags()
Date: Mon, 02 Nov 2026 17:54:10 -0500

There are no callers left. Remove it.

Link: https://lore.kernel.org/20261102-page-wrappers-v1-5-e7280bdb31f6@columbia.edu
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

 include/linux/pagemap.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-find_get_page_flags
+++ a/include/linux/pagemap.h
@@ -846,12 +846,6 @@ static inline struct page *find_get_page
 	return pagecache_get_page(mapping, offset, 0, 0);
 }
 
-static inline struct page *find_get_page_flags(struct address_space *mapping,
-					pgoff_t offset, fgf_t fgp_flags)
-{
-	return pagecache_get_page(mapping, offset, fgp_flags, 0);
-}
-
 /**
  * find_lock_page - locate, pin and lock a pagecache page
  * @mapping: the address_space to search
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

