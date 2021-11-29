Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF5C7C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 22:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbhK2Wum (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 17:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbhK2Wu0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 17:50:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B20C0E2EC8
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 13:27:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 29D76CE16B9
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 21:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06086C53FAD;
        Mon, 29 Nov 2021 21:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638221249;
        bh=buOpF7o0A+jCcTHX4EeQUWcCKramoNJ2Ajl6125wgRE=;
        h=Date:From:To:Subject:From;
        b=gD8IbSUqoJxtPy59fvSYZO6lRBL/DHDisFAxUFcHY+YDkdGtjoTjLQsPqFv9yu6yF
         r7AjxZRHuCFWYtp52KFbU0BNW3m1ASluJYTnU/x4BBMLvDNxsk8qZb5PBgCpIfWywF
         TE4P7gVyS18mc3ABgwtsYM2DCLeKKLKdGJMcmX/Q=
Date:   Mon, 29 Nov 2021 13:27:28 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, david@fromorbit.com, hch@lst.de,
        idryomov@gmail.com, jlayton@kernel.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de, urezki@gmail.com,
        vbabka@suse.cz
Subject:  + mm-vmalloc-add-support-for-__gfp_nofail.patch added to
 -mm tree
Message-ID: <20211129212728.KLLl43YN4%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: add support for __GFP_NOFAIL
has been added to the -mm tree.  Its filename is
     mm-vmalloc-add-support-for-__gfp_nofail.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-add-support-for-__gfp_nofail.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-add-support-for-__gfp_nofail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm/vmalloc: add support for __GFP_NOFAIL

Dave Chinner has mentioned that some of the xfs code would benefit from
kvmalloc support for __GFP_NOFAIL because they have allocations that
cannot fail and they do not fit into a single page.

The large part of the vmalloc implementation already complies with the
given gfp flags so there is no work for those to be done.  The area and
page table allocations are an exception to that.  Implement a retry loop
for those.

Add a short sleep before retrying.  1 jiffy is a completely random
timeout.  Ideally the retry would wait for an explicit event - e.g.  a
change to the vmalloc space change if the failure was caused by the space
fragmentation or depletion.  But there are multiple different reasons to
retry and this could become much more complex.  Keep the retry simple for
now and just sleep to prevent from hogging CPUs.

Link: https://lkml.kernel.org/r/20211122153233.9924-3-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Neil Brown <neilb@suse.de>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-support-for-__gfp_nofail
+++ a/mm/vmalloc.c
@@ -2844,6 +2844,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	 * more permissive.
 	 */
 	if (!order) {
+		gfp_t bulk_gfp = gfp & ~__GFP_NOFAIL;
+
 		while (nr_allocated < nr_pages) {
 			unsigned int nr, nr_pages_request;
 
@@ -2861,12 +2863,12 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			 * but mempolcy want to alloc memory by interleaving.
 			 */
 			if (IS_ENABLED(CONFIG_NUMA) && nid == NUMA_NO_NODE)
-				nr = alloc_pages_bulk_array_mempolicy(gfp,
+				nr = alloc_pages_bulk_array_mempolicy(bulk_gfp,
 							nr_pages_request,
 							pages + nr_allocated);
 
 			else
-				nr = alloc_pages_bulk_array_node(gfp, nid,
+				nr = alloc_pages_bulk_array_node(bulk_gfp, nid,
 							nr_pages_request,
 							pages + nr_allocated);
 
@@ -2921,6 +2923,7 @@ static void *__vmalloc_area_node(struct
 {
 	const gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
 	const gfp_t orig_gfp_mask = gfp_mask;
+	bool nofail = gfp_mask & __GFP_NOFAIL;
 	unsigned long addr = (unsigned long)area->addr;
 	unsigned long size = get_vm_area_size(area);
 	unsigned long array_size;
@@ -2978,8 +2981,12 @@ static void *__vmalloc_area_node(struct
 	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
 		flags = memalloc_noio_save();
 
-	ret = vmap_pages_range(addr, addr + size, prot, area->pages,
+	do {
+		ret = vmap_pages_range(addr, addr + size, prot, area->pages,
 			page_shift);
+		if (nofail && (ret < 0))
+			schedule_timeout_uninterruptible(1);
+	} while (nofail && (ret < 0));
 
 	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
 		memalloc_nofs_restore(flags);
@@ -3074,9 +3081,14 @@ again:
 				  VM_UNINITIALIZED | vm_flags, start, end, node,
 				  gfp_mask, caller);
 	if (!area) {
+		bool nofail = gfp_mask & __GFP_NOFAIL;
 		warn_alloc(gfp_mask, NULL,
-			"vmalloc error: size %lu, vm_struct allocation failed",
-			real_size);
+			"vmalloc error: size %lu, vm_struct allocation failed%s",
+			real_size, (nofail) ? ". Retrying." : "");
+		if (nofail) {
+			schedule_timeout_uninterruptible(1);
+			goto again;
+		}
 		goto fail;
 	}
 
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmalloc-alloc-gfp_nofsio-for-vmalloc.patch
mm-vmalloc-add-support-for-__gfp_nofail.patch
mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch
mm-allow-gfp_kernel-allocations-for-kvmalloc.patch
mm-make-slab-and-vmalloc-allocators-__gfp_nolockdep-aware.patch
mm-drop-node-from-alloc_pages_vma.patch

