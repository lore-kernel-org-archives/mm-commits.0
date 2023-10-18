Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFEACDB47E
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:35:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbjJRVfq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231978AbjJRVfb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:35:31 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D071BE
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:35:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5F6C433B6;
        Wed, 18 Oct 2023 21:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664899;
        bh=//Hfy9IZBVCjxlafgoZSdGeF3hXQ1LWMXolrkRWxTgw=;
        h=Date:To:From:Subject:From;
        b=2O2bFnf4BbX8DykPPCogn+xssJPwNv5DeHdyHJp/pEHO8dcG1xw3c9or1SrxpVLKi
         Lj0y1p1Re9NGBmR76Fc1o2p3wG1+JRe7zDGvGMzZ4FX8/aagEmqVREnuKjPZvctMM0
         pWT+8DGvsLfhoaHR63t7zC3otD32lRDX09av1TYM=
Date:   Wed, 18 Oct 2023 14:34:58 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        christophe.jaillet@wanadoo.fr, Liam.Howlett@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] radix-tree-test-suite-fix-allocation-calculation-in-kmem_cache_alloc_bulk.patch removed from -mm tree
Message-Id: <20231018213459.1E5F6C433B6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: radix tree test suite: fix allocation calculation in kmem_cache_alloc_bulk()
has been removed from the -mm tree.  Its filename was
     radix-tree-test-suite-fix-allocation-calculation-in-kmem_cache_alloc_bulk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: radix tree test suite: fix allocation calculation in kmem_cache_alloc_bulk()
Date: Fri, 29 Sep 2023 16:13:59 -0400

The bulk allocation is iterating through an array and storing enough
memory for the entire bulk allocation instead of a single array entry. 
Only allocate an array element of the size set in the kmem_cache.

Link: https://lkml.kernel.org/r/20230929201359.2857583-1-Liam.Howlett@oracle.com
Fixes: cc86e0c2f306 ("radix tree test suite: add support for slab bulk APIs")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reported-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/radix-tree/linux.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/radix-tree/linux.c~radix-tree-test-suite-fix-allocation-calculation-in-kmem_cache_alloc_bulk
+++ a/tools/testing/radix-tree/linux.c
@@ -165,9 +165,9 @@ int kmem_cache_alloc_bulk(struct kmem_ca
 		for (i = 0; i < size; i++) {
 			if (cachep->align) {
 				posix_memalign(&p[i], cachep->align,
-					       cachep->size * size);
+					       cachep->size);
 			} else {
-				p[i] = malloc(cachep->size * size);
+				p[i] = malloc(cachep->size);
 			}
 			if (cachep->ctor)
 				cachep->ctor(p[i]);
_

Patches currently in -mm which might be from Liam.Howlett@oracle.com are


