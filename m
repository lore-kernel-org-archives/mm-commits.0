Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C7CC433C1
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 486A361481
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 22:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhC1WXD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 18:23:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230450AbhC1WWx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 18:22:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B28761477;
        Sun, 28 Mar 2021 22:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616970172;
        bh=fmPGutm4OKKAyq4Fu62/mzVKDi1/nYt4NTa5qAs7oVU=;
        h=Date:From:To:Subject:From;
        b=P9+ToGgugVoAvj9Vi9m7Cdr6AZbd3Zi9qKS6+Cy27I4kt4kmtj7vDwmQqNxgBOMHT
         iv8G3PUS7tCchxXIH8hxkNpo8kyUzhZFkKG0ubizcclZUifE8t1hZZGhYmMr7yaUuE
         VE07/YCzGfWXM740ktIBdddkxY9yl0h9flSgw/aQ=
Date:   Sun, 28 Mar 2021 15:22:52 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, slyfox@gentoo.org
Subject:  + ia64-mca-always-make-ia64_mca_debug-an-expression.patch
 added to -mm tree
Message-ID: <20210328222252.lIBVjrT6s%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ia64: mca: always make IA64_MCA_DEBUG an expression
has been added to the -mm tree.  Its filename is
     ia64-mca-always-make-ia64_mca_debug-an-expression.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ia64-mca-always-make-ia64_mca_debug-an-expression.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ia64-mca-always-make-ia64_mca_debug-an-expression.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ia64-drop-unused-ia64_fw_emu-ifdef.patch
ia64-simplify-code-flow-around-swiotlb-init.patch
ia64-fix-efi_debug-build.patch
ia64-mca-always-make-ia64_mca_debug-an-expression.patch

