Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 595AFC433E0
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 19:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1360C221F8
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 19:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgL2TuL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 14:50:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:54554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgL2TuL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 14:50:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EB0020867;
        Tue, 29 Dec 2020 19:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609271370;
        bh=3jNSzd8TbkfWlaZcdsMp0+tqOrDXzZQLyJJj7+Gl+GQ=;
        h=Date:From:To:Subject:From;
        b=dQgnqdr3W3Erg/PxsdUTdAiP79YMS9Sk/72PGhPOyMKWT2K9hK6z0CmWu1OHKuLfx
         yNMtkuCHkLSh5qmGA6fDQLYLGA4WxmhabhsBx07JwJgYBgMlFD0rWizfjZdy5aFQEx
         U5X5fb8c0YBY4wyoUFsfyNcCJx1l9GETO9VYdQbU=
Date:   Tue, 29 Dec 2020 11:49:29 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, rppt@kernel.org,
        guro@fb.com
Subject:  + mm-cma-allocate-cma-areas-bottom-up-fix-3.patch added to
 -mm tree
Message-ID: <20201229194929._FM9M%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-allocate-cma-areas-bottom-up-fix-3
has been added to the -mm tree.  Its filename is
     mm-cma-allocate-cma-areas-bottom-up-fix-3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-allocate-cma-areas-bottom-up-fix-3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-allocate-cma-areas-bottom-up-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm-cma-allocate-cma-areas-bottom-up-fix-3

> 32-bit systems can have more than 32 bit in the physical address.
> I think a better option would be to use CONFIG_PHYS_ADDR_T_64BIT

I agree. An updated fixup below.

Cc: Mike Rapoport <rppt@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-allocate-cma-areas-bottom-up-fix-3
+++ a/mm/cma.c
@@ -344,7 +344,7 @@ int __init cma_declare_contiguous_nid(ph
 		 * Avoid using first 4GB to not interfere with constrained zones
 		 * like DMA/DMA32.
 		 */
-#if BITS_PER_LONG > 32
+#if CONFIG_PHYS_ADDR_T_64BIT
 		if (!memblock_bottom_up() && memblock_end >= SZ_4G + size) {
 			memblock_set_bottom_up(true);
 			addr = memblock_alloc_range_nid(size, alignment, SZ_4G,
_

Patches currently in -mm which might be from guro@fb.com are

mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-cma-allocate-cma-areas-bottom-up.patch
mm-cma-allocate-cma-areas-bottom-up-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-2.patch
mm-cma-allocate-cma-areas-bottom-up-fix-3.patch
memblock-do-not-start-bottom-up-allocations-with-kernel_end.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

