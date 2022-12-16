Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAEB7C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 17:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiLPRUU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Dec 2022 12:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiLPRUT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 16 Dec 2022 12:20:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76B429CAE
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 09:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2E126CE1EB8
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 17:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45242C433D2;
        Fri, 16 Dec 2022 17:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671211215;
        bh=vbXL04wrJaeXv7E4+50CIq0J0CCwp5ZJwrddBBQbRi4=;
        h=Date:To:From:Subject:From;
        b=HDdm2sHzn0akdjzg/pT7x8i05A3unH1YE0WFhzAsGdg57V7Da7DxFBqOkD3xzoQbi
         n7QyH/uyrEJtgvmbZea0PLCTVsRMTF2NAy/ft8mRV/ihNYddWK7wiOztOii0gdWpuk
         RFOfLt9X8nOI0GjKgiDz2H97RNAeWlqIBRxaq7og=
Date:   Fri, 16 Dec 2022 09:20:14 -0800
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20221216172015.45242C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes
Date: Fri Dec 16 09:19:24 AM PST 2022

ERROR: code indent should use tabs where possible
#267: FILE: mm/page_vma_mapped.c:172:
+                 * All callers that get here will already hold the$

ERROR: code indent should use tabs where possible
#268: FILE: mm/page_vma_mapped.c:173:
+                 * i_mmap_rwsem.  Therefore, no additional locks need to be$

ERROR: code indent should use tabs where possible
#269: FILE: mm/page_vma_mapped.c:174:
+                 * taken before calling hugetlb_walk().$

total: 3 errors, 0 warnings, 211 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-hugetlb-introduce-hugetlb_walk.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/page_vma_mapped.c~mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes
+++ a/mm/page_vma_mapped.c
@@ -169,9 +169,9 @@ bool page_vma_mapped_walk(struct page_vm
 		if (pvmw->pte)
 			return not_found(pvmw);
 		/*
-                 * All callers that get here will already hold the
-                 * i_mmap_rwsem.  Therefore, no additional locks need to be
-                 * taken before calling hugetlb_walk().
+		 * All callers that get here will already hold the
+		 * i_mmap_rwsem.  Therefore, no additional locks need to be
+		 * taken before calling hugetlb_walk().
 		 */
 		pvmw->pte = hugetlb_walk(vma, pvmw->address, size);
 		if (!pvmw->pte)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-memfd-add-mfd_noexec_seal-and-mfd_exec-fix.patch
mm-hugetlb-introduce-hugetlb_walk-checkpatch-fixes.patch
error-injection-remove-ei_etype_none-fix.patch

