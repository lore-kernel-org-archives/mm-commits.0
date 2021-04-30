Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88ABFC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64CE06144D
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhD3FyH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:54:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230187AbhD3FyH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:54:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A2F861424;
        Fri, 30 Apr 2021 05:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619761999;
        bh=e9tN38W12MYO9tqnv1NatsxHtnhpKoqoPDkFWrYNGC8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=hk+8A4g4j5MXsdTZKUv9CgHYIG2CLQ5sNN86IB7C1IrdLun3ok/Jb1PP2hhA2yIVe
         RQ9Z+H2TszEY6cMUaBsq+CmXT2WAV+42Q/ynXC13HmKvW1vl1r/JfrklBRdP4nBZBv
         d1z8YbuIOuVCkileNvfeX7ssNoA8IR1v6YoQ/qTk=
Date:   Thu, 29 Apr 2021 22:53:18 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        zhang.yunkai@zte.com.cn
Subject:  [patch 001/178] arch/ia64/kernel/head.S: remove duplicate
 include
Message-ID: <20210430055318.xmg5ZeVB5%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Subject: arch/ia64/kernel/head.S: remove duplicate include

'linux/pgtable.h' included in 'arch/ia64/kernel/head.S' is duplicated.

Link: https://lkml.kernel.org/r/20210303084549.179346-1-zhang.yunkai@zte.com.cn
Signed-off-by: Zhang Yunkai <zhang.yunkai@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/head.S |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/ia64/kernel/head.S~module-remove-duplicate-include-in-arch-ia64-kernel-heads
+++ a/arch/ia64/kernel/head.S
@@ -33,7 +33,6 @@
 #include <asm/mca_asm.h>
 #include <linux/init.h>
 #include <linux/linkage.h>
-#include <linux/pgtable.h>
 #include <asm/export.h>
 
 #ifdef CONFIG_HOTPLUG_CPU
_
