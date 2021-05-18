Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB95C433ED
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 20:52:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FEA36135B
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 20:52:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239325AbhERUxS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 16:53:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236529AbhERUxR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 16:53:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0F24611BD;
        Tue, 18 May 2021 20:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621371119;
        bh=BjMnpyM2ZiyydTKfUXRLpx3Gks9LbfD5hyAFFIUMW3Y=;
        h=Date:From:To:Subject:From;
        b=MXW93YUVxAsEMocWrkn8Y+EUxiJ4tc85x6QoQoJvNTjvy4Goh7x8oBCuKBFz04kMe
         QnSXijjGfRL5FjmZxGza+vgWkoSY02TlIDgERm/SxRR/j/gws+otag/7CsQ5JD9noW
         epqyQGV2qcTr6fyrm7yK0rMo2GzhYjub++rq92fY=
Date:   Tue, 18 May 2021 13:51:58 -0700
From:   akpm@linux-foundation.org
To:     alexander.h.duyck@linux.intel.com, alexs@kernel.org, guro@fb.com,
        hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        richard.weiyang@gmail.com, shakeelb@google.com,
        shy828301@gmail.com, songmuchun@bytedance.com,
        wenhui@gwmail.gwu.edu
Subject:  + memcontrol-use-flexible-array-member.patch added to -mm
 tree
Message-ID: <20210518205158.bAZPxC9bM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcontrol: use flexible-array member
has been added to the -mm tree.  Its filename is
     memcontrol-use-flexible-array-member.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcontrol-use-flexible-array-member.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcontrol-use-flexible-array-member.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: wenhuizhang <wenhui@gwmail.gwu.edu>
Subject: memcontrol: use flexible-array member

Change depracated zero-length-and-one-element-arrays into flexible array
member.Zero-length and one-element arrays detected by Lukas's CodeChecker.
Zero/one element arrays causes undefined behaviours if sizeof() used.

Link: https://lkml.kernel.org/r/20210518200910.29912-1-wenhui@gwmail.gwu.edu
Signed-off-by: wenhuizhang <wenhui@gwmail.gwu.edu>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
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

memcontrol-use-flexible-array-member.patch

