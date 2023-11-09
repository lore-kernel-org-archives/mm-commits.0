Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A20DC4167B
	for <mm-commits@archiver.kernel.org>; Thu,  9 Nov 2023 22:14:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjKIWOl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Nov 2023 17:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjKIWOk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Nov 2023 17:14:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4236386A
        for <mm-commits@vger.kernel.org>; Thu,  9 Nov 2023 14:14:38 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540DAC433C8;
        Thu,  9 Nov 2023 22:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699568078;
        bh=i8HHueiGyBUd6ZlEY5PABu9o2hr2GrsmH/iYry3nVJ0=;
        h=Date:To:From:Subject:From;
        b=frXvo0rilwrnbLGlMX0JMqdNjI6GrOCcUCzI6GZ5aNEfXBvGO+Bv9umgaD/faQnAY
         jacU7VyQtb1llw1iKlCu0KK5ZqPMwsjYgTUlRh/JcVwzV0NYLfyEMbFeDKQf8r36K0
         h+c6D3ub3WmAT8Ty028GL1wdlwRo3f+yOuZ/TAdo=
Date:   Thu, 09 Nov 2023 14:14:37 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + gfp-include-__gfp_nowarn-in-gfp_nowait.patch added to mm-unstable branch
Message-Id: <20231109221438.540DAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gfp: include __GFP_NOWARN in GFP_NOWAIT
has been added to the -mm mm-unstable branch.  Its filename is
     gfp-include-__gfp_nowarn-in-gfp_nowait.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/gfp-include-__gfp_nowarn-in-gfp_nowait.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: gfp: include __GFP_NOWARN in GFP_NOWAIT
Date: Thu, 9 Nov 2023 21:15:07 +0000

GFP_NOWAIT callers are always prepared for their allocations to fail
because they fail so frequently.  Forcing the callers to remember to add
__GFP_NOWARN is just annoying and leads to an endless stream of patches
for the places where we forgot to add it.

We can now remove __GFP_NOWARN from all the callers which specify
GFP_NOWAIT, but I'd rather wait a cycle and send patches to each
maintainer instead of creating a big pile of merge conflicts.

Link: https://lkml.kernel.org/r/20231109211507.2262419-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp_types.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/gfp_types.h~gfp-include-__gfp_nowarn-in-gfp_nowait
+++ a/include/linux/gfp_types.h
@@ -274,7 +274,8 @@ typedef unsigned int __bitwise gfp_t;
  * accounted to kmemcg.
  *
  * %GFP_NOWAIT is for kernel allocations that should not stall for direct
- * reclaim, start physical IO or use any filesystem callback.
+ * reclaim, start physical IO or use any filesystem callback.  It is very
+ * likely to fail to allocate memory, even for very small allocations.
  *
  * %GFP_NOIO will use direct reclaim to discard clean pages or slab pages
  * that do not require the starting of any physical IO.
@@ -325,7 +326,7 @@ typedef unsigned int __bitwise gfp_t;
 #define GFP_ATOMIC	(__GFP_HIGH|__GFP_KSWAPD_RECLAIM)
 #define GFP_KERNEL	(__GFP_RECLAIM | __GFP_IO | __GFP_FS)
 #define GFP_KERNEL_ACCOUNT (GFP_KERNEL | __GFP_ACCOUNT)
-#define GFP_NOWAIT	(__GFP_KSWAPD_RECLAIM)
+#define GFP_NOWAIT	(__GFP_KSWAPD_RECLAIM | __GFP_NOWARN)
 #define GFP_NOIO	(__GFP_RECLAIM)
 #define GFP_NOFS	(__GFP_RECLAIM | __GFP_IO)
 #define GFP_USER	(__GFP_RECLAIM | __GFP_IO | __GFP_FS | __GFP_HARDWALL)
_

Patches currently in -mm which might be from willy@infradead.org are

mm-add-folio_zero_tail-and-use-it-in-ext4.patch
mm-add-folio_fill_tail-and-use-it-in-iomap.patch
gfs2-convert-stuffed_readpage-to-stuffed_read_folio.patch
mm-remove-test_set_page_writeback.patch
afs-do-not-test-the-return-value-of-folio_start_writeback.patch
smb-do-not-test-the-return-value-of-folio_start_writeback.patch
mm-return-void-from-folio_start_writeback-and-related-functions.patch
mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch
buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch
gfp-include-__gfp_nowarn-in-gfp_nowait.patch

