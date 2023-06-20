Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 961E4EB64D7
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jun 2023 18:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbjFTS1Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jun 2023 14:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjFTS1Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 20 Jun 2023 14:27:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6295910C2
        for <mm-commits@vger.kernel.org>; Tue, 20 Jun 2023 11:27:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F33D6613EA
        for <mm-commits@vger.kernel.org>; Tue, 20 Jun 2023 18:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E9BC433C0;
        Tue, 20 Jun 2023 18:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687285643;
        bh=TCTVnT1Ir205+jslGyAjpcQJSGroQoSsFzkH6+JCj5Q=;
        h=Date:To:From:Subject:From;
        b=ZLV2jip7A+45tMjGjfyDxTOR4KdxyHgCcSDeuzJ4x8/BO9JW1M8GL5TWMZE+vFPZI
         NBIIIA9voP6AL2zRwLgBUgzXLhgnzIKk6Q/Yelnaroh+Zmsq2+apFc5AI0J3zLwjl1
         iZMAKyRfxsf9JN391P5KWJQUXXRTb/u1WWgA1bV4=
Date:   Tue, 20 Jun 2023 11:27:22 -0700
To:     mm-commits@vger.kernel.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swapfile-delete-outdated-pte_offset_map-comment.patch added to mm-unstable branch
Message-Id: <20230620182723.55E9BC433C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swapfile: delete outdated pte_offset_map() comment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swapfile-delete-outdated-pte_offset_map-comment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swapfile-delete-outdated-pte_offset_map-comment.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm/swapfile: delete outdated pte_offset_map() comment
Date: Mon, 19 Jun 2023 23:50:00 -0700 (PDT)

Delete a triply out-of-date comment from add_swap_count_continuation():
1. vmalloc_to_page() changed from pte_offset_map() to pte_offset_kernel()
2. pte_offset_map() changed from using kmap_atomic() to kmap_local_page()
3. kmap_atomic() changed from using fixed FIX_KMAP addresses in 2.6.37.

Link: https://lkml.kernel.org/r/9022632b-ba9d-8cb0-c25-4be9786481b5@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/swapfile.c~mm-swapfile-delete-outdated-pte_offset_map-comment
+++ a/mm/swapfile.c
@@ -3456,11 +3456,6 @@ int add_swap_count_continuation(swp_entr
 		goto out;
 	}
 
-	/*
-	 * We are fortunate that although vmalloc_to_page uses pte_offset_map,
-	 * no architecture is using highmem pages for kernel page tables: so it
-	 * will not corrupt the GFP_ATOMIC caller's atomic page table kmaps.
-	 */
 	head = vmalloc_to_page(si->swap_map + offset);
 	offset &= ~PAGE_MASK;
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-swapfile-delete-outdated-pte_offset_map-comment.patch

