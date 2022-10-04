Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71D21C4321E
	for <mm-commits@archiver.kernel.org>; Tue,  4 Oct 2022 18:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229436AbiJDSa3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Oct 2022 14:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJDSa3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2022 14:30:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C051B9FA
        for <mm-commits@vger.kernel.org>; Tue,  4 Oct 2022 11:30:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FE87B81BB0
        for <mm-commits@vger.kernel.org>; Tue,  4 Oct 2022 18:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67EDC433C1;
        Tue,  4 Oct 2022 18:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664908224;
        bh=a8uSlbG5VRE4+5NU4QyevtOLVQeN0Zlb6zaeYUBum0Q=;
        h=Date:To:From:Subject:From;
        b=hn8bCxcnWl1MAZGHePNp1LNOaS+nMCjyc3RVIruDvAWXBf189ikSf3qNMkHAr9frZ
         2a1tAW1WmZ+WyVKKMerR6K3EvlHUoVKAvlOqH90SGAuRQ5/D/eR3/i7kaM2//SVFEq
         W+CSF130wZFBfPEeT0X1WJCrEZZBe5K80kbsXkGk=
Date:   Tue, 04 Oct 2022 11:30:24 -0700
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mglru-mm-vmscanc-fix-imprecise-comments.patch added to mm-unstable branch
Message-Id: <20221004183024.D67EDC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mglru: mm/vmscan.c: fix imprecise comments
has been added to the -mm mm-unstable branch.  Its filename is
     mglru-mm-vmscanc-fix-imprecise-comments.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mglru-mm-vmscanc-fix-imprecise-comments.patch

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
From: Yu Zhao <yuzhao@google.com>
Subject: mglru: mm/vmscan.c: fix imprecise comments
Date: Wed, 28 Sep 2022 12:46:20 -0600

Link: https://lkml.kernel.org/r/YzSWfFI+MOeb1ils@google.com
Signed-off-by: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/vmscan.c~mglru-mm-vmscanc-fix-imprecise-comments
+++ a/mm/vmscan.c
@@ -5076,7 +5076,7 @@ static bool should_abort_scan(struct lru
 	DEFINE_MAX_SEQ(lruvec);
 
 	if (!current_is_kswapd()) {
-		/* age each memcg once to ensure fairness */
+		/* age each memcg at most once to ensure fairness */
 		if (max_seq - seq > 1)
 			return true;
 
@@ -5101,10 +5101,9 @@ static bool should_abort_scan(struct lru
 
 	/*
 	 * A minimum amount of work was done under global memory pressure. For
-	 * kswapd, it may be overshooting. For direct reclaim, the target isn't
-	 * met, and yet the allocation may still succeed, since kswapd may have
-	 * caught up. In either case, it's better to stop now, and restart if
-	 * necessary.
+	 * kswapd, it may be overshooting. For direct reclaim, the allocation
+	 * may succeed if all suitable zones are somewhat safe. In either case,
+	 * it's better to stop now, and restart later if necessary.
 	 */
 	for (i = 0; i <= sc->reclaim_idx; i++) {
 		unsigned long wmark;
_

Patches currently in -mm which might be from yuzhao@google.com are

mm-mglru-dont-sync-disk-for-each-aging-cycle.patch
mglru-mm-vmscanc-fix-imprecise-comments.patch

