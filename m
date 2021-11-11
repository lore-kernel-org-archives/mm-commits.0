Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28363C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FB1161247
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbhKKCqO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:46:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:51426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234240AbhKKCqO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:46:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89B0F60F46;
        Thu, 11 Nov 2021 02:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598605;
        bh=fUWZKU1k1doPKSEb9q9slP9Gv5rVGc4Sdf2+Pba9jQI=;
        h=Date:From:To:Subject:From;
        b=XpHmhcmxtqUkqws5BEs8gzkhW6xQpvW6CmOwFqcugRvD3+mSAnIk3Y70G4oXuIq1I
         hspl2jnNFyCVX+Fhdagvdjm4QEHgywdaRd/6LlOyRoqLexhErtvEaQq4Jkt/XGCa/6
         oiuum58L1vK3NIEX5SwxUl6UPMcvpiaHi2f+yQ0U=
Date:   Wed, 10 Nov 2021 18:43:25 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, hch@infradead.org, hdanton@sina.com,
        mgorman@suse.de, mhocko@suse.com, mm-commits@vger.kernel.org,
        npiggin@gmail.com, oleksiy.avramchenko@sonymobile.com,
        pifang@redhat.com, rostedt@goodmis.org, urezki@gmail.com,
        willy@infradead.org
Subject:  [merged]
 mm-vmalloc-check-various-alignments-when-debugging.patch removed from -mm
 tree
Message-ID: <20211111024325.Qt04vaOqY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: check various alignments when debugging
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-check-various-alignments-when-debugging.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


