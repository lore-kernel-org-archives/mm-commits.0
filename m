Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3716C6FA89
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiILD2y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiILD2Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:28:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8BEF252BF
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:28:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A87961169
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E6DC43470;
        Mon, 12 Sep 2022 03:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953301;
        bh=xyAE919HrjqgiymvrXYCL++a+FF2qDVwc1im0pxvivQ=;
        h=Date:To:From:Subject:From;
        b=zZemM+QugZkxhx2aBp/X+d+lmu0D5UEFcQumwFCtDHomUyJ0/a15datX6uClNC0PB
         df7Xu7CLOACqBLPjRZ3MCOAvk0DGGOz+l7iWFEYb2yDOFh/nuOdT42EFwwiLTRVoa6
         EVRD79rlhIVg9LGmAVN9j4vqOuQrcI2UOGxolXto=
Date:   Sun, 11 Sep 2022 20:28:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, riel@surriel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-align-larger-anonymous-mappings-on-thp-boundaries.patch removed from -mm tree
Message-Id: <20220912032821.95E6DC43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: align larger anonymous mappings on THP boundaries
has been removed from the -mm tree.  Its filename was
     mm-align-larger-anonymous-mappings-on-thp-boundaries.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: mm: align larger anonymous mappings on THP boundaries
Date: Tue, 9 Aug 2022 14:24:57 -0400

Align larger anonymous memory mappings on THP boundaries by going through
thp_get_unmapped_area if THPs are enabled for the current process.

With this patch, larger anonymous mappings are now THP aligned.  When a
malloc library allocates a 2MB or larger arena, that arena can now be
mapped with THPs right from the start, which can result in better TLB hit
rates and execution time.

Link: https://lkml.kernel.org/r/20220809142457.4751229f@imladris.surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/mmap.c~mm-align-larger-anonymous-mappings-on-thp-boundaries
+++ a/mm/mmap.c
@@ -2232,6 +2232,9 @@ get_unmapped_area(struct file *file, uns
 		 */
 		pgoff = 0;
 		get_area = shmem_get_unmapped_area;
+	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		/* Ensures that larger anonymous mappings are THP aligned. */
+		get_area = thp_get_unmapped_area;
 	}
 
 	addr = get_area(file, addr, len, pgoff, flags);
_

Patches currently in -mm which might be from riel@surriel.com are


