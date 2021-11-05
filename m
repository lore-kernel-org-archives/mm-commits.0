Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAEDAC4332F
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C89AA6127B
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232129AbhKEUhz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232002AbhKEUhy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:37:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CEDF61252;
        Fri,  5 Nov 2021 20:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144514;
        bh=zOIB/S9H+ITionS7Amebd4LYXa7vQtVFbpQay9Vx7tk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lRbualA7B2zEAnD1pjQySBJD15PL+I/enRD46ryjWe/P+FFg4zRwtjsjEoBu18No5
         +OeyWFAXqOtr4DITg9ztkZxsCB/ue8Rco4TIMvV3YNjtAIqui7Fh/chHAtoq+9zSAB
         t/OA6qWrEdt0MDroIo6ZFOZlMyYJvFJOwsQcMZc8=
Date:   Fri, 05 Nov 2021 13:35:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, shakeelb@google.com,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        wangkefeng.wang@huawei.com, willy@infradead.org
Subject:  [patch 013/262] slub: add back check for free nonslab
 objects
Message-ID: <20211105203514.l8x6qswFB%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
