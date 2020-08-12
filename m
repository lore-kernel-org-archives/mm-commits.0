Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFC3C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 685BA2076C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195879;
	bh=bx5FthwCPKERZJ6yRP7PlMq2b1WJ53vWktjFq+KwScE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=eKJLCstRNEQoKu1Jpdc3MmF0+CXsaqKNbppq/8G00F62zTx7XYnEJ/ixL5/j86JBG
	 eWd1TNuCwab1nemywaDUQSnpPnKPzGcY284KEMdD6qjo17hD36qsjfN0YL61YGbKdZ
	 20RaR1U/P8aewHFnGdpHmDtZ1GD3PvV5bPccCuvM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgHLBbT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726235AbgHLBbS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:31:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 051AB2076C;
        Wed, 12 Aug 2020 01:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195877;
        bh=bx5FthwCPKERZJ6yRP7PlMq2b1WJ53vWktjFq+KwScE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bgK0/RUKHO0FJ4Q5iKSCgczSjt0aTKARBMqL7Q141Lydw5zJiRdHUUeIDz6l4aK1w
         5M6rTW13zwuKg+Fe9obzO39JgRzVQmDstPUH83i+MmdfoxWuOLIcJtGAlvQo34GRj3
         lHp+qZKJLkvvX4WeMkoRbU7zJGjkTP5Ett599c1o=
Date:   Tue, 11 Aug 2020 18:31:16 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, haowenchao22@gmail.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 019/165] mm/mempolicy.c: check parameters first in
 kernel_get_mempolicy
Message-ID: <20200812013116.Bl2q7CRRo%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wenchao Hao <haowenchao22@gmail.com>
Subject: mm/mempolicy.c: check parameters first in kernel_get_mempolicy

Previous implementatoin calls untagged_addr() before error check, while if
the error check failed and return EINVAL, the untagged_addr() call is just
useless work.

Link: http://lkml.kernel.org/r/20200801090825.5597-1-haowenchao22@gmail.com
Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-check-parameters-first-in-kernel_get_mempolicy
+++ a/mm/mempolicy.c
@@ -1632,11 +1632,11 @@ static int kernel_get_mempolicy(int __us
 	int pval;
 	nodemask_t nodes;
 
-	addr = untagged_addr(addr);
-
 	if (nmask != NULL && maxnode < nr_node_ids)
 		return -EINVAL;
 
+	addr = untagged_addr(addr);
+
 	err = do_get_mempolicy(&pval, &nodes, addr, flags);
 
 	if (err)
_
