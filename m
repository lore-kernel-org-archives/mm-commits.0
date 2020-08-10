Return-Path: <SRS0=A/n1=BU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91BEC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1A1F20723
	for <mm-commits@archiver.kernel.org>; Mon, 10 Aug 2020 02:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597026976;
	bh=vzu2u1H+vMflyMPs4IuBRbuhucJHzRa5i2XmGzI4tOw=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=JkKLNVKUvDNW1IgEtlgE1KPLgke/Vh8M0/jrA2CPZlfk0XqoUCguAnVuP4+MgCxHe
	 A094oSctIg2V0yyx8V8lOWdPlx8OgMzb+QnOEZGEL2hpGn1opdUdje7il7zN488cwA
	 Mx7fm6j0r1c5R1sv/Rr2LUWDbKRfA5dUuRKm/loE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgHJCgQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 9 Aug 2020 22:36:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgHJCgQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 9 Aug 2020 22:36:16 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78E462065D;
        Mon, 10 Aug 2020 02:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597026975;
        bh=vzu2u1H+vMflyMPs4IuBRbuhucJHzRa5i2XmGzI4tOw=;
        h=Date:From:To:Subject:From;
        b=ZXafCGLS8bj6eD/ciGTZQNfAjtLJOUD3KYMismh/F5W19Hck1akJRkkbTj0PK+C0t
         xKGIdYhSXbujs2hVMs9vcyk8gXNHfHad2Ui2q7wAfzTAytWlyFpYpavIMebwB5eGM/
         0dMrybV7V3W2VaVVi5Eu53dJXdolFqdow1eo6XBc=
Date:   Sun, 09 Aug 2020 19:36:15 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, axboe@kernel.dk, bvanassche@acm.org,
        hare@suse.de, hughd@google.com, ming.lei@redhat.com,
        mm-commits@vger.kernel.org, xianting_tian@126.com
Subject:  [merged]
 mm-use-blk_io_schedule-for-avoiding-task-hung-in-sync-io.patch removed from
 -mm tree
Message-ID: <20200810023615.iL5LXAqyW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io.c: use blk_io_schedule() for avoiding task hung in sync io
has been removed from the -mm tree.  Its filename was
     mm-use-blk_io_schedule-for-avoiding-task-hung-in-sync-io.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from xianting_tian@126.com are


