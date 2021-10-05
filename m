Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9183CC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 23:33:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7981A6124D
	for <mm-commits@archiver.kernel.org>; Tue,  5 Oct 2021 23:33:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236986AbhJEXfj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 5 Oct 2021 19:35:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236952AbhJEXfj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 5 Oct 2021 19:35:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FC5561222;
        Tue,  5 Oct 2021 23:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1633476828;
        bh=eAGh2aL3o8WMvL1tWQs4m7Nw+djfRmgJfNrPsx8AUQo=;
        h=Date:From:To:Subject:From;
        b=JE+rk/PUlXB8YGhNyRw+bgO6qHs24BjH27aoizMLi8Eq9Oxklvq9rQrpZ7Bq/F6Pi
         uKDJxNt5mF2Hj51WIXEh1Sh28lq6216JzhL+7L2bxUgx9DNXYOyKgBVeslxb/ZlS+D
         sdoQLXG6s1LRvxI0Z33JFHlpJmqFwfSolz7+ovrQ=
Date:   Tue, 05 Oct 2021 16:33:47 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, hch@infradead.org, hdanton@sina.com,
        mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        npiggin@gmail.com, oleksiy.avramchenko@sonymobile.com,
        pifang@redhat.com, rostedt@goodmis.org, urezki@gmail.com,
        willy@infradead.org
Subject:  +
 mm-vmalloc-check-various-alignments-when-debugging.patch added to -mm tree
Message-ID: <20211005233347.tozIQ0SEx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: check various alignments when debugging
has been added to the -mm tree.  Its filename is
     mm-vmalloc-check-various-alignments-when-debugging.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-check-various-alignments-when-debugging.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-check-various-alignments-when-debugging.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: mm/vmalloc: check various alignments when debugging

Before we did not guarantee a free block with lowest start address for
allocations with alignment >= PAGE_SIZE.  Because an alignment overhead
was included into a search length like below:

     length = size + align - 1;

doing so we make sure that a bigger block would fit after applying an
alignment adjustment.  Now there is no such limitation, i.e.  any
alignment that user wants to apply will result to a lowest address of
returned free area.

Link: https://lkml.kernel.org/r/20211004142829.22222-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oleksiy Avramchenko <oleksiy.avramchenko@sonymobile.com>
Cc: Ping Fang <pifang@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-check-various-alignments-when-debugging
+++ a/mm/vmalloc.c
@@ -1269,7 +1269,7 @@ find_vmap_lowest_linear_match(unsigned l
 }
 
 static void
-find_vmap_lowest_match_check(unsigned long size)
+find_vmap_lowest_match_check(unsigned long size, unsigned long align)
 {
 	struct vmap_area *va_1, *va_2;
 	unsigned long vstart;
@@ -1278,8 +1278,8 @@ find_vmap_lowest_match_check(unsigned lo
 	get_random_bytes(&rnd, sizeof(rnd));
 	vstart = VMALLOC_START + rnd;
 
-	va_1 = find_vmap_lowest_match(size, 1, vstart);
-	va_2 = find_vmap_lowest_linear_match(size, 1, vstart);
+	va_1 = find_vmap_lowest_match(size, align, vstart);
+	va_2 = find_vmap_lowest_linear_match(size, align, vstart);
 
 	if (va_1 != va_2)
 		pr_emerg("not lowest: t: 0x%p, l: 0x%p, v: 0x%lx\n",
@@ -1458,7 +1458,7 @@ __alloc_vmap_area(unsigned long size, un
 		return vend;
 
 #if DEBUG_AUGMENT_LOWEST_MATCH_CHECK
-	find_vmap_lowest_match_check(size);
+	find_vmap_lowest_match_check(size, align);
 #endif
 
 	return nva_start_addr;
_

Patches currently in -mm which might be from urezki@gmail.com are

mm-vmalloc-do-not-adjust-the-search-size-for-alignment-overhead.patch
mm-vmalloc-check-various-alignments-when-debugging.patch

