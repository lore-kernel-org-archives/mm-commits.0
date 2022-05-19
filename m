Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D142C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 21:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243725AbiESVDZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 17:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbiESVDY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 17:03:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6649D5B8BE
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 14:03:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 203CDB8288F
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 21:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB1D0C385AA;
        Thu, 19 May 2022 21:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652994200;
        bh=S7yHtAQWb9TgOfPwuWGTxPw9O1p83bHMw3Gt0dD0ShI=;
        h=Date:To:From:Subject:From;
        b=WxQnFkXJE2K3nPSM5qc0rmgrrjaf8J3zumN17DPED9Is6deo6Ep4QcA4JMB/zXp/V
         37ZgqK72c5uN87P6hWG9Mjorh4ASHmoQAicT3TIV3zJCwBhJB6Ad8s7jXHbZGt25ir
         OztJaTANBoiY7Txfb1mPUsJXu4C1tPAblThZ3dNY=
Date:   Thu, 19 May 2022 14:03:20 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vdavydov.dev@gmail.com, timmurray@google.com, surenb@google.com,
        mhocko@suse.com, liumartin@google.com, joaodias@google.com,
        hannes@cmpxchg.org, minchan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-dont-be-stuck-to-rmap-lock-on-reclaim-path-fix.patch removed from -mm tree
Message-Id: <20220519210320.BB1D0C385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-dont-be-stuck-to-rmap-lock-on-reclaim-path-fix
has been removed from the -mm tree.  Its filename was
     mm-dont-be-stuck-to-rmap-lock-on-reclaim-path-fix.patch

This patch was dropped because it was folded into mm-dont-be-stuck-to-rmap-lock-on-reclaim-path.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm-dont-be-stuck-to-rmap-lock-on-reclaim-path-fix
Date: Wed, 4 May 2022 23:11:04 -0700

add comment, per Matthew

Link: https://lkml.kernel.org/r/YnNqeB5tUf6LZ57b@google.com
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: John Dias <joaodias@google.com>
Cc: Tim Murray <timmurray@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Martin Liu <liumartin@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_idle.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_idle.c~mm-dont-be-stuck-to-rmap-lock-on-reclaim-path-fix
+++ a/mm/page_idle.c
@@ -87,6 +87,10 @@ static void page_idle_clear_pte_refs(str
 {
 	struct folio *folio = page_folio(page);
 
+	/*
+	 * Since rwc.try_lock is unused, rwc is effectively immutable, so we
+	 * can make it static to save some cycles and stack.
+	 */
 	static struct rmap_walk_control rwc = {
 		.rmap_one = page_idle_clear_pte_refs_one,
 		.anon_lock = folio_lock_anon_vma_read,
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-dont-be-stuck-to-rmap-lock-on-reclaim-path.patch

