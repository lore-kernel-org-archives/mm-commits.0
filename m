Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC910C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A45A820829
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196045;
	bh=lfcP3+GRktn0yTNm+oU1Q7TC2aE5SJKYH51dcjrZwVM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=GxLrW1uLz5/rl77p+ypl0f+7cvsmiPIf8rW5CWFLVJoCStgFVv8A6lCFkz3MPmHIQ
	 kgD8NSQ/Js5CC518nbWOKYFNjEvA7ali4Lq4Glxxe/Aq/sccrY62YmKXYU3ran7cqf
	 7adFePq5UNo1ozVgVcv5vvAwHuVGyxXRh5kh9PqM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHLBeF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:34:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:34840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgHLBeF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:34:05 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA6F3214F1;
        Wed, 12 Aug 2020 01:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196044;
        bh=lfcP3+GRktn0yTNm+oU1Q7TC2aE5SJKYH51dcjrZwVM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=egFLhTT1LEMyOrW02/PN8ubYcbCImzJNUCnrpLtaKFAxbf7MZ1W/HLcLIrevIGtQ4
         yvUHQVEH6fULO7JMFBAWXlnOrM07LMkHKe/ggPzsWfuelYCYKOhHog768M03viHZPd
         BreFWDII7eWPY4rqvtprG2U18gF6bPvsEYMSqUwM=
Date:   Tue, 11 Aug 2020 18:34:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rdunlap@infradead.org, torvalds@linux-foundation.org
Subject:  [patch 072/165] include/linux/async_tx.h: drop duplicated
 word in a comment
Message-ID: <20200812013404.14KpSj7sO%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: include/linux/async_tx.h: drop duplicated word in a comment

Drop the doubled word "the" in a comment.

Link: http://lkml.kernel.org/r/e85802f7-8f48-8b4c-29b3-ea237a2c7ae9@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/async_tx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/async_tx.h~linux-async_txh-drop-duplicated-word-in-a-comment
+++ a/include/linux/async_tx.h
@@ -36,7 +36,7 @@ struct dma_chan_ref {
 /**
  * async_tx_flags - modifiers for the async_* calls
  * @ASYNC_TX_XOR_ZERO_DST: this flag must be used for xor operations where the
- * the destination address is not a source.  The asynchronous case handles this
+ * destination address is not a source.  The asynchronous case handles this
  * implicitly, the synchronous case needs to zero the destination block.
  * @ASYNC_TX_XOR_DROP_DST: this flag must be used if the destination address is
  * also one of the source addresses.  In the synchronous case the destination
_
