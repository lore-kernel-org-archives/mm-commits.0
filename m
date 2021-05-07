Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79E46C43462
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F80461289
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhEGBHe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:07:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234202AbhEGBHd (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:07:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE917613C2;
        Fri,  7 May 2021 01:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349593;
        bh=V0cwt2yqsFipOyFxNddOZcovg3FD46wbK7RmKDC1ipU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=diImyzSnIb8hrah8OUigl1c/aNyLxScupVWc0ko3Uf7Id+nR+dnQus0C3Xhw99A9p
         Z+zBJs6aDsqzfVSat7IayaaVwn273si5OT5VwWM5Zc0zvGI9rRYBmgnUF33ifeEBZM
         M2ImTl4CmzuxptONMUclJfOqIgp5XehT3wiK8K1E=
Date:   Thu, 06 May 2021 18:06:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        unixbhaskar@gmail.com
Subject:  [patch 85/91] kernel/up.c: fix typo
Message-ID: <20210507010633.pyIofrwg-%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: kernel/up.c: fix typo

s/condtions/conditions/

Link: https://lkml.kernel.org/r/20210317032732.3260835-1-unixbhaskar@gmail.com
Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/up.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/up.c~kernel-fix-a-typo-in-the-file-upc
+++ a/kernel/up.c
@@ -38,7 +38,7 @@ EXPORT_SYMBOL(smp_call_function_single_a
 
 /*
  * Preemption is disabled here to make sure the cond_func is called under the
- * same condtions in UP and SMP.
+ * same conditions in UP and SMP.
  */
 void on_each_cpu_cond_mask(smp_cond_func_t cond_func, smp_call_func_t func,
 			   void *info, bool wait, const struct cpumask *mask)
_
