Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9922FC77B72
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 00:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjDRAyB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 Apr 2023 20:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDRAyA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 Apr 2023 20:54:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EC419A4
        for <mm-commits@vger.kernel.org>; Mon, 17 Apr 2023 17:53:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AD3662B8D
        for <mm-commits@vger.kernel.org>; Tue, 18 Apr 2023 00:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649C7C433D2;
        Tue, 18 Apr 2023 00:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681779238;
        bh=6tiaXw+maRH6CqxNIIihtAiC00r1RV+2S/88gc75UoY=;
        h=Date:To:From:Subject:From;
        b=UrEebadD7EzVe3isGHSn+PhTBBbXRKhyllL2A6m65z1jamIrxHWbqxLu80yQjVez9
         4Clgq0xZOZryhQUeMOVSK95GdKTX1OieWsQG7tsjWt8qo6j7tsUJFtBBqAXsoKV5PX
         DpqMKpmPpHei1QaK24NG9KtL8wBc6mJxOM5mYcBg=
Date:   Mon, 17 Apr 2023 17:53:57 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, sj@kernel.org,
        hughd@google.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-correct-arg-in-reclaim_pages-reclaim_clean_pages_from_list.patch added to mm-unstable branch
Message-Id: <20230418005358.649C7C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: correct arg in reclaim_pages()/reclaim_clean_pages_from_list()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-correct-arg-in-reclaim_pages-reclaim_clean_pages_from_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-correct-arg-in-reclaim_pages-reclaim_clean_pages_from_list.patch

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
Subject: mm: correct arg in reclaim_pages()/reclaim_clean_pages_from_list()
Date: Mon, 17 Apr 2023 19:48:07 +0800

Both of them change the arg from page_list to folio_list when convert them
to use a folio, but not the declaration, let's correct it, also move the
reclaim_pages() from swap.h to internal.h as it only used in mm.

Link: https://lkml.kernel.org/r/20230417114807.186786-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviwed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/internal.h        |    3 ++-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/swap.h~mm-correct-arg-in-reclaim_pages-reclaim_clean_pages_from_list
+++ a/include/linux/swap.h
@@ -442,7 +442,6 @@ extern unsigned long shrink_all_memory(u
 extern int vm_swappiness;
 long remove_mapping(struct address_space *mapping, struct folio *folio);
 
-extern unsigned long reclaim_pages(struct list_head *page_list);
 #ifdef CONFIG_NUMA
 extern int node_reclaim_mode;
 extern int sysctl_min_unmapped_ratio;
--- a/mm/internal.h~mm-correct-arg-in-reclaim_pages-reclaim_clean_pages_from_list
+++ a/mm/internal.h
@@ -804,8 +804,9 @@ extern unsigned long  __must_check vm_mm
         unsigned long, unsigned long);
 
 extern void set_pageblock_order(void);
+unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
-					    struct list_head *page_list);
+					    struct list_head *folio_list);
 /* The ALLOC_WMARK bits are used as an index to zone->watermark */
 #define ALLOC_WMARK_MIN		WMARK_MIN
 #define ALLOC_WMARK_LOW		WMARK_LOW
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-hwpoison-coredump-support-recovery-from-dump_user_range.patch
mm-correct-arg-in-reclaim_pages-reclaim_clean_pages_from_list.patch

