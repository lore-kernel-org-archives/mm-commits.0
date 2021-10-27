Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C50E6C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 08:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A92EC610A5
	for <mm-commits@archiver.kernel.org>; Wed, 27 Oct 2021 08:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237180AbhJ0IDz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 27 Oct 2021 04:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240720AbhJ0ID2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 27 Oct 2021 04:03:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B94E8610C7;
        Wed, 27 Oct 2021 08:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1635321660;
        bh=cEssAW37YtkuEpLU4KqkNgbKVkzjWnpUsE8WU4JIRGs=;
        h=Date:From:To:Subject:From;
        b=b0Laic6N5sMghSah0TO/q3vWYtsru6lDEIBZ+X9AGT2xabqCmETorkhU/DVGsVxj0
         qHjM7d03bhhCA5YKl0HVTZBnxcOy6Mi7XxHiLxtvjJEnDJ9LesR8HLkrRvSERbILIL
         CCd9h53s6ARdxVo4gmkSUy6Bf0ZEE1oieOo0ne6o=
Date:   Wed, 27 Oct 2021 01:00:59 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hch@lst.de, jack@suse.cz,
        miquel.raynal@bootlin.com, mm-commits@vger.kernel.org,
        richard@nod.at, vigneshr@ti.com
Subject:  + mm-simplify-bdi-refcounting-fix-fix.patch added to -mm
 tree
Message-ID: <20211027080059.CtdAIcwQw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-simplify-bdi-refcounting-fix-fix
has been added to the -mm tree.  Its filename is
     mm-simplify-bdi-refcounting-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-simplify-bdi-refcounting-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-simplify-bdi-refcounting-fix-fix.patch

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
Subject: mm-simplify-bdi-refcounting-fix-fix

fix typo

Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/backing-dev-defs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/backing-dev-defs.h~mm-simplify-bdi-refcounting-fix-fix
+++ a/include/linux/backing-dev-defs.h
@@ -104,7 +104,7 @@ struct wb_completion {
  * is tested for blkcg after lookup and removed from index on mismatch so
  * that a new wb for the combination can be created.
  *
- * Each bdi_writeback that is no embedded into the backing_dev_info must hold
+ * Each bdi_writeback that is not embedded into the backing_dev_info must hold
  * a reference to the parent backing_dev_info.  See cgwb_create() for details.
  */
 struct bdi_writeback {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
mm-simplify-bdi-refcounting-fix-fix.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-checkpatch-fixes.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix.patch
mm-vmalloc-introduce-alloc_pages_bulk_array_mempolicy-to-accelerate-memory-allocation-fix-2.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
procfs-do-not-list-tid-0-in-proc-pid-task-fix.patch
ipc-check-checkpoint_restore_ns_capable-to-modify-c-r-proc-files-fix.patch
revert-acct_reclaim_writeback-for-next.patch
linux-next-rejects.patch
restore-acct_reclaim_writeback-for-folio.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault-vs-folios.patch
kernel-forkc-export-kernel_thread-to-modules.patch

