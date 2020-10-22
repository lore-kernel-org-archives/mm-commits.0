Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEDDC5517A
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD86124641
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408203;
	bh=FPqqGO+/hSLFp1AFmtM5de111yve9tzLp1JfjV968Fk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Rs83dTob+kCTdS3ta2jj6NoJqUbYOxitAsC6yxpyh72wBqLgPXfmswO9Kke1rPz6z
	 Xg0DfMMGoc7tij3KF1JmIULJ3aBfQD6DK3FweMTq9r9rcbFEZbgig65zQNrXvBru0F
	 j6pcgsLb+m2Pv39i10CijQdsNy2wgkprsCb/HZxo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373127AbgJVXKC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:10:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:50324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373254AbgJVXKC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:10:02 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B25520756;
        Thu, 22 Oct 2020 23:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408201;
        bh=FPqqGO+/hSLFp1AFmtM5de111yve9tzLp1JfjV968Fk=;
        h=Date:From:To:Subject:From;
        b=PvSNWCxDGTTjRVJ8SJXG2Ktj8rcX9D0/KChV7FESmkTNqTceDrjUEKOEAZOyjkRNn
         EKsUM+AVeFBXkTwiXupeilgjBDp/R4A9phireFDilgqmtM+A7ZpFEUkNIdl/kJeHRJ
         I2zUu3ecW8+/Wz6NUwGVXj6HXMTCLNdtMRGO430s=
Date:   Thu, 22 Oct 2020 16:09:59 -0700
From:   akpm@linux-foundation.org
To:     boris.ostrovsky@oracle.com, chris@chris-wilson.co.uk, hch@lst.de,
        jani.nikula@linux.intel.com, jgross@suse.com,
        joonas.lahtinen@linux.intel.com, matthew.auld@intel.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org,
        peterz@infradead.org, rodrigo.vivi@intel.com,
        sstabellini@kernel.org, tvrtko.ursulin@linux.intel.com,
        urezki@gmail.com, willy@infradead.org
Subject:  [merged] mm-update-the-documentation-for-vfree.patch
 removed from -mm tree
Message-ID: <20201022230959.SPAk6j3uM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: update the documentation for vfree
has been removed from the -mm tree.  Its filename was
     mm-update-the-documentation-for-vfree.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


