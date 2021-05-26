Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 690A7C47087
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 02:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3874F61429
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 02:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhEZCQE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 May 2021 22:16:04 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3944 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbhEZCQE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 May 2021 22:16:04 -0400
Received: from dggems706-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FqZFQ58mHzBw9j;
        Wed, 26 May 2021 10:11:38 +0800 (CST)
Received: from dggeme756-chm.china.huawei.com (10.3.19.102) by
 dggems706-chm.china.huawei.com (10.3.19.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 10:14:30 +0800
Received: from localhost.localdomain (10.69.192.58) by
 dggeme756-chm.china.huawei.com (10.3.19.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 26 May 2021 10:14:30 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <sh_def@163.com>, <catalin.marinas@arm.com>
CC:     <mm-commits@vger.kernel.org>, <linuxarm@openeuler.org>,
        <linuxarm@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH] mm,kmemleak-test: add the dependency on CONFIG_SAMPLES
Date:   Wed, 26 May 2021 10:10:08 +0800
Message-ID: <1621995008-116893-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

As kmemleak-test.c is moved to samples dir, it is not compiled if just
setting CONFIG_DEBUG_KMEMLEAK_TEST as module and enabling
CONFIG_DEBUG_KMEMLEAK. Because it depends on CONFIG_SAMPLES after it is
moved to samples dir.
So the dependency on CONFIG_SAMPLES is added.

Fixes: 1abbef4f5172 ("mm,kmemleak-test.c: move kmemleak-test.c to samples dir")
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 lib/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2779c29..9950542 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -716,7 +716,7 @@ config DEBUG_KMEMLEAK_MEM_POOL_SIZE
 
 config DEBUG_KMEMLEAK_TEST
 	tristate "Simple test for the kernel memory leak detector"
-	depends on DEBUG_KMEMLEAK && m
+	depends on DEBUG_KMEMLEAK && SAMPLES && m
 	help
 	  This option enables a module that explicitly leaks memory.
 
-- 
2.8.1

