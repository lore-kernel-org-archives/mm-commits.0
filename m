Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AAA3C433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 437B2206B2
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597196010;
	bh=dsiebx/prgDTc1RX/im1Jbj6dIu70Cme19t3r3p9nKs=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=ZeOzUtwz1JMsJLp/23+sbVTBqlQJ5do8LnTCCc4vD0mXt3xDoHnZ8YEei+bjY0kud
	 /ALFizrxthftlb1xrwCNOoIX87tsuoV2P5q/q6XMC7zoPCE2w10BkgoqYZnR9xFqu/
	 mCUx/y1eIqrqMXwSynBjlQVIA9D2aVIrxPmbiyVk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgHLBda (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:33:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726630AbgHLBd3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:33:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A1F82076C;
        Wed, 12 Aug 2020 01:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597196009;
        bh=dsiebx/prgDTc1RX/im1Jbj6dIu70Cme19t3r3p9nKs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Sc/As5ZkReqWFzL3CE6Df+Lrfxt1MJEJTijo7zy/5I5Qnb3aUWah5St4gAgUJ92bx
         OTn/Ufz63+vKVHLJ1idrwrlN+VYj5zmaoNRepUhK1f8TqUJZSVQH9mk4KfSt+Jgw/Y
         J9tN82hb0IGjFAXmSaXOc8E0maq8mSQYLBN7tkoE=
Date:   Tue, 11 Aug 2020 18:33:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, rdunlap@infradead.org,
        torvalds@linux-foundation.org, ziy@nvidia.com
Subject:  [patch 061/165] mm/zpool.c: delete duplicated word and
 fix grammar
Message-ID: <20200812013328.Ao7kId7a5%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/zpool.c: delete duplicated word and fix grammar

Drop the repeated word "if".
Fix subject/verb agreement.

Link: http://lkml.kernel.org/r/20200801173822.14973-15-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpool.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/zpool.c~mm-zpoolc-delete-duplicated-word-and-fix-grammar
+++ a/mm/zpool.c
@@ -239,15 +239,15 @@ const char *zpool_get_type(struct zpool
 }
 
 /**
- * zpool_malloc_support_movable() - Check if the zpool support
- * allocate movable memory
+ * zpool_malloc_support_movable() - Check if the zpool supports
+ *	allocating movable memory
  * @zpool:	The zpool to check
  *
- * This returns if the zpool support allocate movable memory.
+ * This returns if the zpool supports allocating movable memory.
  *
  * Implementations must guarantee this to be thread-safe.
  *
- * Returns: true if if the zpool support allocate movable memory, false if not
+ * Returns: true if the zpool supports allocating movable memory, false if not
  */
 bool zpool_malloc_support_movable(struct zpool *zpool)
 {
_
