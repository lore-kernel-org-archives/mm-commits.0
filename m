Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 587B8C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34E49221E2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266218;
	bh=/VmxAqjhnkIBnQ5LXDJJTcLYsaKjizZMMgK1JO37A6I=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=WoVj/K5oI49pzVQWixvvcGaLtUd0/ZlBOaY/Hl00OPg1Nr64qx9DOucEmME+VnfBk
	 DyBGftOweEZIJagEUiKFvHL7p0GXfdtkdwjyOmK/j5NWDmCnh4RZ7RGgAC3DEarard
	 dRoqvQEwzanfZlSvJGswGItJqg3riO+YsnWuEcmo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgHLVDi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:03:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726673AbgHLVDh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:03:37 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58C4420B1F;
        Wed, 12 Aug 2020 21:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266217;
        bh=/VmxAqjhnkIBnQ5LXDJJTcLYsaKjizZMMgK1JO37A6I=;
        h=Date:From:To:Subject:From;
        b=DCOF/0B+9NLxezxzY7VU3epRGXuV3tHxxNp4QI2LarJNqYIgLxvjHH5TDDhqn3nWt
         IYpKclfi1BNa44qMvY+BlUKswE0HJaPckPLGysWYOUkrrLnRWhh9fzEtXgu9gqY9H7
         omCGvaySglbcx50ONXbpyQJscEuqt2D4r/7fLDWg=
Date:   Wed, 12 Aug 2020 14:03:37 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        mm-commits@vger.kernel.org, rdunlap@infradead.org
Subject:  [merged]
 linux-async_txh-drop-duplicated-word-in-a-comment.patch removed from -mm
 tree
Message-ID: <20200812210337.tsubey047%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/async_tx.h: drop duplicated word in a comment
has been removed from the -mm tree.  Its filename was
     linux-async_txh-drop-duplicated-word-in-a-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from rdunlap@infradead.org are


