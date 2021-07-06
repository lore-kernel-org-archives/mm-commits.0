Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF567C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B371661206
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbhGFTOe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:14:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231721AbhGFTOe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:14:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D9E761C72;
        Tue,  6 Jul 2021 19:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598714;
        bh=ORjXiidq2JB3CUKVfSf9sp3vqdbRuIQdI8RYZ5qdLEo=;
        h=Date:From:To:Subject:From;
        b=ze5kQVGzoKCeoapVbN86R5P7FemuqE2vhEFT4JSIywBW0mQa3DyUZMMx6R/xd/rfd
         7Jne/IlPMyX1fbqSw+j1cjABnb1xQgQesaR/da+L53xn1GqWbjKqrkCwOSXBmEZX3c
         ItyecUc8/HEf2A/OO8u1feO2Gy64n/ovqxyAktw8=
Date:   Tue, 06 Jul 2021 12:11:54 -0700
From:   akpm@linux-foundation.org
To:     alexander.h.duyck@linux.intel.com, alexs@kernel.org, guro@fb.com,
        hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, shakeelb@google.com,
        shy828301@gmail.com, songmuchun@bytedance.com,
        wenhui@gwmail.gwu.edu
Subject:  [merged] memcontrol-use-flexible-array-member.patch
 removed from -mm tree
Message-ID: <20210706191154.puDrlh5iB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcontrol: use flexible-array member
has been removed from the -mm tree.  Its filename was
     memcontrol-use-flexible-array-member.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: wenhuizhang <wenhui@gwmail.gwu.edu>
Subject: memcontrol: use flexible-array member

Change deprecated zero-length-and-one-element-arrays into flexible array
member.Zero-length and one-element arrays detected by Lukas's CodeChecker.
Zero/one element arrays cause undefined behaviours if sizeof() used.

Link: https://lkml.kernel.org/r/20210518200910.29912-1-wenhui@gwmail.gwu.edu
Signed-off-by: wenhuizhang <wenhui@gwmail.gwu.edu>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/memcontrol.h~memcontrol-use-flexible-array-member
+++ a/include/linux/memcontrol.h
@@ -349,8 +349,7 @@ struct mem_cgroup {
 	struct deferred_split deferred_split_queue;
 #endif
 
-	struct mem_cgroup_per_node *nodeinfo[0];
-	/* WARNING: nodeinfo must be the last member here */
+	struct mem_cgroup_per_node *nodeinfo[];
 };
 
 /*
_

Patches currently in -mm which might be from wenhui@gwmail.gwu.edu are


