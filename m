Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33E23EB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 20:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjFSUUK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjFSUUJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 16:20:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632C3D3;
        Mon, 19 Jun 2023 13:20:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED9FE60C55;
        Mon, 19 Jun 2023 20:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54ACEC433C8;
        Mon, 19 Jun 2023 20:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687206007;
        bh=iejU9ciVGcFPZLh9wBXZ5JQiyipXY5cxwyrz91O6Ru0=;
        h=Date:To:From:Subject:From;
        b=Pc+MGXrXkIaeuJAwHZqqZaa22QMQAIl6uObiIdBm7w97HbNBuosaTlYcOMx9waAMd
         wDnXzpBFbFH8IxG7I89AuLqmfqgQtpRMFNlq3tz3gF8Tv7TNIV9qBP5qeKOg5mnXAa
         utzXqOaxDaffQOjQN1CWy1S5Zj/+trYTD+BWoBDY=
Date:   Mon, 19 Jun 2023 13:20:06 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, urezki@gmail.com,
        stable@vger.kernel.org, mhocko@suse.com, hch@infradead.org,
        david@redhat.com, bhe@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-vmalloc-do-not-output-a-spurious-warning-when-huge-vmalloc-fails.patch removed from -mm tree
Message-Id: <20230619202007.54ACEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/vmalloc: do not output a spurious warning when huge vmalloc() fails
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-do-not-output-a-spurious-warning-when-huge-vmalloc-fails.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/vmalloc: do not output a spurious warning when huge vmalloc() fails
Date: Mon, 5 Jun 2023 21:11:07 +0100

In __vmalloc_area_node() we always warn_alloc() when an allocation
performed by vm_area_alloc_pages() fails unless it was due to a pending
fatal signal.

However, huge page allocations instigated either by vmalloc_huge() or
__vmalloc_node_range() (or a caller that invokes this like kvmalloc() or
kvmalloc_node()) always falls back to order-0 allocations if the huge page
allocation fails.

This renders the warning useless and noisy, especially as all callers
appear to be aware that this may fallback.  This has already resulted in
at least one bug report from a user who was confused by this (see link).

Therefore, simply update the code to only output this warning for order-0
pages when no fatal signal is pending.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1211410
Link: https://lkml.kernel.org/r/20230605201107.83298-1-lstoakes@gmail.com
Fixes: 80b1d8fdfad1 ("mm: vmalloc: correct use of __GFP_NOWARN mask in __vmalloc_area_node()")
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-do-not-output-a-spurious-warning-when-huge-vmalloc-fails
+++ a/mm/vmalloc.c
@@ -3098,11 +3098,20 @@ static void *__vmalloc_area_node(struct
 	 * allocation request, free them via vfree() if any.
 	 */
 	if (area->nr_pages != nr_small_pages) {
-		/* vm_area_alloc_pages() can also fail due to a fatal signal */
-		if (!fatal_signal_pending(current))
+		/*
+		 * vm_area_alloc_pages() can fail due to insufficient memory but
+		 * also:-
+		 *
+		 * - a pending fatal signal
+		 * - insufficient huge page-order pages
+		 *
+		 * Since we always retry allocations at order-0 in the huge page
+		 * case a warning for either is spurious.
+		 */
+		if (!fatal_signal_pending(current) && page_order == 0)
 			warn_alloc(gfp_mask, NULL,
-				"vmalloc error: size %lu, page order %u, failed to allocate pages",
-				area->nr_pages * PAGE_SIZE, page_order);
+				"vmalloc error: size %lu, failed to allocate pages",
+				area->nr_pages * PAGE_SIZE);
 		goto fail;
 	}
 
_

Patches currently in -mm which might be from lstoakes@gmail.com are


