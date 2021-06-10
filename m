Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40C9CC48BDF
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 22:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 176DA613F1
	for <mm-commits@archiver.kernel.org>; Thu, 10 Jun 2021 22:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFJXAh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Jun 2021 19:00:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230001AbhFJXAf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 10 Jun 2021 19:00:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BCEE613E1;
        Thu, 10 Jun 2021 22:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1623365904;
        bh=zDGyQoyk/iXMgPE+EzQNq3s1qTZWkXuXJJ7SsILgZ6M=;
        h=Date:From:To:Subject:From;
        b=nCAUmNg4nOD0HwkUMNjOSKA0TnM9TCB69MhAvg94hOZzEKda4bL9A1Oi9peDd5ak2
         +bkV5Gy2woFUo2D4+382cfQZIHaQRrVd/2FJzmAzkiVdz16IJ8QdmcikNM/mPl8219
         qhEcy7ZquCSRkntwOdOUq1WdM6gDD+xsGpqAg5kQ=
Date:   Thu, 10 Jun 2021 15:58:24 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?writeback-cgroup-release-dying-cgwbs-by-switching-attache?=
 =?US-ASCII?Q?d-inodes-fix-2.patch?= added to -mm tree
Message-ID: <20210610225824.KRpmytcO1%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-2
has been added to the -mm tree.  Its filename is
     writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-2

replace open-coded "115" with arithmetic

Link: https://lkml.kernel.org/r/YMEcSBcq/VXMiPPO@carbon.dhcp.thefacebook.com

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fs-writeback.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/fs-writeback.c~writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-2
+++ a/fs/fs-writeback.c
@@ -229,7 +229,8 @@ void wb_wait_for_completion(struct wb_co
  * Maximum inodes per isw.  A specific value has been chosen to make
  * struct inode_switch_wbs_context fit into 1024 bytes kmalloc.
  */
-#define WB_MAX_INODES_PER_ISW	115
+#define WB_MAX_INODES_PER_ISW  ((1024UL - sizeof(struct inode_switch_wbs_context)) \
+                                / sizeof(struct inode *))
 
 static atomic_t isw_nr_in_flight = ATOMIC_INIT(0);
 static struct workqueue_struct *isw_wq;
_

Patches currently in -mm which might be from guro@fb.com are

writeback-cgroup-do-not-switch-inodes-with-i_will_free-flag.patch
writeback-cgroup-add-smp_mb-to-cgroup_writeback_umount.patch
writeback-cgroup-increment-isw_nr_in_flight-before-grabbing-an-inode.patch
writeback-cgroup-switch-to-rcu_work-api-in-inode_switch_wbs.patch
writeback-cgroup-keep-list-of-inodes-attached-to-bdi_writeback.patch
writeback-cgroup-split-out-the-functional-part-of-inode_switch_wbs_work_fn.patch
writeback-cgroup-support-switching-multiple-inodes-at-once.patch
writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes.patch
writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-2.patch
writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix.patch

