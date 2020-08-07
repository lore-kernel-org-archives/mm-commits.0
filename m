Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5AE5C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7432E22CAF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781219;
	bh=5Ljwl9+hAOQKO5kGK9vO0ejknpmWlSa6fzSTlSSNcoE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=XihhCbY4ycQsNDhMt/4zVhUk+zetrp5MPukjvlCXFm97eZ/an4kbMTUYhj6hPHxKW
	 tgD31v2cQ3ZetE5O02yZcKD3G4QsrP0ioBZMKmEdD+s0gTnHK2uRXwk6CadbYpkhBC
	 VcCbl1MLl2BsvVE4E3fNnGqIpmEI47XOf8wuJXnM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgHGGUT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGUS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:20:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24BEC2177B;
        Fri,  7 Aug 2020 06:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781218;
        bh=5Ljwl9+hAOQKO5kGK9vO0ejknpmWlSa6fzSTlSSNcoE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=f2AXjbDyMWjyzmrSNonI+3C05GJklJI5EUBWwivLVQlqf1M8NSe/OBfKT6UR9EFGk
         T7CHVyBz2v/hvn/K50HRZFGMpEnBJQgSokSHiv5A4I7hb424IWwPzhsvCX3kajYRKk
         2wCf2F2PO3S9zOsVF/LEBASRVsaIyFz3TApLv33w=
Date:   Thu, 06 Aug 2020 23:20:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, bvanassche@acm.org,
        hare@suse.de, hughd@google.com, linux-mm@kvack.org,
        ming.lei@redhat.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, xianting_tian@126.com
Subject:  [patch 058/163] mm/page_io.c: use blk_io_schedule() for
 avoiding task hung in sync io
Message-ID: <20200807062017.4V6PayTV1%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xianting Tian <xianting_tian@126.com>
Subject: mm/page_io.c: use blk_io_schedule() for avoiding task hung in sync io

swap_readpage() does the sync io for one page, the io is not big,
normally, the io can be finished quickly, but it may take long time or
wait forever in case of io failure or discard.

This patch uses blk_io_schedule() instead of io_schedule() to avoid task
hung and crash (when set /proc/sys/kernel/hung_task_panic) when the above
exception occurs.

This is similar to the hung task avoidance in submit_bio_wait(),
blk_execute_rq() and __blkdev_direct_IO().

Link: http://lkml.kernel.org/r/1596461807-21087-1-git-send-email-xianting_tian@126.com
Signed-off-by: Xianting Tian <xianting_tian@126.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_io.c~mm-use-blk_io_schedule-for-avoiding-task-hung-in-sync-io
+++ a/mm/page_io.c
@@ -441,7 +441,7 @@ int swap_readpage(struct page *page, boo
 			break;
 
 		if (!blk_poll(disk->queue, qc, true))
-			io_schedule();
+			blk_io_schedule();
 	}
 	__set_current_state(TASK_RUNNING);
 	bio_put(bio);
_
