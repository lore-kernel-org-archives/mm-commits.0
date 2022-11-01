Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72443C433FE
	for <mm-commits@archiver.kernel.org>; Tue,  1 Nov 2022 21:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiKAVIU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Nov 2022 17:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbiKAVIT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2022 17:08:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238EB1DA78
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 14:08:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B123C61724
        for <mm-commits@vger.kernel.org>; Tue,  1 Nov 2022 21:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A81CC433D6;
        Tue,  1 Nov 2022 21:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667336897;
        bh=lLbTez84s/EmtoDwie6uFbSxvdR07Ji34CQDjJVe6Hk=;
        h=Date:To:From:Subject:From;
        b=vUwhjDTY+PI+PcA1YG+NMtXEuc1mYsSAwqcznHy+DUVHrssIVNnW8XOxqBWtAskai
         aTUZGzpCveEevSlPkgwMeRGHiyUgqav5hBZGbYuknr3QB+FQrVgjfaVvpXOJdoxsBh
         HKWAU97Kih1qhj3vh1Qf7nSJKge5jz1oXDtHdIdg=
Date:   Tue, 01 Nov 2022 14:08:16 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        yajun.deng@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-simplify-page_zone-and-get_deferred_split_queue-with-page_pgdat.patch added to mm-unstable branch
Message-Id: <20221101210817.0A81CC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: simplify page_zone() and get_deferred_split_queue() with page_pgdat()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-simplify-page_zone-and-get_deferred_split_queue-with-page_pgdat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-simplify-page_zone-and-get_deferred_split_queue-with-page_pgdat.patch

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
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm: simplify page_zone() and get_deferred_split_queue() with page_pgdat()
Date: Tue, 1 Nov 2022 10:32:19 +0800

page_zone() is too long, we can shorten it by page_pgdat().

There is no need define pgdat variable if memcg isn't NULL, so use
page_pgdat() to simplify get_deferred_split_queue().

Link: https://lkml.kernel.org/r/20221101023219.752365-1-yajun.deng@linux.dev
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    8 ++++----
 mm/huge_memory.c   |    7 ++-----
 2 files changed, 6 insertions(+), 9 deletions(-)

--- a/include/linux/mm.h~mm-simplify-page_zone-and-get_deferred_split_queue-with-page_pgdat
+++ a/include/linux/mm.h
@@ -1448,14 +1448,14 @@ static inline void page_kasan_tag_reset(
 
 #endif /* CONFIG_KASAN_SW_TAGS || CONFIG_KASAN_HW_TAGS */
 
-static inline struct zone *page_zone(const struct page *page)
+static inline pg_data_t *page_pgdat(const struct page *page)
 {
-	return &NODE_DATA(page_to_nid(page))->node_zones[page_zonenum(page)];
+	return NODE_DATA(page_to_nid(page));
 }
 
-static inline pg_data_t *page_pgdat(const struct page *page)
+static inline struct zone *page_zone(const struct page *page)
 {
-	return NODE_DATA(page_to_nid(page));
+	return &page_pgdat(page)->node_zones[page_zonenum(page)];
 }
 
 static inline struct zone *folio_zone(const struct folio *folio)
--- a/mm/huge_memory.c~mm-simplify-page_zone-and-get_deferred_split_queue-with-page_pgdat
+++ a/mm/huge_memory.c
@@ -562,19 +562,16 @@ pmd_t maybe_pmd_mkwrite(pmd_t pmd, struc
 static inline struct deferred_split *get_deferred_split_queue(struct page *page)
 {
 	struct mem_cgroup *memcg = page_memcg(compound_head(page));
-	struct pglist_data *pgdat = NODE_DATA(page_to_nid(page));
 
 	if (memcg)
 		return &memcg->deferred_split_queue;
 	else
-		return &pgdat->deferred_split_queue;
+		return &page_pgdat(page)->deferred_split_queue;
 }
 #else
 static inline struct deferred_split *get_deferred_split_queue(struct page *page)
 {
-	struct pglist_data *pgdat = NODE_DATA(page_to_nid(page));
-
-	return &pgdat->deferred_split_queue;
+	return &page_pgdat(page)->deferred_split_queue;
 }
 #endif
 
_

Patches currently in -mm which might be from yajun.deng@linux.dev are

mm-simplify-page_zone-and-get_deferred_split_queue-with-page_pgdat.patch

