Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A331C35265
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B413B22243
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633203;
	bh=msPNQ0QQz+eqkzQW7RkXTHrOKFUYQl20vckE/ibwJUo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=tjxDl836c9mFzRPwPYkLRvxXTyhQ4Hsq8KUZRGkASc4DIscaVHkWHcm0DJdhf5NCC
	 6Qsm2mbgabfACdQI+ekI47rKXK6/sbyw5F5PKLKb8V9Dfygtyc8J6gfcFP0ulpOA9w
	 U8U5hORFaKKdbPkfb+7uYJe33R2et06PTHVb4Uw8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgJMXxX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730088AbgJMXwl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6BCB22201;
        Tue, 13 Oct 2020 23:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633160;
        bh=msPNQ0QQz+eqkzQW7RkXTHrOKFUYQl20vckE/ibwJUo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=IUB1fiLXtLxJrvjnxHqk8tYM4UPdiGF/X+zPvO587d8kNazvJPL3apSUHzYtKivfm
         9btX/9en45lH7u46JYvOlRHz3yI7Mf7/+cbrfyMi3caLeBFEm/MXFVbu94MKm/Ig28
         64I6P2PHo/d8MNayY+SlJuCMltqGabFzsg96C2FA=
Date:   Tue, 13 Oct 2020 16:52:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, gustavoars@kernel.org,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 079/181] mm: memcontrol: use the preferred form
 for passing the size of a structure type
Message-ID: <20201013235239.IxuUc59eL%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: mm: memcontrol: use the preferred form for passing the size of a structure type

Use the preferred form for passing the size of a structure type.  The
alternative form where the structure type is spelled out hurts readability
and introduces an opportunity for a bug when the object type is changed
but the corresponding object identifier to which the sizeof operator is
applied is not.

Link: https://lkml.kernel.org/r/773e013ff2f07fe2a0b47153f14dea054c0c04f1.1596214831.git.gustavoars@kernel.org
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcontrol-use-the-preferred-form-for-passing-the-size-of-a-structure-type
+++ a/mm/memcontrol.c
@@ -4264,7 +4264,7 @@ static int __mem_cgroup_usage_register_e
 	new->entries[size - 1].threshold = threshold;
 
 	/* Sort thresholds. Registering of new threshold isn't time-critical */
-	sort(new->entries, size, sizeof(struct mem_cgroup_threshold),
+	sort(new->entries, size, sizeof(*new->entries),
 			compare_thresholds, NULL);
 
 	/* Find current threshold */
_
