Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F25C43334
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jun 2022 20:07:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232973AbiFFUHy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 16:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbiFFUHx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 16:07:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB0FDF94
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 13:07:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4864DB81B43
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 20:07:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D815CC385A9;
        Mon,  6 Jun 2022 20:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654546069;
        bh=zhqwt+6VrxtliM8ZLcmYnr+G7Yrow1u268M1t9j3VtE=;
        h=Date:To:From:Subject:From;
        b=tVTNX/RRng9ZcWlSBuNJdsKjzIv2l1Tq/ybTznfv8LoSg6sgILA65T2Kgf8fEmpUA
         D/+qLHmNl1vqimPPPHLE7CoL2jqpWFAP82YX3TB1YjoWaJ14kYyXGeu54I2lLkP/3i
         rg0QNzHhePutkWG2BRlauGv0TBVslRs6xuaFCQdU=
Date:   Mon, 06 Jun 2022 13:07:49 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, npiggin@gmail.com,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-remove-the-unnecessary-type-check.patch added to mm-unstable branch
Message-Id: <20220606200749.D815CC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: remove the unnecessary type check
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-remove-the-unnecessary-type-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-remove-the-unnecessary-type-check.patch

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
Subject: mm/vmalloc: remove the unnecessary type check
Date: Mon, 6 Jun 2022 16:39:05 +0800

Patch series "Cleanup patches of vmalloc".

Some cleanup patches found when reading vmalloc code.


This patch (of 5):

In function adjust_va_to_fit_type(), it checks all values of passed in fit
type, including NOTHING_FIT in the else branch.  In fact, it's unnecessary
to check NOTHING_FIT since the check has been done before
adjust_va_to_fit_type() is called in all call sites.  So clean it up.

Link: https://lkml.kernel.org/r/20220606083909.363350-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20220606083909.363350-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-the-unnecessary-type-check
+++ a/mm/vmalloc.c
@@ -1418,8 +1418,6 @@ adjust_va_to_fit_type(struct vmap_area *
 		 * Shrink this VA to remaining size.
 		 */
 		va->va_start = nva_start_addr + size;
-	} else {
-		return -1;
 	}
 
 	if (type != FL_FIT_TYPE) {
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmalloc-remove-the-unnecessary-type-check.patch
mm-vmalloc-remove-the-redundant-boundary-check.patch
mm-vmalloc-fix-typo-in-local-variable-name.patch
mm-vmalloc-add-code-comment-for-find_vmap_area_exceed_addr.patch
mm-ioremap-rename-ioremap_page_range-to-ioremap_range.patch

