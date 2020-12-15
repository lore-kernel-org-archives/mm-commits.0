Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E2CC2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14D51223E0
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgLODI1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:08:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:35068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726340AbgLODHJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:07:09 -0500
Date:   Mon, 14 Dec 2020 19:06:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001589;
        bh=c50P2vWrZigdp+HAdgWiPVK1ngFTtPvmpqMK8E4EV00=;
        h=From:To:Subject:In-Reply-To:From;
        b=idad9lmrlGqiZYRPyIwHVfQlmm9AvK/mwb+9I77OH5Mlm6hzZODtjDc+vSqR/HEpc
         BT9y+ZXTMcI922qUsvkhO28Kgz1BgNlD1+WKe+iNVP+EDk8THf/+J/j+St0s2yYTyW
         EcgCG8mMKrpk176i4SfBeRktu6EZ2G+qn97lUf/8=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org,
        linmiaohe@huawei.com, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 057/200] mm: memcontrol: eliminate redundant check
 in __mem_cgroup_insert_exceeded()
Message-ID: <20201215030628.lkr_4fDa4%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memcontrol: eliminate redundant check in __mem_cgroup_insert_exceeded()

The mz->usage_in_excess >= mz_node->usage_in_excess check is exactly the
else case of mz->usage_in_excess < mz_node->usage_in_excess.  So we could
replace else if (mz->usage_in_excess >= mz_node->usage_in_excess) with
else equally.  Also drop the comment which doesn't really explain much.

Link: https://lkml.kernel.org/r/20201012131607.10656-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-eliminate-redundant-check-in-__mem_cgroup_insert_exceeded
+++ a/mm/memcontrol.c
@@ -623,14 +623,9 @@ static void __mem_cgroup_insert_exceeded
 		if (mz->usage_in_excess < mz_node->usage_in_excess) {
 			p = &(*p)->rb_left;
 			rightmost = false;
-		}
-
-		/*
-		 * We can't avoid mem cgroups that are over their soft
-		 * limit by the same amount
-		 */
-		else if (mz->usage_in_excess >= mz_node->usage_in_excess)
+		} else {
 			p = &(*p)->rb_right;
+		}
 	}
 
 	if (rightmost)
_
