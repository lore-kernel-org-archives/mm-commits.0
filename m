Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5437CC11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E85B61D0E
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhF2Cnd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:43:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhF2Cnc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:43:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E1CA611AE;
        Tue, 29 Jun 2021 02:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934465;
        bh=wQF4Gd8LirYuiq8hMDU+Ju6a7uHFRr/e6WOsNWYtmYU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=wdZtWufHMuNBEIgmLWzDNuyia6s+cbCnC5E/dC/nurNH6+4QD8/schpwwiNx/EQ29
         NCyZe9n4pj8SZEEfgWFowMOHXV86q3oAJWnVM+i3ZfBGwSkPwYrcOVgUiC8EO8HqLf
         uaQZYXj2LQNIN4OdueBk6b0P5wAD+umTLh3OdCco=
Date:   Mon, 28 Jun 2021 19:41:04 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        corbet@lwn.net, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, torvalds@linux-foundation.org,
        willy@infradead.org
Subject:  [patch 149/192] mm/mmzone.h: simplify is_highmem_idx()
Message-ID: <20210629024104.-mPKFGjjc%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: mm/mmzone.h: simplify is_highmem_idx()

There is a lot of historical ifdefery in is_highmem_idx() and its helper
zone_movable_is_highmem() that was required because of two different paths
for nodes and zones initialization that were selected at compile time.

Until commit 3f08a302f533 ("mm: remove CONFIG_HAVE_MEMBLOCK_NODE_MAP
option") the movable_zone variable was only available for configurations
that had CONFIG_HAVE_MEMBLOCK_NODE_MAP enabled so the test in
zone_movable_is_highmem() used that variable only for such configurations.
For other configurations the test checked if the index of ZONE_MOVABLE
was greater by 1 than the index of ZONE_HIGMEM and then movable zone was
considered a highmem zone.  Needless to say, ZONE_MOVABLE - 1 equals
ZONE_HIGHMEM by definition when CONFIG_HIGHMEM=y.

Commit 3f08a302f533 ("mm: remove CONFIG_HAVE_MEMBLOCK_NODE_MAP option")
made movable_zone variable always available.  Since this variable is set
to ZONE_HIGHMEM if CONFIG_HIGHMEM is enabled and highmem zone is
populated, it is enough to check whether

	zone_idx == ZONE_MOVABLE && movable_zone == ZONE_HIGMEM

to test if zone index points to a highmem zone.

Remove zone_movable_is_highmem() that is not used anywhere except
is_highmem_idx() and use the test above in is_highmem_idx() instead.

Link: https://lkml.kernel.org/r/20210426141927.1314326-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/include/linux/mmzone.h~mm-mmzoneh-simplify-is_highmem_idx
+++ a/include/linux/mmzone.h
@@ -982,22 +982,11 @@ static inline void zone_set_nid(struct z
 
 extern int movable_zone;
 
-#ifdef CONFIG_HIGHMEM
-static inline int zone_movable_is_highmem(void)
-{
-#ifdef CONFIG_NEED_MULTIPLE_NODES
-	return movable_zone == ZONE_HIGHMEM;
-#else
-	return (ZONE_MOVABLE - 1) == ZONE_HIGHMEM;
-#endif
-}
-#endif
-
 static inline int is_highmem_idx(enum zone_type idx)
 {
 #ifdef CONFIG_HIGHMEM
 	return (idx == ZONE_HIGHMEM ||
-		(idx == ZONE_MOVABLE && zone_movable_is_highmem()));
+		(idx == ZONE_MOVABLE && movable_zone == ZONE_HIGHMEM));
 #else
 	return 0;
 #endif
_
