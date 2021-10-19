Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD0DAC433F5
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 20:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B31661260
	for <mm-commits@archiver.kernel.org>; Tue, 19 Oct 2021 20:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhJSUYH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 19 Oct 2021 16:24:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230147AbhJSUYH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 19 Oct 2021 16:24:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EE65610CC;
        Tue, 19 Oct 2021 20:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634674914;
        bh=kCRNFe41bEkTkoesraj2v2SwnLYuZTKErggFfR2cc1g=;
        h=Date:From:To:Subject:From;
        b=RaijMBGDh6waOzzfmZ/D88H7FnllpaA0VvGjIWOu7E5lSiasFr89mQw6ECkNd02VO
         oMFVvARK1bQVeyEuEJurieZQhrEE0uLTD2lgpncaqahnTX5A05019pmwM6rQg/pp4F
         lePohHHy3eUQ6S6FmZiOaK1OljoTrIWub2LDhdLQ=
Date:   Tue, 19 Oct 2021 13:21:53 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vvs@virtuozzo.com
Subject:  +
 memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
 added to -mm tree
Message-ID: <20211019202153.M5wqqSP8f%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch

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

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
linux-next-rejects.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
kernel-forkc-export-kernel_thread-to-modules.patch

