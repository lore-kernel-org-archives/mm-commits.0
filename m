Return-Path: <SRS0=2RlJ=CN=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A774C433E2
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 611B32084D
	for <mm-commits@archiver.kernel.org>; Fri,  4 Sep 2020 23:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599262581;
	bh=9T7F3+ZA9+rwxl23x0cEp45CnkCE1T/D6iaqdGZC4Do=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=w0XUX9bD3Lk45nB/wr2oW0cOygAS+AnkGf3IOBUDOngCE5BSEB8lHZ+1qByB8W+pl
	 G33GObkY6sp/+JkJMA6rJNy1GBffS4V8acfR4M8ZmXBX71xjzyF+5EycBDgNvjVGik
	 ARBywOOTTzpex6xOIePSY5SYk/RbFGaZv/J7MWww=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgIDXgV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 4 Sep 2020 19:36:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:39394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726456AbgIDXgU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 4 Sep 2020 19:36:20 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A55C2078E;
        Fri,  4 Sep 2020 23:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599262579;
        bh=9T7F3+ZA9+rwxl23x0cEp45CnkCE1T/D6iaqdGZC4Do=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=uAqRgdLMxAWDtQDcR7Zjq/HHdzrmgDOdy2Dlq3wmKVPOQa6y6byzcoBxxlydqF6/L
         dKGNlpu+TypyAApuj29HSdk+TbluhzKcv+2vhU+NIsurq3sdNCN6X6TVGELfQLcWbe
         XbORkllEyTUN9p0/ZJWSnwQsSa+5HJouKfT6oGyI=
Date:   Fri, 04 Sep 2020 16:36:19 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jgg@nvidia.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 19/19] include/linux/log2.h: add missing () around
 n in roundup_pow_of_two()
Message-ID: <20200904233619.zbFSnj4Eh%akpm@linux-foundation.org>
In-Reply-To: <20200904163454.4db0e6ce0c4584d2653678a3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
