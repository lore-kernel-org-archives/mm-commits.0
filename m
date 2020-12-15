Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B5BC4743D
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F42E230FA
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgLOX77 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbgLOX0k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:26:40 -0500
Date:   Tue, 15 Dec 2020 15:18:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074288;
        bh=kQD+Q57twFRJlrrbYx2CpsBhUxi54AEBjV0wkwartmc=;
        h=From:To:Subject:From;
        b=YZoGV5YXDTivR63SVfz6uvA69mCHMiiSVrKL/xaL1XVgWN+E0yl2H7OvZQuikToF6
         4MBkKDUYyi6K1qwIOY4sYMsHWmXt3vIKGEGQywwyP9GsHBSSqcQsOwcgP0CqoJWd7L
         BSh4SIm/6kImz2n5InZQIP3bsa1AHHeFenSLKYpc=
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, linmiaohe@huawei.com, mhocko@suse.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 =?US-ASCII?Q?mm-memcontrol-eliminate-redundant-check-in-=5F=5Fmem=5Fcgro?=
 =?US-ASCII?Q?up=5Finsert=5Fexceeded.patch?= removed from -mm tree
Message-ID: <20201215231808.NUeVtFkDW%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: eliminate redundant check in __mem_cgroup_insert_exceeded()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-eliminate-redundant-check-in-__mem_cgroup_insert_exceeded.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from linmiaohe@huawei.com are


