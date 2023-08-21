Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F3F8EE49B7
	for <mm-commits@archiver.kernel.org>; Mon, 21 Aug 2023 20:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjHUUj3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjHUUjO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Aug 2023 16:39:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4D2C7
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 13:39:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFB5C64B03
        for <mm-commits@vger.kernel.org>; Mon, 21 Aug 2023 20:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED13C433C8;
        Mon, 21 Aug 2023 20:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1692650350;
        bh=2z0biE/XOao/tdt/HCxUgc4mbLqRXm4eoURPzNTd9QM=;
        h=Date:To:From:Subject:From;
        b=bsSPkUUPdG1D0cr7mf62ADCuVLS1NRWCt7M+eefABXNKqAtXQU5/Jab1CwrPplq/e
         OVWqZQw28iGoUGXRJGzFOjh6zg3NUqF3YdlmbGZWq0FZla0Lky1NOy8bKmZo8bkfpf
         3sVbF685D5w2pYhWdNO6C5vOsGdV++d4kYCacJio=
Date:   Mon, 21 Aug 2023 13:39:09 -0700
To:     mm-commits@vger.kernel.org, wangkefeng.wang@huawei.com,
        sunnanyong@huawei.com, glider@google.com, elver@google.com,
        dvyukov@google.com, zhangpeng362@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmsan-use-helper-function-page_size.patch removed from -mm tree
Message-Id: <20230821203910.3ED13C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kmsan: use helper function page_size()
has been removed from the -mm tree.  Its filename was
     mm-kmsan-use-helper-function-page_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: ZhangPeng <zhangpeng362@huawei.com>
Subject: mm: kmsan: use helper function page_size()
Date: Thu, 27 Jul 2023 09:16:10 +0800

Patch series "minor cleanups for kmsan".

Use helper function and macros to improve code readability.  No functional
modification involved.


This patch (of 3):

Use function page_size() to improve code readability.  No functional
modification involved.

Link: https://lkml.kernel.org/r/20230727011612.2721843-1-zhangpeng362@huawei.com
Link: https://lkml.kernel.org/r/20230727011612.2721843-2-zhangpeng362@huawei.com
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marco Elver <elver@google.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/hooks.c  |    2 +-
 mm/kmsan/shadow.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/kmsan/hooks.c~mm-kmsan-use-helper-function-page_size
+++ a/mm/kmsan/hooks.c
@@ -117,7 +117,7 @@ void kmsan_kfree_large(const void *ptr)
 	page = virt_to_head_page((void *)ptr);
 	KMSAN_WARN_ON(ptr != page_address(page));
 	kmsan_internal_poison_memory((void *)ptr,
-				     PAGE_SIZE << compound_order(page),
+				     page_size(page),
 				     GFP_KERNEL,
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
--- a/mm/kmsan/shadow.c~mm-kmsan-use-helper-function-page_size
+++ a/mm/kmsan/shadow.c
@@ -210,7 +210,7 @@ void kmsan_free_page(struct page *page,
 		return;
 	kmsan_enter_runtime();
 	kmsan_internal_poison_memory(page_address(page),
-				     PAGE_SIZE << compound_order(page),
+				     page_size(page),
 				     GFP_KERNEL,
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
_

Patches currently in -mm which might be from zhangpeng362@huawei.com are


