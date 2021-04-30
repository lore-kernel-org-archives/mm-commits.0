Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CFC9C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DC9561456
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhD3Fya (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:54:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:45594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230284AbhD3Fya (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:54:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B68A361456;
        Fri, 30 Apr 2021 05:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762022;
        bh=XloJaVVAY/JU3eqPkfruAYXA+AoqWVUavP/4Vx8IZus=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Ss7dnMMssr9iNdXeTj2zY3lgwx1tEqazkFm8oHzyCWgOxXcNaEdUbzbzOZs3dzIBZ
         zz9aOKG6y8Ur2jXxyxq7Lb7dhYdQj3ft/ROg4hW3REXGzcT3F9kVjLVeLFtlfGIbl8
         WwH4yrVlbiXOzPApwPijqTg86qNOLtS/6MP+VvX0=
Date:   Thu, 29 Apr 2021 22:53:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, slyfox@gentoo.org,
        torvalds@linux-foundation.org
Subject:  [patch 009/178] ia64: mca: always make IA64_MCA_DEBUG an
 expression
Message-ID: <20210430055342.N4NxwCh4N%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
