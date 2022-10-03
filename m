Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D03C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiJCVLt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiJCVJm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:09:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A845050D
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:06:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EBBAB811BF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AB0C433C1;
        Mon,  3 Oct 2022 21:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831204;
        bh=l/g5KqJaUDu1yjubTJinGLPpRE5DEckgmnJGmL2wNao=;
        h=Date:To:From:Subject:From;
        b=Ez7D0MgwJvuSZKp6SjDvIC6XQx7LfItJ5ERH+2A6j/OlxtWogPsqNCJ+gT6VrZgx6
         V7uyqS3XR2p4YH8gFAl6Zs/SJtSDnGc0zIx1KYCfSr6naXvBfDv/Dd9uQ01q4UtNBt
         6gh7RKBpNQF7V3u25CjC7usdtiJK+alLjo89IoWA=
Date:   Mon, 03 Oct 2022 14:06:44 -0700
To:     mm-commits@vger.kernel.org, xiujianfeng@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-rodata_test-use-page_aligned-helper.patch removed from -mm tree
Message-Id: <20221003210644.B6AB0C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/rodata_test: use PAGE_ALIGNED() helper
has been removed from the -mm tree.  Its filename was
     mm-rodata_test-use-page_aligned-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


