Return-Path: <SRS0=hqm6=DJ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CA93C35257
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2937620796
	for <mm-commits@archiver.kernel.org>; Fri,  2 Oct 2020 21:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601674141;
	bh=eP0dE5jL+Ow17I98tjWB4Tl1yxMnr+u7ohkpRY9pUio=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=K7jemSL2D5eHkf2XInghw83sNFEW2ngwQvWE8FgHLH2tAbpwDLaW5v0w4rD3S3RDU
	 YtmLSErbmNi6MdJT6GcZVdDyKyobCD2AI8UyGe1lckWKCpMrVa2qKbVWw+Ipod96dK
	 jzfQXTnzVDxdsJ6IBo4KDnd65RyLDXuHQwSmgH1k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbgJBV3A (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Oct 2020 17:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:42656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJBV3A (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 2 Oct 2020 17:29:00 -0400
Received: from X1 (c-76-21-107-111.hsd1.ca.comcast.net [76.21.107.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30BBF206DB;
        Fri,  2 Oct 2020 21:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601674139;
        bh=eP0dE5jL+Ow17I98tjWB4Tl1yxMnr+u7ohkpRY9pUio=;
        h=Date:From:To:Subject:From;
        b=QgI+a2YgvQeK0tNhwMQaZiVx2HRzErieIETIxQm/Fvv884lM2gN/EhKAS1huJxmka
         A7oyIDbxbFc9ePcUmb1TH3TG7PjWPpCa6EYNaDO0+x1AdAcG9wzrnE7CbqOWjhY272
         ZiJcwhMpMxgsll1vUIaqUUv+Del3wODF3QeXd6R0=
Date:   Fri, 02 Oct 2020 14:28:58 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, urezki@gmail.com,
        tvrtko.ursulin@linux.intel.com, sstabellini@kernel.org,
        rodrigo.vivi@intel.com, peterz@infradead.org, ngupta@vflare.org,
        minchan@kernel.org, matthew.auld@intel.com,
        joonas.lahtinen@linux.intel.com, jgross@suse.com,
        jani.nikula@linux.intel.com, hch@lst.de, chris@chris-wilson.co.uk,
        boris.ostrovsky@oracle.com, willy@infradead.org
Subject:  + mm-update-the-documentation-for-vfree.patch added to -mm
 tree
Message-ID: <20201002212858.rsDxH%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update the documentation for vfree
has been added to the -mm tree.  Its filename is
     mm-update-the-documentation-for-vfree.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-update-the-documentation-for-vfree.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-update-the-documentation-for-vfree.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: update the documentation for vfree

Patch series "remove alloc_vm_area", v4.

This series removes alloc_vm_area, which was left over from the big
vmalloc interface rework.  It is a rather arkane interface, basicaly the
equivalent of get_vm_area + actually faulting in all PTEs in the allocated
area.  It was originally addeds for Xen (which isn't modular to start
with), and then grew users in zsmalloc and i915 which seems to mostly
qualify as abuses of the interface, especially for i915 as a random driver
should not set up PTE bits directly.


This patch (of 11):

 * Document that you can call vfree() on an address returned from vmap()
 * Remove the note about the minimum size -- the minimum size of a vmalloc
   allocation is one page
 * Add a Context: section
 * Fix capitalisation
 * Reword the prohibition on calling from NMI context to avoid a double
   negative

Link: https://lkml.kernel.org/r/20201002122204.1534411-1-hch@lst.de
Link: https://lkml.kernel.org/r/20201002122204.1534411-2-hch@lst.de
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/mm/vmalloc.c~mm-update-the-documentation-for-vfree
+++ a/mm/vmalloc.c
@@ -2321,20 +2321,21 @@ static void __vfree(const void *addr)
 }
 
 /**
- * vfree - release memory allocated by vmalloc()
- * @addr:  memory base address
+ * vfree - Release memory allocated by vmalloc()
+ * @addr:  Memory base address
  *
- * Free the virtually continuous memory area starting at @addr, as
- * obtained from vmalloc(), vmalloc_32() or __vmalloc(). If @addr is
- * NULL, no operation is performed.
+ * Free the virtually continuous memory area starting at @addr, as obtained
+ * from one of the vmalloc() family of APIs.  This will usually also free the
+ * physical memory underlying the virtual allocation, but that memory is
+ * reference counted, so it will not be freed until the last user goes away.
  *
- * Must not be called in NMI context (strictly speaking, only if we don't
- * have CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG, but making the calling
- * conventions for vfree() arch-depenedent would be a really bad idea)
+ * If @addr is NULL, no operation is performed.
  *
+ * Context:
  * May sleep if called *not* from interrupt context.
- *
- * NOTE: assumes that the object at @addr has a size >= sizeof(llist_node)
+ * Must not be called in NMI context (strictly speaking, it could be
+ * if we have CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG, but making the calling
+ * conventions for vfree() arch-depenedent would be a really bad idea).
  */
 void vfree(const void *addr)
 {
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-factor-find_get_incore_page-out-of-mincore_page.patch
mm-use-find_get_incore_page-in-memcontrol.patch
mm-optimise-madvise-willneed.patch
mm-optimise-madvise-willneed-fix.patch
proc-optimise-smaps-for-shmem-entries.patch
i915-use-find_lock_page-instead-of-find_lock_entry.patch
mm-convert-find_get_entry-to-return-the-head-page.patch
mm-convert-find_get_entry-to-return-the-head-page-fix.patch
mm-shmem-return-head-page-from-find_lock_entry.patch
mm-shmem-return-head-page-from-find_lock_entry-fix.patch
mm-add-find_lock_head.patch
mm-filemap-fix-filemap_map_pages-for-thp.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
page_alloc-fix-freeing-non-compound-pages.patch
xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
xarray-add-xas_split-fix-2.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size.patch
mm-page_owner-change-split_page_owner-to-take-a-count.patch
mm-huge_memory-fix-page_trans_huge_mapcount-assumption-of-thp-size.patch
mm-huge_memory-fix-can_split_huge_page-assumption-of-thp-size.patch
mm-rmap-fix-assumptions-of-thp-size.patch
mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch
mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch
mm-vmscan-allow-arbitrary-sized-pages-to-be-paged-out.patch
fs-add-a-filesystem-flag-for-thps.patch
fs-do-not-update-nr_thps-for-mappings-which-support-thps.patch
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch
harden-autofs-ioctl-table.patch
mm-update-the-documentation-for-vfree.patch

