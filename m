Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF8F7C433E6
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BE2D64F32
	for <mm-commits@archiver.kernel.org>; Sat, 27 Feb 2021 02:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhB0C2r (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 Feb 2021 21:28:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhB0C2r (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 26 Feb 2021 21:28:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93F9061601;
        Sat, 27 Feb 2021 02:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614392886;
        bh=OCyCIrX1kk5avI++tt6XZoyIx7QVEv1elUCJgX67+R0=;
        h=Date:From:To:Subject:From;
        b=UTlrrbR156HyHajxFiJqdm3zsO9c+e1c/IdIMlrDPvkhxLOC6tk+X7/Phzs3rHi13
         iIroI7Wzr2tnW8K1+JfeBZ/6wT9c6gPRt3XUmnH2+sSIgqrXGeoKpgPEF7i44thGM6
         VG8VXqgE5SkHsZVBrZQJ2+pT07i4+SDfLvpZBxBI=
Date:   Fri, 26 Feb 2021 18:28:06 -0800
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  [merged]
 mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch removed from -mm
 tree
Message-ID: <20210227022806.68ZeW6AYz%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/shmem: use pagevec_lookup in shmem_unlock_mapping
has been removed from the -mm tree.  Its filename was
     mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/shmem: use pagevec_lookup in shmem_unlock_mapping

The comment shows that the reason for using find_get_entries() is now
stale; find_get_pages() will not return 0 if it hits a consecutive run of
swap entries, and I don't believe it has since 2011.  pagevec_lookup() is
a simpler function to use than find_get_pages(), so use it instead.

Link: https://lkml.kernel.org/r/20201112212641.27837-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/mm/shmem.c~mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping
+++ a/mm/shmem.c
@@ -842,7 +842,6 @@ unsigned long shmem_swap_usage(struct vm
 void shmem_unlock_mapping(struct address_space *mapping)
 {
 	struct pagevec pvec;
-	pgoff_t indices[PAGEVEC_SIZE];
 	pgoff_t index = 0;
 
 	pagevec_init(&pvec);
@@ -850,16 +849,8 @@ void shmem_unlock_mapping(struct address
 	 * Minor point, but we might as well stop if someone else SHM_LOCKs it.
 	 */
 	while (!mapping_unevictable(mapping)) {
-		/*
-		 * Avoid pagevec_lookup(): find_get_pages() returns 0 as if it
-		 * has finished, if it hits a row of PAGEVEC_SIZE swap entries.
-		 */
-		pvec.nr = find_get_entries(mapping, index,
-					   PAGEVEC_SIZE, pvec.pages, indices);
-		if (!pvec.nr)
+		if (!pagevec_lookup(&pvec, mapping, &index))
 			break;
-		index = indices[pvec.nr - 1] + 1;
-		pagevec_remove_exceptionals(&pvec);
 		check_move_unevictable_pages(&pvec);
 		pagevec_release(&pvec);
 		cond_resched();
_

Patches currently in -mm which might be from willy@infradead.org are


