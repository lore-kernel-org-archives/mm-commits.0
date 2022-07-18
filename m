Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D14FCCA485
	for <mm-commits@archiver.kernel.org>; Mon, 18 Jul 2022 00:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiGRAWE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 20:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbiGRAUp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 20:20:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8431C2710
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 17:18:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EE566CE117E
        for <mm-commits@vger.kernel.org>; Mon, 18 Jul 2022 00:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23EDAC341CA;
        Mon, 18 Jul 2022 00:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658103528;
        bh=bLwFMMH2DIfbASlOsjtmHjvZCHCp1MFhsiWNZ7Sy9XU=;
        h=Date:To:From:Subject:From;
        b=XfgErqmERxvm+MLp3Nx1jMINVucOexvV05o4TCTBGevYhT98MG8wOQUsOtLqQbZaA
         IcXTLUaelqmcdGlKqn/b3sWnTlXlh9JdsaEJUXffwE4EB0CvoaTAIAEDT3s71K7O67
         miDltcpi+OWFL5M4nij0mladNADZCZxookLCnyQ0=
Date:   Sun, 17 Jul 2022 17:18:47 -0700
To:     mm-commits@vger.kernel.org, johannes.thumshirn@wdc.com,
        jack@suse.cz, axboe@kernel.dk, xiujianfeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] writeback-cleanup-bdi_sched_wait.patch removed from -mm tree
Message-Id: <20220718001848.23EDAC341CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: writeback: cleanup bdi_sched_wait()
has been removed from the -mm tree.  Its filename was
     writeback-cleanup-bdi_sched_wait.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: writeback: cleanup bdi_sched_wait()
Date: Wed, 13 Jul 2022 20:53:14 +0800

bdi_sched_wait() is no longer used since commit 839a8e8660b6 ("writeback:
replace custom worker pool implementation with unbound workqueue"), so
remove it.

Link: https://lkml.kernel.org/r/20220713125314.171345-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/include/linux/backing-dev.h~writeback-cleanup-bdi_sched_wait
+++ a/include/linux/backing-dev.h
@@ -140,12 +140,6 @@ static inline bool mapping_can_writeback
 	return inode_to_bdi(mapping->host)->capabilities & BDI_CAP_WRITEBACK;
 }
 
-static inline int bdi_sched_wait(void *word)
-{
-	schedule();
-	return 0;
-}
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 
 struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are

writeback-cleanup-inode_to_wb_is_valid.patch

