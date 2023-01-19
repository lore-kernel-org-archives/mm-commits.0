Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 428D6C677F1
	for <mm-commits@archiver.kernel.org>; Fri, 20 Jan 2023 05:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbjATF3V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 20 Jan 2023 00:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjATF2q (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2023 00:28:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD34A518C7
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 21:23:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1EFFB8275E
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 22:47:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC29C433D2;
        Thu, 19 Jan 2023 22:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674168472;
        bh=28x93UsUJGj+1/T7ht7EsPt/SUUemluOL2i/ruwZ5aY=;
        h=Date:To:From:Subject:From;
        b=KTw8w6LgppQvIb6TCAKeRq9u7JcpeRuCYGD1+iQ9W5xwTxlVo/DQWo67YlWfOwWzq
         Bfs1oDmnrGLH9CawnWtiULqhS7ji4Ewm/wtjK1jfOjCuJkzDtzsbuG9TZBP4HtMRWf
         YQP8oBECTetPWqQctaD+5vr3Ls8m7YxidPkDKYus=
Date:   Thu, 19 Jan 2023 14:47:51 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, talumbau@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-multi-gen-lru-improve-lru_gen_exit_memcg.patch added to mm-unstable branch
Message-Id: <20230119224752.6CC29C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: multi-gen LRU: improve lru_gen_exit_memcg()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-multi-gen-lru-improve-lru_gen_exit_memcg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-multi-gen-lru-improve-lru_gen_exit_memcg.patch

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
From: "T.J. Alumbaugh" <talumbau@google.com>
Subject: mm: multi-gen LRU: improve lru_gen_exit_memcg()
Date: Wed, 18 Jan 2023 00:18:25 +0000

Add warnings and poison ->next.

Link: https://lkml.kernel.org/r/20230118001827.1040870-6-talumbau@google.com
Signed-off-by: T.J. Alumbaugh <talumbau@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmscan.c~mm-multi-gen-lru-improve-lru_gen_exit_memcg
+++ a/mm/vmscan.c
@@ -6168,12 +6168,17 @@ void lru_gen_exit_memcg(struct mem_cgrou
 	int i;
 	int nid;
 
+	VM_WARN_ON_ONCE(!list_empty(&memcg->mm_list.fifo));
+
 	for_each_node(nid) {
 		struct lruvec *lruvec = get_lruvec(memcg, nid);
 
+		VM_WARN_ON_ONCE(lruvec->mm_state.nr_walkers);
 		VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
 					   sizeof(lruvec->lrugen.nr_pages)));
 
+		lruvec->lrugen.list.next = LIST_POISON1;
+
 		for (i = 0; i < NR_BLOOM_FILTERS; i++) {
 			bitmap_free(lruvec->mm_state.filters[i]);
 			lruvec->mm_state.filters[i] = NULL;
_

Patches currently in -mm which might be from talumbau@google.com are

mm-multi-gen-lru-section-for-working-set-protection.patch
mm-multi-gen-lru-section-for-rmap-pt-walk-feedback.patch
mm-multi-gen-lru-section-for-bloom-filters.patch
mm-multi-gen-lru-section-for-memcg-lru.patch
mm-multi-gen-lru-improve-lru_gen_exit_memcg.patch
mm-multi-gen-lru-improve-walk_pmd_range.patch
mm-multi-gen-lru-simplify-lru_gen_look_around.patch

