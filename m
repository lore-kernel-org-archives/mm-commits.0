Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87D67C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:56:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A0062177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 05:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596779791;
	bh=rRujOHtPi+XBNFh83PpByDZRta319D67TAkoRcxAMnU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=hE95cqWKyUbMSEJoL7Lv+gvmEGsdVOkCVXYTZIaconsI0x5Wc2HnrhS/ju4Tr0CXd
	 oIMkyJzM48JJi9iu+f2SbUFcALHTVvI/6n1igon6jXhEzxeGaUQznvqLsewCZD0tn/
	 yfQC9755TsC3tYqK569ry3Ezp3u4nC3QlzRNdUZQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgHGF4b (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 01:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGF4a (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 01:56:30 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00F2421744;
        Fri,  7 Aug 2020 05:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596779790;
        bh=rRujOHtPi+XBNFh83PpByDZRta319D67TAkoRcxAMnU=;
        h=Date:From:To:Subject:From;
        b=vKNT43mhFcn/swWXqBaEj3lzSaQsF8KcJHf6HJGR/Go0NoclC0uST31Rmh1rdxp/w
         892g+h9HqZLU0rJio4jXoI060971EA5d1/TEVO+C+M4xN901uCXu36zDtK/WmgGtjO
         8lUSTsNanBM2XdD1xajPm9lVLL6tAkuTcnpKqDfY=
Date:   Thu, 06 Aug 2020 22:56:29 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com,
        glider@google.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, walter-zh.wu@mediatek.com
Subject:  [folded-merged]
 kasan-fix-kasan-unit-tests-for-tag-based-kasan-v4.patch removed from -mm
 tree
Message-ID: <20200807055629.GvqRJ98Si%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-fix-kasan-unit-tests-for-tag-based-kasan-v4
has been removed from the -mm tree.  Its filename was
     kasan-fix-kasan-unit-tests-for-tag-based-kasan-v4.patch

This patch was dropped because it was folded into kasan-fix-kasan-unit-tests-for-tag-based-kasan.patch

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan-fix-kasan-unit-tests-for-tag-based-kasan-v4

use KASAN_SHADOW_SCALE_SIZE instead of 13

Link: http://lkml.kernel.org/r/20200708132524.11688-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/lib/test_kasan.c~kasan-fix-kasan-unit-tests-for-tag-based-kasan-v4
+++ a/lib/test_kasan.c
@@ -23,7 +23,9 @@
 
 #include <asm/page.h>
 
-#define OOB_TAG_OFF (IS_ENABLED(CONFIG_KASAN_GENERIC) ? 0 : 13)
+#include "../mm/kasan/kasan.h"
+
+#define OOB_TAG_OFF (IS_ENABLED(CONFIG_KASAN_GENERIC) ? 0 : KASAN_SHADOW_SCALE_SIZE)
 
 /*
  * We assign some test results to these globals to make sure the tests
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are

rcu-kasan-record-and-print-call_rcu-call-stack.patch
kasan-record-and-print-the-free-track.patch
kasan-add-tests-for-call_rcu-stack-recording.patch
kasan-update-documentation-for-generic-kasan.patch
kasan-fix-kasan-unit-tests-for-tag-based-kasan.patch

