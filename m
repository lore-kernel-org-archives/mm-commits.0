Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CC08C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jun 2022 20:07:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbiFFUHy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 16:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiFFUHx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 16:07:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA324DFD2
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 13:07:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51D1A61509
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 20:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42F1C385A9;
        Mon,  6 Jun 2022 20:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654546071;
        bh=OgLCQl+cuPBuDkLNxsHPS/AbYOx22xo7NN78pv1U1sY=;
        h=Date:To:From:Subject:From;
        b=oaH40gpw7gFjGKIKQLg0IyzA2c+KowKgHa4VElh2kb52JA27v8NheZeILps4v0ypm
         3Hhkbly0MLKP4vbt06JQ9tbeNpcslUIF4+usIQJrZPwYN+iWgwFP2b2d1iAtbiLhgu
         gUobj+yGt5VJg7jo4zTKAslNKsvWrtDdok6QxcTI=
Date:   Mon, 06 Jun 2022 13:07:51 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, npiggin@gmail.com,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-remove-the-redundant-boundary-check.patch added to mm-unstable branch
Message-Id: <20220606200751.A42F1C385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: remove the redundant boundary check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-remove-the-redundant-boundary-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-remove-the-redundant-boundary-check.patch

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
Subject: mm/vmalloc: remove the redundant boundary check
Date: Mon, 6 Jun 2022 16:39:06 +0800

In function find_va_links(), when traversing the vmap_area tree, the
comparing to check if the passed in 'va' is above or below 'tmp_va' is
redundant, assuming both 'va' and 'tmp_va' has ->va_start <= ->va_end.

Here, to simplify the checking as code change.

Link: https://lkml.kernel.org/r/20220606083909.363350-3-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-the-redundant-boundary-check
+++ a/mm/vmalloc.c
@@ -874,11 +874,9 @@ find_va_links(struct vmap_area *va,
 		 * Trigger the BUG() if there are sides(left/right)
 		 * or full overlaps.
 		 */
-		if (va->va_start < tmp_va->va_end &&
-				va->va_end <= tmp_va->va_start)
+		if (va->va_end <= tmp_va->va_start)
 			link = &(*link)->rb_left;
-		else if (va->va_end > tmp_va->va_start &&
-				va->va_start >= tmp_va->va_end)
+		else if (va->va_start >= tmp_va->va_end)
 			link = &(*link)->rb_right;
 		else {
 			WARN(1, "vmalloc bug: 0x%lx-0x%lx overlaps with 0x%lx-0x%lx\n",
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmalloc-remove-the-unnecessary-type-check.patch
mm-vmalloc-remove-the-redundant-boundary-check.patch
mm-vmalloc-fix-typo-in-local-variable-name.patch
mm-vmalloc-add-code-comment-for-find_vmap_area_exceed_addr.patch
mm-ioremap-rename-ioremap_page_range-to-ioremap_range.patch

