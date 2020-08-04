Return-Path: <SRS0=09mD=BO=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34307C433DF
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 00:11:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EA6D2086A
	for <mm-commits@archiver.kernel.org>; Tue,  4 Aug 2020 00:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596499878;
	bh=OJakgQN2QFLO0xsgGSp/8TRg4dqUmop2FnflVLWVw+s=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Wlb8hNBL2iGG5jeykE7zFp+8PiD7+CXeWhrmKAMOiC6TDN/YzxFnZ+iIUzljrWAdF
	 f9aWxE/0OYw2jTZX/Fob8Zkg7sGSP7fnkhtdDG9cTyZEbxhN/q/7lRmYamyzbPDM6g
	 jSS+YUC1h/u241f9+wH8BNQA5DqyibLeuX0lm0h0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgHDALR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Aug 2020 20:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728010AbgHDALP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 3 Aug 2020 20:11:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D95632076E;
        Tue,  4 Aug 2020 00:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596499874;
        bh=OJakgQN2QFLO0xsgGSp/8TRg4dqUmop2FnflVLWVw+s=;
        h=Date:From:To:Subject:From;
        b=RBsNycY0fl8VA52fmi462H3MpotBsBFoXzPrbYSRyM8Pnj0HTxSWVce6Nwt2p4dP9
         4IT7sZo0dFJYNgXbpde0Iv4pV08yiMSWdIvqRfFPJt1e1dEurRPo4zM4T+CMqL3u+g
         /d5diis+vGesm2xr5Q0AwAo/pC+GkGUcXhwL2apE=
Date:   Mon, 03 Aug 2020 17:11:13 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, axboe@kernel.dk, bvanassche@acm.org,
        hare@suse.de, hughd@google.com, ming.lei@redhat.com,
        mm-commits@vger.kernel.org, xianting_tian@126.com
Subject:  +
 mm-use-blk_io_schedule-for-avoiding-task-hung-in-sync-io.patch added to -mm
 tree
Message-ID: <20200804001113.0toe3M3uW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_io.c: use blk_io_schedule() for avoiding task hung in sync io
has been added to the -mm tree.  Its filename is
     mm-use-blk_io_schedule-for-avoiding-task-hung-in-sync-io.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-blk_io_schedule-for-avoiding-task-hung-in-sync-io.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-blk_io_schedule-for-avoiding-task-hung-in-sync-io.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-use-blk_io_schedule-for-avoiding-task-hung-in-sync-io.patch

