Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA20E9412F
	for <mm-commits@archiver.kernel.org>; Fri,  6 Oct 2023 21:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbjJFVrT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 6 Oct 2023 17:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233789AbjJFVrM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 6 Oct 2023 17:47:12 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6BBFC
        for <mm-commits@vger.kernel.org>; Fri,  6 Oct 2023 14:47:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B468C433C8;
        Fri,  6 Oct 2023 21:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696628826;
        bh=AUQXthUXKKZ3rqQAcpG2z2Bn9yX5LZ12VD2bZjd47m4=;
        h=Date:To:From:Subject:From;
        b=s9npmHcNLsZrjqAd5bRpX+a3y8dtNA26+YVGz7t1b4N+7xIGCwhnXkpu2VTmq/Pac
         e8pwNyyeeubgQ9yNV9PxxsBralnphWO6SJX5LkvZ9rQsOtk69lVBGddTHQFcqGhm9v
         brqMjNSlVMyfzTrAo6hWhJHbUYLRzWI7EarVIT10=
Date:   Fri, 06 Oct 2023 14:47:04 -0700
To:     mm-commits@vger.kernel.org, sidhartha.kumar@oracle.com,
        dan.carpenter@linaro.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-filemap-remove-hugetlb-special-casing-in-filemapc-fix.patch removed from -mm tree
Message-Id: <20231006214706.7B468C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlbfs: fix an NULL vs IS_ERR() bug
has been removed from the -mm tree.  Its filename was
     mm-filemap-remove-hugetlb-special-casing-in-filemapc-fix.patch

This patch was dropped because it was folded into mm-filemap-remove-hugetlb-special-casing-in-filemapc.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@linaro.org>
Subject: hugetlbfs: fix an NULL vs IS_ERR() bug
Date: Thu, 28 Sep 2023 08:17:36 +0300

This code was converted from using find_lock_page() which returns NULL,
to calling filemap_lock_hugetlb_folio() which returns -ENOENT.  The
check needs to be updated to match.  Also IS_ERR() has an unlikely()
built in so we can remove that.

Link: https://lkml.kernel.org/r/1772c296-1417-486f-8eef-171af2192681@moroto.mountain
Fixes: 4649d8d5bb81 ("mm/filemap: remove hugetlb special casing in filemap.c")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/hugetlbfs/inode.c~mm-filemap-remove-hugetlb-special-casing-in-filemapc-fix
+++ a/fs/hugetlbfs/inode.c
@@ -354,7 +354,7 @@ static ssize_t hugetlbfs_read_iter(struc
 
 		/* Find the folio */
 		folio = filemap_lock_hugetlb_folio(h, mapping, index);
-		if (unlikely(folio == NULL)) {
+		if (IS_ERR(folio)) {
 			/*
 			 * We have a HOLE, zero out the user-buffer for the
 			 * length of the hole or request.
_

Patches currently in -mm which might be from dan.carpenter@linaro.org are

mm-filemap-remove-hugetlb-special-casing-in-filemapc.patch

