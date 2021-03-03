Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6178C15506
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BDB364E76
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbhCDA7O (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:57488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346235AbhCDAcG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:32:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 931FC64E46;
        Wed,  3 Mar 2021 23:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614813215;
        bh=npM+TcVcWYZBZLIowprcOIDg5Xk2hS1i37cRpt7cW10=;
        h=Date:From:To:Subject:From;
        b=MS3UpcuaUk1CUNXI9oGftdj/4TLaZH2j2w2CODf47wGeim9ygGeuTYDwjhwn4sWf+
         7EEL1fnZAd2ErwZkU60/B/4oIya//Ejb/sJ0XbyaRQ72bu2IQFpQMXx80QGJOm8qFm
         Jo3yK4qJGs7HvD7Ko26HctoZKnRzdLNGBZpFBDCs=
Date:   Wed, 03 Mar 2021 15:13:35 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zhang.yunkai@zte.com.cn
Subject:  +
 module-remove-duplicate-include-in-arch-ia64-kernel-heads.patch added to
 -mm tree
Message-ID: <20210303231335.7968KIbPt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: arch/ia64/kernel/head.S: remove duplicate include
has been added to the -mm tree.  Its filename is
     module-remove-duplicate-include-in-arch-ia64-kernel-heads.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/module-remove-duplicate-include-in-arch-ia64-kernel-heads.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/module-remove-duplicate-include-in-arch-ia64-kernel-heads.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from zhang.yunkai@zte.com.cn are

module-remove-duplicate-include-in-arch-ia64-kernel-heads.patch

