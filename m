Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70E85C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A9AE61CF6
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhF2AUy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:58870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhF2AUx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:20:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B4B561CED;
        Tue, 29 Jun 2021 00:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624925907;
        bh=PGQpo6jknyFwE004aZOmuPVQeF6wxArEQzwVtnubvpE=;
        h=Date:From:To:Subject:From;
        b=EXV/qOohXU5FqOrX4leF/veJ/4pEuermB6eU+P+eS2vExzTD/72Wr2T0CYMQQnWFa
         PS92CUGGaRVNpMAbOjuVwjCVcrIrmcrfDCmkRQNFw//wIpNvrxrJR05I8Gm4rhhl12
         tBPGQOhe9rNc6KcQ6CJe/Z3WqHIT36wHGTncy4/I=
Date:   Mon, 28 Jun 2021 17:18:26 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, mm-commits@vger.kernel.org
Subject:  [folded-merged]
 =?US-ASCII?Q?writeback-cgroup-release-dying-cgwbs-by-switching-attache?=
 =?US-ASCII?Q?d-inodes-fix-2.patch?= removed from -mm tree
Message-ID: <20210629001826.fjN3z0kcA%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-2
has been removed from the -mm tree.  Its filename was
     writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix-2.patch

This patch was dropped because it was folded into writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes.patch

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
writeback-cgroup-release-dying-cgwbs-by-switching-attached-inodes-fix.patch

