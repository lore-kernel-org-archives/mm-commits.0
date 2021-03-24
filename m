Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F2EC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:35:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A88E161A1D
	for <mm-commits@archiver.kernel.org>; Wed, 24 Mar 2021 22:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235442AbhCXWep (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Mar 2021 18:34:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235419AbhCXWee (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Mar 2021 18:34:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94D83619E4;
        Wed, 24 Mar 2021 22:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616625273;
        bh=UwmTtjwd3cIrNxDkleof9FhjW8Ea7Q6wJSXuhG1Pt7w=;
        h=Date:From:To:Subject:From;
        b=YEfJwP9qtv8g3ODeRIgBRWyi2LeGrsdItY+DKJcOGmwMt3UH8unWwf5vSj5fWi6N4
         fXfbV/Fgu3MyG5FTklbp0626nSH+uYgtfNnwMBPT1erc2OA64/O98HBv5V4ymcQMjy
         neKtziphmB9Lkjpm1Swd36YUEiruYirAa97cg64s=
Date:   Wed, 24 Mar 2021 15:34:33 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, urezki@gmail.com, vjitta@codeaurora.org
Subject:  +
 mm-vmalloc-prevent-use-after-free-in-_vm_unmap_aliases.patch added to -mm
 tree
Message-ID: <20210324223433.ZQn6K%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmalloc: prevent use after free in _vm_unmap_aliases
has been added to the -mm tree.  Its filename is
     mm-vmalloc-prevent-use-after-free-in-_vm_unmap_aliases.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-prevent-use-after-free-in-_vm_unmap_aliases.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-prevent-use-after-free-in-_vm_unmap_aliases.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -2039,7 +2039,7 @@ static void _vm_unmap_aliases(unsigned l
 		rcu_read_lock();
 		list_for_each_entry_rcu(vb, &vbq->free, free_list) {
 			spin_lock(&vb->lock);
-			if (vb->dirty) {
+			if (vb->dirty && vb->dirty != VMAP_BBMAP_BITS) {
 				unsigned long va_start = vb->va->va_start;
 				unsigned long s, e;
 
_

Patches currently in -mm which might be from vjitta@codeaurora.org are

mm-vmalloc-prevent-use-after-free-in-_vm_unmap_aliases.patch

