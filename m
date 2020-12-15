Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1BE6C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A76A224BD
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgLODHy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:07:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725806AbgLODHt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:07:49 -0500
Date:   Mon, 14 Dec 2020 19:07:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001628;
        bh=GaRjoJQHe14AULP51nE428JJNv8wOrr+npL69+THgm4=;
        h=From:To:Subject:In-Reply-To:From;
        b=aIE2WITkV9ZetRTZYA2W0IhoxbXQcS0438DkWFSOZo8p7zu4awXsy58+gBRRhSE/R
         NyFk/FdIRcBcQrki4qtfhnJJ+D6+ShagJSr8Cb4cqwumGXi2PXBCAkB0M/TVMaluv6
         Q5utDsCBvWnSFKK6jGF2ya3Y5WteiRbti1Q5pk3I=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org,
        jrdr.linux@gmail.com, kaixuxia@tencent.com, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        tencent_os_robot@tencent.com, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 069/200] mm: memcontrol: sssign boolean values to
 a bool variable
Message-ID: <20201215030707.P_A5gWbZ4%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
