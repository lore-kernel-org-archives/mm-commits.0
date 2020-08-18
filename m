Return-Path: <SRS0=0jXN=B4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A125C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 089E82065D
	for <mm-commits@archiver.kernel.org>; Tue, 18 Aug 2020 23:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597792146;
	bh=2MH85r7sh6t2hOrEogrVuPjWwNkW6a3BkUVhbwcxj+A=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Voi12iNTvHaB2VHZmuklueDwrma5WX4YyOTjT7LZ3zmDoUPbXXLMvibEAmZvn4bOZ
	 8WJbTNm0kKVIjO38suyZZTJFIKmbFo9S93sLYQxXedYWGyDopUoJ689JEMc0Kk4gRr
	 PKU77YbepDvB8rpcvsgPWoMfK661RtW0yIzoGxTc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726967AbgHRXJF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Aug 2020 19:09:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726539AbgHRXJF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 Aug 2020 19:09:05 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05C0120738;
        Tue, 18 Aug 2020 23:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597792144;
        bh=2MH85r7sh6t2hOrEogrVuPjWwNkW6a3BkUVhbwcxj+A=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Dzu1AHc5hoTGR6NxJEtnore7kIOBJ0tsUmHTWTAG2xkoNAGOntaVwFjzhEyVSr6Tx
         FvqLlnxj63ap5h7AVJuHvHIlAF1W92TFDG/QMf/QLJPOR+dMMVzPIy5AKVqUQPnFku
         lgecbdMOsOtXmvxb5OTDaUPeaqBgXyf44NTIHtgg=
Date:   Tue, 18 Aug 2020 16:09:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     alexander.h.duyck@linux.intel.com, cai@lca.pw, david@redhat.com,
        hughd@google.com, iamjoonsoo.kim@lge.com,
        mgorman@techsingularity.net, mhocko@suse.com,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        yang.shi@linux.alibaba.com, ying.huang@intel.com, yuzhao@google.com
Subject:  + mm-remove-superfluous-__clearpageactive.patch added to
 -mm tree
Message-ID: <20200818230903.7bPtsPWOF%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove superfluous __ClearPageActive()
has been added to the -mm tree.  Its filename is
     mm-remove-superfluous-__clearpageactive.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-superfluous-__clearpageactive.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-superfluous-__clearpageactive.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yu Zhao <yuzhao@google.com>
Subject: mm: remove superfluous __ClearPageActive()

To activate a page, mark_page_accessed() always holds a reference on it. 
It either gets a new reference when adding a page to
lru_pvecs.activate_page or reuses an existing one it previously got when
it added a page to lru_pvecs.lru_add.  So it doesn't call SetPageActive()
on a page that doesn't have any reference left.  Therefore, the race is
impossible these days (I didn't brother to dig into its history).

For other paths, namely reclaim and migration, a reference count is always
held while calling SetPageActive() on a page.

SetPageSlabPfmemalloc() also uses SetPageActive(), but it's irrelevant to
LRU pages.

Link: http://lkml.kernel.org/r/20200818184704.3625199-2-yuzhao@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    2 --
 mm/swap.c     |    2 --
 2 files changed, 4 deletions(-)

--- a/mm/memremap.c~mm-remove-superfluous-__clearpageactive
+++ a/mm/memremap.c
@@ -471,8 +471,6 @@ void free_devmap_managed_page(struct pag
 		return;
 	}
 
-	/* Clear Active bit in case of parallel mark_page_accessed */
-	__ClearPageActive(page);
 	__ClearPageWaiters(page);
 
 	mem_cgroup_uncharge(page);
--- a/mm/swap.c~mm-remove-superfluous-__clearpageactive
+++ a/mm/swap.c
@@ -900,8 +900,6 @@ void release_pages(struct page **pages,
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		}
 
-		/* Clear Active bit in case of parallel mark_page_accessed */
-		__ClearPageActive(page);
 		__ClearPageWaiters(page);
 
 		list_add(&page->lru, &pages_to_free);
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-remove-activate_page-from-unuse_pte.patch
mm-remove-superfluous-__clearpageactive.patch
mm-remove-superfluous-__clearpagewaiters.patch

