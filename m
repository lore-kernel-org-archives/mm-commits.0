Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8EB0C04A68
	for <mm-commits@archiver.kernel.org>; Thu, 28 Jul 2022 22:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiG1WpT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jul 2022 18:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiG1WpS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2022 18:45:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2A5175B7
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 15:45:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DA6CECE26A6
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 22:45:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50F7C433C1;
        Thu, 28 Jul 2022 22:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659048313;
        bh=53/94pKKBSVTeMC22yeQBMpogfSBGRwW+39TpzIkO4Y=;
        h=Date:To:From:Subject:From;
        b=U6IqC8FlcqiTFi5D97xqX+ooq4qHqYKOSGF5/yTwETouPaXh7YpyzHe4hT62aj35c
         RZ+DpJALjctU6LQamXwcsMxZrwROplq26qrMtsOhlBeAXt2dVFJQTdwv1jmPPK4tVt
         LkIz4CuSjmFhyf0LWRpxaG+vRkc+tPYpi/vNIa0Q=
Date:   Thu, 28 Jul 2022 15:45:12 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-failure-convert-to-pr_fmt-v2.patch added to mm-unstable branch
Message-Id: <20220728224513.B50F7C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-memory-failure-convert-to-pr_fmt-v2
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-failure-convert-to-pr_fmt-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-failure-convert-to-pr_fmt-v2.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm-memory-failure-convert-to-pr_fmt-v2
Date: Wed, 27 Jul 2022 11:25:11 +0800

Link: https://lkml.kernel.org/r/20220727032511.145506-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memory-failure.c~mm-memory-failure-convert-to-pr_fmt-v2
+++ a/mm/memory-failure.c
@@ -2285,6 +2285,7 @@ static int __init memory_failure_init(vo
 }
 core_initcall(memory_failure_init);
 
+#undef pr_fmt
 #define unpoison_pr_info(fmt, pfn, rs)			\
 ({							\
 	if (__ratelimit(rs))				\
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-cleanup-is_highmem.patch
mm-use-is_zone_movable_page-helper.patch
mm-memory-failure-convert-to-pr_fmt.patch
mm-memory-failure-convert-to-pr_fmt-v2.patch

