Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B8C9C56202
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 05:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 963792087C
	for <mm-commits@archiver.kernel.org>; Thu, 26 Nov 2020 05:47:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X+O8DgPZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731142AbgKZFrQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Nov 2020 00:47:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730615AbgKZFrQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 26 Nov 2020 00:47:16 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6691220770;
        Thu, 26 Nov 2020 05:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606369635;
        bh=Ef1KarLUOGZn2g6ViWzvE6RrM24KXr4pzvKQTT1Gboo=;
        h=Date:From:To:Subject:From;
        b=X+O8DgPZlz4w0RQ4RlSprUBKorlLyN8fu9IEBAt5g/FI2dX9xHbSE3t3ab/p+PId+
         LKQ7wba43/b9lvnr8KTZB3ZdwCZS/lfzdso5TW544CuD/zxx+rdfnkYxTFajrDYNuT
         tUHQfZBjK5of2P/a5HCb2tC4oQ80mStCJmD7Lr1A=
Date:   Wed, 25 Nov 2020 21:47:13 -0800
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dchinner@redhat.com, hannes@cmpxchg.org,
        hch@lst.de, hughd@google.com, jack@suse.cz,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  +
 mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch added to
 -mm tree
Message-ID: <20201126054713.GmEiU5MZ_%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-truncateshmem-handle-truncates-that-split-thps-fix-fix
has been added to the -mm tree.  Its filename is
     mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch

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
Subject: mm-truncateshmem-handle-truncates-that-split-thps-fix-fix

fix page unlocking, per Hugh

Link: https://lkml.kernel.org/r/CANsGZ6a95WK7+2H4Zyg5FwDxhdJQqR8nKND1Cn6r6e3QxWeW4Q@mail.gmail.com
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/shmem.c~mm-truncateshmem-handle-truncates-that-split-thps-fix-fix
+++ a/mm/shmem.c
@@ -961,8 +961,11 @@ static void shmem_undo_range(struct inod
 						page, lstart, lend);
 				if (index > end)
 					end = indices[i] - 1;
+			} else {
+				unlock_page(page);
 			}
 		}
+
 		index = indices[i - 1] + 1;
 		pagevec_remove_exceptionals(&pvec);
 		pagevec_reinit(&pvec);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kthread_worker-document-cpu-hotplug-handling-fix.patch
mm.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

