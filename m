Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B3FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 00:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236404AbiCYAet (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 20:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343825AbiCYAer (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 20:34:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A342AC57
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 17:33:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1D5560C84
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 00:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D54C340EC;
        Fri, 25 Mar 2022 00:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648168390;
        bh=uRREi2R4Jn2m0WN0rtlcYML1rbblPn1ZXdbDPgY0e2A=;
        h=Date:To:From:Subject:From;
        b=xnAXRe0hQWYCVEHN2iRk3AHjLJ9jEki64GlWruz0HpJWwTTu1Ug9NczlbdsV9CBo1
         DI374sTq3KbbJOMAb6YN8Hf3vlpMvUO4ztYh2TZAvp1pzvrFK2MtSv452b5vGHkxGM
         TWZ5PN4Wn12JSMZqEY5jD2f6nLMCWoSMsX8oW15s=
Date:   Thu, 24 Mar 2022 17:33:09 -0700
To:     mm-commits@vger.kernel.org, andreyknvl@gmail.com,
        sfr@canb.auug.org.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-improve-vmalloc-tests-fix.patch removed from -mm tree
Message-Id: <20220325003310.16D54C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: similar to "kasan: test: fix compatibility with FORTIFY_SOURCE"
has been removed from the -mm tree.  Its filename was
     kasan-improve-vmalloc-tests-fix.patch

This patch was dropped because it was folded into kasan-improve-vmalloc-tests.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: similar to "kasan: test: fix compatibility with FORTIFY_SOURCE"

Link: https://lkml.kernel.org/r/20220128144801.73f5ced0@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/test_kasan.c~kasan-improve-vmalloc-tests-fix
+++ a/lib/test_kasan.c
@@ -1104,6 +1104,8 @@ static void vmalloc_oob(struct kunit *te
 	v_ptr = vmalloc(size);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
 
+	OPTIMIZER_HIDE_VAR(v_ptr);
+
 	/*
 	 * We have to be careful not to hit the guard page in vmalloc tests.
 	 * The MMU will catch that and crash us.
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

kasan-improve-vmalloc-tests.patch

