Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08740C43334
	for <mm-commits@archiver.kernel.org>; Wed,  8 Jun 2022 01:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236964AbiFHBK5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Jun 2022 21:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585390AbiFGXti (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2022 19:49:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638DC2789BD
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 15:32:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D823615C8
        for <mm-commits@vger.kernel.org>; Tue,  7 Jun 2022 22:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3386C3411E;
        Tue,  7 Jun 2022 22:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654641140;
        bh=6iQSvX8rb/TMLWccPqBMpHtT6Hv5F5HfIhX+ADLr+q0=;
        h=Date:To:From:Subject:From;
        b=PcslqlloGby4DqKNDyn1W/gfHTNoNV69lHQCp2ljIrlyTmiLmRvXP8ZY+u+qCAkCf
         wMwGvBQGUHKJOmSSjNOuUiFXsxF+B1DnYdp3PVXyhJEgQ31MoKDa3qV/NLu/g9PvNy
         3IWVYu7cs9oBVsKzL9iC5XR3CAnV5RtRAAeEniQo=
Date:   Tue, 07 Jun 2022 15:32:19 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, hch@infradead.org,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-add-code-comment-for-find_vmap_area_exceed_addr.patch added to mm-unstable branch
Message-Id: <20220607223219.F3386C3411E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: add code comment for find_vmap_area_exceed_addr()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-add-code-comment-for-find_vmap_area_exceed_addr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-add-code-comment-for-find_vmap_area_exceed_addr.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc: add code comment for find_vmap_area_exceed_addr()
Date: Tue, 7 Jun 2022 18:59:58 +0800

Its behaviour is like find_vma() which finds an area above the specified
address, add comment to make it easier to understand.

And also fix two places of grammer mistake/typo.

Link: https://lkml.kernel.org/r/20220607105958.382076-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-add-code-comment-for-find_vmap_area_exceed_addr
+++ a/mm/vmalloc.c
@@ -790,6 +790,7 @@ unsigned long vmalloc_nr_pages(void)
 	return atomic_long_read(&nr_vmalloc_pages);
 }
 
+/* Look up the first VA which satisfies addr < va_end, NULL if none. */
 static struct vmap_area *find_vmap_area_exceed_addr(unsigned long addr)
 {
 	struct vmap_area *va = NULL;
@@ -929,7 +930,7 @@ link_va(struct vmap_area *va, struct rb_
 		 * Some explanation here. Just perform simple insertion
 		 * to the tree. We do not set va->subtree_max_size to
 		 * its current size before calling rb_insert_augmented().
-		 * It is because of we populate the tree from the bottom
+		 * It is because we populate the tree from the bottom
 		 * to parent levels when the node _is_ in the tree.
 		 *
 		 * Therefore we set subtree_max_size to zero after insertion,
@@ -1655,7 +1656,7 @@ static atomic_long_t vmap_lazy_nr = ATOM
 
 /*
  * Serialize vmap purging.  There is no actual critical section protected
- * by this look, but we want to avoid concurrent calls for performance
+ * by this lock, but we want to avoid concurrent calls for performance
  * reasons and to make the pcpu_get_vm_areas more deterministic.
  */
 static DEFINE_MUTEX(vmap_purge_lock);
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmalloc-invoke-classify_va_fit_type-in-adjust_va_to_fit_type.patch
mm-vmalloc-remove-the-redundant-boundary-check.patch
mm-vmalloc-fix-typo-in-local-variable-name.patch
mm-vmalloc-add-code-comment-for-find_vmap_area_exceed_addr.patch

