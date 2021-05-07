Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C07C433B4
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA77C613C5
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbhEGBF4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:05:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230384AbhEGBF4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:05:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B12E610FA;
        Fri,  7 May 2021 01:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349497;
        bh=svQBwBACLtUvO35TNf1+dAi5TDq7x9dlAAkf8ZKJ5+k=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tSLXF1qpjeV3XJptgB2kd4nmavJECsDNSWDMWTds4NyGRBjA/AsUxCgGDai2hWyrO
         vNkKgaZ0Hk+eeMWUlXQg77KY9ghUum99Zr7ZEESTRiMv669tYjl1VTkssKB+J9FxFu
         6goE6dW+EbKBCj62OqflPhyObrqpO07IkVpcEUkc=
Date:   Thu, 06 May 2021 18:04:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, heying24@huawei.com, hulkci@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 56/91] smp: kernel/panic.c - silence warnings
Message-ID: <20210507010457.h2agUId-5%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
