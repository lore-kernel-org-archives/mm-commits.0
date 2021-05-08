Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D097C43460
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C49D61402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:39:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhEHWkN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:43114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229620AbhEHWkN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:40:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8298161402;
        Sat,  8 May 2021 22:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513551;
        bh=kftQxnjANNi8vbGs6uklSQ3ljWAg3LaHmbgKypxscjM=;
        h=Date:From:To:Subject:From;
        b=kZDf8qPf86PT2nnM2neFi588Z5Lj2z6++9ZRvLNZ3wh0nExP5qzlUvceBSS0ihAQD
         9+pv+R8Vy2KyAyGeB94HEfR9Wc6hwZZR3MX/oLl9buKlppaE/i8M9gdHIe0aTKFvAU
         EPKyXtXrLGJYmJuxIcW7qO4ijRlEw1csW9bVlH1Y=
Date:   Sat, 08 May 2021 15:39:11 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, slyfox@gentoo.org
Subject:  [merged]
 ia64-mca-always-make-ia64_mca_debug-an-expression.patch removed from -mm
 tree
Message-ID: <20210508223911.1w7_uMSm8%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: mca: always make IA64_MCA_DEBUG an expression
has been removed from the -mm tree.  Its filename was
     ia64-mca-always-make-ia64_mca_debug-an-expression.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sergei Trofimovich <slyfox@gentoo.org>
Subject: ia64: mca: always make IA64_MCA_DEBUG an expression

At least ia64_mca_log_sal_error_record() expects some statement:

    static void ia64_mca_log_sal_error_record(int sal_info_type)
    {
        ...
        if (irq_safe)
            IA64_MCA_DEBUG("CPU %d: SAL log contains %s error record
",
                smp_processor_id(),
                sal_info_type < ARRAY_SIZE(rec_name) ? rec_name[sal_info_type] : "UNKNOWN");
        ...
    }

Instead of fixing all callers the change expicitly makes IA64_MCA_DEBUG
a non-empty expression.

Link: https://lkml.kernel.org/r/20210328215549.830420-1-slyfox@gentoo.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/mca.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/ia64/kernel/mca.c~ia64-mca-always-make-ia64_mca_debug-an-expression
+++ a/arch/ia64/kernel/mca.c
@@ -109,9 +109,9 @@
 #include "irq.h"
 
 #if defined(IA64_MCA_DEBUG_INFO)
-# define IA64_MCA_DEBUG(fmt...)	printk(fmt)
+# define IA64_MCA_DEBUG(fmt...) printk(fmt)
 #else
-# define IA64_MCA_DEBUG(fmt...)
+# define IA64_MCA_DEBUG(fmt...) do {} while (0)
 #endif
 
 #define NOTIFY_INIT(event, regs, arg, spin)				\
_

Patches currently in -mm which might be from slyfox@gentoo.org are


