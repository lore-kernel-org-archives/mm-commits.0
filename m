Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A95B9C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 21:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbhK2Vcr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 16:32:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57222 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbhK2Vaq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 16:30:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03E83B81648
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 21:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61841C53FC7;
        Mon, 29 Nov 2021 21:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638221246;
        bh=nTzfJpJUxTMMC5JaONd9WKXZPZiIZO4QPhA2sumEiiU=;
        h=Date:From:To:Subject:From;
        b=hlMf/t/q/FrnjRh34X2bGYxUqKgNx59j31jrPiyECbetkJsFweYNuHcfnPQ7HzRGJ
         wMC7N9HI5duT9oS3jCpSqxcEJILIIi41ipvmPNL1/zTvAgV3aQIShZyY8564LY/42o
         OvGMjgcdNmNN+cBLnn/JtbciBcoEXaCtzT1I5ejk=
Date:   Mon, 29 Nov 2021 13:27:25 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, dchinner@redhat.com, hch@lst.de,
        idryomov@gmail.com, jlayton@kernel.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de, urezki@gmail.com,
        vbabka@suse.cz
Subject:  + mm-vmalloc-alloc-gfp_nofsio-for-vmalloc.patch added to
 -mm tree
Message-ID: <20211129212725.umN3G-Odg%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc
has been added to the -mm tree.  Its filename is
     mm-vmalloc-alloc-gfp_nofsio-for-vmalloc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-alloc-gfp_nofsio-for-vmalloc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-alloc-gfp_nofsio-for-vmalloc.patch

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
Subject: mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc

Patch series "extend vmalloc support for constrained allocations", v2.

Based on a recent discussion with Dave and Neil [1] I have tried to
implement NOFS, NOIO, NOFAIL support for the vmalloc to make life of
kvmalloc users easier.

A requirement for NOFAIL support for kvmalloc was new to me but this seems
to be really needed by the xfs code.

NOFS/NOIO was a known and a long term problem which was hoped to be
handled by the scope API.  Those scope should have been used at the
reclaim recursion boundaries both to document them and also to remove the
necessity of NOFS/NOIO constrains for all allocations within that scope. 
Instead workarounds were developed to wrap a single allocation instead
(like ceph_kvmalloc).

First patch implements NOFS/NOIO support for vmalloc.  The second one adds
NOFAIL support and the third one bundles all together into kvmalloc and
drops ceph_kvmalloc which can use kvmalloc directly now.

[1] http://lkml.kernel.org/r/163184741778.29351.16920832234899124642.stgit@noble.brown


This patch (of 4):

vmalloc historically hasn't supported GFP_NO{FS,IO} requests because page
table allocations do not support externally provided gfp mask and
performed GFP_KERNEL like allocations.

Since few years we have scope (memalloc_no{fs,io}_{save,restore}) APIs to
enforce NOFS and NOIO constrains implicitly to all allocators within the
scope.  There was a hope that those scopes would be defined on a higher
level when the reclaim recursion boundary starts/stops (e.g.  when a lock
required during the memory reclaim is required etc.).  It seems that not
all NOFS/NOIO users have adopted this approach and instead they have taken
a workaround approach to wrap a single [k]vmalloc allocation by a scope
API.

These workarounds do not serve the purpose of a better reclaim recursion
documentation and reduction of explicit GFP_NO{FS,IO} usege so let's just
provide them with the semantic they are asking for without a need for
workarounds.

Add support for GFP_NOFS and GFP_NOIO to vmalloc directly.  All internal
allocations already comply with the given gfp_mask.  The only current
exception is vmap_pages_range which maps kernel page tables.  Infer the
proper scope API based on the given gfp mask.

Link: https://lkml.kernel.org/r/20211122153233.9924-1-mhocko@kernel.org
Link: https://lkml.kernel.org/r/20211122153233.9924-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-alloc-gfp_nofsio-for-vmalloc
+++ a/mm/vmalloc.c
@@ -2926,6 +2926,8 @@ static void *__vmalloc_area_node(struct
 	unsigned long array_size;
 	unsigned int nr_small_pages = size >> PAGE_SHIFT;
 	unsigned int page_order;
+	unsigned int flags;
+	int ret;
 
 	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
 	gfp_mask |= __GFP_NOWARN;
@@ -2967,8 +2969,24 @@ static void *__vmalloc_area_node(struct
 		goto fail;
 	}
 
-	if (vmap_pages_range(addr, addr + size, prot, area->pages,
-			page_shift) < 0) {
+	/*
+	 * page tables allocations ignore external gfp mask, enforce it
+	 * by the scope API
+	 */
+	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
+		flags = memalloc_nofs_save();
+	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
+		flags = memalloc_noio_save();
+
+	ret = vmap_pages_range(addr, addr + size, prot, area->pages,
+			page_shift);
+
+	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
+		memalloc_nofs_restore(flags);
+	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
+		memalloc_noio_restore(flags);
+
+	if (ret < 0) {
 		warn_alloc(orig_gfp_mask, NULL,
 			"vmalloc error: size %lu, failed to map pages",
 			area->nr_pages * PAGE_SIZE);
_

Patches currently in -mm which might be from mhocko@suse.com are

mm-vmalloc-alloc-gfp_nofsio-for-vmalloc.patch
mm-vmalloc-add-support-for-__gfp_nofail.patch
mm-vmalloc-be-more-explicit-about-supported-gfp-flags.patch
mm-allow-gfp_kernel-allocations-for-kvmalloc.patch
mm-make-slab-and-vmalloc-allocators-__gfp_nolockdep-aware.patch
mm-drop-node-from-alloc_pages_vma.patch

