Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEEE2C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 25 May 2022 17:49:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbiEYRt0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 May 2022 13:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343505AbiEYRtJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 May 2022 13:49:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61D2515A9
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 10:49:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B75161800
        for <mm-commits@vger.kernel.org>; Wed, 25 May 2022 17:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FD2C34114;
        Wed, 25 May 2022 17:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653500945;
        bh=SkHClzgh8KToBecTUUh1S337d12YI7S6QUDLhEVDffs=;
        h=Date:To:From:Subject:From;
        b=l4FyY7VrXQWbheAT8YwYmWbJTDSPfi1X9G8FvKZwOMpb/PBJEsBfLL0hzNR9ggIHz
         QaOXQJk9mbW0mEyjJCdr0KV3uTZA5XanzpKuTcR6QCtGQGDTQ1Y4IzqIoyv2RWxd5s
         XaO/qvLS9LOKZ3D0r7bsuE9Vwa+VuFHxQ7/tsnCQ=
Date:   Wed, 25 May 2022 10:49:04 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        glider@google.com, elver@google.com, dvyukov@google.com,
        wangkefeng.wang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kfence-use-page_aligned-helper.patch removed from -mm tree
Message-Id: <20220525174905.71FD2C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: kfence: use PAGE_ALIGNED helper
has been removed from the -mm tree.  Its filename was
     mm-kfence-use-page_aligned-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: kfence: use PAGE_ALIGNED helper
Date: Fri, 20 May 2022 10:18:33 +0800

Use PAGE_ALIGNED macro instead of IS_ALIGNED and passing PAGE_SIZE.

Link: https://lkml.kernel.org/r/20220520021833.121405-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/kfence_test.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/kfence/kfence_test.c~mm-kfence-use-page_aligned-helper
+++ a/mm/kfence/kfence_test.c
@@ -296,10 +296,9 @@ static void *test_alloc(struct kunit *te
 
 			if (policy == ALLOCATE_ANY)
 				return alloc;
-			if (policy == ALLOCATE_LEFT && IS_ALIGNED((unsigned long)alloc, PAGE_SIZE))
+			if (policy == ALLOCATE_LEFT && PAGE_ALIGNED(alloc))
 				return alloc;
-			if (policy == ALLOCATE_RIGHT &&
-			    !IS_ALIGNED((unsigned long)alloc, PAGE_SIZE))
+			if (policy == ALLOCATE_RIGHT && !PAGE_ALIGNED(alloc))
 				return alloc;
 		} else if (policy == ALLOCATE_NONE)
 			return alloc;
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-kasan-fix-input-of-vmalloc_to_page.patch

