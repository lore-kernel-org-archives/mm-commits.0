Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A428C6FD18
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjC1XYW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjC1XW5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:22:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71513C10
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:22:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62F80B81EEC
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21941C433D2;
        Tue, 28 Mar 2023 23:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045745;
        bh=d6c2XDH3+Ht5n/oj8w//UoqoAuxD7qbEKtxSPFdV6qs=;
        h=Date:To:From:Subject:From;
        b=v2CkFtU/BTJQsOc+kipMQxUU1A0SECJ3V0C3HARAlx03l3nSfe6PMBVAxOqGbv2QD
         q+NX1NAo3/YjAoBZV+rU4wdbHVig2Hid+rZNrcpXwW8674LCTCS8YoMnh+CT6wKpWg
         136Xr1/QhXQJddVIUrLx+/Qp10CNll5P87toomoQ=
Date:   Tue, 28 Mar 2023 16:22:24 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, david@redhat.com, wangkefeng.wang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-directly-use-is_enabledconfig_hwpoison_inject.patch removed from -mm tree
Message-Id: <20230328232225.21941C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: memory-failure: directly use IS_ENABLED(CONFIG_HWPOISON_INJECT)
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-directly-use-is_enabledconfig_hwpoison_inject.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: memory-failure: directly use IS_ENABLED(CONFIG_HWPOISON_INJECT)
Date: Mon, 13 Mar 2023 13:39:29 +0800

It's more clear and simple to just use IS_ENABLED(CONFIG_HWPOISON_INJECT)
to check whether or not to enable HWPoison injector module instead of
CONFIG_HWPOISON_INJECT/CONFIG_HWPOISON_INJECT_MODULE.

Link: https://lkml.kernel.org/r/20230313053929.84607-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory-failure.c~mm-memory-failure-directly-use-is_enabledconfig_hwpoison_inject
+++ a/mm/memory-failure.c
@@ -168,7 +168,7 @@ static bool page_handle_poison(struct pa
 	return true;
 }
 
-#if defined(CONFIG_HWPOISON_INJECT) || defined(CONFIG_HWPOISON_INJECT_MODULE)
+#if IS_ENABLED(CONFIG_HWPOISON_INJECT)
 
 u32 hwpoison_filter_enable = 0;
 u32 hwpoison_filter_dev_major = ~0U;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


