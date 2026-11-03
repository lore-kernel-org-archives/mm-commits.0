Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793670996;
	b=BoNAnyFxnncg3U1qTM4olPSZZXAq/t61Hv3lr8aQTPZbZt9Uowgfy2AejIk6qxJ3uGxw
	 1ebINFyvZrmHSdPAhni/USoxlildmVO2c6KDkcQdf9g9mvWQDeDd7XdigwWGShPMpba3l
	 KXSYGbovBUUUtOCi/gk4ccS32EtvXsn64IH6vl0AOWQQp2N5x6Cm0tF4NmsC2fD+uy96d
	 7U2GbcjVNJ1JTQsJIU4rHfdWozE2GDL5yO6hrfT7RUv+J/yIQA82C3QeS3vA9YaDyJngv
	 MyeV6Q+2w2TDAXVQ/3aiZzEbM7Oj0y2rA9h7jQ0jovs/Oc+I2izxM8lJ6OV/3QSXhpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793670996;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=XatqyqvjKW1utaYTowkEhwH3vXAwY9pPob8r22j0Og4=;
	b=rLtoyOFPrGV77hgnbTyV9acGeibbKXGnRKiPxOiBGr8QcRFNosbgG9AU8BG0kQtZkLNc
	 +WjwuNUz3gIKxAY0xn8hF4vS7sDfVc7Eqx5lPa44M21g5pWawEDfsXCOFoO4D1vVhf7On
	 idHL31fuaOQofwLjgp4N4/VtOLPP/X/hLOxzDexpifcyg5wfIy+Zj31dcuW5EP7jbT0lp
	 ++7VyYTM4jqOikuv/KLAFnM3jHbMy+uYwYakT0YaYhFLLSPwe+32/A3UOquubXPnuQutO
	 RW4ddvlqkURSNUMNPmcjwwCMd4u/tCVQtMZQzYFF9A7x54uS+8xiXFpvk+NON/Tx4/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=u+PN7CFL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5380606A339
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 01:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=u+PN7CFL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E52A1F00A02;
	Tue,  3 Nov 2026 01:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793670995;
	bh=XatqyqvjKW1utaYTowkEhwH3vXAwY9pPob8r22j0Og4=;
	h=Date:To:From:Subject;
	b=u+PN7CFL2TCsvPGNsOmJhVugDb/9Z8It9UDWnMMGUUpCL9mhuPB6YkdGdsXTQG/Jo
	 OoQkhRHda/22jqS0139xnbjlTVp9cCUERksIFjacqlvvoP+FpUc4YQLZf5ytgBD3EM
	 Zx0Uj2Ai2NpEIVv1qQDSaaEOaWsIO/W3jAQR9uJ0=
Date: Mon, 02 Nov 2026 17:56:35 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	willy@infradead.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,
	rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,matthew.brost@intel.com,
	ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,
	jhubbard@nvidia.com,jgg@ziepe.ca,jack@suse.cz,hughd@google.com,
	gourry@gourry.net,david@kernel.org,byungchul@sk.com,
	baolin.wang@linux.alibaba.com,apopple@nvidia.com,tz2294@columbia.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-attach_page_private-and-detach_page_private.patch added to mm-new branch
Message-Id: <20261103015635.8E52A1F00A02@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: remove attach_page_private() and detach_page_private()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-attach_page_private-and-detach_page_private.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-attach_page_private-and-detach_page_private.patch

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
Subject: mm: remove attach_page_private() and detach_page_private()
Date: Mon, 02 Nov 2026 17:54:09 -0500

There are no callers left of either wrapper. Remove them.

Link: https://lore.kernel.org/20261102-page-wrappers-v1-4-e7280bdb31f6@columbia.edu
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

 include/linux/pagemap.h |   10 ----------
 1 file changed, 10 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-attach_page_private-and-detach_page_private
+++ a/include/linux/pagemap.h
@@ -635,16 +635,6 @@ static inline void *folio_detach_private
 	return data;
 }
 
-static inline void attach_page_private(struct page *page, void *data)
-{
-	folio_attach_private(page_folio(page), data);
-}
-
-static inline void *detach_page_private(struct page *page)
-{
-	return folio_detach_private(page_folio(page));
-}
-
 #ifdef CONFIG_NUMA
 struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
 		struct mempolicy *policy);
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

