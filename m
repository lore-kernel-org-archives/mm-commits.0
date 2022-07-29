Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA29C00140
	for <mm-commits@archiver.kernel.org>; Fri, 29 Jul 2022 01:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiG2BiS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 28 Jul 2022 21:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbiG2BiR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 28 Jul 2022 21:38:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEAC6A9FC
        for <mm-commits@vger.kernel.org>; Thu, 28 Jul 2022 18:38:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2A9061D49
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 01:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7EEC433D7;
        Fri, 29 Jul 2022 01:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659058695;
        bh=ZN5cU9132KxrlWEK7sXnU22TeR1hi4VAVBwtW5oBkFU=;
        h=Date:To:From:Subject:From;
        b=i1wW7k1HNmJGhZnpYdVMJfcW0JPfI+nEZ+gLO/TaUZshOXMAALicgYtLXVvHubTBH
         b2FKmgqCIuQzTr149jVpDGIuX262jtGQoig1UBRHRIkjlfcvZ1iazA9cSTdEPSxpxb
         eVJIgGO2a15HpTZL2zYM50liNqYc8gjWFBeoB+I8=
Date:   Thu, 28 Jul 2022 18:38:14 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-memory-failure-convert-to-pr_fmt-v2.patch removed from -mm tree
Message-Id: <20220729013815.3F7EEC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-memory-failure-convert-to-pr_fmt-v2
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-convert-to-pr_fmt-v2.patch

This patch was dropped because it had testing failures

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

