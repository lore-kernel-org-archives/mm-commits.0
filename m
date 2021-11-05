Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 339BDC433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08FB46113B
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 18:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhKESc6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 14:32:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231425AbhKESc5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 14:32:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC46461108;
        Fri,  5 Nov 2021 18:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636137017;
        bh=QNEMDVkvNniECYkRD2LTwpnWP+d49MA87fk2lzmOjFU=;
        h=Date:From:To:Subject:From;
        b=BdMdybjGd+c+QSWsw2jDrB4J52Lmd+rZI/9sFqqOjtBScjvKNN7deeWkOULFybwW8
         MkRcjzUproUMQzEeE8O2RujcdnvSMU78r0x5K2H7+Ygm1XzGY2ORgwPxQrLkTiQS1q
         nurczcxFi7f4S1s2LQLdReEIMsvi0zPLBr4A1R5E=
Date:   Fri, 05 Nov 2021 11:30:17 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [folded-merged]
 mm-move-kvmalloc-related-functions-to-slabh-fix.patch removed from -mm tree
Message-ID: <20211105183017.a0TbgqFF3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/hwmon/occ/p9_sbe.c needs slab.h
has been removed from the -mm tree.  Its filename was
     mm-move-kvmalloc-related-functions-to-slabh-fix.patch

This patch was dropped because it was folded into mm-move-kvmalloc-related-functions-to-slabh.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/hwmon/occ/p9_sbe.c needs slab.h

for kvmalloc/kvfree

(only needed after pending linux-next patches are included)

Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/occ/p9_sbe.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/occ/p9_sbe.c~mm-move-kvmalloc-related-functions-to-slabh-fix
+++ a/drivers/hwmon/occ/p9_sbe.c
@@ -3,6 +3,7 @@
 
 #include <linux/device.h>
 #include <linux/errno.h>
+#include <linux/slab.h>
 #include <linux/fsi-occ.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-move-kvmalloc-related-functions-to-slabh.patch
mm-simplify-bdi-refcounting-fix-fix.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
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

