Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C0B8C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 02:45:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A55C613E8
	for <mm-commits@archiver.kernel.org>; Fri, 22 Oct 2021 02:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbhJVCsC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Oct 2021 22:48:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232462AbhJVCsC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Oct 2021 22:48:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E911D6139F;
        Fri, 22 Oct 2021 02:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634870745;
        bh=oyaQUTHez4bSL+gOdUkRLpOG3ZhDS0YKbbuYtgytUQA=;
        h=Date:From:To:Subject:From;
        b=OFKoYMyp3sGW0Wd+UaR+J+A4EqvcMKRGGSIn6V6fIAlUHCKLoWswW1vGQgu6xMsba
         bhbzcFykapdkzOqiWSNwrGV9v8r8qkoJ40zmU0jAoBiyLe5snl+qUWXgw8Mr54+SRA
         XE+dtDNqZJA1TrRow83HmDIkVbKKPXOWcKMbysuA=
Date:   Thu, 21 Oct 2021 19:45:44 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, axboe@kernel.dk, hch@infradead.org,
        jisoo2146.oh@samsung.com, junho89.kim@samsung.com,
        mj0123.lee@samsung.com, mm-commits@vger.kernel.org,
        nanich.lee@samsung.com, seunghwan.hyun@samsung.com,
        sookwan7.kim@samsung.com, willy@infradead.org,
        yt0928.kim@samsung.com
Subject:  +
 mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch added to -mm
 tree
Message-ID: <20211022024544.QRLrQrBha%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix
has been added to the -mm tree.  Its filename is
     mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch

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
Subject: mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix

Cc: Changheun Lee <nanich.lee@samsung.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: <jisoo2146.oh@samsung.com>
Cc: <junho89.kim@samsung.com>
Cc: Manjong Lee <mj0123.lee@samsung.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <seunghwan.hyun@samsung.com>
Cc: <sookwan7.kim@samsung.com>
Cc: <yt0928.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/backing-dev.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/backing-dev.c~mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix
+++ a/mm/backing-dev.c
@@ -947,10 +947,12 @@ void bdi_unregister(struct backing_dev_i
 	wb_shutdown(&bdi->wb);
 	cgwb_bdi_unregister(bdi);
 
-	/* if min ratio doesn't 0, it has to set 0 before unregister */
-	if (bdi->min_ratio) {
+	/*
+	 * If this BDI's min ratio has been set, use bdi_set_min_ratio() to
+	 * update the global bdi_min_ratio.
+	 */
+	if (bdi->min_ratio)
 		bdi_set_min_ratio(bdi, 0);
-	}
 
 	if (bdi->dev) {
 		bdi_debug_unregister(bdi);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-test-use-underlying-string-helpers-checkpatch-fixes.patch
mm-bdi-initialize-bdi_min_ratio-when-bdi-unregister-fix.patch
mm.patch
mm-page_ownerc-modify-the-type-of-argument-order-in-some-functions-fix.patch
memcg-kmem-further-deprecate-kmemlimit_in_bytes-checkpatch-fixes.patch
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

