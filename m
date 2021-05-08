Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3548C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90BA561402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:53:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbhEHWyx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229690AbhEHWyw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:54:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 950C060E0B;
        Sat,  8 May 2021 22:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514430;
        bh=BMLlA6rjsfrew/dnp+wPepEdhVtiMHXG5uyGYVTZ1PU=;
        h=Date:From:To:Subject:From;
        b=bVmIkjZV5vOpEKpH1NFGHzVQgSR0MuhCpna1qb83wjXSbmsIsa4xPfsl0B/EFxZ5n
         QfPgITz+J0ZRwM8mYeWuIe82YwU2KIxeH5xik7SjTfxRh+erocbTqAG86i/Wq6CH8W
         K9u2PIThd0Ys5gVQQGHCjiFNlbZpLGbgzr5fPj+w=
Date:   Sat, 08 May 2021 15:53:50 -0700
From:   akpm@linux-foundation.org
To:     heying24@huawei.com, hulkci@huawei.com, mm-commits@vger.kernel.org
Subject:  [merged] smp-kernel-panicc-silence-warnings.patch removed
 from -mm tree
Message-ID: <20210508225350.Zhv5vPvdJ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: smp: kernel/panic.c - silence warnings
has been removed from the -mm tree.  Its filename was
     smp-kernel-panicc-silence-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -56,6 +56,14 @@ void on_each_cpu_cond_mask(smp_cond_func
 int smp_call_function_single_async(int cpu, call_single_data_t *csd);
 
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
 static inline void on_each_cpu(smp_call_func_t func, void *info, int wait)
_

Patches currently in -mm which might be from heying24@huawei.com are


