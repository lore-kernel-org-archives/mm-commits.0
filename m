Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2972BC4321E
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiCVVr1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236435AbiCVVrY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:47:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995C9DF45
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:45:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F465B81DAD
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08273C340EC;
        Tue, 22 Mar 2022 21:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985554;
        bh=rkVyZCLtKId1gqM4EKvVgPOCeh/3NOaqkpucbTzplJU=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=pR2xMY8NY5adcB2gvwwTAHHq0TKoaWsUe6151vAC62IoBZMrlAfjhkg6UKmE4uufO
         s3miP1zLFP73kMYmLrUcJb9qaOAsnDjBfYZ1m/thBtzeAW02k1ZyuoZvRP+MzpuIGY
         kI4So82P/ZAugJuzFNjW2kuW6ZwTw22/FptLHeKo=
Date:   Tue, 22 Mar 2022 14:45:53 -0700
To:     vbabka@suse.cz, mhocko@suse.com, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, quic_charante@quicinc.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 145/227] mm: vmscan: fix documentation for page_check_references()
Message-Id: <20220322214554.08273C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
