Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CEB6C38145
	for <mm-commits@archiver.kernel.org>; Wed,  7 Sep 2022 22:55:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbiIGWzN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Sep 2022 18:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiIGWyl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Sep 2022 18:54:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E6A15FDD
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 15:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5195B81F56
        for <mm-commits@vger.kernel.org>; Wed,  7 Sep 2022 22:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9D2C433D6;
        Wed,  7 Sep 2022 22:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662591276;
        bh=rA6qcsoybNmYIYd5kZPRe4UKLe/9SW+ZTIBll1OT7c0=;
        h=Date:To:From:Subject:From;
        b=BfwZ3CXwJya3T6ykZ56JW68wX7unjv+J5mkwAhhvriszc2bUMErU+MhJJOvK01/ET
         LxzkXDczt2caFXP4Jt2I6DftHiULB5g1V2MuicoRblzoEdJa9zSBstumw5H4OW+09v
         xJCVxS9B7THg9QQL6rtHd9erMor/MNukyv8JZJwM=
Date:   Wed, 07 Sep 2022 15:54:35 -0700
To:     mm-commits@vger.kernel.org, xiujianfeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rodata_test-use-page_aligned-helper.patch added to mm-unstable branch
Message-Id: <20220907225436.4B9D2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/rodata_test: use PAGE_ALIGNED() helper
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rodata_test-use-page_aligned-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rodata_test-use-page_aligned-helper.patch

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
From: Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: mm/rodata_test: use PAGE_ALIGNED() helper
Date: Tue, 6 Sep 2022 15:53:12 +0800

Use PAGE_ALIGNED() helper instead of open-coding operation, no functional
changes here.

Link: https://lkml.kernel.org/r/20220906075312.166595-1-xiujianfeng@huawei.com
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rodata_test.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/rodata_test.c~mm-rodata_test-use-page_aligned-helper
+++ a/mm/rodata_test.c
@@ -9,13 +9,13 @@
 
 #include <linux/rodata_test.h>
 #include <linux/uaccess.h>
+#include <linux/mm.h>
 #include <asm/sections.h>
 
 static const int rodata_test_data = 0xC3;
 
 void rodata_test(void)
 {
-	unsigned long start, end;
 	int zero = 0;
 
 	/* test 1: read the value */
@@ -39,13 +39,11 @@ void rodata_test(void)
 	}
 
 	/* test 4: check if the rodata section is PAGE_SIZE aligned */
-	start = (unsigned long)__start_rodata;
-	end = (unsigned long)__end_rodata;
-	if (start & (PAGE_SIZE - 1)) {
+	if (!PAGE_ALIGNED(__start_rodata)) {
 		pr_err("start of .rodata is not page size aligned\n");
 		return;
 	}
-	if (end & (PAGE_SIZE - 1)) {
+	if (!PAGE_ALIGNED(__end_rodata)) {
 		pr_err("end of .rodata is not page size aligned\n");
 		return;
 	}
_

Patches currently in -mm which might be from xiujianfeng@huawei.com are

mm-hwpoison-add-__init-__exit-annotations-to-module-init-exit-funcs.patch
mm-rodata_test-use-page_aligned-helper.patch

