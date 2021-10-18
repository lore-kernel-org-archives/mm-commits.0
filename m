Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C416C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A82761206
	for <mm-commits@archiver.kernel.org>; Mon, 18 Oct 2021 22:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhJRWuu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Oct 2021 18:50:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:57794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhJRWut (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 18 Oct 2021 18:50:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2139611C6;
        Mon, 18 Oct 2021 22:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634597318;
        bh=q5b6MpUENHxJzKJhqXufrHbV5+Y+hHXSGQj1gV1bQiI=;
        h=Date:From:To:Subject:From;
        b=CXDRC5L+hbiBL8Yd7ppuX49CSybR1XAiQSFjb7ARQ+R5nuys321/IOABAz/1eMVBG
         JLpGHrewxfgvhJqiyaKJzzQdFVgDwPV2hfjpuMx2q5KeIrzCfm+QLlEMwoQIEQj+/w
         hosqFZ+w9LOUkw/QloMjybYAX2QYUs/1bIUu+XsE=
Date:   Mon, 18 Oct 2021 15:48:37 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, chenwandun@huawei.com,
        edumazet@google.com, guohanjun@huawei.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, urezki@gmail.com,
        wangkefeng.wang@huawei.com
Subject:  +
 =?US-ASCII?Q?mm-vmalloc-introduce-alloc=5Fpages=5Fbulk=5Farray=5Fmempo?=
 =?US-ASCII?Q?licy-to-accelerate-memory-allocation-fix-2.patch?= added to
 -mm tree
Message-ID: <20211018224837.Lp8yu7UNE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2
has been added to the -mm tree.  Its filename is
     mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch

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
Subject: mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2

fix CONFIG_NUMA=n build.  alloc_pages_bulk_array_mempolicy() was undefined

Cc: Chen Wandun <chenwandun@huawei.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2
+++ a/mm/vmalloc.c
@@ -2856,7 +2856,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			 */
 			nr_pages_request = min(100U, nr_pages - nr_allocated);
 
-			if (nid == NUMA_NO_NODE)
+			if (IS_ENABLED(CONFIG_NUMA) && nid == NUMA_NO_NODE)
 				nr = alloc_pages_bulk_array_mempolicy(gfp,
 							nr_pages_request,
 							pages + nr_allocated);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
kernel-forkc-export-kernel_thread-to-modules.patch

