Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F053C433E6
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 01:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE3C5225AA
	for <mm-commits@archiver.kernel.org>; Wed, 23 Dec 2020 01:54:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgLWByG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 20:54:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:38060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgLWByG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 20:54:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98136225AA;
        Wed, 23 Dec 2020 01:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608688405;
        bh=xl+Gsn2y7bfWHFeDIIW1LLugc+IKDXLdTDG5wWzVeKI=;
        h=Date:From:To:Subject:From;
        b=tTxnhSzqzTetWhVwu/dHhkADUVfgDBywqnt9x/sQCTPnqHe1EAceCvRF3uHQM9L4g
         o240psX9HcuK8UFKrMhUT2BDwPnGqrIz3z6+Niuerl2td4iJtKk4cyyIbyfY/oWHG5
         iZ3qb6gO6js2tcM1Q2HAj2EPaemQlWtTjn128RDs=
Date:   Tue, 22 Dec 2020 17:53:25 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, vvghjk1234@gmail.com,
        rppt@linux.ibm.com, riel@surriel.com, mhocko@kernel.org,
        iamjoonsoo.kim@lge.com, guro@fb.com
Subject:  + mm-cma-allocate-cma-areas-bottom-up-fix.patch added to
 -mm tree
Message-ID: <20201223015325.kL811%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-allocate-cma-areas-bottom-up-fix
has been added to the -mm tree.  Its filename is
     mm-cma-allocate-cma-areas-bottom-up-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-cma-allocate-cma-areas-bottom-up-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-allocate-cma-areas-bottom-up-fix.patch

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
Subject: mm-cma-allocate-cma-areas-bottom-up-fix

whitespace fix, per Mike

Link: https://lkml.kernel.org/r/20201221170551.GB3428478@carbon.DHCP.thefacebook.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Wonhyuk Yang <vvghjk1234@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/cma.c~mm-cma-allocate-cma-areas-bottom-up-fix
+++ a/mm/cma.c
@@ -344,8 +344,7 @@ int __init cma_declare_contiguous_nid(ph
 		 * Avoid using first 4GB to not interfere with constrained zones
 		 * like DMA/DMA32.
 		 */
-		if (!memblock_bottom_up() &&
-		    memblock_end >= SZ_4G + size) {
+		if (!memblock_bottom_up() && memblock_end >= SZ_4G + size) {
 			memblock_set_bottom_up(true);
 			addr = memblock_alloc_range_nid(size, alignment, SZ_4G,
 							limit, nid, true);
_

Patches currently in -mm which might be from guro@fb.com are

mm-slub-call-account_slab_page-after-slab-page-initialization.patch
mm-memcg-slab-pre-allocate-obj_cgroups-for-slab-caches-with-slab_account.patch
mm-cma-allocate-cma-areas-bottom-up.patch
mm-cma-allocate-cma-areas-bottom-up-fix.patch
memblock-do-not-start-bottom-up-allocations-with-kernel_end.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix.patch

