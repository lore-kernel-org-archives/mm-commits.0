Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 153E1C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 23:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6539610C8
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 23:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbhJ1AAf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 20:00:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhJ1AAe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 20:00:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA8DB600D3;
        Wed, 27 Oct 2021 23:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635379088;
        bh=CDpomQADm/+mEGGvWXKJkPuGOcL/VLpu4PjQOUXTXzY=;
        h=Date:From:To:Subject:From;
        b=tSYj5uuFTB1/TUeZnVfnaGXLlQD9lz7V6hCXP8cLHKiYLFjyHlOD9nrSMyxyU12h3
         kQPaPBChlG5TfTaw/nYyEaYm/jQaDBTYPFut3fbj9w5lXAFZwqMqyIyTUpjHwKg+DC
         HfeGcnco5xjXg2ltZ8tK/sW7by4VfwuUCvGvk/t4=
Date:   Wed, 27 Oct 2021 16:58:08 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  + mm-move-kvmalloc-related-functions-to-slabh-fix.patch
 added to -mm tree
Message-ID: <20211027235808.9SeLNrXoU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/hwmon/occ/p9_sbe.c needs slab.h
has been added to the -mm tree.  Its filename is
     mm-move-kvmalloc-related-functions-to-slabh-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-kvmalloc-related-functions-to-slabh-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-kvmalloc-related-functions-to-slabh-fix.patch

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

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-move-kvmalloc-related-functions-to-slabh-fix.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
mm-simplify-bdi-refcounting-fix-fix.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
delay-replace-kernelh-with-the-necessary-inclusions-fix.patch
generic-radix-tree-replace-kernelh-with-the-necessary-inclusions-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
revert-acct_reclaim_writeback-for-next.patch
linux-next-rejects.patch
restore-acct_reclaim_writeback-for-folio.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
kernel-forkc-export-kernel_thread-to-modules.patch
linux-next-rejects-fix.patch

