Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D54FFC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B29A26147D
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:59:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhD3F74 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230045AbhD3F7z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:59:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E59C3613A9;
        Fri, 30 Apr 2021 05:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762348;
        bh=1CKbKM0R4kK3bXyDGvN1pK7hcVHzG+6Ji14Gb37yn9g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=V+p7+38reEfbhf/rTyETFeNLLiKRWxwb+Qp9j4+9vdou7EAavt0sNOI5mLY1asdPN
         /Y/mFqbHb+/vCT5NCB8hEIGqO/m2phGLiHXgRDrKa5UNJU+6M3ZXJQlNDbhySlRwv+
         5UQyiPCOI4k6O+Zk3EJ9fLR291l4dA8LbT4ESmzA=
Date:   Thu, 29 Apr 2021 22:59:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        urezki@gmail.com, vjitta@codeaurora.org
Subject:  [patch 115/178] mm: vmalloc: prevent use after free in
 _vm_unmap_aliases
Message-ID: <20210430055907.ycr60LTRb%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vijayanand Jitta <vjitta@codeaurora.org>
Subject: mm: vmalloc: prevent use after free in _vm_unmap_aliases

A potential use after free can occur in _vm_unmap_aliases where an already
freed vmap_area could be accessed, Consider the following scenario:

Process 1						Process 2

__vm_unmap_aliases					__vm_unmap_aliases
	purge_fragmented_blocks_allcpus				rcu_read_lock()
		rcu_read_lock()
			list_del_rcu(&vb->free_list)
									list_for_each_entry_rcu(vb .. )
	__purge_vmap_area_lazy
		kmem_cache_free(va)
										va_start = vb->va->va_start

Here Process 1 is in purge path and it does list_del_rcu on vmap_block and
later frees the vmap_area, since Process 2 was holding the rcu lock at
this time vmap_block will still be present in and Process 2 accesse it and
thereby it tries to access vmap_area of that vmap_block which was already
freed by Process 1 and this results in use after free.

Fix this by adding a check for vb->dirty before accessing vmap_area
structure since vb->dirty will be set to VMAP_BBMAP_BITS in purge path
checking for this will prevent the use after free.

Link: https://lkml.kernel.org/r/1616062105-23263-1-git-send-email-vjitta@codeaurora.org
Signed-off-by: Vijayanand Jitta <vjitta@codeaurora.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-prevent-use-after-free-in-_vm_unmap_aliases
+++ a/mm/vmalloc.c
@@ -2040,7 +2040,7 @@ static void _vm_unmap_aliases(unsigned l
 		rcu_read_lock();
 		list_for_each_entry_rcu(vb, &vbq->free, free_list) {
 			spin_lock(&vb->lock);
-			if (vb->dirty) {
+			if (vb->dirty && vb->dirty != VMAP_BBMAP_BITS) {
 				unsigned long va_start = vb->va->va_start;
 				unsigned long s, e;
 
_
