Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0A9C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 28 Dec 2022 23:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiL1Xdt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 28 Dec 2022 18:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiL1Xds (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2022 18:33:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26DF120B4
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 15:33:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89B6AB8188C
        for <mm-commits@vger.kernel.org>; Wed, 28 Dec 2022 23:33:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C85C433F1;
        Wed, 28 Dec 2022 23:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672270424;
        bh=C69Bwkf+T4tf6Hs9hQxAE4rUbI/BmV4oUELj4XEpXIk=;
        h=Date:To:From:Subject:From;
        b=gMSsgcmVRrpdTeIkddwihVDpOnjJ1tZ8Sj5yRMuvDtLxqdG4K6UJx4mxGkRtGREnF
         XknTGQj9ygYIk82UxcutwYy/6Y+ZX1FdJEheCLlzpl6G7a8np/9JW18nU3H+iynqib
         922+lCi165xGk1o1JycVRVAPVlkLDbhXqt2B9qiY=
Date:   Wed, 28 Dec 2022 15:33:43 -0800
To:     mm-commits@vger.kernel.org, zhengjun.xing@linux.intel.com,
        ying.huang@intel.com, willy@infradead.org, shy828301@gmail.com,
        rientjes@google.com, riel@surriel.com, nathan@kernel.org,
        feng.tang@intel.com, fengwei.yin@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-check-and-bail-out-if-page-in-deferred-queue-already.patch added to mm-unstable branch
Message-Id: <20221228233344.17C85C433F1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: check and bail out if page in deferred queue already
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-check-and-bail-out-if-page-in-deferred-queue-already.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-check-and-bail-out-if-page-in-deferred-queue-already.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yin Fengwei <fengwei.yin@intel.com>
Subject: mm/thp: check and bail out if page in deferred queue already
Date: Fri, 23 Dec 2022 21:52:07 +0800

Kernel build regression with LLVM was reported here:
https://lore.kernel.org/all/Y1GCYXGtEVZbcv%2F5@dev-arch.thelio-3990X/ with
commit f35b5d7d676e ("mm: align larger anonymous mappings on THP
boundaries").  And the commit f35b5d7d676e was reverted.

It turned out the regression is related with madvise(MADV_DONTNEED)
was used by ld.lld. But with none PMD_SIZE aligned parameter len.
trace-bpfcc captured:
531607  531732  ld.lld          do_madvise.part.0 start: 0x7feca9000000, len: 0x7fb000, behavior: 0x4
531607  531793  ld.lld          do_madvise.part.0 start: 0x7fec86a00000, len: 0x7fb000, behavior: 0x4

If the underneath physical page is THP, the madvise(MADV_DONTNEED) can
trigger split_queue_lock contention raised significantly. perf showed
following data:
    14.85%     0.00%  ld.lld           [kernel.kallsyms]           [k]
       entry_SYSCALL_64_after_hwframe
           11.52%
                entry_SYSCALL_64_after_hwframe
                do_syscall_64
                __x64_sys_madvise
                do_madvise.part.0
                zap_page_range
                unmap_single_vma
                unmap_page_range
                page_remove_rmap
                deferred_split_huge_page
                __lock_text_start
                native_queued_spin_lock_slowpath

If THP can't be removed from rmap as whole THP, partial THP will be
removed from rmap by removing sub-pages from rmap.  Even the THP head page
is added to deferred queue already, the split_queue_lock will be acquired
and check whether the THP head page is in the queue already.  Thus, the
contention of split_queue_lock is raised.

Before acquire split_queue_lock, check and bail out early if the THP
head page is in the queue already. The checking without holding
split_queue_lock could race with deferred_split_scan, but it doesn't
impact the correctness here.

Test result of building kernel with ld.lld:
commit 7b5a0b664ebe (parent commit of f35b5d7d676e):
time -f "\t%E real,\t%U user,\t%S sys" make LD=ld.lld -skj96 allmodconfig all
        6:07.99 real,   26367.77 user,  5063.35 sys

commit f35b5d7d676e:
time -f "\t%E real,\t%U user,\t%S sys" make LD=ld.lld -skj96 allmodconfig all
        7:22.15 real,   26235.03 user,  12504.55 sys

commit f35b5d7d676e with the fixing patch:
time -f "\t%E real,\t%U user,\t%S sys" make LD=ld.lld -skj96 allmodconfig all
        6:08.49 real,   26520.15 user,  5047.91 sys

Link: https://lkml.kernel.org/r/20221223135207.2275317-1-fengwei.yin@intel.com
Signed-off-by: Yin Fengwei <fengwei.yin@intel.com>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Cc: Yang Shi <shy828301@gmail.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/huge_memory.c~mm-thp-check-and-bail-out-if-page-in-deferred-queue-already
+++ a/mm/huge_memory.c
@@ -2835,6 +2835,9 @@ void deferred_split_huge_page(struct pag
 	if (PageSwapCache(page))
 		return;
 
+	if (!list_empty(page_deferred_list(page)))
+		return;
+
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (list_empty(page_deferred_list(page))) {
 		count_vm_event(THP_DEFERRED_SPLIT_PAGE);
_

Patches currently in -mm which might be from fengwei.yin@intel.com are

mm-thp-check-and-bail-out-if-page-in-deferred-queue-already.patch

