Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 168FEC07E9C
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E55B061CA1
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231803AbhGFTXs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231696AbhGFTXr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:23:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 866E461C9C;
        Tue,  6 Jul 2021 19:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625599268;
        bh=F2qnXNeFD+zT/09McaJNBDrSSQQBI8FBiOFzrdzPtNA=;
        h=Date:From:To:Subject:From;
        b=CqzZmx/sJLzsWvWyAO31ahxMN3ONIYI31/6dVKQztLfmLf/Iv/kg9giZXifkTW22d
         6oevkuTG4sndsZGQWLjp4ThqIOiTCmx2rWyaoqi+QQn+grT0G2sazDx/Dn27/mVRxW
         yVZmzgznpkIJeTklnj+BQIvmK9I3jGA96h3qbgXI=
Date:   Tue, 06 Jul 2021 12:21:08 -0700
From:   akpm@linux-foundation.org
To:     david@redhat.com, ddstreet@ieee.org, mgorman@techsingularity.net,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shy828301@gmail.com,
        vbabka@suse.cz
Subject:  [merged]
 mm-z3fold-add-kerneldoc-fields-for-z3fold_pool.patch removed from -mm tree
Message-ID: <20210706192108.G2KB_Hqqt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/z3fold: add kerneldoc fields for z3fold_pool
has been removed from the -mm tree.  Its filename was
     mm-z3fold-add-kerneldoc-fields-for-z3fold_pool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/z3fold: add kerneldoc fields for z3fold_pool

make W=1 generates the following warning for z3fold_pool

  mm/z3fold.c:171: warning: Function parameter or member 'zpool' not described in 'z3fold_pool'
  mm/z3fold.c:171: warning: Function parameter or member 'zpool_ops' not described in 'z3fold_pool'

Commit 9a001fc19ccc ("z3fold: the 3-fold allocator for compressed pages")
simply did not document the fields at the time.  Add rudimentary
documentation.

Link: https://lkml.kernel.org/r/20210520084809.8576-11-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/z3fold.c~mm-z3fold-add-kerneldoc-fields-for-z3fold_pool
+++ a/mm/z3fold.c
@@ -144,6 +144,8 @@ struct z3fold_header {
  * @c_handle:	cache for z3fold_buddy_slots allocation
  * @ops:	pointer to a structure of user defined operations specified at
  *		pool creation time.
+ * @zpool:	zpool driver
+ * @zpool_ops:	zpool operations structure with an evict callback
  * @compact_wq:	workqueue for page layout background optimization
  * @release_wq:	workqueue for safe page release
  * @work:	work_struct for safe page release
_

Patches currently in -mm which might be from mgorman@techsingularity.net are


