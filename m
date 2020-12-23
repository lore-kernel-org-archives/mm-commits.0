Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D83C433DB
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 20:16:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00B57223E4
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 20:16:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbgLWUQa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Dec 2020 15:16:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:38120 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727369AbgLWUQa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 23 Dec 2020 15:16:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD95220855;
        Wed, 23 Dec 2020 20:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608754549;
        bh=2gaTC+3SihtYLiGHeL4PRgpV46rCE+yLesfk9UMgWd4=;
        h=Date:From:To:Subject:From;
        b=b7artWaTTjvjFHCXj1B3m44jYvpE6zwFbALw8aQzkkV8x/UjWo5wPydlmRZCf90zt
         c1aswz555ppTYMS628kDSqrsPqh2bg1s+L0fWy9Uis+G8F6VsLk9Hli9hVTgcAAZAW
         D1Buv66OvyH6P6ZHtcQXzvBRUbwCrIUTj0A3QA6w=
Date:   Wed, 23 Dec 2020 12:15:49 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au, guro@fb.com
Subject:  + mm-cma-allocate-cma-areas-bottom-up-fix-2.patch added to
 -mm tree
Message-ID: <20201223201549.3Zwhl%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-allocate-cma-areas-bottom-up-fix-2
has been added to the -mm tree.  Its filename is
     mm-cma-allocate-cma-areas-bottom-up-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-allocate-cma-areas-bottom-up-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-allocate-cma-areas-bottom-up-fix-2.patch

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
Subject: mm-cma-allocate-cma-areas-bottom-up-fix-2

fix 32-bit warnings

Link: https://lkml.kernel.org/r/20201223163537.GA4011967@carbon.DHCP.thefacebook.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/cma.c~mm-cma-allocate-cma-areas-bottom-up-fix-2
+++ a/mm/cma.c
@@ -344,12 +344,14 @@ int __init cma_declare_contiguous_nid(ph
 		 * Avoid using first 4GB to not interfere with constrained zones
 		 * like DMA/DMA32.
 		 */
+#if BITS_PER_LONG > 32
 		if (!memblock_bottom_up() && memblock_end >= SZ_4G + size) {
 			memblock_set_bottom_up(true);
 			addr = memblock_alloc_range_nid(size, alignment, SZ_4G,
 							limit, nid, true);
 			memblock_set_bottom_up(false);
 		}
+#endif
 
 		if (!addr) {
 			addr = memblock_alloc_range_nid(size, alignment, base,
_

Patches currently in -mm which might be from guro@fb.com are

mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-cma-allocate-cma-areas-bottom-up.patch
mm-cma-allocate-cma-areas-bottom-up-fix.patch
mm-cma-allocate-cma-areas-bottom-up-fix-2.patch
memblock-do-not-start-bottom-up-allocations-with-kernel_end.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

