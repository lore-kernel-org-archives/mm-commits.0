Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30ED1C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16B52610F7
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhEGBFk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:05:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:46254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231271AbhEGBFj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:05:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45C9F61289;
        Fri,  7 May 2021 01:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349479;
        bh=93ef1ukrQMbpy8g1f2XZQsltw+KWYX9RH2E4/K5tXJ0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=R6MTX3Xg9GUclNGcr04lJGsZcUwCVwgKQ9RkCnDgN9VW+kcCrK39uHFHJECOU9z+8
         JXP+twC+W/Ya/wOVTcq25UpRPS8heFjPOHqN1uKjwKzwOpDnSoX9AeOjac+c23kZ11
         kTrvUobjrt/4fmOigEz5Y9N/L+2RzD4hX0iuc2+M=
Date:   Thu, 06 May 2021 18:04:38 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, baijiaju1990@gmail.com, bhe@redhat.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        oslab@tsinghua.edu.cn, torvalds@linux-foundation.org
Subject:  [patch 50/91] kernel: kexec_file: fix error return code
 of kexec_calculate_store_digests()
Message-ID: <20210507010438.8fLVHEks0%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: kernel: kexec_file: fix error return code of kexec_calculate_store_digests()

When vzalloc() returns NULL to sha_regions, no error return code of
kexec_calculate_store_digests() is assigned.  To fix this bug, ret is
assigned with -ENOMEM in this case.

Link: https://lkml.kernel.org/r/20210309083904.24321-1-baijiaju1990@gmail.com
Fixes: a43cac0d9dc2 ("kexec: split kexec_file syscall code to kexec_file.c")
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_file.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/kexec_file.c~kernel-kexec_file-fix-error-return-code-of-kexec_calculate_store_digests
+++ a/kernel/kexec_file.c
@@ -740,8 +740,10 @@ static int kexec_calculate_store_digests
 
 	sha_region_sz = KEXEC_SEGMENT_MAX * sizeof(struct kexec_sha_region);
 	sha_regions = vzalloc(sha_region_sz);
-	if (!sha_regions)
+	if (!sha_regions) {
+		ret = -ENOMEM;
 		goto out_free_desc;
+	}
 
 	desc->tfm   = tfm;
 
_
