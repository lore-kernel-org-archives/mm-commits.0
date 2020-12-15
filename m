Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79531C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 480F32256F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbgLODLF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:11:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727770AbgLODLB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:11:01 -0500
Date:   Mon, 14 Dec 2020 19:08:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001737;
        bh=os6GMpGCseIJnLPeK/nDTnOSGQxeV0Rx9APFradvn6o=;
        h=From:To:Subject:In-Reply-To:From;
        b=e/jsO87bWva9pfCPf7kmNUsgTSh6+9wFcRpduAWh0+kh6c0WGYhA0c+BQfxK+UJya
         W2G2/m7BcnTl2MJS7VFX8eWv6vnGaJ221v2w0Z0rVq0vBAzx6JHQIo8xgcjf6jnZtY
         gMxAeI0ZcGAGz5sQngMIHupLUHccj0JFgpf9Vjk0=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 097/200] mm/vmalloc.c: remove unnecessary return
 statement
Message-ID: <20201215030856.z4RK5xn-3%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm/vmalloc.c: remove unnecessary return statement

Remove unnecessary return statement for void function.

Link: https://lkml.kernel.org/r/ca23f89259c80c3562700ae6e227b2815a195853.1606891153.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-unnecessary-return-statement
+++ a/mm/vmalloc.c
@@ -2291,7 +2291,6 @@ static void __vunmap(const void *addr, i
 	}
 
 	kfree(area);
-	return;
 }
 
 static inline void __vfree_deferred(const void *addr)
_
