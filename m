Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 410F1C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jul 2022 15:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbiGMPJU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Jul 2022 11:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236861AbiGMPJM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2022 11:09:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7D0DEE
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 08:09:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 034B160B9F
        for <mm-commits@vger.kernel.org>; Wed, 13 Jul 2022 15:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEB4C34114;
        Wed, 13 Jul 2022 15:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1657724950;
        bh=wJmFwpBSqBA/ORS8aNGA7gHFRevrfBGNgzKWUOzdEK4=;
        h=Date:To:From:Subject:From;
        b=2ey7Z1Yt2U/izb4QT2kQZUYaabAC7NQ4UMvzQv3H/HfyiEVxcZok0BjFYozvDkFXS
         LnhNonIzM8KBrmN7qYWoLgHkthDzbkwHi6yvJPQIBLRUXe47eNA0e9N8Kn92j3emNl
         /oe/RKRaVLDAIwz7XfwkJo1zQ7nTfVihEc+mt1W4=
Date:   Wed, 13 Jul 2022 08:09:09 -0700
To:     mm-commits@vger.kernel.org, johannes.thumshirn@wdc.com,
        jack@suse.cz, xiujianfeng@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + writeback-cleanup-bdi_sched_wait.patch added to mm-unstable branch
Message-Id: <20220713150910.4CEB4C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback: cleanup bdi_sched_wait()
has been added to the -mm mm-unstable branch.  Its filename is
     writeback-cleanup-bdi_sched_wait.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/writeback-cleanup-bdi_sched_wait.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-mprotect-remove-the-redundant-initialization-for-error.patch
writeback-cleanup-bdi_sched_wait.patch

