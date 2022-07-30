Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 365EDC19F2B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbiG3BJB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239677AbiG3BIk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FA585FA6
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50B74B829FD
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E309DC433C1;
        Sat, 30 Jul 2022 01:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143310;
        bh=RJIh+6SPQv6boJI9NYXciZGHqH0cl3NqzMBHZFTr81E=;
        h=Date:To:From:Subject:From;
        b=ZY09uQEVkigB/LXX1hjmjy26tH4c3xn+Cyg2b/zPk+/9Aq4wqu4KF48Z0z4jGtykJ
         eUppg1VreZmWRx/fU3Umsnvh1kr+y2ukkLdQTgAG6+BdSexjnah9I0YGqvGvERHh8r
         gJTpu+s0MujL5ITN/YZvdsKuVTOB3tEJEBBlJB10=
Date:   Fri, 29 Jul 2022 18:08:29 -0700
To:     mm-commits@vger.kernel.org, mark-pk.tsai@mediatek.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-correct-the-wrong-cpuset-file-path-in-comment.patch removed from -mm tree
Message-Id: <20220730010829.E309DC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: correct the wrong cpuset file path in comment
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-correct-the-wrong-cpuset-file-path-in-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Subject: mm/page_alloc: correct the wrong cpuset file path in comment
Date: Mon, 18 Jul 2022 20:03:35 +0800

cpuset.c was moved to kernel/cgroup/ in below commit
201af4c0fab0 ("cgroup: move cgroup files under kernel/cgroup/")
Correct the wrong path in comment.

Link: https://lkml.kernel.org/r/20220718120336.5145-1-mark-pk.tsai@mediatek.com
Signed-off-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-correct-the-wrong-cpuset-file-path-in-comment
+++ a/mm/page_alloc.c
@@ -4170,7 +4170,7 @@ get_page_from_freelist(gfp_t gfp_mask, u
 retry:
 	/*
 	 * Scan zonelist, looking for a zone with enough free.
-	 * See also __cpuset_node_allowed() comment in kernel/cpuset.c.
+	 * See also __cpuset_node_allowed() comment in kernel/cgroup/cpuset.c.
 	 */
 	no_fallback = alloc_flags & ALLOC_NOFRAGMENT;
 	z = ac->preferred_zoneref;
_

Patches currently in -mm which might be from mark-pk.tsai@mediatek.com are


