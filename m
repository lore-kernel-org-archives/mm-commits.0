Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 335C9C43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBACF22259
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602708994;
	bh=Lyop6uXWVs/k+OHSa3DNHTuAxW4KIhhR9rll0KocSB4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Qef6dbs0cbsoNW0mPkk3lMgGK+9wiUsFHQvy9ps92QTxr0D8GZcCISAd/ndF2zNT+
	 9+8e+xNwz+seI4h6YH56uxJHXbNVfVfB1TuEyfK/2eoXV1XHIzCMp5gu1/kknPAe0t
	 P8WpCSEOuSGB6SH2C3jiAr/0Gj/ZhV15hdUkeQu0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389386AbgJNU4e (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:56:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgJNU4b (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:56:31 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE3A522254;
        Wed, 14 Oct 2020 20:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602708989;
        bh=Lyop6uXWVs/k+OHSa3DNHTuAxW4KIhhR9rll0KocSB4=;
        h=Date:From:To:Subject:From;
        b=2pafBSLswQJzvbR2ICTVAnELKmIMy5Pchy6j9oE+eMo3tjJRKckqrgr200f7pl7Ez
         arWgPpVogEu7fY78TxHGkkWn61gSJKZcLFmShuvTTItm0XFOGYyliINlGLRVQdOxjK
         SyP+agR4jqrRgJ1b0PpyDThtFpAsCOd1Qkl801+M=
Date:   Wed, 14 Oct 2020 13:56:28 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, liu.xiang6@zte.com.cn,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, wuyun.wu@huawei.com
Subject:  [merged]
 mm-slub-make-add_full-condition-more-explicit.patch removed from -mm tree
Message-ID: <20201014205628.zlyR2odtu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: make add_full() condition more explicit
has been removed from the -mm tree.  Its filename was
     mm-slub-make-add_full-condition-more-explicit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2245,7 +2245,8 @@ redo:
 		}
 	} else {
 		m = M_FULL;
-		if (kmem_cache_debug(s) && !lock) {
+#ifdef CONFIG_SLUB_DEBUG
+		if ((s->flags & SLAB_STORE_USER) && !lock) {
 			lock = 1;
 			/*
 			 * This also ensures that the scanning of full
@@ -2254,6 +2255,7 @@ redo:
 			 */
 			spin_lock(&n->list_lock);
 		}
+#endif
 	}
 
 	if (l != m) {
_

Patches currently in -mm which might be from wuyun.wu@huawei.com are


