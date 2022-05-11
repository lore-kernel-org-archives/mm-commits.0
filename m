Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B26DCC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 11 May 2022 18:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbiEKS2e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 11 May 2022 14:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346240AbiEKS2c (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 May 2022 14:28:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DF066694
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 11:28:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89B7AB82527
        for <mm-commits@vger.kernel.org>; Wed, 11 May 2022 18:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33338C340EE;
        Wed, 11 May 2022 18:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652293709;
        bh=MgUEPMmeaQ0HUkacRRNhcBrDn8IyhRQkUZny2tw0SAc=;
        h=Date:To:From:Subject:From;
        b=pf8Nn1R9cy6hW7s8Aw8LYEfCxCkUx0a95SgECN57cx4xDOzYGFzTOlzuGBL+H8Of0
         e349VwTkE9UBXxnGxKuAaqIsftBHQXGcup0IvUnvBI+lNIEy3QMbzFYFAqwWDsc9s2
         GmApus8vWK2NqHI/nD7hCGDwHVz9BymQIu/HrSzs=
Date:   Wed, 11 May 2022 11:28:28 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, rostedt@goodmis.org,
        jirislaby@kernel.org, gregkh@linuxfoundation.org,
        akinobu.mita@gmail.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-missing-handler-for-__gfp_nowarn-v2.patch added to mm-unstable branch
Message-Id: <20220511182829.33338C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-fix-missing-handler-for-__gfp_nowarn-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-fix-missing-handler-for-__gfp_nowarn-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-missing-handler-for-__gfp_nowarn-v2.patch

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
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: mm-fix-missing-handler-for-__gfp_nowarn-v2

  - add comment to WARN_ON_ONCE_GFP
  - handle __alloc_contig_migrate_range() case
  - do not deal with:
	WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));

Link: https://lkml.kernel.org/r/20220511061951.1114-1-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |    4 ++++
 mm/page_alloc.c |    4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/mm/internal.h~mm-fix-missing-handler-for-__gfp_nowarn-v2
+++ a/mm/internal.h
@@ -35,6 +35,10 @@ struct folio_batch;
 /* Do not use these with a slab allocator */
 #define GFP_SLAB_BUG_MASK (__GFP_DMA32|__GFP_HIGHMEM|~__GFP_BITS_MASK)
 
+/*
+ * Different from WARN_ON_ONCE(), no warning will be issued
+ * when we specify __GFP_NOWARN.
+ */
 #define WARN_ON_ONCE_GFP(cond, gfp)	({				\
 	static bool __section(".data.once") __warned;			\
 	int __ret_warn_once = !!(cond);					\
--- a/mm/page_alloc.c~mm-fix-missing-handler-for-__gfp_nowarn-v2
+++ a/mm/page_alloc.c
@@ -3712,7 +3712,7 @@ struct page *rmqueue(struct zone *prefer
 	 * We most definitely don't want callers attempting to
 	 * allocate greater than order-1 page units with __GFP_NOFAIL.
 	 */
-	WARN_ON_ONCE_GFP((gfp_flags & __GFP_NOFAIL) && (order > 1), gfp_flags);
+	WARN_ON_ONCE((gfp_flags & __GFP_NOFAIL) && (order > 1));
 
 	do {
 		page = NULL;
@@ -9022,7 +9022,7 @@ int __alloc_contig_migrate_range(struct
 
 	lru_cache_enable();
 	if (ret < 0) {
-		if (ret == -EBUSY)
+		if (!(cc->gfp_mask & __GFP_NOWARN) && ret == -EBUSY)
 			alloc_contig_dump_pages(&cc->migratepages);
 		putback_movable_pages(&cc->migratepages);
 		return ret;
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-fix-missing-handler-for-__gfp_nowarn.patch
mm-fix-missing-handler-for-__gfp_nowarn-v2.patch
tty-fix-deadlock-caused-by-calling-printk-under-tty_port-lock.patch

