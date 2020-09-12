Return-Path: <SRS0=X2ny=CV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2ABEC43461
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AAD4420732
	for <mm-commits@archiver.kernel.org>; Sat, 12 Sep 2020 16:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599927934;
	bh=wGj2L1Pn3fuCZGdyFB5YGS6R7wDUw5E9f6UFsLL8QX4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=gXgSvRynNiqTuNva9Td2T5/+MhO39AIe7gNrjbpkBx9fW5W4IDMwKlLP6QlWpqkf+
	 HnGHq0D3QxpVEYM+z7YJQDCg5FM/PMB8eV96VV01/3OvKWiJR2giz6lHg5WfrX7HJP
	 LRAxC6qDXjZ9WacjoPJe/VzRCeIZRJL1zWkDls5o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbgILQZP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 12 Sep 2020 12:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgILQYO (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 12 Sep 2020 12:24:14 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CF5121D7E;
        Sat, 12 Sep 2020 16:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599927854;
        bh=wGj2L1Pn3fuCZGdyFB5YGS6R7wDUw5E9f6UFsLL8QX4=;
        h=Date:From:To:Subject:From;
        b=xpF+RWF7YFp0tU3JY9SjqZsLtVi2KxYoFdpeKxJFw0FkqNPX67UhiCqf7+pSRT1oF
         povVUE8Pug4owgTqd0wv/ro7zlhMSEojp8NINzumjV4KekYvmHmFqK8NyQDbrs7V/1
         eVbpNj2lABzuBjP37f0ZEB27U6fZpol9BZf9ODJU=
Date:   Sat, 12 Sep 2020 09:24:14 -0700
From:   akpm@linux-foundation.org
To:     jgg@nvidia.com, mm-commits@vger.kernel.org
Subject:  [merged]
 log2-add-missing-around-n-in-roundup_pow_of_two.patch removed from -mm tree
Message-ID: <20200912162414.3-RHwL3jE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/log2.h: add missing () around n in roundup_pow_of_two()
has been removed from the -mm tree.  Its filename was
     log2-add-missing-around-n-in-roundup_pow_of_two.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: include/linux/log2.h: add missing () around n in roundup_pow_of_two()

Otherwise gcc generates warnings if the expression is complicated.

Link: https://lkml.kernel.org/r/0-v1-8a2697e3c003+41165-log_brackets_jgg@nvidia.com
Fixes: 312a0c170945 ("[PATCH] LOG2: Alter roundup_pow_of_two() so that it can use a ilog2() on a constant")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/log2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/log2.h~log2-add-missing-around-n-in-roundup_pow_of_two
+++ a/include/linux/log2.h
@@ -173,7 +173,7 @@ unsigned long __rounddown_pow_of_two(uns
 #define roundup_pow_of_two(n)			\
 (						\
 	__builtin_constant_p(n) ? (		\
-		(n == 1) ? 1 :			\
+		((n) == 1) ? 1 :		\
 		(1UL << (ilog2((n) - 1) + 1))	\
 				   ) :		\
 	__roundup_pow_of_two(n)			\
_

Patches currently in -mm which might be from jgg@nvidia.com are


