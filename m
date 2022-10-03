Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FE9C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbiJCVMw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiJCVLh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD73951439
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 684FB611F0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B81C9C433B5;
        Mon,  3 Oct 2022 21:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831223;
        bh=GBbILlAniMHKp21QMwo7NNnds8XJLpNyaWq7OIrxTbI=;
        h=Date:To:From:Subject:From;
        b=mv6WCf5fokm1vhcDOpw64NiDx5YY4Jy43qTfmHJPgOxGJwxb17xjpLw0SJ/uuFWW6
         cNF9qpAK8orAsuFpxn8lY4hec1XlZAGaecN2BYkvw/FAn6qOWPuBVn44BUIJJMBkE4
         9BG5YxUxeyewx4WzIUFnZYamyxKnon53rfsXO7AQ=
Date:   Mon, 03 Oct 2022 14:07:03 -0700
To:     mm-commits@vger.kernel.org, zhanglianjie@uniontech.com,
        willy@infradead.org, vbabka@suse.cz, neilb@suse.de, jack@suse.cz,
        dhowells@redhat.com, bvanassche@acm.org, axboe@kernel.dk,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-remove-unused-macro-dirty_full_scope.patch removed from -mm tree
Message-Id: <20221003210703.B81C9C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: writeback: remove unused macro DIRTY_FULL_SCOPE
has been removed from the -mm tree.  Its filename was
     writeback-remove-unused-macro-dirty_full_scope.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: writeback: remove unused macro DIRTY_FULL_SCOPE
Date: Fri, 9 Sep 2022 10:57:11 +0800

It's introduced but never used. Remove it.

Link: https://lkml.kernel.org/r/20220909025711.32012-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Jens Axboe <axboe@kernel.dk>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: zhanglianjie <zhanglianjie@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |    8 --------
 1 file changed, 8 deletions(-)

--- a/include/linux/writeback.h~writeback-remove-unused-macro-dirty_full_scope
+++ a/include/linux/writeback.h
@@ -17,20 +17,12 @@ struct bio;
 DECLARE_PER_CPU(int, dirty_throttle_leaks);
 
 /*
- * The 1/4 region under the global dirty thresh is for smooth dirty throttling:
- *
- *	(thresh - thresh/DIRTY_FULL_SCOPE, thresh)
- *
- * Further beyond, all dirtier tasks will enter a loop waiting (possibly long
- * time) for the dirty pages to drop, unless written enough pages.
- *
  * The global dirty threshold is normally equal to the global dirty limit,
  * except when the system suddenly allocates a lot of anonymous memory and
  * knocks down the global dirty threshold quickly, in which case the global
  * dirty limit will follow down slowly to prevent livelocking all dirtier tasks.
  */
 #define DIRTY_SCOPE		8
-#define DIRTY_FULL_SCOPE	(DIRTY_SCOPE / 2)
 
 struct backing_dev_info;
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


