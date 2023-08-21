Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F07EE4996
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:42:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjHUUmi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjHUUmA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:42:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75757E60
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:40:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06E3B64B0A
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56444C433C8;
        Mon, 21 Aug 2023 20:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650458;
        bh=OZI8/LnY0x2xn8eqZDD857j91Tj70qgrJkSysMg49TU=;
        h=Date:To:From:Subject:From;
        b=F9orOx3HdUsxY2CDf0Q58LnaUQXXeFjnceBacipLf8xHIv+tUtoKcOni0QOUofw11
         4dhBz5LPrgDkgAeDGjDlsIquvelD/0I177YoLff6bFdyOXLezvKcFzsx5mhaAOnhnT
         DcHWci5k4MqrxLE8e8aDtOKaXp1ZbdJF1dZvp/Js=
Date:   Mon, 21 Aug 2023 13:40:57 -0700
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        yuzhao@google.com, surenb@google.com, kaleshsingh@google.com,
        david@redhat.com, quic_charante@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] multi-gen-lru-skip-cma-pages-when-they-are-not-eligible.patch removed from -mm tree
Message-Id: <20230821204058.56444C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Multi-gen LRU: skip CMA pages when they are not eligible
has been removed from the -mm tree.  Its filename was
     multi-gen-lru-skip-cma-pages-when-they-are-not-eligible.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: Multi-gen LRU: skip CMA pages when they are not eligible
Date: Wed, 9 Aug 2023 13:35:44 +0530

This patch is based on the commit 5da226dbfce3("mm: skip CMA pages when
they are not available") which skips cma pages reclaim when they are not
eligible for the current allocation context.  In mglru, such pages are
added to the tail of the immediate generation to maintain better LRU
order, which is unlike the case of conventional LRU where such pages are
directly added to the head of the LRU list(akin to adding to head of the
youngest generation in mglru).

No observable issue without this patch on MGLRU, but logically it make
sense to skip the CMA page reclaim when those pages can't be satisfied for
the current allocation context.

Link: https://lkml.kernel.org/r/1691568344-13475-1-git-send-email-quic_charante@quicinc.com
Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Reviewed-by: Kalesh Singh <kaleshsingh@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~multi-gen-lru-skip-cma-pages-when-they-are-not-eligible
+++ a/mm/vmscan.c
@@ -4943,7 +4943,7 @@ static bool sort_folio(struct lruvec *lr
 	}
 
 	/* ineligible */
-	if (zone > sc->reclaim_idx) {
+	if (zone > sc->reclaim_idx || skip_cma(folio, sc)) {
 		gen = folio_inc_gen(lruvec, folio, false);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
_

Patches currently in -mm which might be from quic_charante@quicinc.com are


