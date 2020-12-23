Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C7E2C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 22:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41A5422288
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 22:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbgLWWnC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 17:43:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgLWWnC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 17:43:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA77922571;
        Wed, 23 Dec 2020 22:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608763342;
        bh=GI7/n833QX7EvD0dB9EQWMOehkNzU3ZFqptIVggGSAY=;
        h=Date:From:To:Subject:From;
        b=ievOYokIAufE2ZTEudS+li3ZRVDbOj54YqAWTgsenHVBKDgz+k8YC71vEbN0iyGZs
         onCQgVYvrcqKM+YtS+sE5jzB+sfevJdFjf0fcOojPIbsztQ12WKliEyDVmT1beSGuw
         75KPNrgsAFAPP0jsep0FMxrKuJDyB1xHwSm1IRo0=
Date:   Wed, 23 Dec 2020 14:42:21 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shakeelb@google.com, mhocko@kernel.org, hannes@cmpxchg.org,
        akpm@linux-foundation.org
Subject:  +
 =?us-ascii?Q?mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usag?=
 =?us-ascii?Q?e-checkpatch-fixes.patch?= added to -mm tree
Message-ID: <20201223224221.IY1OI%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes

fix typo in comment

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes
+++ a/include/linux/memcontrol.h
@@ -113,7 +113,7 @@ struct mem_cgroup_per_node {
 
 	/*
 	 * Legacy local VM stats. This should be struct lruvec_stat and
-	 * cannot be optimized to struct batched_lruvec_stat. Becasue
+	 * cannot be optimized to struct batched_lruvec_stat. Because
 	 * the threshold of the lruvec_stat_cpu can be as big as
 	 * MEMCG_CHARGE_BATCH * PAGE_SIZE. It can fit into s32. But this
 	 * filed has no upper limit.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm.patch
mm-memcontrol-optimize-per-lruvec-stats-counter-memory-usage-checkpatch-fixes.patch
mm-fix-initialization-of-struct-page-for-holes-in-memory-layout-checkpatch-fixes.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
kfence-kasan-make-kfence-compatible-with-kasan-fix.patch
linux-next-git-rejects.patch
set_memory-allow-set_direct_map__noflush-for-multiple-pages-fix.patch
arch-mm-wire-up-memfd_secret-system-call-were-relevant-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

