Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A36FAC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347460AbiATV0E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377751AbiATV0D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:26:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABD0C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:26:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 447CAB81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FB9C340E0;
        Thu, 20 Jan 2022 21:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713961;
        bh=Q/9IazH68yDRR+zZ0YOG+2Uy1QtVNk8n58rJCAB0eXo=;
        h=Date:From:To:Subject:From;
        b=OF9aCOnUi/eFp1vJvsju5V4HuQwzpN/FoZCnretKH4rfz5HLWvWRwtgV4hfE5Xz2X
         Q14Sw+Iw8yAF4Do4qSkyS+GxBB0h+WL0qnTluzoNMXOlLRnVTTJbyz1OTQPapk9X0s
         p1D79bc9xCOBxc0hcplNHD2B4WcioJh7B/oNJyro=
Date:   Thu, 20 Jan 2022 13:26:00 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, dchinner@redhat.com, hch@lst.de,
        idryomov@gmail.com, jlayton@kernel.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, neilb@suse.de, sfr@canb.auug.org.au,
        urezki@gmail.com, vbabka@suse.cz
Subject:  [merged] mm-vmalloc-alloc-gfp_nofsio-for-vmalloc.patch
 removed from -mm tree
Message-ID: <20220120212600.itwinczgq%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: alloc GFP_NO{FS,IO} for vmalloc
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-alloc-gfp_nofsio-for-vmalloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[sfr@canb.auug.org.au: mm/vmalloc.c needs linux/sched/mm.h]
 Link: https://lkml.kernel.org/r/20211217232641.0148710c@canb.auug.org.au
Link: https://lkml.kernel.org/r/20211122153233.9924-1-mhocko@kernel.org
Link: https://lkml.kernel.org/r/20211122153233.9924-2-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
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

 mm/vmalloc.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-alloc-gfp_nofsio-for-vmalloc
+++ a/mm/vmalloc.c
@@ -39,6 +39,7 @@
 #include <linux/pgtable.h>
 #include <linux/uaccess.h>
 #include <linux/hugetlb.h>
+#include <linux/sched/mm.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
 
@@ -2928,6 +2929,8 @@ static void *__vmalloc_area_node(struct
 	unsigned long array_size;
 	unsigned int nr_small_pages = size >> PAGE_SHIFT;
 	unsigned int page_order;
+	unsigned int flags;
+	int ret;
 
 	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
 	gfp_mask |= __GFP_NOWARN;
@@ -2976,8 +2979,24 @@ static void *__vmalloc_area_node(struct
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


