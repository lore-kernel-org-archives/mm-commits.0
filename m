Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 715AFC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357375AbiCYBfC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357388AbiCYBdt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D069BF01E
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3DDEB8261B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B13C340EC;
        Fri, 25 Mar 2022 01:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171933;
        bh=LySOqN1rNTclEAd1b6e8RW5mMnkczilUDWzQV7AjDU8=;
        h=Date:To:From:Subject:From;
        b=iErEanm6TwsGlCbl/xEAK9QiqEHYj7qOGsoKx8+6O4ALiaVEfidFjv2eIbaEMKcud
         oRLPfgh1kumu5s8jROWYIbuT3mNPO0tafajkgNTJ7HIQ7BGUrnPXJM9nuJo+Er1+A+
         YAwJGylAvxILa1/ZI3YH2z/ZJ/fsCBx17sF+mXqc=
Date:   Thu, 24 Mar 2022 18:32:13 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        iamjoonsoo.kim@lge.com, hannes@cmpxchg.org,
        quic_charante@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-vmscan-fix-documentation-for-page_check_references.patch removed from -mm tree
Message-Id: <20220325013213.95B13C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: fix documentation for page_check_references()
has been removed from the -mm tree.  Its filename was
     mm-vmscan-fix-documentation-for-page_check_references.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm: vmscan: fix documentation for page_check_references()

commit b518154e59aa ("mm/vmscan: protect the workingset on anonymous LRU")
requires to look twice for both mapped anon/file pages are used more than
once to take the decission of reclaim or activation.  Correct the
documentation accordingly.

Link: https://lkml.kernel.org/r/1646925640-21324-1-git-send-email-quic_charante@quicinc.com
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-fix-documentation-for-page_check_references
+++ a/mm/vmscan.c
@@ -1385,7 +1385,7 @@ static enum page_references page_check_r
 		/*
 		 * All mapped pages start out with page table
 		 * references from the instantiating fault, so we need
-		 * to look twice if a mapped file page is used more
+		 * to look twice if a mapped file/anon page is used more
 		 * than once.
 		 *
 		 * Mark it and spare it for another trip around the
_

Patches currently in -mm which might be from quic_charante@quicinc.com are


