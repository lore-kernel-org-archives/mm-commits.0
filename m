Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6997C433E0
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86140207B7
	for <mm-commits@archiver.kernel.org>; Mon, 25 Jan 2021 22:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732271AbhAYW2w (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:28:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:35988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732966AbhAYVhZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 25 Jan 2021 16:37:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E86022581;
        Mon, 25 Jan 2021 21:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611610505;
        bh=5AQ1bbniT9EmSLDHwALBNM0BYtmNtVditTpX5RJieE0=;
        h=Date:From:To:Subject:From;
        b=qbSJRx+Bu/ARqjyKZmzQxzVlhaxzV5uXeMhoVQfTxk2YVdmzR+cwgsfTVrcaVs50Q
         yGhGMX0rN223NLaCHN4iolnsjSu3IZoXKHdZD8Jq3QSIR0ZQHsDgV/salLYi1kpJLY
         x6/0sXAlvFEiitF1tD42BJ2DUDOqqPurX8Oaoa3M=
Date:   Mon, 25 Jan 2021 13:35:05 -0800
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com,
        dan.j.williams@intel.com, dvyukov@google.com, glider@google.com,
        lecopzer.chen@mediatek.com, lecopzer@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 kasan-fix-incorrect-arguments-passing-in-kasan_add_zero_shadow.patch
 removed from -mm tree
Message-ID: <20210125213505.whHGYmWOn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: fix incorrect arguments passing in kasan_add_zero_shadow
has been removed from the -mm tree.  Its filename was
     kasan-fix-incorrect-arguments-passing-in-kasan_add_zero_shadow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Lecopzer Chen <lecopzer@gmail.com>
Subject: kasan: fix incorrect arguments passing in kasan_add_zero_shadow

kasan_remove_zero_shadow() shall use original virtual address, start and
size, instead of shadow address.

Link: https://lkml.kernel.org/r/20210103063847.5963-1-lecopzer@gmail.com
Fixes: 0207df4fa1a86 ("kernel/memremap, kasan: make ZONE_DEVICE with work with KASAN")
Signed-off-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/kasan/init.c~kasan-fix-incorrect-arguments-passing-in-kasan_add_zero_shadow
+++ a/mm/kasan/init.c
@@ -486,7 +486,6 @@ int kasan_add_zero_shadow(void *start, u
 
 	ret = kasan_populate_early_shadow(shadow_start, shadow_end);
 	if (ret)
-		kasan_remove_zero_shadow(shadow_start,
-					size >> KASAN_SHADOW_SCALE_SHIFT);
+		kasan_remove_zero_shadow(start, size);
 	return ret;
 }
_

Patches currently in -mm which might be from lecopzer@gmail.com are


