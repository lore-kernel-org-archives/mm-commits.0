Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5B3C4321E
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:40:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiKIBkd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiKIBji (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:39:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455DD66CBF
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:38:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01FFDB81CC7
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:38:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A09DC433D7;
        Wed,  9 Nov 2022 01:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957936;
        bh=IMZ9YYkBqvilUb4aaysYCM1qnYSkxYbR2l1BSuuOO7o=;
        h=Date:To:From:Subject:From;
        b=OTC9LD3BDWnzeUVWQv4B34nWI4dftrAphYAi/bV17+z/F07r5U0uAhANjxwTY3xTT
         /YgzgLHhS4TNtyDt/m2BsQBF1u5mJ956iW7LlHxMZDfkQJE9OyUDVueacBdEMrvfKa
         ypYZZxT0OjOJRqEcuw8M2Jej5xHx5ulsVQ8sXMi4=
Date:   Tue, 08 Nov 2022 17:38:56 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rostedt@goodmis.org, oleksiy.avramchenko@sony.com,
        npiggin@gmail.com, hch@lst.de, urezki@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-vmalloc-use-trace_purge_vmap_area_lazy-event.patch removed from -mm tree
Message-Id: <20221109013856.9A09DC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: vmalloc: use trace_purge_vmap_area_lazy event
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-use-trace_purge_vmap_area_lazy-event.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm: vmalloc: use trace_purge_vmap_area_lazy event
Date: Tue, 18 Oct 2022 20:10:51 +0200

This is for debug purposes and is called when all outstanding areas are
removed back to the vmap space.  It gives some extra information about:

- a start:end range where set of vmap ares were freed;
- a number of purged areas which were backed off.

[urezki@gmail.com: simplify return boolean expression]
  Link: https://lkml.kernel.org/r/20221020125247.5053-1-urezki@gmail.com
Link: https://lkml.kernel.org/r/20221018181053.434508-6-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-use-trace_purge_vmap_area_lazy-event
+++ a/mm/vmalloc.c
@@ -1730,6 +1730,7 @@ static void purge_fragmented_blocks_allc
 static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end)
 {
 	unsigned long resched_threshold;
+	unsigned int num_purged_areas = 0;
 	struct list_head local_purge_list;
 	struct vmap_area *va, *n_va;
 
@@ -1741,7 +1742,7 @@ static bool __purge_vmap_area_lazy(unsig
 	spin_unlock(&purge_vmap_area_lock);
 
 	if (unlikely(list_empty(&local_purge_list)))
-		return false;
+		goto out;
 
 	start = min(start,
 		list_first_entry(&local_purge_list,
@@ -1776,12 +1777,16 @@ static bool __purge_vmap_area_lazy(unsig
 					      va->va_start, va->va_end);
 
 		atomic_long_sub(nr, &vmap_lazy_nr);
+		num_purged_areas++;
 
 		if (atomic_long_read(&vmap_lazy_nr) < resched_threshold)
 			cond_resched_lock(&free_vmap_area_lock);
 	}
 	spin_unlock(&free_vmap_area_lock);
-	return true;
+
+out:
+	trace_purge_vmap_area_lazy(start, end, num_purged_areas);
+	return num_purged_areas > 0;
 }
 
 /*
_

Patches currently in -mm which might be from urezki@gmail.com are


