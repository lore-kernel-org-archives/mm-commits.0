Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4895C433F5
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAB09610A0
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 22:00:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347951AbhIBWBW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:01:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347625AbhIBWBW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 18:01:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F31060E8B;
        Thu,  2 Sep 2021 22:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630620023;
        bh=530wtrbwbaDUSAfHQfUi395nW8RJ/urpWo/ZU01fSiU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eQjrZvo2zunSR217OeqQ1XyG/9Wtq+NfqLM6yL536m0zXbT8LrPYZPio/mnHxPjV1
         nvturbdQI+4Ga1KPT93ed1wMFE7vJca9xBFmSwVXiRuDml1InQ3LmGBcpxlJJdE7/B
         nAYlI9KxWbVkHTNFhxwSdeXNpoUc7ZVAqQmqLA9I=
Date:   Thu, 02 Sep 2021 15:00:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vvs@virtuozzo.com
Subject:  [patch 196/212] mm/mempolicy.c: use in_task() in
 mempolicy_slab_node()
Message-ID: <20210902220023.TyvJBPEbZ%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>
Subject: mm/mempolicy.c: use in_task() in mempolicy_slab_node()

Obsoleted in_intrrupt() include task context with disabled BH, it's better
to use in_task() instead.

Link: https://lkml.kernel.org/r/984ee771-4834-21da-801f-c15c18ddf4d1@virtuozzo.com
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mempolicy.c~mm-use-in_task-in-mempolicy_slab_node
+++ a/mm/mempolicy.c
@@ -1934,7 +1934,7 @@ unsigned int mempolicy_slab_node(void)
 	struct mempolicy *policy;
 	int node = numa_mem_id();
 
-	if (in_interrupt())
+	if (!in_task())
 		return node;
 
 	policy = current->mempolicy;
_
