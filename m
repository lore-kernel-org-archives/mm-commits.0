Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFB0C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 10 Nov 2023 18:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbjKJS6u (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Nov 2023 13:58:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235919AbjKJS6h (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Nov 2023 13:58:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB1624237
        for <mm-commits@vger.kernel.org>; Fri, 10 Nov 2023 10:21:19 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60AC7C433AB;
        Fri, 10 Nov 2023 18:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699640408;
        bh=sM6XbFd8EXdK00SnoWve7JnlyC3N5eK8q4O7Wab48fk=;
        h=Date:To:From:Subject:From;
        b=taIDuTYtNpnqEuSrxvFncwYYmLCqNSWoOc+MYpdRk5N+LNV1WRM1NPB9tGtToy6x9
         sfqwg6D1TBtNa5kYlQJBPCt/fPPhdoFc0AvuF3VNycOLcNAPtRvz07SpfJm5ahbmb8
         0Y/YWAMzcngjAAzosbOmjnZkhHge4HMGpJughZ1I=
Date:   Fri, 10 Nov 2023 10:20:07 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        gregory.price@memverge.com, david@redhat.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [nacked] fs-proc-page-remove-unneeded-pagetail-pageslab-check.patch removed from -mm tree
Message-Id: <20231110182008.60AC7C433AB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/proc/page: remove unneeded PageTail && PageSlab check
has been removed from the -mm tree.  Its filename was
     fs-proc-page-remove-unneeded-pagetail-pageslab-check.patch

This patch was dropped because it was nacked

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

fs-proc-page-use-a-folio-in-stable_page_flags.patch
fs-proc-page-respect-folio-head-page-flag-placement.patch
mm-huge_memory-use-more-folio-api-in-__split_huge_page_tail.patch
mm-task_mmu-use-a-folio-in-smaps_account.patch
mm-task_mmu-use-a-folio-in-clear_refs_pte_range.patch
page_idle-kill-page-idle-and-young-wrapper.patch

