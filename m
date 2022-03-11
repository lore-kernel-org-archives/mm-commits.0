Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79AE9C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 11 Mar 2022 02:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbiCKCLN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 10 Mar 2022 21:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233354AbiCKCLM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2022 21:11:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598FB1A58E4
        for <mm-commits@vger.kernel.org>; Thu, 10 Mar 2022 18:10:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E0EFB82849
        for <mm-commits@vger.kernel.org>; Fri, 11 Mar 2022 02:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEAEC340E8;
        Fri, 11 Mar 2022 02:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646964607;
        bh=pYg2GEAPbjwylkDIQkv6y55+eqhNo6ZMk4nAsm+tgKI=;
        h=Date:To:From:Subject:From;
        b=J0Icyj6Bv21Z8WZNQiAq5m5Vq3mDivKiRHtzyYibs73q+03sxvtiHNFQUeHy4Z/77
         VrgtlMc02LeN64BsudukD9eNk9pi0FARTqk7mi2Uf3NLRN9qAiD9RlDM8bo7NAmx3u
         x2o4yfKEU87yG1pFWdakq5TFmMPELNYB0RTTsy+w=
Date:   Thu, 10 Mar 2022 18:10:06 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        iamjoonsoo.kim@lge.com, hannes@cmpxchg.org,
        quic_charante@quicinc.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-fix-documentation-for-page_check_references.patch added to -mm tree
Message-Id: <20220311021007.9DEAEC340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: fix documentation for page_check_references()
has been added to the -mm tree.  Its filename is
     mm-vmscan-fix-documentation-for-page_check_references.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-fix-documentation-for-page_check_references.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-fix-documentation-for-page_check_references.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-vmscan-fix-documentation-for-page_check_references.patch

