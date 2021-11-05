Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B84C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:37:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5962561220
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbhKESkh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:40:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232646AbhKESkg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:40:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7427611C0;
        Fri,  5 Nov 2021 18:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137477;
        bh=b+0ruQmJ0006r+7caHuqT5CUSpFMheHxj+kj+KpcInY=;
        h=Date:From:To:Subject:From;
        b=KKa8/Q/83cs67XIt5wUhTTL1+HYh2ojICoC+r8XIzTrhUGxqC6wWkaPvhig8GDQZm
         1wIWd791GdMd0DitShCx53LxdLY4RpXpRVeU+JvjPrtx1I/z+AOTLJH2Y3jC+qMtSq
         MC4VnPHvE8e/Dh07s7w9VBhL6LmNXeDaVGy8gOy4=
Date:   Fri, 05 Nov 2021 11:37:56 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, chenwandun@huawei.com,
        edumazet@google.com, guohanjun@huawei.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, urezki@gmail.com,
        wangkefeng.wang@huawei.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-vmalloc-introduce-alloc=5Fpages=5Fbulk=5Farray=5Fmempo?=
 =?US-ASCII?Q?licy-to-accelerate-memory-allocation-fix-2.patch?= removed
 from -mm tree
Message-ID: <20211105183756.RYqrAdWb2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch

This patch was dropped because it was folded into mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation.patch

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
@@ -2860,7 +2860,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 			 * otherwise memory may be allocated in only one node,
 			 * but mempolcy want to alloc memory by interleaving.
 			 */
-			if (nid == NUMA_NO_NODE)
+			if (IS_ENABLED(CONFIG_NUMA) && nid == NUMA_NO_NODE)
 				nr = alloc_pages_bulk_array_mempolicy(gfp,
 							nr_pages_request,
 							pages + nr_allocated);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation.patch
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

