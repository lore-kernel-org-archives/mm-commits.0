Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B856EC6FA82
	for <mm-commits@archiver.kernel.org>; Thu, 15 Sep 2022 21:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiIOVao (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Sep 2022 17:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiIOVan (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Sep 2022 17:30:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D5373912
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 14:30:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CAF6B82270
        for <mm-commits@vger.kernel.org>; Thu, 15 Sep 2022 21:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3D15C433B5;
        Thu, 15 Sep 2022 21:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663277439;
        bh=PVkojEW8zT0Nflbo+RA3k9t69UpRnAsELImReh3NoTk=;
        h=Date:To:From:Subject:From;
        b=OkIYZAc+/ERCab+DZaSjXD/jIWCA/5x7B6sK3zqlMU6IZwWrnj+Up0aArzAuh/EI1
         iqM0OtD8J2FruxNQn7H7DWOpRczLZSLuSUh+A/hgJvUK1JzOqHyehXw1NH99vKWmkK
         hQTFpFcLSPPkl5qO6GcfqQ3emSJGswveWMNapcMo=
Date:   Thu, 15 Sep 2022 14:30:39 -0700
To:     mm-commits@vger.kernel.org, xiang@kernel.org, willy@infradead.org,
        surenb@google.com, josef@toxicpanda.com,
        hsiangkao@linux.alibaba.com, hannes@cmpxchg.org, dsterba@suse.com,
        clm@fb.com, chao@kernel.org, axboe@kernel.dk, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + sched-psi-export-psi_memstall_enterleave.patch added to mm-unstable branch
Message-Id: <20220915213039.B3D15C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sched/psi: export psi_memstall_{enter,leave}
has been added to the -mm mm-unstable branch.  Its filename is
     sched-psi-export-psi_memstall_enterleave.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sched-psi-export-psi_memstall_enterleave.patch

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

frontswap-dont-call-init-if-no-ops-are-registered.patch
mm-add-psi-accounting-around-read_folio-and-readahead-calls.patch
sched-psi-export-psi_memstall_enterleave.patch
btrfs-add-manual-psi-accounting-for-compressed-reads.patch
erofs-add-manual-psi-accounting-for-the-compressed-address-space.patch
block-remove-psi-accounting-from-the-bio-layer.patch

