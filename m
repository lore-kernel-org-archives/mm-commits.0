Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BCBC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D286611C0
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbhKESke (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232637AbhKESkd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B40BA611C1;
        Fri,  5 Nov 2021 18:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137474;
        bh=84L6ic+LSa81NfRY2imIKkxbyEEFNX5iMULGxDwohgI=;
        h=Date:From:To:Subject:From;
        b=WYTDuYWIRBL7jqZCE5IKHqO267zZ8RW3ZdmpVQCV+ALOhF0+mzDx4PK+pjZaA4FYq
         qiasJzGxEJpj6gtLh8m9c6LD5b7/p+1NEmiwRUdFYYMqqWZyqVbj60gHmbC9FxXAD8
         cx3s3f0Zht6CEpwNRENH9ncze7dmthTpc6+hzZSU=
Date:   Fri, 05 Nov 2021 11:37:53 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, chenwandun@huawei.com,
        edumazet@google.com, guohanjun@huawei.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com, shakeelb@google.com,
        urezki@gmail.com, wangkefeng.wang@huawei.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-vmalloc-introduce-alloc=5Fpages=5Fbulk=5Farray=5Fmempoli?=
 =?US-ASCII?Q?cy-to-accelerate-memory-allocation-fix.patch?= removed from
 -mm tree
Message-ID: <20211105183753.-yExprH_I%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch

This patch was dropped because it was folded into mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix

make two functions static

Cc: Chen Wandun <chenwandun@huawei.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix
+++ a/mm/mempolicy.c
@@ -2196,7 +2196,7 @@ struct page *alloc_pages(gfp_t gfp, unsi
 }
 EXPORT_SYMBOL(alloc_pages);
 
-unsigned long alloc_pages_bulk_array_interleave(gfp_t gfp,
+static unsigned long alloc_pages_bulk_array_interleave(gfp_t gfp,
 		struct mempolicy *pol, unsigned long nr_pages,
 		struct page **page_array)
 {
@@ -2231,7 +2231,7 @@ unsigned long alloc_pages_bulk_array_int
 	return total_allocated;
 }
 
-unsigned long alloc_pages_bulk_array_preferred_many(gfp_t gfp, int nid,
+static unsigned long alloc_pages_bulk_array_preferred_many(gfp_t gfp, int nid,
 		struct mempolicy *pol, unsigned long nr_pages,
 		struct page **page_array)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation.patch
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

