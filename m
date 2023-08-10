Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E75CC001B0
	for <mm-commits@archiver.kernel.org>; Thu, 10 Aug 2023 17:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234871AbjHJRQ3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Aug 2023 13:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234840AbjHJRQ1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Aug 2023 13:16:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8986E26B8
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 10:16:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F95565E8B
        for <mm-commits@vger.kernel.org>; Thu, 10 Aug 2023 17:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75982C433C8;
        Thu, 10 Aug 2023 17:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691687785;
        bh=/G7f4pxjUpEOnx7YXBrjuYY0KVd9dKYWdEL6wpFhX8o=;
        h=Date:To:From:Subject:From;
        b=hizO0AlbumpXbPm9U4MBgAwHA1LnF6vQH3DzoUXgJPG5+6g79GhLWwCIyoZ3ZjcGC
         sIYI1RdEOWfk/qEy7HsNP1Kmuz2Bz9Wp2ouNndS3qc9zNtUZq05XX8yu0RDJ4xLPdl
         eJGlY7K6xKbc0q70qVn72cqUJtemox31Y4KuMrpw=
Date:   Thu, 10 Aug 2023 10:16:24 -0700
To:     mm-commits@vger.kernel.org, zhaoyang.huang@unisoc.com,
        yuzhao@google.com, surenb@google.com, kaleshsingh@google.com,
        david@redhat.com, quic_charante@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + multi-gen-lru-skip-cma-pages-when-they-are-not-eligible.patch added to mm-unstable branch
Message-Id: <20230810171625.75982C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Multi-gen LRU: skip CMA pages when they are not eligible
has been added to the -mm mm-unstable branch.  Its filename is
     multi-gen-lru-skip-cma-pages-when-they-are-not-eligible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/multi-gen-lru-skip-cma-pages-when-they-are-not-eligible.patch

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
@@ -4944,7 +4944,7 @@ static bool sort_folio(struct lruvec *lr
 	}
 
 	/* ineligible */
-	if (zone > sc->reclaim_idx) {
+	if (zone > sc->reclaim_idx || skip_cma(folio, sc)) {
 		gen = folio_inc_gen(lruvec, folio, false);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
_

Patches currently in -mm which might be from quic_charante@quicinc.com are

mm-madvise-fix-uneven-accounting-of-psi.patch
multi-gen-lru-skip-cma-pages-when-they-are-not-eligible.patch

