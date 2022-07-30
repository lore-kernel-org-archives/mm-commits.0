Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A7FEC00144
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 00:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbiG3A4v (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 20:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiG3A4u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 20:56:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A87804AE
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 17:56:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEB97B829FD
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 00:56:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59E11C433C1;
        Sat, 30 Jul 2022 00:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659142607;
        bh=jNqsCj0T2Fey0OLX4fyP56JkBc1Y6r/ht2pRNj5/q4I=;
        h=Date:To:From:Subject:From;
        b=0CcY6s6UT7QnCh0TOqeL+qdwlLrYk6/dt4fTGxiQG8tYoXeGU+/MXGCMlk/VgyYwZ
         SNC0GUBRymqQTGUYSlUeMO48wOsqOt3N1gefTA31aA/L2qnIeVDiuMWfMnfa/GKyuw
         KyD5ww9y6kSszETtbk3nrYafss2qPiOZdUtLc7mE=
Date:   Fri, 29 Jul 2022 17:56:46 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-failure-convert-to-pr_fmt-v3.patch removed from -mm tree
Message-Id: <20220730005647.59E11C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memory-failure-convert-to-pr_fmt-v3
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-convert-to-pr_fmt-v3.patch

This patch was dropped because it was folded into mm-memory-failure-convert-to-pr_fmt.patch

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm-memory-failure-convert-to-pr_fmt-v3
Date: Fri, 29 Jul 2022 11:19:19 +0800

Use pr_fmt to prefix all pr_<level> output, but unpoison_memory()
and soft_offline_page() are used by error injection, which have
own prefixes like "Unpoison:" and "soft offline:", meanwhile,
soft_offline_page() could be used by memory hotremove, so reset
pr_fmt before unpoison_pr_info definition to keep the original
output for them.

Link: https://lkml.kernel.org/r/20220729031919.72331-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failure-convert-to-pr_fmt-v3
+++ a/mm/memory-failure.c
@@ -2285,6 +2285,8 @@ static int __init memory_failure_init(vo
 }
 core_initcall(memory_failure_init);
 
+#undef pr_fmt
+#define pr_fmt(fmt)	"" fmt
 #define unpoison_pr_info(fmt, pfn, rs)			\
 ({							\
 	if (__ratelimit(rs))				\
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-cleanup-is_highmem.patch
mm-use-is_zone_movable_page-helper.patch
mm-memory-failure-convert-to-pr_fmt.patch

