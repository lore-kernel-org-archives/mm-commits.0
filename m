Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF8E2C4167D
	for <mm-commits@archiver.kernel.org>; Fri, 10 Nov 2023 17:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345611AbjKJRmz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Nov 2023 12:42:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235012AbjKJRl6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2023 12:41:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D921C446C5
        for <mm-commits@vger.kernel.org>; Fri, 10 Nov 2023 09:25:43 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61063C433C7;
        Fri, 10 Nov 2023 17:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699637143;
        bh=uPXb12y1A3BIYUVZN42a5qsma6NV7zd9Qtx+OYEJU1I=;
        h=Date:To:From:Subject:From;
        b=IFptWFW8DFQmAmttEqFWz1sdgNta9bvLoSUCVHgnTjYU1ZmYgkScccZ/vlNl+F9nw
         h4TJzO3I+1dMB/GwQERuGmE7MZOkAYXZukGZgMOR1R40CnDfh8Oxi0+POvvszxE/Fc
         oP0BGeMANhyLMp9S/qVvrmyQgi9trywujKCYai44=
Date:   Fri, 10 Nov 2023 09:25:41 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        gregory.price@memverge.com, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-page-remove-unneeded-pagetail-pageslab-check.patch added to mm-unstable branch
Message-Id: <20231110172543.61063C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/page: remove unneeded PageTail && PageSlab check
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-page-remove-unneeded-pagetail-pageslab-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-page-remove-unneeded-pagetail-pageslab-check.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: fs/proc/page: remove unneeded PageTail && PageSlab check
Date: Fri, 10 Nov 2023 11:33:18 +0800

Patch series "mm: remove page idle and young wrapper", v2.

Convert to use folio idle and young functions instead of page ones,
then remove all page idle and young wrapper.


This patch (of 7):

After commit dcb351cd095a ("page-flags: define behavior SL*B-related flags
on compound pages"), the slab could not be a tail, remove unneeded
PageTail && PageSlab check.

Link: https://lkml.kernel.org/r/20231110033324.2455523-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20231110033324.2455523-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gregory Price <gregory.price@memverge.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/page.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/fs/proc/page.c~fs-proc-page-remove-unneeded-pagetail-pageslab-check
+++ a/fs/proc/page.c
@@ -184,9 +184,6 @@ u64 stable_page_flags(struct page *page)
 	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
 
 	u |= kpf_copy_bit(k, KPF_SLAB,		PG_slab);
-	if (PageTail(page) && PageSlab(page))
-		u |= 1 << KPF_SLAB;
-
 	u |= kpf_copy_bit(k, KPF_ERROR,		PG_error);
 	u |= kpf_copy_bit(k, KPF_DIRTY,		PG_dirty);
 	u |= kpf_copy_bit(k, KPF_UPTODATE,	PG_uptodate);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

fs-proc-page-remove-unneeded-pagetail-pageslab-check.patch
fs-proc-page-use-a-folio-in-stable_page_flags.patch
fs-proc-page-respect-folio-head-page-flag-placement.patch
mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch
mm-task_mmu-use-a-folio-in-smaps_account.patch
mm-task_mmu-use-a-folio-in-clear_refs_pte_range.patch
page_idle-kill-page-idle-and-young-wrapper.patch

