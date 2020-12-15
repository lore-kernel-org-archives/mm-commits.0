Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34FAAC2BBCD
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02B9522D07
	for <mm-commits@archiver.kernel.org>; Wed, 16 Dec 2020 00:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgLPAAo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:34564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbgLOX3n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:29:43 -0500
Date:   Tue, 15 Dec 2020 15:18:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074323;
        bh=aCqpobQR9OEzXSZTZ0Qrv0bI+Y4eir4ZmXD933ADu6I=;
        h=From:To:Subject:From;
        b=i0F+Q95voBRtdDcXWLE4jXPMd8zl+novFg0PXaSx1cfF751+jphfcu0KdGpQqWFZo
         VOXE5XzvopIbuyc8Cm6FKQ1KY3yIe7hKbwJt0lZ8KiEdKQqRKbI7Lly85HuPqn6cnO
         T25tBIG726/t2szOrhIYh4TBKApPSx2/hT2PskQk=
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, jrdr.linux@gmail.com, kaixuxia@tencent.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        tencent_os_robot@tencent.com, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-assign-boolean-values-to-a-bool-variable.patch removed from
 -mm tree
Message-ID: <20201215231843.1RN5PKKN7%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: sssign boolean values to a bool variable
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-assign-boolean-values-to-a-bool-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm: memcontrol: sssign boolean values to a bool variable

Fix the following coccinelle warnings:

./mm/memcontrol.c:7341:2-22: WARNING: Assignment of 0/1 to bool variable
./mm/memcontrol.c:7343:2-22: WARNING: Assignment of 0/1 to bool variable

Link: https://lkml.kernel.org/r/1604737495-6418-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Acked-by: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-assign-boolean-values-to-a-bool-variable
+++ a/mm/memcontrol.c
@@ -7262,9 +7262,9 @@ bool mem_cgroup_swap_full(struct page *p
 static int __init setup_swap_account(char *s)
 {
 	if (!strcmp(s, "1"))
-		cgroup_memory_noswap = 0;
+		cgroup_memory_noswap = false;
 	else if (!strcmp(s, "0"))
-		cgroup_memory_noswap = 1;
+		cgroup_memory_noswap = true;
 	return 1;
 }
 __setup("swapaccount=", setup_swap_account);
_

Patches currently in -mm which might be from kaixuxia@tencent.com are


