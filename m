Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 894C9C77B7C
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 22:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbjEEWnI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 18:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjEEWnF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 18:43:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7254EC6;
        Fri,  5 May 2023 15:43:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55AF46142C;
        Fri,  5 May 2023 22:43:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADB31C433EF;
        Fri,  5 May 2023 22:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683326583;
        bh=ibHF5rc2uxff6U8TNbaiSlkDxut4FyWTb6X/x3RTk30=;
        h=Date:To:From:Subject:From;
        b=A1DrciISCcQ0smjtRoDWyTu+YS6jcnS6mJ/fiBcNssm42sr3bRa97kQhnx8miquun
         Ui/odobb6ZCmycpFyIWQCcAnwU/FA8Qlpb8ka4UQw6MOienTbvAli0zenRBk77eEzM
         FVnDUoGfiPX3jrdMmjU0O0bKPylt05boAeYy2MdU=
Date:   Fri, 05 May 2023 15:43:03 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        stable@vger.kernel.org, peterx@redhat.com, lstoakes@gmail.com,
        jhubbard@nvidia.com, hch@lst.de, david@redhat.com, jack@suse.cz,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-do-not-reclaim-private-data-from-pinned-page.patch removed from -mm tree
Message-Id: <20230505224303.ADB31C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: do not reclaim private data from pinned page
has been removed from the -mm tree.  Its filename was
     mm-do-not-reclaim-private-data-from-pinned-page.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jan Kara <jack@suse.cz>
Subject: mm: do not reclaim private data from pinned page
Date: Fri, 28 Apr 2023 14:41:40 +0200

If the page is pinned, there's no point in trying to reclaim it. 
Furthermore if the page is from the page cache we don't want to reclaim
fs-private data from the page because the pinning process may be writing
to the page at any time and reclaiming fs private info on a dirty page can
upset the filesystem (see link below).

Link: https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz
Link: https://lkml.kernel.org/r/20230428124140.30166-1-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/vmscan.c~mm-do-not-reclaim-private-data-from-pinned-page
+++ a/mm/vmscan.c
@@ -1967,6 +1967,16 @@ retry:
 			}
 		}
 
+		/*
+		 * Folio is unmapped now so it cannot be newly pinned anymore.
+		 * No point in trying to reclaim folio if it is pinned.
+		 * Furthermore we don't want to reclaim underlying fs metadata
+		 * if the folio is pinned and thus potentially modified by the
+		 * pinning process as that may upset the filesystem.
+		 */
+		if (folio_maybe_dma_pinned(folio))
+			goto activate_locked;
+
 		mapping = folio_mapping(folio);
 		if (folio_test_dirty(folio)) {
 			/*
_

Patches currently in -mm which might be from jack@suse.cz are


