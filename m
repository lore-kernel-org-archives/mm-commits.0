Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793671001;
	b=3TSP0h5MjS5lZb2e5LUErkR1tWeXjW7FCL0Vri1juvPImzyo1L5l+orPRXNmkIAUJDqX
	 OsGfcEUQg5eP2oMsD3pbzoPcdSUt3LHcFz3z+4mD8zz88k7KY7RpIygWmjXMHs0V6MYcM
	 ct+uU63eBaDt5/7/vWGgkFnCaiCrhIZ+e9Kx+dzV7VJXi0hNA1GesOxQioiZd1+lKeH2A
	 Mi1ll/fzSdEWu6XwFa4LMMd1M1xpGeiLU+1RUO3F+a20Bb87oo/WcKJbsFhnj13Ip7G6k
	 jY73JxS3tAHq4oJiYWUuWl7I5ExQTCU250MB+hYfr0tAUfbCHCKsLx4809oLokHtjRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793671001;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=pzxY/yBiyJ4sNgIQTA+3A/2yJOH+G1H8nStCyEP5rtw=;
	b=MIClenuxMuQM7P5Rw+ZpGfvGJKJtDEZng92qobxNE3fJvkioLm2u4qGTtMIiiUMHUmqe
	 1XW7k/qV5Ry402qyzihvEzrFofSkECto4ZqiRQATVZF/EuEtfynhDuKnLIbVtgsrBu0WE
	 Vy2aB+iJ/OEGyaEhPQhGle+eEGvEUSDsZVhKqtERS7jqhMRfryIujUmBLQjvLYWJcELRX
	 U2u+jLarySOL+QDgVoMqEnf+K/7aB1YS4Z7ntcniDk2YukUVIRO833sYe0LGBTGvPvz1X
	 iqV4q4IOBM2pBAq1E/GTsrIYyQYLR35gbEhQ6/pncb8fX9SL74RDcoNLYJWpR5deijQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=j9a7xPEX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378CB606A32F
	for <mm-commits@vger.kernel.org>; Tue,  3 Nov 2026 01:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=j9a7xPEX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F1F1F000C1;
	Tue,  3 Nov 2026 01:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793671001;
	bh=pzxY/yBiyJ4sNgIQTA+3A/2yJOH+G1H8nStCyEP5rtw=;
	h=Date:To:From:Subject;
	b=j9a7xPEXVFVkH2bnE4ic+G5F7PzsMLLtnCByTi1l2cElKAi/TOMlFLEqqzajfFZS1
	 51hNnqCz9/yui+mnWa4I27BPZuYt/paPxNxTNVmM9UeKIpPpQTygrhqrgknK79N+/O
	 kTtkl3C//MA7+AMcPrPRFo3IV1554HtY9mfiGgGw=
Date: Mon, 02 Nov 2026 17:56:40 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,
	willy@infradead.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,
	rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,matthew.brost@intel.com,
	ljs@kernel.org,liam@infradead.org,joshua.hahnjy@gmail.com,
	jhubbard@nvidia.com,jgg@ziepe.ca,jack@suse.cz,hughd@google.com,
	gourry@gourry.net,david@kernel.org,byungchul@sk.com,
	baolin.wang@linux.alibaba.com,apopple@nvidia.com,tz2294@columbia.edu,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-read_cache_page_gfp.patch added to mm-new branch
Message-Id: <20261103015641.05F1F1F000C1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm: remove read_cache_page_gfp()
has been added to the -mm mm-new branch.  Its filename is
     mm-remove-read_cache_page_gfp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-remove-read_cache_page_gfp.patch

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
Subject: mm: remove read_cache_page_gfp()
Date: Mon, 02 Nov 2026 17:54:12 -0500

There are no callers left. Point the comment on shmem_read_folio_gfp()
at mapping_read_folio_gfp() instead.

Link: https://lore.kernel.org/20261102-page-wrappers-v1-7-e7280bdb31f6@columbia.edu
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

 include/linux/pagemap.h |    2 --
 mm/filemap.c            |   23 -----------------------
 mm/shmem.c              |    4 ++--
 3 files changed, 2 insertions(+), 27 deletions(-)

--- a/include/linux/pagemap.h~mm-remove-read_cache_page_gfp
+++ a/include/linux/pagemap.h
@@ -962,8 +962,6 @@ struct folio *mapping_read_folio_gfp(str
 		gfp_t flags);
 struct page *read_cache_page(struct address_space *, pgoff_t index,
 		filler_t *filler, struct file *file);
-extern struct page * read_cache_page_gfp(struct address_space *mapping,
-				pgoff_t index, gfp_t gfp_mask);
 
 static inline struct page *read_mapping_page(struct address_space *mapping,
 				pgoff_t index, struct file *file)
--- a/mm/filemap.c~mm-remove-read_cache_page_gfp
+++ a/mm/filemap.c
@@ -4260,29 +4260,6 @@ struct page *read_cache_page(struct addr
 }
 EXPORT_SYMBOL(read_cache_page);
 
-/**
- * read_cache_page_gfp - read into page cache, using specified page allocation flags.
- * @mapping:	the page's address_space
- * @index:	the page index
- * @gfp:	the page allocator flags to use if allocating
- *
- * This is the same as "read_mapping_page(mapping, index, NULL)", but with
- * any new page allocations done using the specified allocation flags.
- *
- * If the page does not get brought uptodate, return -EIO.
- *
- * The function expects mapping->invalidate_lock to be already held.
- *
- * Return: up to date page on success, ERR_PTR() on failure.
- */
-struct page *read_cache_page_gfp(struct address_space *mapping,
-				pgoff_t index,
-				gfp_t gfp)
-{
-	return do_read_cache_page(mapping, index, NULL, NULL, gfp);
-}
-EXPORT_SYMBOL(read_cache_page_gfp);
-
 /*
  * Warn about a page cache invalidation failure during a direct I/O write.
  */
--- a/mm/shmem.c~mm-remove-read_cache_page_gfp
+++ a/mm/shmem.c
@@ -6200,9 +6200,9 @@ int shmem_zero_setup_desc(struct vm_area
  * @index:	the folio index
  * @gfp:	the page allocator flags to use if allocating
  *
- * This behaves as a tmpfs "read_cache_page_gfp(mapping, index, gfp)",
+ * This behaves as a tmpfs "mapping_read_folio_gfp(mapping, index, gfp)",
  * with any new page allocations done using the specified allocation flags.
- * But read_cache_page_gfp() uses the ->read_folio() method: which does not
+ * But mapping_read_folio_gfp() uses the ->read_folio() method: which does not
  * suit tmpfs, since it may have pages in swapcache, and needs to find those
  * for itself; although drivers/gpu/drm i915 and ttm rely upon this support.
  *
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

