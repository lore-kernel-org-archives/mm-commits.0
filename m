Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B84E2C433DB
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 17:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81CFF6197D
	for <mm-commits@archiver.kernel.org>; Fri, 19 Mar 2021 17:46:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbhCSRpm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 19 Mar 2021 13:45:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhCSRpR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 19 Mar 2021 13:45:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB7436197F;
        Fri, 19 Mar 2021 17:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616175916;
        bh=jzlg4bF+vE9zwlFEueEzCaNKnaFL/UZWB3pYK7i0MuQ=;
        h=Date:From:To:Subject:From;
        b=E53wB3A+AuEcTWKMK+Ico8p1ach1vK99ptWIqJpGVjbnAG+3d4mq0lGhd5DbKSq/E
         PMaZck8xoK16mu2ALHpslk6ConKAlp6Cet1BPrAvE01ncE+7WY1+YqlZhH+dPw/dvm
         hqJ+B49AuWLt2//pgXgMFHEpI9oAGOBDOQ4K+yi8=
Date:   Fri, 19 Mar 2021 10:45:16 -0700
From:   akpm@linux-foundation.org
To:     heying24@huawei.com, hulkci@huawei.com, mm-commits@vger.kernel.org
Subject:  + smp-kernel-panicc-silence-warnings.patch added to -mm
 tree
Message-ID: <20210319174516.BbNe9oy2N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: smp: kernel/panic.c - silence warnings
has been added to the -mm tree.  Its filename is
     smp-kernel-panicc-silence-warnings.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/smp-kernel-panicc-silence-warnings.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/smp-kernel-panicc-silence-warnings.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: He Ying <heying24@huawei.com>
Subject: smp: kernel/panic.c - silence warnings

We found these warnings in kernel/panic.c by using sparse tool:
warning: symbol 'panic_smp_self_stop' was not declared.
warning: symbol 'nmi_panic_self_stop' was not declared.
warning: symbol 'crash_smp_send_stop' was not declared.

To avoid them, add declarations for these three functions in
include/linux/smp.h.

Link: https://lkml.kernel.org/r/20210316084150.75201-1-heying24@huawei.com
Signed-off-by: He Ying <heying24@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/smp.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/smp.h~smp-kernel-panicc-silence-warnings
+++ a/include/linux/smp.h
@@ -51,6 +51,14 @@ int smp_call_function_single(int cpuid,
 			     int wait);
 
 /*
+ * Cpus stopping functions in panic. All have default weak definitions.
+ * Architecture-dependent code may override them.
+ */
+void panic_smp_self_stop(void);
+void nmi_panic_self_stop(struct pt_regs *regs);
+void crash_smp_send_stop(void);
+
+/*
  * Call a function on all processors
  */
 void on_each_cpu(smp_call_func_t func, void *info, int wait);
_

Patches currently in -mm which might be from heying24@huawei.com are

smp-kernel-panicc-silence-warnings.patch

