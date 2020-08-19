Return-Path: <SRS0=1kGn=B5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D33C433E1
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6A4020882
	for <mm-commits@archiver.kernel.org>; Wed, 19 Aug 2020 19:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597865845;
	bh=aS3s4hrzBb5AFFojxkB5/SHmncJZd9phnk4kjdkZFT4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=PP8vpEg4CEPh6NysTL6n43ynQ+2xzHultwlDzZwhV79xNUIe48rvhlqxp/29kTuT0
	 qyhZKy7/WFVdzr1WcZAufoYgRfpSPDA6eKVoop9aFSB6jItdeM4bAw9UYhVTT7CXcJ
	 RHCLX00Kh26z4HRQ5dMiW2oZQGsVeBNLa6drA9GA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgHSThZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 19 Aug 2020 15:37:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:48070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725997AbgHSThX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Aug 2020 15:37:23 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F835207BB;
        Wed, 19 Aug 2020 19:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597865843;
        bh=aS3s4hrzBb5AFFojxkB5/SHmncJZd9phnk4kjdkZFT4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=0B8gSZMSS0ik3t2+y4lEenZiLA4+z+7Dwt2uJzwvwF/djE0MKTj9JXGd4/cNdOC47
         T+EUvWx98sa147NWhnidFc6sx+OiFKHFeJ8XNF4czvY1m86RoUyv9G7ZJ6mGEmcC3P
         hedA34dgBmKttsYZQ8NpvMMlpPkAtLiUWj0MQJOk=
Date:   Wed, 19 Aug 2020 12:37:22 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     cl@linux.com, iamjoonsoo.kim@lge.com, liu.xiang6@zte.com.cn,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, wuyun.wu@huawei.com
Subject:  + mm-slub-make-add_full-condition-more-explicit.patch
 added to -mm tree
Message-ID: <20200819193722.x8Rf_X2Xb%akpm@linux-foundation.org>
In-Reply-To: <20200814172939.55d6d80b6e21e4241f1ee1f3@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: make add_full() condition more explicit
has been added to the -mm tree.  Its filename is
     mm-slub-make-add_full-condition-more-explicit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-make-add_full-condition-more-explicit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-make-add_full-condition-more-explicit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Abel Wu <wuyun.wu@huawei.com>
Subject: mm/slub: make add_full() condition more explicit

The commit below is incomplete, as it didn't handle the add_full() part. 
commit a4d3f8916c65 ("slub: remove useless kmem_cache_debug() before
remove_full()")

This patch checks for SLAB_STORE_USER instead of kmem_cache_debug(), since
that should be the only context in which we need the list_lock for
add_full().

Link: https://lkml.kernel.org/r/20200811020240.1231-1-wuyun.wu@huawei.com
Signed-off-by: Abel Wu <wuyun.wu@huawei.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Liu Xiang <liu.xiang6@zte.com.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-make-add_full-condition-more-explicit
+++ a/mm/slub.c
@@ -2250,7 +2250,8 @@ redo:
 		}
 	} else {
 		m = M_FULL;
-		if (kmem_cache_debug(s) && !lock) {
+#ifdef CONFIG_SLUB_DEBUG
+		if ((s->flags & SLAB_STORE_USER) && !lock) {
 			lock = 1;
 			/*
 			 * This also ensures that the scanning of full
@@ -2259,6 +2260,7 @@ redo:
 			 */
 			spin_lock(&n->list_lock);
 		}
+#endif
 	}
 
 	if (l != m) {
_

Patches currently in -mm which might be from wuyun.wu@huawei.com are

mm-slub-branch-optimization-in-free-slowpath.patch
mm-slub-fix-missing-alloc_slowpath-stat-when-bulk-alloc.patch
mm-slub-make-add_full-condition-more-explicit.patch

