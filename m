Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F06A6C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA9586113B
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbhKEShe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:37:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232416AbhKEShe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:37:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1457861159;
        Fri,  5 Nov 2021 18:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137294;
        bh=wKvdyNzUk8PYAg2TSMFeAiH50ujbWKrf6wEma7/LVq0=;
        h=Date:From:To:Subject:From;
        b=ZufikBtk5/vv8KjCzWrsX/B8f8A3JOHwzYsk+MyaveseBHEqUAia/YyJ+KB6ZO+h6
         yPVjyOoGgd3aVBF0cEbgW3sWi43wtK4i7f3o1wVs91tUNzqMq/z9tsOULCnJJ8eA0z
         ogpETzNOmM3Rf7i4cKC7VdrKsBIHcTWS9S19y1qA=
Date:   Fri, 05 Nov 2021 11:34:53 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vvs@virtuozzo.com
Subject:  [folded-merged]
 memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
 removed from -mm tree
Message-ID: <20211105183453.ZUu_53pV8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch

This patch was dropped because it was folded into memcg-kmem-further-deprecate-kmemlimit_in_bytes.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes

WARNING: ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -3766,7 +3766,7 @@ static ssize_t mem_cgroup_write(struct k
 			break;
 		case _KMEM:
 			/* kmem.limit_in_bytes is deprecated. */
-			ret = -ENOTSUPP;
+			ret = -EOPNOTSUPP;
 			break;
 		case _TCP:
 			ret = memcg_update_tcp_max(memcg, nr_pages);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

memcg-kmem-further-deprecate-kmemlimit_in_bytes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
delay-replace-kernelh-with-the-necessary-inclusions-fix.patch
generic-radix-tree-replace-kernelh-with-the-necessary-inclusions-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
revert-acct_reclaim_writeback-for-next.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

