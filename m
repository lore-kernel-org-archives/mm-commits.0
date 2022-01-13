Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77504C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 13 Jan 2022 20:20:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232953AbiAMUUg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 13 Jan 2022 15:20:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54566 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232597AbiAMUUg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jan 2022 15:20:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B1ACB8237F
        for <mm-commits@vger.kernel.org>; Thu, 13 Jan 2022 20:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCEE7C36AE9;
        Thu, 13 Jan 2022 20:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642105234;
        bh=pdHqennAGoCIn+1JqGZu/oBZyVluqWgCls0FvePoxMw=;
        h=Date:From:To:Subject:From;
        b=O8TMr7IcoMqFvMv/rqLBsWQJiG8QYrBg8tD2N6c061ZUHMICYevRhsbQPBT/hbSGf
         8pTgCqg/3P7WkG2SHDoVHIsC977Ysn0MaNZwyGwdmwO2hr4gBLGR4bE7sJ62kIL/3b
         Mnp0BcZS+RcbZz7JCf+zyrkJFAiLqKfGJ9Eq7l4M=
Date:   Thu, 13 Jan 2022 12:20:33 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@gmail.com,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        wangkefeng.wang@huawei.com
Subject:  +
 mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix.patch added to -mm
 tree
Message-ID: <20220113202033.8CMmXQsBw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix
has been added to the -mm tree.  Its filename is
     mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix.patch

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
Subject: mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix

simplify ifdefs, per Andrey

Link: https://lkml.kernel.org/r/CA+fCnZcnwJHUQq34VuRxpdoY6_XbJCDJ-jopksS5Eia4PijPzw@mail.gmail.com
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmalloc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/vmalloc.h~mm-defer-kmemleak-object-creation-of-module_alloc-v4-fix
+++ a/include/linux/vmalloc.h
@@ -28,8 +28,8 @@ struct notifier_block;		/* in notifier.h
 #define VM_MAP_PUT_PAGES	0x00000200	/* put pages and free array in vfree */
 #define VM_NO_HUGE_VMAP		0x00000400	/* force PAGE_SIZE pte mapping */
 
-#if defined(CONFIG_KASAN) && (defined(CONFIG_KASAN_GENERIC) || \
-	defined(CONFIG_KASAN_SW_TAGS)) && !defined(CONFIG_KASAN_VMALLOC)
+#if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
+	!defined(CONFIG_KASAN_VMALLOC)
 #define VM_DEFER_KMEMLEAK	0x00000800	/* defer kmemleak object creation */
 #else
 #define VM_DEFER_KMEMLEAK	0
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread-add-the-helper-function-kthread_run_on_cpu-fix.patch
kmemleak-fix-kmemleak-false-positive-report-with-hw-tag-based-kasan-enable-fix.patch
device-dax-remove-pfn-from-__dev_dax_ptepmdpud_fault-fix.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens-checkpatch-fixes.patch
shmem-fix-a-race-between-shmem_unused_huge_shrink-and-shmem_evict_inode-checkpatch-fixes.patch
memcg-add-per-memcg-vmalloc-stat-v2-fix.patch
mm-remove-redundant-check-about-fault_flag_allow_retry-bit-checkpatch-fixes.patch
mm-vmalloc-allocate-small-pages-for-area-pages-fix.patch
mm-page_allocc-do-not-warn-allocation-failure-on-zone-dma-if-no-managed-pages-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
mm-memcg-percpu-account-extra-objcg-space-to-memory-cgroups-fix.patch
mm-rmap-fix-potential-batched-tlb-flush-race-fix.patch

