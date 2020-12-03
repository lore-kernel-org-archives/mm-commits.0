Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B040C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 21:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F37C82223E
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 21:57:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388464AbgLCV54 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 16:57:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387570AbgLCV54 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 16:57:56 -0500
Date:   Thu, 03 Dec 2020 13:57:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607032635;
        bh=gYWQXeFrICya5HQPX9GNlGyEet+Rky8HFqqojZFMjI8=;
        h=From:To:Subject:From;
        b=gQM32/OsJ3umcDHju5vTl1N4TB1enX5KqK3LQC/jn9BQP60o9EdEVrTxg5PGD3UKh
         1WvRKZmOJgwwpmtBoRlVyozYGVbZbXlpZaGAu9sccrBXJmmG/qna9MjYgoD7Os/ybo
         QzGEQTYQDe8wFiKACV8pd5+1B21Ld0i2ASA6EB4g=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dchinner@redhat.com, hannes@cmpxchg.org,
        hch@lst.de, hughd@google.com, jack@suse.cz,
        kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [folded-merged]
 mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch removed
 from -mm tree
Message-ID: <20201203215714.qgSGQJXCH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-truncateshmem-handle-truncates-that-split-thps-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-truncateshmem-handle-truncates-that-split-thps-fix-fix.patch

This patch was dropped because it was folded into mm-truncateshmem-handle-truncates-that-split-thps.patch

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
mm-remove-the-unuseful-else-after-a-return-checkpatch-fixes.patch
mm-prevent-gup_fast-from-racing-with-cow-during-fork-checkpatch-fixes.patch
mm-swap_state-skip-meaningless-swap-cache-readahead-when-ra_infowin-==-0-fix.patch
mm-vmallocc-__vmalloc_area_node-avoid-32-bit-overflow.patch
mm-truncateshmem-handle-truncates-that-split-thps.patch
mm-cma-improve-pr_debug-log-in-cma_release-fix.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
lib-cmdline_kunit-add-a-new-test-suite-for-cmdline-api-fix.patch
ilog2-improve-ilog2-for-constant-arguments-checkpatch-fixes.patch
lib-test_bitmapc-add-for_each_set_clump-test-cases-checkpatch-fixes.patch
checkpatch-fix-typo_spelling-check-for-words-with-apostrophe-fix.patch
resource-fix-kernel-doc-markups-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kmap-stupid-hacks-to-make-it-compile.patch
init-kconfig-dont-assume-scripts-lld-versionsh-is-executable.patch
kernel-forkc-export-kernel_thread-to-modules.patch

