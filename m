Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52637C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CC7F61989
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbhKKCmj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:42:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233571AbhKKCmj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:42:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A98FA61872;
        Thu, 11 Nov 2021 02:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636598391;
        bh=VwWxsj9h1lP55YzCRgkdGIT1Ym1CGoInKGkbgQ3PZjA=;
        h=Date:From:To:Subject:From;
        b=DkQl5NE9bgloeYnEuFVC0Dhuh3Cs27f2lAXxHq1l+ruxM3+MJ4KLndvEC+h78U3Qh
         c0wajwcnNz1ruNeWM+UUmYDv57fVOWEUyD6UdSvM5Y0pyCzUd60A4O43fgnF7LWNZ7
         19zD3l+nCKJ2TzxV1sQzj/+6QL3R4G83qHohHj2I=
Date:   Wed, 10 Nov 2021 18:39:50 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, shakeelb@google.com,
        vbabka@suse.cz, wangkefeng.wang@huawei.com, willy@infradead.org
Subject:  [merged]
 slub-add-back-check-for-free-nonslab-objects.patch removed from -mm tree
Message-ID: <20211111023950.YoVSofll6%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub: add back check for free nonslab objects
has been removed from the -mm tree.  Its filename was
     slub-add-back-check-for-free-nonslab-objects.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: slub: add back check for free nonslab objects

After commit ("f227f0faf63b slub: fix unreclaimable slab stat for bulk
free"), the check for free nonslab page is replaced by VM_BUG_ON_PAGE,
which only check with CONFIG_DEBUG_VM enabled, but this config may impact
performance, so it only for debug.

Commit ("0937502af7c9 slub: Add check for kfree() of non slab objects.")
add the ability, which should be needed in any configs to catch the
invalid free, they even could be potential issue, eg, memory corruption,
use after free and double free, so replace VM_BUG_ON_PAGE to WARN_ON_ONCE,
add object address printing to help use to debug the issue.

Link: https://lkml.kernel.org/r/20210930070214.61499-1-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rienjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/slub.c~slub-add-back-check-for-free-nonslab-objects
+++ a/mm/slub.c
@@ -3522,7 +3522,9 @@ static inline void free_nonslab_page(str
 {
 	unsigned int order = compound_order(page);
 
-	VM_BUG_ON_PAGE(!PageCompound(page), page);
+	if (WARN_ON_ONCE(!PageCompound(page)))
+		pr_warn_once("object pointer: 0x%p\n", object);
+
 	kfree_hook(object);
 	mod_lruvec_page_state(page, NR_SLAB_UNRECLAIMABLE_B, -(PAGE_SIZE << order));
 	__free_pages(page, order);
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


