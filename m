Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DA65C04A95
	for <mm-commits@archiver.kernel.org>; Wed, 28 Sep 2022 17:14:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbiI1ROh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Sep 2022 13:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234432AbiI1ROF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Sep 2022 13:14:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A6DFEEB5C
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 10:13:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3721061F3B
        for <mm-commits@vger.kernel.org>; Wed, 28 Sep 2022 17:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B96DC433D7;
        Wed, 28 Sep 2022 17:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664385207;
        bh=wrtnEoQg+8CuKrBUGflTcLEuh8ZfaURq4GB/3GOlLrQ=;
        h=Date:To:From:Subject:From;
        b=G98dqtEnUc9USnkLrVyL5LKyhQRxuWt70F+8ABkf8IVP5o3EHyNmxtfFwsw4JkPZi
         +YmrupKWBaDfN8fKY7rspSYN35q0BFOcWdqyFqze7o/qT8rrhl4vHM7VA1TEWsFYVT
         CLPxuHI3mZv/3iopKmEdDgEXmCpDOE4+0zM8nJeU=
Date:   Wed, 28 Sep 2022 10:13:20 -0700
To:     mm-commits@vger.kernel.org, xiang@kernel.org, willy@infradead.org,
        surenb@google.com, josef@toxicpanda.com,
        hsiangkao@linux.alibaba.com, hannes@cmpxchg.org, dsterba@suse.com,
        clm@fb.com, chao@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] sched-psi-export-psi_memstall_enterleave.patch removed from -mm tree
Message-Id: <20220928171327.6B96DC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: sched/psi: export psi_memstall_{enter,leave}
has been removed from the -mm tree.  Its filename was
     sched-psi-export-psi_memstall_enterleave.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: sched/psi: export psi_memstall_{enter,leave}
Date: Thu, 15 Sep 2022 10:41:57 +0100

To properly account for all refaults from file system logic, file systems
need to call psi_memstall_enter directly, so export it.

Link: https://lkml.kernel.org/r/20220915094200.139713-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chao Yu <chao@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched/psi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/sched/psi.c~sched-psi-export-psi_memstall_enterleave
+++ a/kernel/sched/psi.c
@@ -917,6 +917,7 @@ void psi_memstall_enter(unsigned long *f
 
 	rq_unlock_irq(rq, &rf);
 }
+EXPORT_SYMBOL_GPL(psi_memstall_enter);
 
 /**
  * psi_memstall_leave - mark the end of an memory stall section
@@ -946,6 +947,7 @@ void psi_memstall_leave(unsigned long *f
 
 	rq_unlock_irq(rq, &rf);
 }
+EXPORT_SYMBOL_GPL(psi_memstall_leave);
 
 #ifdef CONFIG_CGROUPS
 int psi_cgroup_alloc(struct cgroup *cgroup)
_

Patches currently in -mm which might be from hch@lst.de are

btrfs-add-manual-psi-accounting-for-compressed-reads.patch
erofs-add-manual-psi-accounting-for-the-compressed-address-space.patch
block-remove-psi-accounting-from-the-bio-layer.patch

